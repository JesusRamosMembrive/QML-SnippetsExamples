import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Colored Track Switches"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Style.resize(20)
        rowSpacing: Style.resize(12)

        Repeater {
            model: [
                { label: "Notifications", color: "#4FC3F7", checked: true },
                { label: "Do Not Disturb", color: "#EF5350", checked: false },
                { label: "Auto-Sync", color: "#66BB6A", checked: true },
                { label: "Power Saver", color: "#FFA726", checked: false }
            ]

            RowLayout {
                id: colorSwitchRow
                required property var modelData
                required property int index

                property bool on: modelData.checked

                Layout.fillWidth: true
                spacing: Style.resize(12)

                // Custom track
                Rectangle {
                    id: colorTrack
                    width: Style.resize(52)
                    height: Style.resize(28)
                    radius: height / 2
                    color: colorSwitchRow.on
                           ? colorSwitchRow.modelData.color
                           : "#3A3D45"

                    Behavior on color { ColorAnimation { duration: 250 } }

                    // Knob
                    Rectangle {
                        id: colorKnob
                        width: Style.resize(22)
                        height: width
                        radius: width / 2
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        x: colorSwitchRow.on
                           ? parent.width - width - Style.resize(3)
                           : Style.resize(3)

                        Behavior on x {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }

                        // Shadow
                        layer.enabled: true
                        layer.effect: Item {}
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: colorSwitchRow.on = !colorSwitchRow.on
                    }
                }

                Label {
                    text: colorSwitchRow.modelData.label
                    font.pixelSize: Style.resize(14)
                    color: colorSwitchRow.on ? "white" : Style.fontSecondaryColor
                    Layout.fillWidth: true

                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }
    }
}
