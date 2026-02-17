import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false

    // ── Section 6: Animated Level Meter (VU Meter) ────
    Label {
        text: "VU Level Meter"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: vuMeterItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(100)

        property var levels: [0.6, 0.8, 0.5, 0.9, 0.3, 0.7, 0.65, 0.85,
                              0.4, 0.75, 0.55, 0.7, 0.6, 0.45, 0.8, 0.5,
                              0.9, 0.35, 0.65, 0.7]

        Timer {
            id: vuTimer
            running: root.active
            interval: 100
            repeat: true
            onTriggered: {
                var newLevels = []
                for (var i = 0; i < vuRepeater.count; i++) {
                    var prev = vuMeterItem.levels[i] || 0.5
                    var next = Math.max(0.05, Math.min(1.0,
                        prev + (Math.random() - 0.48) * 0.3))
                    newLevels.push(next)
                }
                vuMeterItem.levels = newLevels
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: Style.resize(4)

            Repeater {
                id: vuRepeater
                model: 20

                delegate: Item {
                    id: vuBar
                    required property int index

                    width: Style.resize(16)
                    height: Style.resize(80)

                    property real level: vuMeterItem.levels[vuBar.index] || 0.5

                    Column {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        spacing: Style.resize(2)

                        Repeater {
                            model: 10

                            delegate: Rectangle {
                                id: vuSegment
                                required property int index

                                readonly property int segIndex: 9 - vuSegment.index
                                readonly property bool active:
                                    segIndex < Math.round(vuBar.level * 10)

                                width: vuBar.width
                                height: Style.resize(5)
                                radius: Style.resize(1)
                                color: !active ? Qt.rgba(1, 1, 1, 0.06)
                                     : segIndex >= 8 ? "#FF3B30"
                                     : segIndex >= 6 ? "#FF9500"
                                     : "#34C759"

                                opacity: active ? 1.0 : 0.4

                                Behavior on color {
                                    ColorAnimation { duration: 80 }
                                }
                                Behavior on opacity {
                                    NumberAnimation { duration: 80 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
