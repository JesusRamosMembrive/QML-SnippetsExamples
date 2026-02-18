import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool carouselActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "1. 3D Carousel"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.carouselActive ? "Pause" : "Start"
            onClicked: root.carouselActive = !root.carouselActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: carouselArea
            anchors.fill: parent

            property real carouselAngle: 0

            Timer {
                interval: 50
                repeat: true
                running: root.active && root.carouselActive
                onTriggered: carouselArea.carouselAngle += 0.8
            }

            Repeater {
                model: [
                    { color: "#00D1A9", label: "Qt", idx: 0 },
                    { color: "#FF5900", label: "QML", idx: 1 },
                    { color: "#4A90D9", label: "C++", idx: 2 },
                    { color: "#9B59B6", label: "JS", idx: 3 },
                    { color: "#FEA601", label: "UI", idx: 4 }
                ]

                Rectangle {
                    property real itemAngle: (carouselArea.carouselAngle + modelData.idx * 72) * Math.PI / 180
                    property real depth: (Math.cos(itemAngle) + 1) / 2

                    x: carouselArea.width / 2 + Math.sin(itemAngle) * carouselArea.width * 0.28 - width / 2
                    y: carouselArea.height / 2 - height / 2 + (1 - depth) * Style.resize(12)
                    z: depth * 10
                    width: Style.resize(90)
                    height: Style.resize(120)
                    radius: Style.resize(10)
                    color: modelData.color
                    scale: 0.55 + 0.45 * depth
                    opacity: 0.3 + 0.7 * depth

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(6)

                        Label {
                            text: modelData.label
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Card " + (modelData.idx + 1)
                            font.pixelSize: Style.resize(11)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
