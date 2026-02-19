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
        spacing: Style.resize(20)

        Label {
            text: "Interactive Gradient Demo"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Control the gradient stops with the range slider"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Gradient preview
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            radius: Style.resize(8)

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#1A1D23" }
                GradientStop { position: gradientRange.first.value / 100; color: Style.mainColor }
                GradientStop { position: gradientRange.second.value / 100; color: "#FEA601" }
                GradientStop { position: 1.0; color: "#1A1D23" }
            }
        }

        // Gradient range control
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Gradient Stops"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: gradientRange.first.value.toFixed(0) + "% — " + gradientRange.second.value.toFixed(0) + "%"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: gradientRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 25
                    second.value: 75
                }
            }
        }

        // Opacity range control
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Opacity Window"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: opacityRange.first.value.toFixed(0) + "% — " + opacityRange.second.value.toFixed(0) + "%"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: opacityRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 30
                    second.value: 90
                }
            }

            // Opacity preview boxes
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(4)

                Repeater {
                    model: 10
                    Rectangle {
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(30)
                        radius: Style.resize(4)
                        color: Style.mainColor
                        opacity: {
                            var pos = (index + 0.5) * 10
                            var lo = opacityRange.first.value
                            var hi = opacityRange.second.value
                            if (pos >= lo && pos <= hi) return 1.0
                            return 0.15
                        }
                    }
                }
            }
        }
    }
}
