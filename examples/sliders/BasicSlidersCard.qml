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
            text: "Basic Sliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Horizontal Slider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Horizontal Slider: " + horizontalSlider.value.toFixed(2)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)
                Layout.preferredWidth: root.width - 10

                Slider {
                    id: horizontalSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    value: 50
                }
            }
        }

        // Stepped Slider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Stepped Slider (step: 10): " + steppedSlider.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    id: steppedSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    stepSize: 10
                    value: 50
                    snapMode: Slider.SnapAlways
                }
            }
        }

        // Disabled Slider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Disabled Slider"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    value: 75
                    enabled: false
                }
            }
        }
    }
}
