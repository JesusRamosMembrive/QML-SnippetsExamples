// =============================================================================
// websocketclient.cpp — Implementacion del cliente WebSocket
// =============================================================================

#include "websocketclient.h"
#include <QDebug>

// =============================================================================
// CONSTRUCTOR
// =============================================================================
// Conecta las senales internas de QWebSocket a nuestros slots privados.
// Esto es el patron Observer: cuando QWebSocket emite "connected", nuestro
// onConnected() se ejecuta automaticamente. No necesitamos hacer polling
// ni verificar el estado manualmente — el sistema de senales/slots lo
// maneja todo de forma asincrona y thread-safe.
// =============================================================================
WebSocketClient::WebSocketClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected,
            this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected,
            this, &WebSocketClient::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived,
            this, &WebSocketClient::onTextMessageReceived);

    // -------------------------------------------------------------------------
    // QOverload<>::of(): necesario cuando una senal tiene multiples sobrecargas.
    // QWebSocket::errorOccurred tiene variantes con distintos parametros.
    // QOverload desambigua cual queremos conectar especificando el tipo
    // del parametro (QAbstractSocket::SocketError).
    // Sin esto, el compilador no sabe cual de las sobrecargas usar.
    // -------------------------------------------------------------------------
    connect(&m_webSocket,
            QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::errorOccurred),
            this, &WebSocketClient::onError);
}

// =============================================================================
// DESTRUCTOR
// =============================================================================
// Cierra el socket de forma limpia. isValid() verifica que el socket no
// este ya cerrado — llamar close() en un socket invalido podria causar
// comportamiento indefinido. Es buena practica siempre limpiar recursos
// en el destructor (RAII — Resource Acquisition Is Initialization).
// =============================================================================
WebSocketClient::~WebSocketClient()
{
    if (m_webSocket.isValid())
        m_webSocket.close();
}

// =============================================================================
// Getters — funciones READ de Q_PROPERTY
// =============================================================================
// Metodos const que devuelven el valor actual de las propiedades.
// Son llamados automaticamente por QML cuando accede a la propiedad.
// =============================================================================

bool WebSocketClient::connected() const
{
    return m_connected;
}

QString WebSocketClient::url() const
{
    return m_url;
}

// =============================================================================
// PATRON SETTER (setUrl)
// =============================================================================
// 1. Guard clause: verificar si el valor realmente cambio
// 2. Actualizar la variable miembro
// 3. Emitir la senal NOTIFY
//
// La guard clause (if m_url != url) es CRITICA:
// - Previene bucles infinitos cuando un binding de QML escribe de vuelta
// - Evita repintados innecesarios en la UI
// - Es el patron estandar en Qt para todos los setters con NOTIFY
// =============================================================================
void WebSocketClient::setUrl(const QString &url)
{
    if (m_url != url) {
        m_url = url;
        emit urlChanged();
    }
}

QString WebSocketClient::statusText() const
{
    return m_statusText;
}

// =============================================================================
// Metodos Q_INVOKABLE — llamables desde QML
// =============================================================================

void WebSocketClient::connectToServer()
{
    if (m_connected) {
        qDebug() << "WebSocketClient: Already connected";
        return;
    }

    // QStringLiteral: mas eficiente que QString("...") — crea el string en
    // tiempo de compilacion, no en tiempo de ejecucion. El compilador
    // genera los datos UTF-16 directamente en el binario, evitando la
    // conversion de Latin-1/UTF-8 a UTF-16 que haria QString("...").
    setStatusText(QStringLiteral("Connecting to %1...").arg(m_url));
    m_webSocket.open(QUrl(m_url));
}

void WebSocketClient::disconnectFromServer()
{
    if (!m_connected) {
        qDebug() << "WebSocketClient: Not connected";
        return;
    }

    setStatusText(QStringLiteral("Disconnecting..."));
    m_webSocket.close();
}

void WebSocketClient::sendMessage(const QString &message)
{
    if (!m_connected) {
        emit errorOccurred(QStringLiteral("Not connected"));
        return;
    }

    m_webSocket.sendTextMessage(message);
    emit messageSent(message);
}

// =============================================================================
// Private slots — Handlers de senales internas de QWebSocket
// =============================================================================
// Estos slots se ejecutan automaticamente cuando QWebSocket emite sus
// senales. Actualizan el estado interno y re-emiten senales propias
// para que QML pueda reaccionar (onConnectedChanged, onMessageReceived, etc.)
// =============================================================================

void WebSocketClient::onConnected()
{
    qDebug() << "WebSocketClient: Connected to" << m_url;
    setConnected(true);
    setStatusText(QStringLiteral("Connected to %1").arg(m_url));
}

void WebSocketClient::onDisconnected()
{
    qDebug() << "WebSocketClient: Disconnected";
    setConnected(false);
    setStatusText(QStringLiteral("Disconnected"));
}

void WebSocketClient::onTextMessageReceived(const QString &message)
{
    emit messageReceived(message);
}

void WebSocketClient::onError(QAbstractSocket::SocketError error)
{
    // Q_UNUSED(error): suprime el warning del compilador "parametro no usado".
    // Recibimos el enum de error pero preferimos usar m_webSocket.errorString()
    // que nos da un mensaje legible en vez de un codigo numerico.
    Q_UNUSED(error);
    QString errorMsg = m_webSocket.errorString();
    qDebug() << "WebSocketClient: Error -" << errorMsg;
    setConnected(false);
    setStatusText(QStringLiteral("Error: %1").arg(errorMsg));
    emit errorOccurred(errorMsg);
}

// =============================================================================
// Setters privados — Patron setter con guard clause
// =============================================================================
// Mismo patron que setUrl(): verificar cambio → actualizar → emitir senal.
// Son privados porque "connected" y "statusText" son propiedades READ-only
// desde QML. Solo el propio objeto puede modificar estos valores internamente.
// =============================================================================

void WebSocketClient::setStatusText(const QString &text)
{
    if (m_statusText != text) {
        m_statusText = text;
        emit statusTextChanged();
    }
}

void WebSocketClient::setConnected(bool connected)
{
    if (m_connected != connected) {
        m_connected = connected;
        emit connectedChanged();
    }
}
