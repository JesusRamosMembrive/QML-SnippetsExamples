// =============================================================================
// websocketclient.h — Clase C++ expuesta a QML (patron moderno Qt 6)
// =============================================================================
//
// PATRON: Clase C++ registrada en QML usando el sistema moderno de Qt 6.
// En vez del antiguo qmlRegisterType<>() manual, usamos macros declarativas
// (QML_ELEMENT) y CMake se encarga del registro automatico.
//
// INCLUDE GUARD (#ifndef/#define/#endif):
// Patron clasico para evitar la doble inclusion de headers. Si este archivo
// ya fue incluido en la unidad de compilacion, el preprocesador lo salta.
// Alternativa moderna: #pragma once (no estandar pero soportado por todos
// los compiladores modernos).
// =============================================================================

#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QtQml/qqmlregistration.h>  // Necesario para QML_ELEMENT

// =============================================================================
// WebSocketClient — Cliente WebSocket accesible desde QML
// =============================================================================
// Hereda de QObject, requisito para participar en el sistema de
// senales/slots y ser visible desde QML.
// =============================================================================
class WebSocketClient : public QObject
{
    // -------------------------------------------------------------------------
    // Q_OBJECT: Macro OBLIGATORIA para cualquier clase que use senales, slots
    // o propiedades. Habilita el Meta-Object System: el MOC (Meta-Object
    // Compiler) genera codigo de introspeccion que permite a Qt descubrir
    // senales, slots y propiedades en tiempo de ejecucion.
    // Sin esta macro, connect(), emit y Q_PROPERTY no funcionan.
    // -------------------------------------------------------------------------
    Q_OBJECT

    // -------------------------------------------------------------------------
    // QML_ELEMENT: Forma moderna (Qt 6) de registrar un tipo C++ para QML.
    // Reemplaza el antiguo qmlRegisterType<WebSocketClient>("uri", 1, 0, "WebSocketClient").
    // El MOC + CMake auto-generan el codigo de registro en tiempo de compilacion.
    // El nombre del tipo en QML sera identico al nombre de la clase C++.
    // -------------------------------------------------------------------------
    QML_ELEMENT

    // -------------------------------------------------------------------------
    // Q_PROPERTY — El puente entre C++ y QML
    // -------------------------------------------------------------------------
    // Sintaxis: Q_PROPERTY(tipo nombre READ getter [WRITE setter] NOTIFY senal)
    //
    // Cada propiedad queda accesible en QML como:
    //     webSocket.connected, webSocket.url, webSocket.statusText
    //
    // NOTIFY es OBLIGATORIO para que los bindings de QML funcionen.
    // Sin NOTIFY, QML no puede saber cuando el valor cambia y el binding
    // nunca se re-evalua. Qt Creator mostrara un warning si falta.
    //
    // "connected" es READ-only (sin WRITE) — QML no puede asignarlo.
    // "url" tiene WRITE setUrl — QML puede hacer: webSocket.url = "wss://..."
    // -------------------------------------------------------------------------
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

public:
    explicit WebSocketClient(QObject *parent = nullptr);
    ~WebSocketClient();

    // Getters (funciones READ de Q_PROPERTY)
    bool connected() const;
    QString url() const;
    void setUrl(const QString &url);  // Setter (funcion WRITE de Q_PROPERTY)
    QString statusText() const;

    // -------------------------------------------------------------------------
    // Q_INVOKABLE: Marca metodos como invocables desde QML.
    // Sin esta macro, QML NO puede ver el metodo aunque sea public.
    // Los metodos public solos NO bastan — se necesita Q_INVOKABLE o la
    // palabra clave "slots" para que el MOC los registre.
    //
    // En QML se usan asi:
    //     webSocket.connectToServer()
    //     webSocket.sendMessage("hola")
    // -------------------------------------------------------------------------
    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void sendMessage(const QString &message);

// -------------------------------------------------------------------------
// signals: Senales que se pueden conectar a handlers en QML.
// La convencion de nombres es: senal "foo" → handler QML "onFoo"
// Ejemplos:
//     messageReceived  → onMessageReceived { console.log(message) }
//     errorOccurred    → onErrorOccurred { console.log(error) }
//     connectedChanged → onConnectedChanged { ... }
//
// Las senales se declaran pero NO se implementan — el MOC genera el
// codigo automaticamente. Solo se "emiten" con la palabra clave emit.
// -------------------------------------------------------------------------
signals:
    void connectedChanged();
    void urlChanged();
    void statusTextChanged();
    void messageReceived(const QString &message);
    void messageSent(const QString &message);
    void errorOccurred(const QString &error);

// -------------------------------------------------------------------------
// private slots: Handlers internos conectados a las senales de QWebSocket.
// "slots" es una macro de Qt que marca metodos como receptores de senales.
// Al ser private, solo se pueden conectar internamente (no desde QML).
// -------------------------------------------------------------------------
private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(const QString &message);
    void onError(QAbstractSocket::SocketError error);

private:
    void setStatusText(const QString &text);
    void setConnected(bool connected);

    // -------------------------------------------------------------------------
    // Variables miembro con prefijo m_: convencion comun en Qt/C++
    // para distinguir miembros privados de variables locales y parametros.
    //
    // Inicializacion inline {valor}: caracteristica de C++11 que inicializa
    // los miembros en la declaracion. Evita tener que inicializarlos en el
    // constructor y es mas seguro (imposible olvidar inicializar un miembro).
    // -------------------------------------------------------------------------
    QWebSocket m_webSocket;
    QString m_url{QStringLiteral("wss://echo.websocket.org")};
    bool m_connected{false};
    QString m_statusText{QStringLiteral("Disconnected")};
};

#endif // WEBSOCKETCLIENT_H
