import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle
import websocket

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // C++ WebSocketClient exposed to QML via QML_ELEMENT
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

    ListModel {
        id: logModel
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

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

            ConnectionCard {
                id: connectionCard
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(120)
                connected: wsClient.connected
                statusText: wsClient.statusText
                onConnectClicked: wsClient.connectToServer()
                onDisconnectClicked: wsClient.disconnectFromServer()
            }

            SendMessageCard {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(75)
                connected: wsClient.connected
                onMessageSent: (message) => wsClient.sendMessage(message)
            }

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
