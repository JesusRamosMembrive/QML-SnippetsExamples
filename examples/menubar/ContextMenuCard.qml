import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string lastAction: "None"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Context Menu"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Right-click on items below"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Repeater {
                    model: ["Document.pdf", "Image.png", "Notes.txt", "Data.csv"]

                    Rectangle {
                        required property string modelData
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(36)
                        radius: Style.resize(4)
                        color: fileArea.containsMouse ? Style.surfaceColor : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(10)
                            anchors.rightMargin: Style.resize(10)

                            Label {
                                text: modelData.endsWith(".pdf") ? "\u2622"
                                    : modelData.endsWith(".png") ? "\u25A3"
                                    : modelData.endsWith(".txt") ? "\u2263"
                                    : "\u2637"
                                font.pixelSize: Style.resize(16)
                                color: Style.mainColor
                            }

                            Label {
                                text: modelData
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: fileArea
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            hoverEnabled: true
                            onClicked: function(mouse) {
                                fileContextMenu.fileName = modelData
                                fileContextMenu.popup()
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Label {
                    text: "Last: " + root.lastAction
                    font.pixelSize: Style.resize(12)
                    color: Style.mainColor
                }
            }
        }

        Menu {
            id: fileContextMenu
            property string fileName: ""

            MenuItem { text: "Open " + fileContextMenu.fileName; onTriggered: root.lastAction = "Open " + fileContextMenu.fileName }
            MenuItem { text: "Rename"; onTriggered: root.lastAction = "Rename " + fileContextMenu.fileName }
            MenuItem { text: "Copy"; onTriggered: root.lastAction = "Copy " + fileContextMenu.fileName }
            MenuSeparator {}
            MenuItem { text: "Delete"; onTriggered: root.lastAction = "Delete " + fileContextMenu.fileName }
        }
    }
}
