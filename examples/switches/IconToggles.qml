import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Icon Toggles"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        Repeater {
            model: [
                { icon: "\uD83D\uDCF6", label: "Wi-Fi",    accent: "#4FC3F7" },
                { icon: "\u2699",        label: "Gear",     accent: "#FF8A65" },
                { icon: "\uD83D\uDD14", label: "Alerts",   accent: "#FFD54F" },
                { icon: "\uD83D\uDCCD", label: "Location", accent: "#81C784" },
                { icon: "\u2708",        label: "Flight",   accent: "#CE93D8" }
            ]

            Rectangle {
                id: iconToggle
                required property var modelData
                required property int index

                property bool on: index === 0 || index === 3

                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(90)
                radius: Style.resize(12)
                color: on ? Qt.rgba(Qt.color(modelData.accent).r,
                                    Qt.color(modelData.accent).g,
                                    Qt.color(modelData.accent).b, 0.15)
                         : Style.surfaceColor
                border.color: on ? modelData.accent : "#3A3D45"
                border.width: on ? 2 : 1

                Behavior on color { ColorAnimation { duration: 250 } }
                Behavior on border.color { ColorAnimation { duration: 250 } }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(6)

                    Label {
                        text: iconToggle.modelData.icon
                        font.pixelSize: Style.resize(28)
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        opacity: iconToggle.on ? 1.0 : 0.4

                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    Label {
                        text: iconToggle.modelData.label
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: iconToggle.on ? iconToggle.modelData.accent
                                             : Style.fontSecondaryColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: iconToggle.on = !iconToggle.on
                }
            }
        }
    }
}
