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
        url: urlField.text

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

            // Header
            Label {
                text: "WebSocket (C++ \u2194 QML)"
                font.pixelSize: Style.resize(32)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            // Connection card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(120)
                color: "white"
                radius: Style.resize(8)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Connection"
                        font.pixelSize: Style.resize(18)
                        font.bold: true
                        color: Style.mainColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(10)

                        Label {
                            text: "URL:"
                            font.pixelSize: Style.resize(14)
                            color: "#666"
                        }

                        TextField {
                            id: urlField
                            Layout.fillWidth: true
                            text: "wss://echo.websocket.org"
                            font.pixelSize: Style.resize(13)
                            enabled: !wsClient.connected
                            selectByMouse: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(10)

                        // Status indicator
                        Rectangle {
                            width: Style.resize(12)
                            height: Style.resize(12)
                            radius: width / 2
                            color: wsClient.connected ? "#4CAF50" : "#F44336"

                            SequentialAnimation on opacity {
                                running: wsClient.statusText.indexOf("Connecting") >= 0
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.3; duration: 500 }
                                NumberAnimation { to: 1.0; duration: 500 }
                            }
                        }

                        Label {
                            text: wsClient.statusText
                            font.pixelSize: Style.resize(13)
                            color: wsClient.connected ? "#4CAF50" : "#666"
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Connect"
                            enabled: !wsClient.connected
                            onClicked: wsClient.connectToServer()
                        }

                        Button {
                            text: "Disconnect"
                            enabled: wsClient.connected
                            onClicked: wsClient.disconnectFromServer()
                        }
                    }
                }
            }

            // Send message card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(75)
                color: "white"
                radius: Style.resize(8)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Send Message"
                        font.pixelSize: Style.resize(18)
                        font.bold: true
                        color: Style.mainColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(10)

                        TextField {
                            id: messageField
                            Layout.fillWidth: true
                            placeholderText: "Type a message..."
                            font.pixelSize: Style.resize(13)
                            enabled: wsClient.connected
                            selectByMouse: true

                            onAccepted: {
                                if (text.length > 0) {
                                    wsClient.sendMessage(text);
                                    text = "";
                                }
                            }
                        }

                        Button {
                            text: "Send"
                            enabled: wsClient.connected && messageField.text.length > 0
                            onClicked: {
                                wsClient.sendMessage(messageField.text);
                                messageField.text = "";
                            }
                        }
                    }
                }
            }

            // Message log card
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                radius: Style.resize(8)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "Message Log"
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: Style.mainColor
                            Layout.fillWidth: true
                        }

                        Label {
                            text: logModel.count + " messages"
                            font.pixelSize: Style.resize(12)
                            color: "#999"
                        }

                        Button {
                            text: "Clear"
                            enabled: logModel.count > 0
                            onClicked: logModel.clear()
                        }
                    }

                    // Log list
                    ListView {
                        id: logView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: logModel
                        clip: true
                        spacing: Style.resize(2)

                        delegate: Rectangle {
                            width: logView.width
                            height: Style.resize(32)
                            color: index % 2 === 0 ? "#f8f8f8" : "white"
                            radius: Style.resize(4)

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(10)
                                anchors.rightMargin: Style.resize(10)
                                spacing: Style.resize(10)

                                // Timestamp
                                Label {
                                    text: model.time
                                    font.pixelSize: Style.resize(12)
                                    font.family: "Courier New"
                                    color: "#999"
                                    Layout.preferredWidth: Style.resize(65)
                                }

                                // Direction arrow
                                Label {
                                    text: model.direction === "sent" ? "\u2192" :
                                          model.direction === "received" ? "\u2190" : "\u26A0"
                                    font.pixelSize: Style.resize(16)
                                    color: model.direction === "sent" ? Style.mainColor :
                                           model.direction === "received" ? "#4A90D9" : "#F44336"
                                    Layout.preferredWidth: Style.resize(20)
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                // Message text
                                Label {
                                    text: model.text
                                    font.pixelSize: Style.resize(13)
                                    color: model.direction === "error" ? "#F44336" : "#333"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                // Type tag
                                Rectangle {
                                    Layout.preferredWidth: Style.resize(55)
                                    Layout.preferredHeight: Style.resize(20)
                                    radius: Style.resize(3)
                                    color: model.direction === "sent" ? "#E0F7E9" :
                                           model.direction === "received" ? "#E3F2FD" : "#FFEBEE"

                                    Label {
                                        anchors.centerIn: parent
                                        text: model.direction === "sent" ? "sent" :
                                              model.direction === "received" ? "echo" : "error"
                                        font.pixelSize: Style.resize(10)
                                        color: model.direction === "sent" ? "#2E7D32" :
                                               model.direction === "received" ? "#1565C0" : "#C62828"
                                    }
                                }
                            }
                        }

                        // Empty state
                        Label {
                            anchors.centerIn: parent
                            text: "No messages yet.\nConnect and send a message to see the echo response."
                            font.pixelSize: Style.resize(14)
                            color: "#CCC"
                            horizontalAlignment: Text.AlignHCenter
                            visible: logModel.count === 0
                        }
                    }
                }
            }

            // Description
            Label {
                text: "C++ WebSocketClient class exposed to QML via QML_ELEMENT. Uses Q_PROPERTY for data binding, Q_INVOKABLE for methods, and signals for events."
                font.pixelSize: Style.resize(12)
                color: "#666"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
