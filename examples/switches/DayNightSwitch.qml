import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Day / Night Switch"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(80)

        property bool isNight: true

        Rectangle {
            id: dayNightTrack
            anchors.centerIn: parent
            width: Style.resize(160)
            height: Style.resize(60)
            radius: height / 2
            color: parent.isNight ? "#1A237E" : "#42A5F5"

            Behavior on color { ColorAnimation { duration: 500 } }

            // Stars (visible at night)
            Repeater {
                model: [
                    { sx: 0.2, sy: 0.25, size: 3 },
                    { sx: 0.35, sy: 0.6, size: 2 },
                    { sx: 0.7, sy: 0.2, size: 2.5 },
                    { sx: 0.8, sy: 0.65, size: 2 },
                    { sx: 0.55, sy: 0.35, size: 1.5 }
                ]

                Rectangle {
                    required property var modelData
                    x: dayNightTrack.width * modelData.sx
                    y: dayNightTrack.height * modelData.sy
                    width: modelData.size
                    height: width
                    radius: width / 2
                    color: "white"
                    opacity: dayNightTrack.parent.isNight ? 0.8 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 400 } }
                }
            }

            // Knob (sun / moon)
            Rectangle {
                id: dayNightKnob
                width: Style.resize(48)
                height: width
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                x: dayNightTrack.parent.isNight
                   ? parent.width - width - Style.resize(6)
                   : Style.resize(6)
                color: dayNightTrack.parent.isNight ? "#ECEFF1" : "#FFD54F"

                Behavior on x {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InOutCubic
                    }
                }
                Behavior on color { ColorAnimation { duration: 400 } }

                // Moon crater (night only)
                Rectangle {
                    x: parent.width * 0.55
                    y: parent.height * 0.2
                    width: parent.width * 0.2
                    height: width
                    radius: width / 2
                    color: Qt.darker(parent.color, 1.15)
                    opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }

                Rectangle {
                    x: parent.width * 0.3
                    y: parent.height * 0.55
                    width: parent.width * 0.15
                    height: width
                    radius: width / 2
                    color: Qt.darker(parent.color, 1.15)
                    opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }

                // Sun rays (day only)
                Repeater {
                    model: 8

                    Rectangle {
                        id: sunRay
                        required property int index
                        property real rayAngle: index * 45

                        width: Style.resize(3)
                        height: Style.resize(8)
                        radius: width / 2
                        color: "#FFD54F"
                        opacity: dayNightTrack.parent.isNight ? 0.0 : 0.9
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.width * 0.55

                        transform: Rotation {
                            origin.x: sunRay.width / 2
                            origin.y: dayNightKnob.width * 0.55
                            angle: sunRay.rayAngle
                        }

                        Behavior on opacity { NumberAnimation { duration: 300 } }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: dayNightTrack.parent.isNight ? "\uD83C\uDF19" : "\u2600"
                    font.pixelSize: Style.resize(20)
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: dayNightTrack.parent.isNight = !dayNightTrack.parent.isNight
            }
        }

        // Status text
        Label {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: parent.isNight ? "Night Mode" : "Day Mode"
            font.pixelSize: Style.resize(14)
            color: parent.isNight ? "#90CAF9" : "#FFD54F"
            font.bold: true

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }
}
