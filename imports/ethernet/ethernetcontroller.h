// =============================================================================
// ethernetcontroller.h — Fachada C++ expuesta a QML (QML_ELEMENT)
// =============================================================================
//
// PATRON FACHADA (Facade):
//   Esta clase es el UNICO punto de contacto entre QML y el backend de
//   protocolo Ethernet. Internamente compone UdpTransport y StanagCodec,
//   pero QML solo ve las propiedades, metodos y senales de esta fachada.
//
//   QML nunca interactua con UdpTransport ni StanagCodec directamente.
//   Esto aisla la logica de protocolo de la presentacion — si manana
//   cambiamos de UDP a TCP, o de STANAG a otro protocolo, QML no cambia.
//
// COMUNICACION CON QML:
//   Las senales emiten SOLO tipos simples (QString, int, bool, QVariantList).
//   Esto evita tener que registrar tipos complejos en QML y simplifica
//   el binding. QML recibe los datos y los inserta en un ListModel local.
//
// FLUJO TIPICO:
//   1. QML llama startListening() → bind socket → indicador verde
//   2. QML llama sendMessage(id, mask, values) → encode → UDP → log
//   3. UDP recibe datagrama → decode → signals → QML actualiza log
//   4. QML llama stopListening() → unbind → indicador rojo
// =============================================================================

#ifndef ETHERNETCONTROLLER_H
#define ETHERNETCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>
#include "udptransport.h"
#include "stanagcodec.h"
#include "stanagmessage.h"

class EthernetController : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // =========================================================================
    // Q_PROPERTY — Propiedades expuestas a QML
    // =========================================================================

    // --- Estado de conexion ---
    Q_PROPERTY(bool bound READ bound NOTIFY boundChanged)
    Q_PROPERTY(quint16 listenPort READ listenPort WRITE setListenPort NOTIFY listenPortChanged)
    Q_PROPERTY(quint16 sendPort READ sendPort WRITE setSendPort NOTIFY sendPortChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

    // --- Contadores de actividad ---
    Q_PROPERTY(int sentCount READ sentCount NOTIFY sentCountChanged)
    Q_PROPERTY(int receivedCount READ receivedCount NOTIFY receivedCountChanged)
    Q_PROPERTY(int errorCount READ errorCount NOTIFY errorCountChanged)

    // --- Ultimo mensaje (para vista rapida) ---
    Q_PROPERTY(QString lastSentHex READ lastSentHex NOTIFY lastSentHexChanged)
    Q_PROPERTY(QString lastReceivedHex READ lastReceivedHex NOTIFY lastReceivedHexChanged)

public:
    explicit EthernetController(QObject *parent = nullptr);
    ~EthernetController() override;

    // --- Getters ---
    bool bound() const;
    quint16 listenPort() const;
    quint16 sendPort() const;
    QString statusText() const;
    int sentCount() const;
    int receivedCount() const;
    int errorCount() const;
    QString lastSentHex() const;
    QString lastReceivedHex() const;

    // --- Setters ---
    void setListenPort(quint16 port);
    void setSendPort(quint16 port);

    // =========================================================================
    // Q_INVOKABLE — Metodos invocables desde QML
    // =========================================================================

    // Empezar a escuchar en listenPort
    Q_INVOKABLE void startListening();

    // Dejar de escuchar
    Q_INVOKABLE void stopListening();

    // =========================================================================
    // sendMessage() — Construir y enviar un mensaje STANAG
    // =========================================================================
    // Parametros desde QML:
    //   messageId:     numero de mensaje STANAG (1-65535)
    //   presenceMask:  bitmask indicando que campos incluir (0-16383)
    //   fieldValues:   QVariantList con un double por cada bit activo
    //                  (en orden de bit, de menor a mayor)
    //
    // QVariantList es la forma de Qt para recibir arrays de JavaScript.
    // En QML:  controller.sendMessage(1, 0x0003, [40.4168, -3.7038])
    // En C++:  QVariantList = [{40.4168}, {-3.7038}]
    // =========================================================================
    Q_INVOKABLE void sendMessage(int messageId, int presenceMask,
                                 const QVariantList &fieldValues);

    // =========================================================================
    // sendRawHex() — Enviar una cadena hexadecimal como datagrama crudo
    // =========================================================================
    // Permite enviar tramas manuales para testing. La cadena se convierte
    // a bytes con QByteArray::fromHex(). Ejemplo: "00 01 0A FF" → 4 bytes.
    // Util para probar el parser con datos malformados o tramas ajenas.
    // =========================================================================
    Q_INVOKABLE void sendRawHex(const QString &hexString);

    // =========================================================================
    // getFieldDefinitions() — Obtener tabla de campos para la UI
    // =========================================================================
    // Retorna un QVariantList con un QVariantMap por campo:
    //   [{name: "Latitude", sizeBytes: 4}, {name: "Longitude", sizeBytes: 4}, ...]
    // QML usa esto para generar los checkboxes y editores de campo.
    // =========================================================================
    Q_INVOKABLE QVariantList getFieldDefinitions() const;

signals:
    // --- Signals de cambio de propiedad ---
    void boundChanged();
    void listenPortChanged();
    void sendPortChanged();
    void statusTextChanged();
    void sentCountChanged();
    void receivedCountChanged();
    void errorCountChanged();
    void lastSentHexChanged();
    void lastReceivedHexChanged();

    // =========================================================================
    // Signals de actividad de protocolo (para el log de QML)
    // =========================================================================
    // Todos los parametros son tipos simples — QML los recibe directamente
    // en los handlers onMessageSent, onMessageReceived, etc.

    // Emitida despues de enviar un mensaje exitosamente
    void messageSent(const QString &timestamp, const QString &hexDump,
                     int messageId, int fieldCount, int byteSize);

    // Emitida cuando se recibe y decodifica un datagrama
    void messageReceived(const QString &timestamp, const QString &hexDump,
                         int messageId, int sourcePort, int fieldCount,
                         int byteSize, bool checksumOk);

    // Emitida con los campos decodificados del ultimo mensaje recibido
    // QVariantList de QVariantMap: [{index, name, hex, value}, ...]
    void fieldsDecoded(const QVariantList &fields);

    // Emitida cuando falla el decode o hay error de red
    void protocolError(const QString &timestamp, const QString &error,
                       const QString &hexDump);

private slots:
    // =========================================================================
    // onDatagramReceived() — Procesar un datagrama UDP entrante
    // =========================================================================
    // Conectado a UdpTransport::datagramReceived. Intenta decodificar
    // el datagrama como un mensaje STANAG. Si el decode falla, emite
    // protocolError. Si tiene exito, emite messageReceived + fieldsDecoded.
    // =========================================================================
    void onDatagramReceived(const QByteArray &data, quint16 senderPort);

private:
    // Setters privados para propiedades read-only
    void setStatusText(const QString &text);
    void setBound(bool bound);

    // --- Componentes internos ---
    UdpTransport m_transport;       // Capa de transporte UDP
    quint16 m_listenPort = 5000;    // Puerto de escucha por defecto
    quint16 m_sendPort   = 5001;    // Puerto de envio por defecto
    quint16 m_nextSequence = 0;     // Contador de secuencia (auto-incremento)
    bool m_bound = false;
    QString m_statusText{QStringLiteral("Not bound")};

    // --- Contadores ---
    int m_sentCount     = 0;
    int m_receivedCount = 0;
    int m_errorCount    = 0;

    // --- Cache del ultimo mensaje ---
    QString m_lastSentHex;
    QString m_lastReceivedHex;
};

#endif // ETHERNETCONTROLLER_H
