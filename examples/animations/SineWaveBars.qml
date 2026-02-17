import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    // ── Section title ────────────────────────────────
    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Sine Wave Bars"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
            Layout.fillWidth: true
        }
        Button {
            text: root.sectionActive ? "\u25A0 Stop" : "\u25B6 Play"
            flat: true
            font.pixelSize: Style.resize(12)
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    // ── Content ──────────────────────────────────────
    Item {
        id: content
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(160)

        property real time: 0
        property bool running: root.active && root.sectionActive
        property real freq: waveFreqSlider.value
        property real amp: waveAmpSlider.value

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Timer {
            running: content.running
            interval: 30
            repeat: true
            onTriggered: content.time += 0.06
        }

        Row {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: Style.resize(-10)
            spacing: Style.resize(3)

            Repeater {
                model: 32
                delegate: Rectangle {
                    id: waveBar
                    required property int index

                    readonly property real phase: waveBar.index * content.freq * 0.3
                    readonly property real wave:
                        Math.sin(content.time * 3 + phase) * content.amp

                    width: Style.resize(10)
                    height: Style.resize(20) + Math.abs(wave) * Style.resize(80)
                    radius: Style.resize(3)
                    anchors.verticalCenter: parent.verticalCenter

                    color: Qt.hsla(
                        0.47 + waveBar.index * 0.015,
                        0.7,
                        0.45 + Math.abs(wave) * 0.2,
                        1.0)

                    Behavior on height {
                        NumberAnimation { duration: 50 }
                    }
                }
            }
        }

        // Controls
        Row {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Style.resize(5)
            spacing: Style.resize(20)

            Row {
                spacing: Style.resize(5)
                Label {
                    text: "Freq"
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Slider {
                    id: waveFreqSlider
                    width: Style.resize(100)
                    from: 0.3; to: 3; value: 1; stepSize: 0.1
                }
            }

            Row {
                spacing: Style.resize(5)
                Label {
                    text: "Amp"
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Slider {
                    id: waveAmpSlider
                    width: Style.resize(100)
                    from: 0.1; to: 1.5; value: 1; stepSize: 0.1
                }
            }
        }
    }
}
