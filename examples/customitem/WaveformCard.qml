import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool animating: false

    Timer {
        interval: 50
        running: root.animating
        repeat: true
        onTriggered: waveform.phase += 0.15
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Waveform Display"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem — sine wave with QPainterPath"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Waveform display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            WaveformItem {
                id: waveform
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                frequency: freqSlider.value
                amplitude: ampSlider.value
                lineWidth: 2
            }
        }

        // Frequency
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Freq:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                id: freqSlider
                Layout.fillWidth: true
                from: 0.5; to: 8.0; value: 2.0
            }

            Label {
                text: freqSlider.value.toFixed(1) + " Hz"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // Amplitude
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Amp:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                id: ampSlider
                Layout.fillWidth: true
                from: 0.1; to: 1.0; value: 0.8
            }

            Label {
                text: (ampSlider.value * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: root.animating ? "Stop" : "Animate"
                implicitHeight: Style.resize(34)
                onClicked: root.animating = !root.animating
            }

            Button {
                text: "Reset"
                implicitHeight: Style.resize(34)
                onClicked: {
                    waveform.phase = 0
                    freqSlider.value = 2.0
                    ampSlider.value = 0.8
                    root.animating = false
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Grid:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Switch {
                checked: waveform.showGrid
                onCheckedChanged: waveform.showGrid = checked
            }
        }
    }
}
