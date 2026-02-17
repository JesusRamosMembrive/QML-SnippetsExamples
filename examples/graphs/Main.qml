import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Graphs Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: Vibration Sensor
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

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
                                            running: root.fullSize
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

                    // ========================================
                    // Card 2: Scrolling Waveform
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(8)

                            Label {
                                text: "Scrolling Waveform"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
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
                                            running: root.fullSize
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

                    // ========================================
                    // Card 3: Bar Series
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Bar Series"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Button {
                                text: "Randomize"
                                onClicked: {
                                    for (let i = 0; i < 6; i++)
                                        barSet.replace(i, Math.random() * 80 + 10)
                                }
                            }

                            // Graph area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#1a1a2e"
                                    radius: Style.resize(6)
                                }

                                GraphsView {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)

                                    theme: GraphsTheme {
                                        backgroundVisible: false
                                        plotAreaBackgroundColor: "transparent"
                                    }

                                    axisX: BarCategoryAxis {
                                        categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                                        lineVisible: false
                                        gridVisible: false
                                    }

                                    axisY: ValueAxis {
                                        min: 0
                                        max: 100
                                        tickInterval: 25
                                        lineVisible: false
                                        subGridVisible: false
                                    }

                                    BarSeries {
                                        BarSet {
                                            id: barSet
                                            label: "Activity"
                                            values: [65, 45, 80, 55, 70, 90]
                                            color: Style.mainColor
                                            borderColor: Qt.darker(Style.mainColor, 1.2)
                                            borderWidth: 1
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "BarSeries with BarCategoryAxis. Click Randomize to update values"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Multi-Series
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

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
                                            running: root.fullSize
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

                } // End of GridLayout
            }
        }
    }
}
