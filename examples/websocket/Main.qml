// =============================================================================
// Main.qml — Pagina principal del ejemplo WebSocket
// =============================================================================
// Demuestra comunicacion WebSocket en tiempo real integrando una clase C++
// (WebSocketClient) con la interfaz QML. La arquitectura sigue el patron
// clasico de Qt: la logica de red vive en C++, y QML solo se encarga de
// la presentacion y la interaccion del usuario.
//
// Estructura de la pagina:
//   - ConnectionCard: configurar URL y conectar/desconectar
//   - SendMessageCard: enviar mensajes al servidor
//   - MessageLogCard: historial de mensajes enviados, recibidos y errores
//
// El ListModel (logModel) actua como almacen central de mensajes. Los
// handlers de senales de WebSocketClient insertan entries al inicio del
// modelo (insert(0, ...)) para que los mensajes mas recientes aparezcan
// primero, igual que un terminal de logs.
//
// Aprendizaje clave: la clase C++ usa QML_ELEMENT para registrarse,
// Q_PROPERTY para bindings bidireccionales, Q_INVOKABLE para metodos
// y signals para eventos asincronos.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle
import websocket

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del Dashboard (ver Dashboard.qml).
    // fullSize se activa cuando el usuario selecciona esta pagina en el menu.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // -------------------------------------------------------------------------
    // WebSocketClient (C++): se instancia como cualquier componente QML.
    // Su propiedad "url" se vincula a la URL del ConnectionCard.
    // Los tres handlers (onMessageReceived, onMessageSent, onErrorOccurred)
    // son senales de C++ que QML recibe automaticamente. Cada uno inserta
    // una entrada en el ListModel con timestamp, direccion y texto.
    // -------------------------------------------------------------------------
    WebSocketClient {
        id: wsClient
        url: connectionCard.url

        onMessageReceived: function(message) {
            logModel.insert(0, {
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                direction: "received",
                text: message
            });
        }

        onMessageSent: function(message) {
            logModel.insert(0, {
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                direction: "sent",
                text: message
            });
        }

        onErrorOccurred: function(error) {
            logModel.insert(0, {
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                direction: "error",
                text: error
            });
        }
    }

    // Modelo central de mensajes: almacena todo el historial de la sesion.
    // Las tarjetas hijas no manipulan el modelo directamente — solo
    // MessageLogCard lo lee, y los handlers de arriba lo escriben.
    ListModel {
        id: logModel
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // Layout vertical que organiza las tres tarjetas de arriba a abajo.
        // MessageLogCard usa Layout.fillHeight para ocupar todo el espacio
        // restante, dando maximo espacio al historial de mensajes.
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            spacing: Style.resize(20)

            Label {
                text: "WebSocket (C++ \u2194 QML)"
                font.pixelSize: Style.resize(32)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            // Tarjeta de conexion: URL, boton conectar/desconectar, indicador
            ConnectionCard {
                id: connectionCard
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(120)
                connected: wsClient.connected
                statusText: wsClient.statusText
                onConnectClicked: wsClient.connectToServer()
                onDisconnectClicked: wsClient.disconnectFromServer()
            }

            // Tarjeta de envio: campo de texto + boton Send
            SendMessageCard {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(75)
                connected: wsClient.connected
                onMessageSent: (message) => wsClient.sendMessage(message)
            }

            // Tarjeta de log: ListView con el historial de mensajes
            MessageLogCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                logModel: logModel
            }

            Label {
                text: "C++ WebSocketClient class exposed to QML via QML_ELEMENT. Uses Q_PROPERTY for data binding, Q_INVOKABLE for methods, and signals for events."
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
