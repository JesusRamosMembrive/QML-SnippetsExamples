import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Large Knob Toggles"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(20)

        Repeater {
            model: [
                { icon: "\uD83D\uDD0A", offIcon: "\uD83D\uDD07", label: "Sound",  color: "#7E57C2" },
                { icon: "\uD83D\uDD06", offIcon: "\uD83D\uDD05", label: "Screen", color: "#26A69A" },
                { icon: "\uD83D\uDD12", offIcon: "\uD83D\uDD13", label: "Lock",   color: "#EF5350" },
                { icon: "\u26A1",        offIcon: "\uD83D\uDD0C", label: "Power",  color: "#FFA726" }
            ]

            Item {
                id: largeToggleItem
                required property var modelData
                required property int index

                property bool on: index < 2

                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(100)

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Style.resize(8)

                    // Large circular knob
                    Rectangle {
                        id: largeKnob
                        Layout.preferredWidth: Style.resize(64)
                        Layout.preferredHeight: Style.resize(64)
                        Layout.alignment: Qt.AlignHCenter
                        radius: width / 2
                        color: largeToggleItem.on
                               ? largeToggleItem.modelData.color
                               : Style.surfaceColor
                        border.color: largeToggleItem.on
                                      ? Qt.lighter(largeToggleItem.modelData.color, 1.3)
                                      : "#3A3D45"
                        border.width: 2

                        Behavior on color { ColorAnimation { duration: 250 } }
                        Behavior on border.color { ColorAnimation { duration: 250 } }

                        scale: knobMa.pressed ? 0.9 : (knobMa.containsMouse ? 1.05 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150 } }

                        Label {
                            anchors.centerIn: parent
                            text: largeToggleItem.on
                                  ? largeToggleItem.modelData.icon
                                  : largeToggleItem.modelData.offIcon
                            font.pixelSize: Style.resize(26)
                        }

                        MouseArea {
                            id: knobMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: largeToggleItem.on = !largeToggleItem.on
                        }
                    }

                    Label {
                        text: largeToggleItem.modelData.label
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: largeToggleItem.on
                               ? largeToggleItem.modelData.color
                               : Style.fontSecondaryColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }
            }
        }
    }
}
