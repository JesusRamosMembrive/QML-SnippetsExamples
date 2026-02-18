import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool active: false
    property bool animRunning: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Scrolling Waveform"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Button {
                text: root.animRunning ? "Stop" : "Start"
                onClicked: root.animRunning = !root.animRunning
            }
        }

        // Speed slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Speed: " + scrollSpeedSlider.value.toFixed(1) + "x"; font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: scrollSpeedSlider; anchors.fill: parent; from: 0.2; to: 5.0; value: 1.0; stepSize: 0.1 }
            }
        }

        // Waveform selector
        RowLayout {
            id: waveSelector
            Layout.fillWidth: true
            spacing: Style.resize(6)

            property int waveType: 0

            Button {
                text: "Sine"
                highlighted: waveSelector.waveType === 0
                onClicked: waveSelector.waveType = 0
            }
            Button {
                text: "Heartbeat"
                highlighted: waveSelector.waveType === 1
                onClicked: waveSelector.waveType = 1
            }
            Button {
                text: "Noise"
                highlighted: waveSelector.waveType === 2
                onClicked: waveSelector.waveType = 2
            }
        }

        // Graph area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            GraphsView {
                anchors.fill: parent
                anchors.margins: Style.resize(4)

                theme: GraphsTheme {
                    backgroundVisible: false
                    plotAreaBackgroundColor: "transparent"
                }

                axisX: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    max: 200
                }

                axisY: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    min: 0
                    max: 8
                }

                LineSeries {
                    id: scrollLine
                    property int pointCount: 200
                    property real time: 0

                    color: "#4A90D9"
                    width: 2

                    FrameAnimation {
                        running: root.active && root.animRunning
                        onTriggered: {
                            scrollLine.time += 0.04 * scrollSpeedSlider.value
                            var waveType = waveSelector.waveType

                            for (let i = 0; i < scrollLine.pointCount; ++i) {
                                let t = scrollLine.time + (i / scrollLine.pointCount) * 6.0
                                let y = 4.0

                                if (waveType === 0) {
                                    // Sine wave with harmonics
                                    y = Math.sin(t * 3.0) * 2.0 + Math.sin(t * 7.1) * 0.5 + 4.0
                                } else if (waveType === 1) {
                                    // Heartbeat-like: sharp spikes
                                    let phase = (t * 1.5) % (Math.PI * 2)
                                    y = 4.0
                                    if (phase < 0.3)
                                        y += Math.sin(phase / 0.3 * Math.PI) * 0.5
                                    else if (phase > 1.0 && phase < 1.3)
                                        y += Math.sin((phase - 1.0) / 0.3 * Math.PI) * 3.0
                                    else if (phase > 1.3 && phase < 1.8)
                                        y -= Math.sin((phase - 1.3) / 0.5 * Math.PI) * 1.0
                                    else if (phase > 2.2 && phase < 2.7)
                                        y += Math.sin((phase - 2.2) / 0.5 * Math.PI) * 0.8
                                } else {
                                    // Filtered noise
                                    y = Math.sin(t * 5.0) * 1.5 + Math.sin(t * 13.7) * 0.8 + Math.sin(t * 23.1) * 0.4 + 4.0
                                }

                                scrollLine.replace(i, i, y)
                            }
                        }
                    }

                    Component.onCompleted: {
                        for (let i = 0; i < pointCount; ++i)
                            append(i, 4.0)
                    }
                }
            }
        }

        Label {
            text: "Real-time scrolling line chart, updated every frame"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
