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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        Label {
            text: "Multi-Series"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Frequency slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Freq: " + multiFreqSlider.value.toFixed(1); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: multiFreqSlider; anchors.fill: parent; from: 0.5; to: 5.0; value: 2.0; stepSize: 0.1 }
            }
        }

        // Phase slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Phase: " + multiPhaseSlider.value.toFixed(1); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: multiPhaseSlider; anchors.fill: parent; from: 0.0; to: 6.28; value: 1.0; stepSize: 0.1 }
            }
        }

        // Legend
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)
            Repeater {
                model: [
                    { label: "Sin", clr: "#00D1A9" },
                    { label: "Cos", clr: "#4A90D9" },
                    { label: "Sawtooth", clr: "#FEA601" }
                ]
                RowLayout {
                    spacing: Style.resize(4)
                    Rectangle { width: Style.resize(12); height: Style.resize(3); color: modelData.clr; radius: 1 }
                    Label { text: modelData.label; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                }
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
                    max: 100
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
                    id: sinSeries
                    color: "#00D1A9"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }
                }

                LineSeries {
                    id: cosSeries
                    color: "#4A90D9"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }
                }

                LineSeries {
                    id: sawSeries
                    color: "#FEA601"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }

                    property real time: 0

                    FrameAnimation {
                        running: root.active
                        onTriggered: {
                            sawSeries.time += 0.03
                            let freq = multiFreqSlider.value
                            let phase = multiPhaseSlider.value

                            for (let i = 0; i < 100; ++i) {
                                let x = i / 100.0 * Math.PI * 4.0
                                let t = x + sawSeries.time * freq

                                // Sin series
                                let ys = Math.sin(t) * 2.5 + 4.0
                                sinSeries.replace(i, i, ys)

                                // Cos series (phase offset)
                                let yc = Math.cos(t + phase) * 2.5 + 4.0
                                cosSeries.replace(i, i, yc)

                                // Sawtooth series
                                let sawVal = ((t + phase * 2) % (Math.PI * 2)) / (Math.PI * 2)
                                let ysaw = (sawVal * 2.0 - 1.0) * 2.0 + 4.0
                                sawSeries.replace(i, i, ysaw)
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: "3 LineSeries overlaid with real-time FrameAnimation updates"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
