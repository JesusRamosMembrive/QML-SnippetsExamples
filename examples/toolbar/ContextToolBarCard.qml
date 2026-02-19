import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedItems: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Contextual ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "ToolBar changes based on selection"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Contextual toolbar
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: root.selectedItems > 0 ? "#1A3A5C" : Style.bgColor
                radius: Style.resize(4)
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(6)

                // Normal toolbar
                RowLayout {
                    visible: root.selectedItems === 0
                    spacing: Style.resize(6)
                    ToolButton { text: "\u2795 New" }
                    ToolButton { text: "\u21BB Refresh" }
                    ToolButton { text: "\u2699 Settings" }
                }

                // Selection toolbar
                RowLayout {
                    visible: root.selectedItems > 0
                    spacing: Style.resize(6)

                    Label {
                        text: root.selectedItems + " selected"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#4FC3F7"
                    }

                    ToolSeparator {}

                    ToolButton { text: "\u2702 Delete"; onClicked: root.selectedItems = 0 }
                    ToolButton { text: "\u2398 Copy" }
                    ToolButton { text: "\u2717 Clear"; onClicked: root.selectedItems = 0 }
                }

                Item { Layout.fillWidth: true }
            }
        }

        // Selectable items
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Repeater {
                    model: ["Document A", "Document B", "Document C", "Document D"]

                    CheckBox {
                        required property string modelData
                        text: modelData
                        onCheckedChanged: {
                            root.selectedItems += checked ? 1 : -1
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
