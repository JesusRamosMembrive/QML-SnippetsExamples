// =============================================================================
// udptransport.cpp — Implementacion de la capa de transporte UDP
// =============================================================================

#include "udptransport.h"
#include <QHostAddress>
#include <QNetworkDatagram>

// =============================================================================
// Constructor
// =============================================================================
// Conecta la senal readyRead del socket a nuestro slot onReadyRead().
// readyRead se emite cada vez que hay datagramas pendientes de leer.
// Esta conexion es la base del patron asincrono de Qt: en vez de hacer
// polling (preguntar continuamente "¿hay datos?"), el event loop nos
// notifica cuando llegan datos.
// =============================================================================
UdpTransport::UdpTransport(QObject *parent)
    : QObject(parent)
{
    connect(&m_socket, &QUdpSocket::readyRead,
            this, &UdpTransport::onReadyRead);
}

// =============================================================================
// Destructor
// =============================================================================
// Si el socket esta bindeado, lo cerramos limpiamente. QUdpSocket::close()
// libera el puerto para que otros procesos puedan usarlo.
// =============================================================================
UdpTransport::~UdpTransport()
{
    if (m_bound)
        m_socket.close();
}

// =============================================================================
// bind() — Vincular el socket a un puerto local
// =============================================================================
// QHostAddress::LocalHost = 127.0.0.1 (solo conexiones locales).
// Alternativa: QHostAddress::Any = 0.0.0.0 (acepta conexiones de cualquier
// interfaz de red). Para un ejemplo didactico, LocalHost es mas seguro.
//
// ReuseAddressHint permite reutilizar un puerto que el SO aun tiene en
// estado TIME_WAIT (comun cuando cierras y reabres rapidamente). Sin esto,
// el bind podria fallar si reinicias la app rapido.
// =============================================================================
bool UdpTransport::bind(quint16 port)
{
    if (m_bound) {
        emit errorOccurred(QStringLiteral("Socket already bound to port %1")
                               .arg(m_socket.localPort()));
        return false;
    }

    if (!m_socket.bind(QHostAddress::LocalHost, port,
                       QAbstractSocket::ReuseAddressHint)) {
        emit errorOccurred(QStringLiteral("Failed to bind port %1: %2")
                               .arg(port)
                               .arg(m_socket.errorString()));
        return false;
    }

    m_bound = true;
    return true;
}

// =============================================================================
// unbind() — Cerrar el socket y liberar el puerto
// =============================================================================
void UdpTransport::unbind()
{
    if (!m_bound)
        return;

    m_socket.close();
    m_bound = false;
}

bool UdpTransport::isBound() const
{
    return m_bound;
}

quint16 UdpTransport::boundPort() const
{
    return m_bound ? m_socket.localPort() : 0;
}

// =============================================================================
// sendDatagram() — Enviar un datagrama UDP a localhost:destPort
// =============================================================================
// writeDatagram() retorna el numero de bytes enviados, o -1 en caso de error.
// UDP es "fire and forget": no hay confirmacion de que el destino recibio
// los datos. Si nadie esta escuchando en destPort, el datagrama simplemente
// se descarta sin error (a diferencia de TCP que daria connection refused).
// =============================================================================
bool UdpTransport::sendDatagram(const QByteArray &data, quint16 destPort)
{
    qint64 bytesSent = m_socket.writeDatagram(
        data, QHostAddress::LocalHost, destPort);

    if (bytesSent == -1) {
        emit errorOccurred(QStringLiteral("Send failed: %1")
                               .arg(m_socket.errorString()));
        return false;
    }

    return true;
}

// =============================================================================
// onReadyRead() — Slot que procesa datagramas entrantes
// =============================================================================
// hasPendingDatagrams(): retorna true si hay al menos un datagrama en la
// cola de recepcion del socket. El loop while procesa todos los datagramas
// pendientes, no solo el primero.
//
// receiveDatagram(): lee y consume un datagrama de la cola. Retorna un
// QNetworkDatagram que contiene los datos, la direccion y puerto del emisor.
// Es preferible a la antigua readDatagram() porque devuelve toda la metadata
// en un solo objeto.
//
// senderPort(): nos dice que puerto uso el emisor. Esto es util para
// identificar al remitente en el protocolo STANAG (el puerto actua como
// identificador de la estacion).
// =============================================================================
void UdpTransport::onReadyRead()
{
    while (m_socket.hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_socket.receiveDatagram();
        emit datagramReceived(datagram.data(),
                              static_cast<quint16>(datagram.senderPort()));
    }
}
