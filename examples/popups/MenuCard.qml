import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // Dropdown Menu
    Menu {
        id: dropdownMenu

        MenuItem {
            text: "Cut"
            onTriggered: menuResultLabel.text = "Selected: Cut"
        }
        MenuItem {
            text: "Copy"
            onTriggered: menuResultLabel.text = "Selected: Copy"
        }
        MenuItem {
            text: "Paste"
            onTriggered: menuResultLabel.text = "Selected: Paste"
        }

        MenuSeparator {}

        MenuItem {
            text: "Bold"
            checkable: true
            checked: true
            onTriggered: menuResultLabel.text = "Bold: " + (checked ? "ON" : "OFF")
        }
        MenuItem {
            text: "Italic"
            checkable: true
            onTriggered: menuResultLabel.text = "Italic: " + (checked ? "ON" : "OFF")
        }
    }

    // Context Menu
    Menu {
        id: contextMenu

        MenuItem {
            text: "Select All"
            onTriggered: menuResultLabel.text = "Context: Select All"
        }
        MenuItem {
            text: "Delete"
            onTriggered: menuResultLabel.text = "Context: Delete"
        }

        MenuSeparator {}

        MenuItem {
            text: "Properties"
            onTriggered: menuResultLabel.text = "Context: Properties"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Menu"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            id: menuButton
            text: "Open Menu"
            Layout.fillWidth: true
            onClicked: dropdownMenu.popup(menuButton, 0, menuButton.height)
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            color: Style.bgColor
            radius: Style.resize(8)
            border.color: Style.inactiveColor
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "Right-click here"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: function(mouse) {
                    contextMenu.popup()
                }
            }
        }

        Label {
            id: menuResultLabel
            text: "Selected: —"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.mainColor
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: menuInfoCol.implicitHeight + Style.resize(20)
            color: Style.bgColor
            radius: Style.resize(6)

            ColumnLayout {
                id: menuInfoCol
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Menu supports:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Regular items, separators"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Checkable items (Bold, Italic)"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Context menu (right-click)"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }

        Label {
            text: "Menu provides dropdown and context menus with rich item types"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
