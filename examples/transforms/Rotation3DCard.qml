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
        spacing: Style.resize(8)

        Label {
            text: "3D Rotation"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // X axis
        RowLayout {
            Layout.fillWidth: true
            Label { text: "X: " + xRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#E74C3C"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: xRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        // Y axis
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Y: " + yRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#00D1A9"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: yRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        // Z axis
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Z: " + zRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#4A90D9"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: zRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        Button {
            text: "Reset"
            onClicked: { xRotSlider.value = 0; yRotSlider.value = 0; zRotSlider.value = 0 }
        }

        // 3D preview
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(6)
            }

            Rectangle {
                id: rect3d
                anchors.centerIn: parent
                width: Style.resize(100)
                height: Style.resize(100)
                radius: Style.resize(10)
                color: "#4A90D9"

                transform: [
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 1; y: 0; z: 0 }
                        angle: xRotSlider.value
                    },
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: yRotSlider.value
                    },
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 0; y: 0; z: 1 }
                        angle: zRotSlider.value
                    }
                ]

                Label {
                    anchors.centerIn: parent
                    text: "3D"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: "white"
                }
            }
        }

        Label {
            text: "Rotation with axis { x; y; z } creates 3D perspective effects"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
