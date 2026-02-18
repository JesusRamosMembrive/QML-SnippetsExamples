import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool connected: false

    signal messageSent(string message)

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
                enabled: root.connected
                selectByMouse: true

                onAccepted: {
                    if (text.length > 0) {
                        root.messageSent(text)
                        text = ""
                    }
                }
            }

            Button {
                text: "Send"
                enabled: root.connected && messageField.text.length > 0
                onClicked: {
                    root.messageSent(messageField.text)
                    messageField.text = ""
                }
            }
        }
    }
}
