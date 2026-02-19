import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string textContent: "Hello World"
    property bool isBold: false
    property bool isItalic: false
    property bool isUnderline: false
    property string textAlign: "left"
    property int fontSize: 16

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Text Editor ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Formatting toolbar
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: Style.bgColor
                radius: Style.resize(4)
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(2)

                ToolButton {
                    text: "B"
                    font.bold: true
                    checkable: true
                    checked: root.isBold
                    onCheckedChanged: root.isBold = checked
                }
                ToolButton {
                    text: "I"
                    font.italic: true
                    checkable: true
                    checked: root.isItalic
                    onCheckedChanged: root.isItalic = checked
                }
                ToolButton {
                    text: "U"
                    font.underline: true
                    checkable: true
                    checked: root.isUnderline
                    onCheckedChanged: root.isUnderline = checked
                }

                ToolSeparator {}

                ToolButton { text: "\u2261"; onClicked: root.textAlign = "left" }
                ToolButton { text: "\u2550"; onClicked: root.textAlign = "center" }
                ToolButton { text: "\u2261"; onClicked: root.textAlign = "right" }

                ToolSeparator {}

                ToolButton { text: "A\u207B"; onClicked: root.fontSize = Math.max(10, root.fontSize - 2) }
                Label { text: root.fontSize + "px"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }
                ToolButton { text: "A\u207A"; onClicked: root.fontSize = Math.min(32, root.fontSize + 2) }
            }
        }

        // Editable text area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            TextArea {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                text: root.textContent
                onTextChanged: root.textContent = text
                font.pixelSize: Style.resize(root.fontSize)
                font.bold: root.isBold
                font.italic: root.isItalic
                font.underline: root.isUnderline
                horizontalAlignment: root.textAlign === "center" ? Text.AlignHCenter
                                   : root.textAlign === "right" ? Text.AlignRight
                                   : Text.AlignLeft
                color: Style.fontPrimaryColor
                wrapMode: Text.WordWrap
                background: null
            }
        }

        // Status bar
        Label {
            text: "Bold: " + root.isBold + " | Italic: " + root.isItalic + " | Size: " + root.fontSize + "px | Align: " + root.textAlign
            font.pixelSize: Style.resize(11)
            color: Style.inactiveColor
            Layout.fillWidth: true
        }
    }
}
