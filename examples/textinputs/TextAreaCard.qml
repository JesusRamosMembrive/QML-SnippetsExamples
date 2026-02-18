import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "TextArea"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Multi-line text input with word wrap:"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        TextArea {
            id: messageArea
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(150)
            placeholderText: "Type your message here..."
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Characters: " + messageArea.text.length + " / 200"
                font.pixelSize: Style.resize(13)
                color: messageArea.text.length > 200 ? "#FF5900" : Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            GradientButton {
                text: "Clear"
                startColor: "#FF5900"
                endColor: "#FF8C00"
                width: Style.resize(80)
                height: Style.resize(32)
                onClicked: messageArea.text = ""
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: Style.bgColor
        }

        Label {
            text: "TextArea provides multi-line text editing with word wrap and scrolling"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
