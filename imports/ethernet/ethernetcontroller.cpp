// =============================================================================
// ethernetcontroller.cpp — Implementacion de la fachada Ethernet para QML
// =============================================================================

#include "ethernetcontroller.h"
#include <QDateTime>
#include <QVariantMap>

// =============================================================================
// Constructor
// =============================================================================
// Conecta las senales de UdpTransport a nuestros slots.
// m_transport es miembro directo (no puntero), asi que su lifetime esta
// ligado al lifetime de EthernetController. No necesitamos delete manual.
//
// La conexion se hace en el constructor para que este lista antes de que
// QML empiece a interactuar con el objeto. Es el patron estandar en Qt:
// "configura todo en el constructor, el objeto sale listo para usar".
// =============================================================================
EthernetController::EthernetController(QObject *parent)
    : QObject(parent)
{
    connect(&m_transport, &UdpTransport::datagramReceived,
            this, &EthernetController::onDatagramReceived);

    connect(&m_transport, &UdpTransport::errorOccurred,
            this, [this](const QString &error) {
                m_errorCount++;
                emit errorCountChanged();

                QString timestamp = QDateTime::currentDateTime()
                                        .toString(QStringLiteral("hh:mm:ss.zzz"));
                emit protocolError(timestamp, error, QString());
            });
}

EthernetController::~EthernetController()
{
    if (m_bound)
        m_transport.unbind();
}

// =============================================================================
// Getters — Funciones READ de Q_PROPERTY
// =============================================================================
bool EthernetController::bound() const { return m_bound; }
quint16 EthernetController::listenPort() const { return m_listenPort; }
quint16 EthernetController::sendPort() const { return m_sendPort; }
QString EthernetController::statusText() const { return m_statusText; }
int EthernetController::sentCount() const { return m_sentCount; }
int EthernetController::receivedCount() const { return m_receivedCount; }
int EthernetController::errorCount() const { return m_errorCount; }
QString EthernetController::lastSentHex() const { return m_lastSentHex; }
QString EthernetController::lastReceivedHex() const { return m_lastReceivedHex; }

// =============================================================================
// Setters — Con guard clause para evitar bucles de binding
// =============================================================================
void EthernetController::setListenPort(quint16 port)
{
    if (m_listenPort != port) {
        m_listenPort = port;
        emit listenPortChanged();
    }
}

void EthernetController::setSendPort(quint16 port)
{
    if (m_sendPort != port) {
        m_sendPort = port;
        emit sendPortChanged();
    }
}

void EthernetController::setStatusText(const QString &text)
{
    if (m_statusText != text) {
        m_statusText = text;
        emit statusTextChanged();
    }
}

void EthernetController::setBound(bool bound)
{
    if (m_bound != bound) {
        m_bound = bound;
        emit boundChanged();
    }
}

// =============================================================================
// startListening() — Bindear el socket al puerto de escucha
// =============================================================================
void EthernetController::startListening()
{
    if (m_bound) {
        setStatusText(QStringLiteral("Already bound to port %1").arg(m_listenPort));
        return;
    }

    if (m_transport.bind(m_listenPort)) {
        setBound(true);
        setStatusText(QStringLiteral("Listening on port %1 → Sending to port %2")
                          .arg(m_listenPort)
                          .arg(m_sendPort));
    } else {
        setStatusText(QStringLiteral("Failed to bind port %1").arg(m_listenPort));
        m_errorCount++;
        emit errorCountChanged();
    }
}

// =============================================================================
// stopListening() — Cerrar el socket
// =============================================================================
void EthernetController::stopListening()
{
    if (!m_bound) {
        setStatusText(QStringLiteral("Not bound"));
        return;
    }

    m_transport.unbind();
    setBound(false);
    setStatusText(QStringLiteral("Disconnected (was on port %1)").arg(m_listenPort));
}

// =============================================================================
// sendMessage() — Construir, serializar y enviar un mensaje STANAG
// =============================================================================
// Flujo completo del "send path":
//   1. Construir un StanagMessage desde los parametros de QML
//   2. Llenar los campos segun el bitmask y los valores proporcionados
//   3. Serializar con StanagCodec::encode() (BigEndian)
//   4. Enviar por UDP con UdpTransport::sendDatagram()
//   5. Emitir messageSent() para que QML actualice el log
//
// Los fieldValues se emparejan con los bits activos del presenceMask.
// Ejemplo: presenceMask=0x0005 (bits 0 y 2), fieldValues=[40.4, 500]
//   → campo 0 (Latitude) = 40.4, campo 2 (Altitude) = 500
// =============================================================================
void EthernetController::sendMessage(int messageId, int presenceMask,
                                     const QVariantList &fieldValues)
{
    StanagMessage msg;
    msg.messageId    = static_cast<quint16>(messageId);
    msg.sourcePort   = m_listenPort;
    msg.destPort     = m_sendPort;
    msg.sequenceNum  = m_nextSequence++;
    msg.presenceMask = static_cast<quint16>(presenceMask);

    // --- Llenar campos desde QML ---
    const auto &defs = StanagCodec::fieldDefinitions();
    int valueIndex = 0;

    for (int i = 0; i < kStanagMaxFields; ++i) {
        if (!(presenceMask & (1 << i)))
            continue;

        StanagField field;
        field.index = i;
        field.name = defs[i].name;
        field.value = (valueIndex < fieldValues.size())
                          ? fieldValues[valueIndex].toDouble()
                          : 0.0;
        valueIndex++;

        msg.fields.append(field);
    }

    // --- Serializar ---
    QByteArray encoded = StanagCodec::encode(msg);

    // --- Enviar ---
    if (m_transport.sendDatagram(encoded, m_sendPort)) {
        m_sentCount++;
        emit sentCountChanged();

        QString hexDump = QString::fromLatin1(encoded.toHex(' ')).toUpper();
        m_lastSentHex = hexDump;
        emit lastSentHexChanged();

        QString timestamp = QDateTime::currentDateTime()
                                .toString(QStringLiteral("hh:mm:ss.zzz"));
        emit messageSent(timestamp, hexDump, messageId,
                         msg.fields.size(), encoded.size());
    } else {
        m_errorCount++;
        emit errorCountChanged();
    }
}

// =============================================================================
// sendRawHex() — Enviar una cadena hexadecimal cruda por UDP
// =============================================================================
// Util para testing: permite enviar tramas manuales, incluyendo datos
// malformados para probar la robustez del parser del receptor.
//
// QByteArray::fromHex() convierte caracteres hex a bytes:
//   "48 65 6C 6C 6F" → [0x48, 0x65, 0x6C, 0x6C, 0x6F] = "Hello"
// Los espacios y caracteres no-hex se ignoran automaticamente.
// =============================================================================
void EthernetController::sendRawHex(const QString &hexString)
{
    // Eliminar espacios y convertir hex a bytes
    QString cleanHex = hexString;
    cleanHex.remove(QLatin1Char(' '));
    QByteArray data = QByteArray::fromHex(cleanHex.toLatin1());

    if (data.isEmpty()) {
        QString timestamp = QDateTime::currentDateTime()
                                .toString(QStringLiteral("hh:mm:ss.zzz"));
        emit protocolError(timestamp,
                           QStringLiteral("Invalid hex string"),
                           hexString);
        return;
    }

    if (m_transport.sendDatagram(data, m_sendPort)) {
        m_sentCount++;
        emit sentCountChanged();

        QString hexDump = QString::fromLatin1(data.toHex(' ')).toUpper();
        m_lastSentHex = hexDump;
        emit lastSentHexChanged();

        QString timestamp = QDateTime::currentDateTime()
                                .toString(QStringLiteral("hh:mm:ss.zzz"));
        emit messageSent(timestamp, hexDump, 0, 0, data.size());
    }
}

// =============================================================================
// getFieldDefinitions() — Tabla de campos para la UI de QML
// =============================================================================
// Convierte la tabla interna de FieldDef a QVariantList de QVariantMap.
// QVariantMap es la forma de Qt de pasar objetos JavaScript entre C++ y QML.
//
// En QML se puede acceder asi:
//   var defs = controller.getFieldDefinitions()
//   defs[0].name     // "Latitude"
//   defs[0].sizeBytes // 4
// =============================================================================
QVariantList EthernetController::getFieldDefinitions() const
{
    QVariantList result;
    const auto &defs = StanagCodec::fieldDefinitions();

    for (int i = 0; i < defs.size(); ++i) {
        QVariantMap entry;
        entry[QStringLiteral("index")] = i;
        entry[QStringLiteral("name")] = defs[i].name;
        entry[QStringLiteral("sizeBytes")] = defs[i].sizeBytes;
        result.append(entry);
    }

    return result;
}

// =============================================================================
// onDatagramReceived() — Procesar un datagrama UDP entrante
// =============================================================================
// Flujo completo del "receive path":
//   1. Recibir bytes crudos de UdpTransport
//   2. Intentar decodificar con StanagCodec::decode()
//   3. Si falla → emitir protocolError con el hex dump del datagrama
//   4. Si exito → emitir messageReceived + fieldsDecoded
//
// La conversion de campos decodificados a QVariantList permite que QML
// muestre cada campo individualmente sin conocer la estructura interna
// de StanagField.
// =============================================================================
void EthernetController::onDatagramReceived(const QByteArray &data,
                                            quint16 senderPort)
{
    m_receivedCount++;
    emit receivedCountChanged();

    QString hexDump = QString::fromLatin1(data.toHex(' ')).toUpper();
    m_lastReceivedHex = hexDump;
    emit lastReceivedHexChanged();

    QString timestamp = QDateTime::currentDateTime()
                            .toString(QStringLiteral("hh:mm:ss.zzz"));

    // --- Intentar decodificar ---
    StanagMessage msg;
    if (!StanagCodec::decode(data, msg)) {
        m_errorCount++;
        emit errorCountChanged();
        emit protocolError(timestamp,
                           QStringLiteral("Failed to decode message (%1 bytes)")
                               .arg(data.size()),
                           hexDump);
        return;
    }

    // --- Emitir mensaje recibido ---
    emit messageReceived(timestamp, hexDump,
                         msg.messageId, senderPort,
                         msg.fields.size(), data.size(),
                         msg.checksumValid);

    // --- Convertir campos a QVariantList para QML ---
    QVariantList fieldList;
    for (const auto &field : msg.fields) {
        QVariantMap entry;
        entry[QStringLiteral("index")] = field.index;
        entry[QStringLiteral("name")] = field.name;
        entry[QStringLiteral("hex")] = QString::fromLatin1(
            field.rawBytes.toHex(' ')).toUpper();
        entry[QStringLiteral("value")] = field.value;
        fieldList.append(entry);
    }
    emit fieldsDecoded(fieldList);
}
