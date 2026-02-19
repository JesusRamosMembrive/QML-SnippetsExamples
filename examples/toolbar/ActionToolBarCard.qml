import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string logText: ""

    function log(msg) {
        logText = msg + "\n" + logText
        if (logText.length > 200)
            logText = logText.substring(0, 200)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ToolBar with Actions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ToolBar with mixed controls
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
                spacing: Style.resize(6)

                ToolButton { text: "\u2795"; font.pixelSize: Style.resize(14); onClicked: root.log("New file") }

                ToolSeparator {}

                ToolButton { text: "\u2702"; font.pixelSize: Style.resize(14); onClicked: root.log("Cut") }
                ToolButton { text: "\u2398"; font.pixelSize: Style.resize(14); onClicked: root.log("Copy") }
                ToolButton { text: "\u2399"; font.pixelSize: Style.resize(14); onClicked: root.log("Paste") }

                ToolSeparator {}

                ToolButton { text: "\u21B6"; font.pixelSize: Style.resize(14); onClicked: root.log("Undo") }
                ToolButton { text: "\u21B7"; font.pixelSize: Style.resize(14); onClicked: root.log("Redo") }

                Item { Layout.fillWidth: true }

                ComboBox {
                    model: ["100%", "75%", "50%", "125%", "150%"]
                    implicitWidth: Style.resize(90)
                    onCurrentTextChanged: root.log("Zoom: " + currentText)
                }
            }
        }

        // Action log
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Action Log"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.mainColor
                }

                Label {
                    text: root.logText || "Click toolbar buttons..."
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
