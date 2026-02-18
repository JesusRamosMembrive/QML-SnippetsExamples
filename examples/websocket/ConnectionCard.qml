import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool connected: false
    property string statusText: ""
    readonly property string url: urlField.text

    signal connectClicked()
    signal disconnectClicked()

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
                color: Style.fontSecondaryColor
            }

            TextField {
                id: urlField
                Layout.fillWidth: true
                text: "wss://echo.websocket.org"
                font.pixelSize: Style.resize(13)
                enabled: !root.connected
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
                color: root.connected ? "#4CAF50" : "#F44336"

                SequentialAnimation on opacity {
                    running: root.statusText.indexOf("Connecting") >= 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }

            Label {
                text: root.statusText
                font.pixelSize: Style.resize(13)
                color: root.connected ? "#4CAF50" : Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            Button {
                text: "Connect"
                enabled: !root.connected
                onClicked: root.connectClicked()
            }

            Button {
                text: "Disconnect"
                enabled: root.connected
                onClicked: root.disconnectClicked()
            }
        }
    }
}
