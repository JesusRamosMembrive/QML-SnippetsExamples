import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Circular Gauge"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem — arc gauge with needle"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Gauges side by side
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(10)

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                GaugeItem {
                    id: rpmGauge
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) - Style.resize(10)
                    height: width
                    value: rpmSlider.value
                    minValue: 0
                    maxValue: 8000
                    label: "RPM"
                    gaugeColor: "#00D1A9"
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                GaugeItem {
                    id: speedGauge
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) - Style.resize(10)
                    height: width
                    value: speedSlider.value
                    minValue: 0
                    maxValue: 260
                    label: "km/h"
                    gaugeColor: "#FF6B6B"
                }
            }
        }

        // RPM slider
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "RPM:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(50)
            }

            Slider {
                id: rpmSlider
                Layout.fillWidth: true
                from: 0; to: 8000; value: 3500
            }

            Label {
                text: rpmSlider.value.toFixed(0)
                font.pixelSize: Style.resize(11)
                color: "#00D1A9"
                Layout.preferredWidth: Style.resize(45)
            }
        }

        // Speed slider
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Speed:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(50)
            }

            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from: 0; to: 260; value: 120
            }

            Label {
                text: speedSlider.value.toFixed(0)
                font.pixelSize: Style.resize(11)
                color: "#FF6B6B"
                Layout.preferredWidth: Style.resize(45)
            }
        }
    }
}
