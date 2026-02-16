#include "websocketclient.h"
#include <QDebug>

WebSocketClient::WebSocketClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected,
            this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected,
            this, &WebSocketClient::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived,
            this, &WebSocketClient::onTextMessageReceived);
    connect(&m_webSocket,
            QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::errorOccurred),
            this, &WebSocketClient::onError);
}

WebSocketClient::~WebSocketClient()
{
    if (m_webSocket.isValid())
        m_webSocket.close();
}

bool WebSocketClient::connected() const
{
    return m_connected;
}

QString WebSocketClient::url() const
{
    return m_url;
}

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

void WebSocketClient::connectToServer()
{
    if (m_connected) {
        qDebug() << "WebSocketClient: Already connected";
        return;
    }

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
    Q_UNUSED(error);
    QString errorMsg = m_webSocket.errorString();
    qDebug() << "WebSocketClient: Error -" << errorMsg;
    setConnected(false);
    setStatusText(QStringLiteral("Error: %1").arg(errorMsg));
    emit errorOccurred(errorMsg);
}

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
