import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(20)

        Label {
            text: "Basic Switch"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Switch {
                id: wifiSwitch
                text: "Wi-Fi"
            }

            Switch {
                id: bluetoothSwitch
                text: "Bluetooth"
                checked: true
            }

            Switch {
                id: airplaneSwitch
                text: "Airplane Mode"
                enabled: false
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(1)
            color: Style.bgColor
        }

        Label {
            text: "Wi-Fi: " + (wifiSwitch.checked ? "ON" : "OFF")
                  + "  |  Bluetooth: " + (bluetoothSwitch.checked ? "ON" : "OFF")
                  + "  |  Airplane: " + (airplaneSwitch.checked ? "ON" : "OFF")
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "Switch provides a toggleable on/off control with animated indicator"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
