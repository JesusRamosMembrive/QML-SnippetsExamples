// =============================================================================
// udptransport.h — Capa de transporte UDP sobre QUdpSocket
// =============================================================================
//
// PATRON: Wrapper delgado sobre una libreria de Qt (QUdpSocket).
//
// Esta clase encapsula la comunicacion UDP, aislando la capa de transporte
// del protocolo STANAG. EthernetController (la fachada QML) usa esta clase
// internamente — no se expone directamente a QML.
//
// ¿POR QUE UDP Y NO TCP?
//   - UDP es sin conexion (connectionless): cada datagrama es independiente.
//   - No hay handshake, no hay garantia de entrega, no hay orden.
//   - Ideal para telemetria en tiempo real donde un dato viejo es inutil:
//     si pierdes un paquete de posicion GPS, el siguiente ya trae datos nuevos.
//   - STANAG 4586 y la mayoria de protocolos aeronauticos usan UDP.
//   - TCP garantiza entrega y orden, pero la retransmision introduce latencia
//     inaceptable en sistemas de control en tiempo real.
//
// QUDPSOCKET:
//   - bind(port): escucha datagramas entrantes en ese puerto.
//   - writeDatagram(data, host, port): envia un datagrama al destino.
//   - readyRead: senal emitida cuando hay datagramas pendientes de leer.
//   - pendingDatagramSize(): tamano del proximo datagrama en la cola.
//   - readDatagram(): lee y consume un datagrama de la cola.
//
// HILO PRINCIPAL:
//   QUdpSocket es asincrono (basado en event loop). No bloquea el hilo.
//   La senal readyRead se emite cuando llegan datos, y nuestro slot los
//   procesa inmediatamente. Para volumenes de datos en localhost esto es
//   mas que suficiente — no necesitamos un hilo separado.
// =============================================================================

#ifndef UDPTRANSPORT_H
#define UDPTRANSPORT_H

#include <QObject>
#include <QUdpSocket>

class UdpTransport : public QObject
{
    Q_OBJECT

public:
    explicit UdpTransport(QObject *parent = nullptr);
    ~UdpTransport() override;

    // =========================================================================
    // bind() — Empezar a escuchar datagramas en un puerto
    // =========================================================================
    // Llama a QUdpSocket::bind(QHostAddress::LocalHost, port).
    // LocalHost (127.0.0.1) restringe la escucha a conexiones locales.
    // Retorna true si el bind fue exitoso, false si el puerto ya esta en uso.
    //
    // NOTA: Un socket UDP puede enviar Y recibir por el mismo puerto.
    // Si bind() es exitoso, podemos tanto enviar como recibir.
    // =========================================================================
    bool bind(quint16 port);

    // =========================================================================
    // unbind() — Dejar de escuchar
    // =========================================================================
    // Cierra el socket. Despues de unbind() ya no se reciben datagramas.
    // Se puede volver a llamar bind() con el mismo u otro puerto.
    // =========================================================================
    void unbind();

    bool isBound() const;
    quint16 boundPort() const;

    // =========================================================================
    // sendDatagram() — Enviar datos por UDP a localhost:destPort
    // =========================================================================
    // Usa QUdpSocket::writeDatagram() para enviar un QByteArray como
    // datagrama UDP a la direccion localhost (127.0.0.1) y puerto destino.
    //
    // IMPORTANTE: No necesita bind() previo para enviar. El SO asigna
    // un puerto efimero automaticamente si el socket no esta bindeado.
    // Pero si queremos que el receptor vea nuestro puerto como "source",
    // debemos hacer bind() antes de enviar.
    // =========================================================================
    bool sendDatagram(const QByteArray &data, quint16 destPort);

signals:
    // Emitida cuando llega un datagrama. Incluye los datos y el puerto
    // del emisor para poder identificar quien lo envio.
    void datagramReceived(const QByteArray &data, quint16 senderPort);

    // Emitida cuando ocurre un error de socket (puerto en uso, etc.)
    void errorOccurred(const QString &error);

private slots:
    // =========================================================================
    // onReadyRead() — Procesar datagramas pendientes
    // =========================================================================
    // Conectado a QUdpSocket::readyRead. Se ejecuta automaticamente cuando
    // hay uno o mas datagramas esperando ser leidos.
    //
    // Usa un while(hasPendingDatagrams()) para procesar TODOS los datagramas
    // pendientes en una sola invocacion del slot. Esto es importante porque
    // readyRead podria no emitirse por cada datagrama individual si llegan
    // varios rapidamente (batching del OS).
    // =========================================================================
    void onReadyRead();

private:
    QUdpSocket m_socket;
    bool m_bound = false;
};

#endif // UDPTRANSPORT_H
