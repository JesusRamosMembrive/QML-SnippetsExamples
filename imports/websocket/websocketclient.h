#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QtQml/qqmlregistration.h>

class WebSocketClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

public:
    explicit WebSocketClient(QObject *parent = nullptr);
    ~WebSocketClient();

    bool connected() const;
    QString url() const;
    void setUrl(const QString &url);
    QString statusText() const;

    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void sendMessage(const QString &message);

signals:
    void connectedChanged();
    void urlChanged();
    void statusTextChanged();
    void messageReceived(const QString &message);
    void messageSent(const QString &message);
    void errorOccurred(const QString &error);

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(const QString &message);
    void onError(QAbstractSocket::SocketError error);

private:
    void setStatusText(const QString &text);
    void setConnected(bool connected);

    QWebSocket m_webSocket;
    QString m_url{QStringLiteral("wss://echo.websocket.org")};
    bool m_connected{false};
    QString m_statusText{QStringLiteral("Disconnected")};
};

#endif // WEBSOCKETCLIENT_H
