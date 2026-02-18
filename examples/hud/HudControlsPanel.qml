import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    readonly property real pitch: pitchSlider.value
    readonly property real roll: rollSlider.value
    readonly property real heading: headingSlider.value
    readonly property real speed: speedSlider.value
    readonly property real altitude: altSlider.value
    readonly property real fpa: fpaSlider.value

    color: Style.cardColor
    radius: Style.resize(8)

    GridLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(10)
        columns: 6
        rowSpacing: Style.resize(4)
        columnSpacing: Style.resize(10)

        // Row 1
        Label {
            text: "Pitch"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: pitchSlider
                Layout.fillWidth: true
                from: -20; to: 20; value: 5
            }
            Label {
                text: pitchSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        Label {
            text: "Roll"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: rollSlider
                Layout.fillWidth: true
                from: -45; to: 45; value: 0
            }
            Label {
                text: rollSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        Label {
            text: "Heading"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: headingSlider
                Layout.fillWidth: true
                from: 0; to: 359; value: 0
            }
            Label {
                text: headingSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        // Row 2
        Label {
            text: "Speed"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from: 100; to: 600; value: 350
            }
            Label {
                text: speedSlider.value.toFixed(0) + " kt"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(45)
            }
        }

        Label {
            text: "Altitude"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: altSlider
                Layout.fillWidth: true
                from: 0; to: 50000; value: 25000
            }
            Label {
                text: altSlider.value.toFixed(0) + " ft"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(55)
            }
        }

        Label {
            text: "FPA"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: fpaSlider
                Layout.fillWidth: true
                from: -10; to: 10; value: 2
            }
            Label {
                text: fpaSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }
    }
}
