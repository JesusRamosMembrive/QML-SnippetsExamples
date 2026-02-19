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
            text: "Basic MenuBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                MenuBar {
                    Layout.fillWidth: true

                    Menu {
                        title: "File"
                        Action { text: "New"; onTriggered: root.lastAction = "File > New" }
                        Action { text: "Open..."; onTriggered: root.lastAction = "File > Open" }
                        Action { text: "Save"; onTriggered: root.lastAction = "File > Save" }
                        MenuSeparator {}
                        Action { text: "Exit"; onTriggered: root.lastAction = "File > Exit" }
                    }

                    Menu {
                        title: "Edit"
                        Action { text: "Undo"; onTriggered: root.lastAction = "Edit > Undo" }
                        Action { text: "Redo"; onTriggered: root.lastAction = "Edit > Redo" }
                        MenuSeparator {}
                        Action { text: "Cut"; onTriggered: root.lastAction = "Edit > Cut" }
                        Action { text: "Copy"; onTriggered: root.lastAction = "Edit > Copy" }
                        Action { text: "Paste"; onTriggered: root.lastAction = "Edit > Paste" }
                    }

                    Menu {
                        title: "Help"
                        Action { text: "About"; onTriggered: root.lastAction = "Help > About" }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Label {
                        anchors.centerIn: parent
                        text: "Last action: " + root.lastAction
                        font.pixelSize: Style.resize(14)
                        color: Style.fontPrimaryColor
                    }
                }
            }
        }
    }
}
