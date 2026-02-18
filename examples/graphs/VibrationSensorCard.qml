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
            text: "Vibration Sensor"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Amplitude slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Amplitude: " + vibAmpSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibAmpSlider; anchors.fill: parent; from: 0.0; to: 1.0; value: 0.5; stepSize: 0.05 }
            }
        }

        // Frequency slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Frequency: " + vibFreqSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibFreqSlider; anchors.fill: parent; from: 0.0; to: 1.0; value: 0.5; stepSize: 0.05 }
            }
        }

        // Resolution slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Points: " + vibResSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibResSlider; anchors.fill: parent; from: 10; to: 500; value: 500; stepSize: 10;
                    onValueChanged: vibLine.change(value)
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
                    max: 8
                }

                axisY: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    max: 8
                }

                LineSeries {
                    id: vibLine
                    property int divisions: 500
                    property real amplitude: vibAmpSlider.value
                    property real resolution: vibFreqSlider.value

                    color: Style.mainColor
                    width: 2

                    FrameAnimation {
                        running: root.active
                        onTriggered: {
                            for (let i = 0; i < vibLine.divisions; ++i) {
                                let y = Math.sin(vibLine.resolution * i)
                                y *= Math.cos(i)
                                y *= Math.sin(i / vibLine.divisions * 3.2) * 3 * vibLine.amplitude * Math.random()
                                vibLine.replace(i, (i / vibLine.divisions) * 8.0, y + 4)
                            }
                        }
                    }

                    Component.onCompleted: {
                        for (let i = 1; i <= divisions; ++i)
                            append((i / divisions) * 8.0, 4.0)
                    }

                    function change(newDivs) {
                        let delta = newDivs - divisions
                        if (delta < 0) {
                            delta = Math.abs(delta)
                            removeMultiple(count - 1 - delta, delta)
                        } else {
                            for (let i = 0; i < delta; ++i)
                                append(((count + i) / divisions) * 8.0, 4.0)
                        }
                        divisions = newDivs
                    }
                }
            }
        }

        Label {
            text: "FrameAnimation + LineSeries.replace() for 60fps fluid updates"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
