import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Button States & Interactions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                id: clickableButton
                text: clickableButton.down ? "Pressed!" : "Press Me"
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
                onClicked: {
                    statusLabel.text = "Button clicked!";
                    clickTimer.restart();
                }
            }

            Button {
                id: hoverButton
                text: hoverButton.hovered ? "Hovering" : "Hover Me"
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
            }

            Button {
                id: toggleButton
                text: toggleButton.checked ? "Checked" : "Checkable"
                checkable: true
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            id: statusLabel
            text: "Interact with the buttons above"
            font.pixelSize: Style.resize(14)
            color: Style.mainColor
            Layout.topMargin: Style.resize(10)

            Timer {
                id: clickTimer
                interval: 2000
                onTriggered: statusLabel.text = "Interact with the buttons above"
            }
        }

        Label {
            text: "• down: Button is being pressed\n• hovered: Mouse is over the button\n• checkable: Button can be toggled on/off"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
