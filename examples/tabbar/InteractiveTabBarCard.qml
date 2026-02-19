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
            text: "TabBar + Controls"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Each tab controls a different property"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Preview rectangle
        Rectangle {
            id: previewRect
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            radius: Style.resize(8)
            color: colorSlider.value < 0.33 ? Style.mainColor
                 : colorSlider.value < 0.66 ? "#FEA601"
                 : "#4FC3F7"
            opacity: opacitySlider.value
            border.width: borderSlider.value
            border.color: "#FFFFFF"

            Behavior on color { ColorAnimation { duration: 200 } }

            Label {
                anchors.centerIn: parent
                text: "Preview"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: "#FFFFFF"
            }
        }

        // TabBar for controls
        TabBar {
            id: controlTabBar
            Layout.fillWidth: true

            TabButton { text: "Color" }
            TabButton { text: "Opacity" }
            TabButton { text: "Border" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: controlTabBar.currentIndex

            // Color tab
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Slide to change color"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: "Teal"; font.pixelSize: Style.resize(12); color: Style.mainColor }
                        Item { Layout.fillWidth: true }
                        Label { text: "Orange"; font.pixelSize: Style.resize(12); color: "#FEA601" }
                        Item { Layout.fillWidth: true }
                        Label { text: "Blue"; font.pixelSize: Style.resize(12); color: "#4FC3F7" }
                    }

                    Slider {
                        id: colorSlider
                        Layout.fillWidth: true
                        from: 0; to: 1; value: 0
                    }
                }
            }

            // Opacity tab
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Opacity: " + (opacitySlider.value * 100).toFixed(0) + "%"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    Slider {
                        id: opacitySlider
                        Layout.fillWidth: true
                        from: 0.1; to: 1.0; value: 1.0
                    }
                }
            }

            // Border tab
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Border width: " + borderSlider.value.toFixed(0) + " px"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    Slider {
                        id: borderSlider
                        Layout.fillWidth: true
                        from: 0; to: 8; value: 0
                        stepSize: 1
                    }
                }
            }
        }
    }
}
