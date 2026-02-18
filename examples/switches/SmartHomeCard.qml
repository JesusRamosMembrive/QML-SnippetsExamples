import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: darkModeSwitch.checked ? "#1E2028" : Style.cardColor
    radius: Style.resize(8)

    Behavior on color {
        ColorAnimation { duration: 300 }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Interactive Demo - Smart Home Panel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        CheckBox {
            id: enableZoneCheckBox
            text: "Enable Zone"
            checked: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
        }

        Switch {
            id: darkModeSwitch
            text: "Dark Mode"
            enabled: enableZoneCheckBox.checked
        }

        Label {
            text: "Temperature:"
            font.pixelSize: Style.resize(14)
            color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
            font.bold: true
        }

        ButtonGroup {
            id: tempGroup
        }

        RowLayout {
            spacing: Style.resize(10)

            RadioButton {
                id: tempLow
                text: "Low"
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }

            RadioButton {
                id: tempMedium
                text: "Medium"
                checked: true
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }

            RadioButton {
                id: tempHigh
                text: "High"
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
        }

        Label {
            text: "Zone: " + (enableZoneCheckBox.checked ? "Enabled" : "Disabled")
                  + "  |  Mode: " + (darkModeSwitch.checked ? "Dark" : "Light")
                  + "  |  Temp: " + (tempLow.checked ? "Low" : tempMedium.checked ? "Medium" : "High")
            font.pixelSize: Style.resize(13)
            color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "Controls interact: CheckBox enables the zone, Switch toggles theme, RadioButtons select temperature"
            font.pixelSize: Style.resize(12)
            color: darkModeSwitch.checked ? "#999" : Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
