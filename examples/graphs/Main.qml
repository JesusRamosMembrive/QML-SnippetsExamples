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

                // ========================================
                // Card 5: Custom Graph Creations
                // ========================================
                Rectangle {
                    id: card5Graphs
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    property bool monitorActive: false

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Graph Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Canvas-based charts: system monitor, radar, candlestick, donut, scatter, heatmap"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // --- Section 1: System Monitor ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "1. System Monitor"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Graphs.monitorActive ? "Pause" : "Start"
                                    onClicked: card5Graphs.monitorActive = !card5Graphs.monitorActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(220)
                                color: "#0A0E14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: monitorCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property var coreHistory: []
                                    property var coreTargets: [0.3, 0.5, 0.2, 0.4]
                                    property var coreCurrent: [0.3, 0.5, 0.2, 0.4]
                                    property int histLen: 100

                                    Component.onCompleted: {
                                        var h = []
                                        for (var c = 0; c < 4; c++) {
                                            var ch = []
                                            for (var i = 0; i < histLen; i++) ch.push(0.25)
                                            h.push(ch)
                                        }
                                        coreHistory = h
                                    }

                                    Timer {
                                        interval: 60
                                        repeat: true
                                        running: root.fullSize && card5Graphs.monitorActive
                                        onTriggered: {
                                            var h = monitorCanvas.coreHistory
                                            var tgts = monitorCanvas.coreTargets
                                            var cur = monitorCanvas.coreCurrent
                                            if (!h || h.length < 4) return

                                            for (var c = 0; c < 4; c++) {
                                                if (Math.random() < 0.08) tgts[c] = Math.random() * 0.8 + 0.05
                                                cur[c] += (tgts[c] - cur[c]) * 0.15
                                                h[c].push(cur[c])
                                                if (h[c].length > monitorCanvas.histLen) h[c].shift()
                                            }
                                            monitorCanvas.coreTargets = tgts
                                            monitorCanvas.coreCurrent = cur
                                            monitorCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var colors = ["#00D1A9", "#4A90D9", "#FEA601", "#9B59B6"]
                                        var data = coreHistory
                                        if (!data || data.length < 4 || !data[0] || data[0].length < 2) return
                                        var len = data[0].length

                                        // Grid lines
                                        ctx.strokeStyle = "#1A2030"
                                        ctx.lineWidth = 0.5
                                        for (var g = 0; g <= 4; g++) {
                                            var gy = h - g / 4 * h * 0.9
                                            ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke()
                                        }

                                        // Stacked area charts
                                        for (var c = 3; c >= 0; c--) {
                                            ctx.beginPath()
                                            for (var i = 0; i < len; i++) {
                                                var x = i / (len - 1) * w
                                                var sv = 0
                                                for (var j = 0; j <= c; j++) sv += data[j][i]
                                                var y = h - sv / 4 * h * 0.88
                                                if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y)
                                            }
                                            for (var i = len - 1; i >= 0; i--) {
                                                var x = i / (len - 1) * w
                                                var sv = 0
                                                for (var j = 0; j < c; j++) sv += data[j][i]
                                                var y = h - sv / 4 * h * 0.88
                                                ctx.lineTo(x, y)
                                            }
                                            ctx.closePath()
                                            ctx.fillStyle = colors[c] + "40"
                                            ctx.fill()
                                            ctx.strokeStyle = colors[c]
                                            ctx.lineWidth = 1.5
                                            ctx.stroke()
                                        }

                                        // Core labels
                                        ctx.font = "10px monospace"
                                        ctx.textAlign = "right"
                                        var cur = coreCurrent
                                        for (var c = 0; c < 4; c++) {
                                            ctx.fillStyle = colors[c]
                                            ctx.fillText("Core " + c + ": " + Math.round((cur[c] || 0) * 100) + "%", w - 5, 14 + c * 14)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 2: Radar Chart ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "2. Radar Chart"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Randomize"
                                    onClicked: {
                                        var p = [], e = []
                                        for (var i = 0; i < 5; i++) {
                                            p.push(Math.round(Math.random() * 40 + 60))
                                            e.push(Math.round(Math.random() * 50 + 30))
                                        }
                                        radarCanvas.playerStats = p
                                        radarCanvas.enemyStats = e
                                        radarCanvas.requestPaint()
                                    }
                                }
                            }

                            // Legend
                            RowLayout {
                                spacing: Style.resize(15)
                                Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00D1A9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Player"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
                                Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#FF5900"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Enemy"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(280)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: radarCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - Style.resize(20), Style.resize(270))
                                    height: width

                                    property var playerStats: [85, 70, 60, 90, 55]
                                    property var enemyStats: [60, 80, 75, 45, 70]
                                    property var labels: ["ATK", "DEF", "SPD", "HP", "MP"]

                                    function drawDataset(ctx, cx, cy, r, data, strokeColor, fillColor) {
                                        ctx.beginPath()
                                        for (var i = 0; i < data.length; i++) {
                                            var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                                            var val = data[i] / 100 * r
                                            var px = cx + val * Math.cos(angle)
                                            var py = cy + val * Math.sin(angle)
                                            if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                                        }
                                        ctx.closePath()
                                        ctx.fillStyle = fillColor
                                        ctx.fill()
                                        ctx.strokeStyle = strokeColor
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        // Data point dots
                                        for (var i = 0; i < data.length; i++) {
                                            var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                                            var val = data[i] / 100 * r
                                            ctx.beginPath()
                                            ctx.arc(cx + val * Math.cos(angle), cy + val * Math.sin(angle), 3, 0, 2 * Math.PI)
                                            ctx.fillStyle = strokeColor
                                            ctx.fill()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cx = w / 2, cy = h / 2
                                        var r = Math.min(cx, cy) - 30
                                        var N = 5

                                        // Grid pentagons
                                        for (var ring = 1; ring <= 5; ring++) {
                                            var rr = r * ring / 5
                                            ctx.beginPath()
                                            for (var i = 0; i < N; i++) {
                                                var angle = i * 2 * Math.PI / N - Math.PI / 2
                                                var px = cx + rr * Math.cos(angle)
                                                var py = cy + rr * Math.sin(angle)
                                                if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                                            }
                                            ctx.closePath()
                                            ctx.strokeStyle = ring === 5 ? "#444" : "#2A2D35"
                                            ctx.lineWidth = ring === 5 ? 1.5 : 0.5
                                            ctx.stroke()
                                        }

                                        // Spokes
                                        for (var i = 0; i < N; i++) {
                                            var angle = i * 2 * Math.PI / N - Math.PI / 2
                                            ctx.beginPath()
                                            ctx.moveTo(cx, cy)
                                            ctx.lineTo(cx + r * Math.cos(angle), cy + r * Math.sin(angle))
                                            ctx.strokeStyle = "#2A2D35"
                                            ctx.lineWidth = 0.5
                                            ctx.stroke()
                                        }

                                        // Datasets
                                        drawDataset(ctx, cx, cy, r, enemyStats, "#FF5900", "rgba(255,89,0,0.15)")
                                        drawDataset(ctx, cx, cy, r, playerStats, "#00D1A9", "rgba(0,209,169,0.2)")

                                        // Axis labels
                                        ctx.font = "bold 12px sans-serif"
                                        ctx.textAlign = "center"
                                        ctx.textBaseline = "middle"
                                        for (var i = 0; i < N; i++) {
                                            var angle = i * 2 * Math.PI / N - Math.PI / 2
                                            var lx = cx + (r + 18) * Math.cos(angle)
                                            var ly = cy + (r + 18) * Math.sin(angle)
                                            ctx.fillStyle = "#888"
                                            ctx.fillText(labels[i], lx, ly)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 3: Candlestick Chart ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "3. Candlestick Chart"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Randomize"
                                    onClicked: candleCanvas.generateCandles()
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(220)
                                color: "#0A0E14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: candleCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property var candles: []

                                    function generateCandles() {
                                        var c = []
                                        var price = 100 + Math.random() * 50
                                        for (var i = 0; i < 24; i++) {
                                            var change = (Math.random() - 0.45) * 8
                                            var open = price
                                            var close = price + change
                                            var high = Math.max(open, close) + Math.random() * 4
                                            var low = Math.min(open, close) - Math.random() * 4
                                            c.push({ o: open, c: close, h: high, l: low })
                                            price = close
                                        }
                                        candles = c
                                        requestPaint()
                                    }

                                    Component.onCompleted: generateCandles()

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        if (candles.length === 0) return
                                        var pad = 10

                                        // Find price range
                                        var minP = 99999, maxP = 0
                                        for (var i = 0; i < candles.length; i++) {
                                            if (candles[i].l < minP) minP = candles[i].l
                                            if (candles[i].h > maxP) maxP = candles[i].h
                                        }
                                        minP -= 2; maxP += 2
                                        var range = maxP - minP

                                        function yScale(val) { return pad + (1 - (val - minP) / range) * (h - 2 * pad) }

                                        var candleW = (w - 2 * pad) / candles.length * 0.6
                                        var spacing = (w - 2 * pad) / candles.length

                                        // Grid
                                        ctx.strokeStyle = "#1A2030"
                                        ctx.lineWidth = 0.5
                                        ctx.font = "9px monospace"
                                        ctx.fillStyle = "#444"
                                        ctx.textAlign = "left"
                                        for (var g = 0; g <= 4; g++) {
                                            var gPrice = minP + range * g / 4
                                            var gy = yScale(gPrice)
                                            ctx.beginPath(); ctx.moveTo(pad, gy); ctx.lineTo(w - pad, gy); ctx.stroke()
                                            ctx.fillText(gPrice.toFixed(1), 2, gy - 3)
                                        }

                                        // Moving average
                                        ctx.beginPath()
                                        var maWindow = 5
                                        for (var i = maWindow - 1; i < candles.length; i++) {
                                            var sum = 0
                                            for (var j = i - maWindow + 1; j <= i; j++) sum += candles[j].c
                                            var maY = yScale(sum / maWindow)
                                            var maX = pad + i * spacing + spacing / 2
                                            if (i === maWindow - 1) ctx.moveTo(maX, maY); else ctx.lineTo(maX, maY)
                                        }
                                        ctx.strokeStyle = "#FEA601"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()

                                        // Candles
                                        for (var i = 0; i < candles.length; i++) {
                                            var cd = candles[i]
                                            var x = pad + i * spacing + spacing / 2
                                            var isUp = cd.c >= cd.o
                                            var color = isUp ? "#27AE60" : "#E74C3C"

                                            // Wick
                                            ctx.beginPath()
                                            ctx.moveTo(x, yScale(cd.h))
                                            ctx.lineTo(x, yScale(cd.l))
                                            ctx.strokeStyle = color
                                            ctx.lineWidth = 1
                                            ctx.stroke()

                                            // Body
                                            var bodyTop = yScale(Math.max(cd.o, cd.c))
                                            var bodyBot = yScale(Math.min(cd.o, cd.c))
                                            var bodyH = Math.max(1, bodyBot - bodyTop)
                                            ctx.fillStyle = color
                                            ctx.fillRect(x - candleW / 2, bodyTop, candleW, bodyH)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 4: Donut Chart ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "4. Donut Chart"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Randomize"
                                    onClicked: {
                                        var s = donutCanvas.segments
                                        for (var i = 0; i < s.length; i++)
                                            s[i].value = Math.round(Math.random() * 40 + 5)
                                        donutCanvas.segments = s
                                        donutCanvas.requestPaint()
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(250)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: donutCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - Style.resize(20), Style.resize(240))
                                    height: width

                                    property var segments: [
                                        { value: 35, color: "#00D1A9", label: "QML" },
                                        { value: 25, color: "#4A90D9", label: "C++" },
                                        { value: 20, color: "#FEA601", label: "Python" },
                                        { value: 12, color: "#9B59B6", label: "JS" },
                                        { value: 8, color: "#E74C3C", label: "Other" }
                                    ]

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cx = w / 2, cy = h / 2
                                        var outerR = Math.min(cx, cy) - 8
                                        var innerR = outerR * 0.55
                                        var total = 0
                                        for (var i = 0; i < segments.length; i++) total += segments[i].value

                                        var startAngle = -Math.PI / 2
                                        for (var i = 0; i < segments.length; i++) {
                                            var sweep = segments[i].value / total * 2 * Math.PI
                                            ctx.beginPath()
                                            ctx.arc(cx, cy, outerR, startAngle, startAngle + sweep)
                                            ctx.arc(cx, cy, innerR, startAngle + sweep, startAngle, true)
                                            ctx.closePath()
                                            ctx.fillStyle = segments[i].color
                                            ctx.fill()

                                            // Segment border
                                            ctx.strokeStyle = Style.surfaceColor
                                            ctx.lineWidth = 2
                                            ctx.stroke()

                                            // Label line
                                            var midAngle = startAngle + sweep / 2
                                            var labelR = outerR + 12
                                            var lx = cx + labelR * Math.cos(midAngle)
                                            var ly = cy + labelR * Math.sin(midAngle)
                                            ctx.font = "10px sans-serif"
                                            ctx.textAlign = midAngle > Math.PI / 2 || midAngle < -Math.PI / 2 ? "right" : "left"
                                            ctx.textBaseline = "middle"
                                            ctx.fillStyle = segments[i].color
                                            ctx.fillText(segments[i].label + " " + Math.round(segments[i].value / total * 100) + "%", lx, ly)

                                            startAngle += sweep
                                        }

                                        // Center text
                                        ctx.font = "bold 22px sans-serif"
                                        ctx.fillStyle = "#E0E0E0"
                                        ctx.textAlign = "center"
                                        ctx.textBaseline = "middle"
                                        ctx.fillText(total.toString(), cx, cy - 6)
                                        ctx.font = "10px sans-serif"
                                        ctx.fillStyle = "#888"
                                        ctx.fillText("TOTAL", cx, cy + 12)
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 5: Scatter Plot ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "5. Scatter Plot"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                // Legend
                                Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#00D1A9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "A"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
                                Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#FF5900"; anchors.verticalCenter: parent.verticalCenter } Label { text: "B"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
                                Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#4A90D9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "C"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
                                Item { width: Style.resize(8) }
                                Button {
                                    text: "Randomize"
                                    onClicked: scatterCanvas.regenerate()
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(220)
                                color: "#0A0E14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: scatterCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property var clusters: []

                                    function regenerate() {
                                        var c = []
                                        var centers = [
                                            { cx: 0.22, cy: 0.3, color: "#00D1A9" },
                                            { cx: 0.55, cy: 0.65, color: "#FF5900" },
                                            { cx: 0.8, cy: 0.25, color: "#4A90D9" }
                                        ]
                                        for (var i = 0; i < 3; i++) {
                                            var pts = []
                                            for (var j = 0; j < 18; j++) {
                                                pts.push({
                                                    x: centers[i].cx + (Math.random() - 0.5) * 0.22,
                                                    y: centers[i].cy + (Math.random() - 0.5) * 0.22,
                                                    size: 3 + Math.random() * 4
                                                })
                                            }
                                            c.push({ points: pts, color: centers[i].color })
                                        }
                                        clusters = c
                                        requestPaint()
                                    }

                                    Component.onCompleted: regenerate()

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        // Grid
                                        ctx.strokeStyle = "#1A2030"
                                        ctx.lineWidth = 0.5
                                        for (var gx = 0; gx <= 10; gx++) {
                                            var x = gx / 10 * w
                                            ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke()
                                        }
                                        for (var gy = 0; gy <= 8; gy++) {
                                            var y = gy / 8 * h
                                            ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke()
                                        }

                                        // Axes
                                        ctx.strokeStyle = "#333"
                                        ctx.lineWidth = 1
                                        ctx.beginPath(); ctx.moveTo(0, h); ctx.lineTo(w, h); ctx.stroke()
                                        ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, h); ctx.stroke()

                                        // Points
                                        for (var ci = 0; ci < clusters.length; ci++) {
                                            var cl = clusters[ci]
                                            for (var pi = 0; pi < cl.points.length; pi++) {
                                                var pt = cl.points[pi]
                                                ctx.beginPath()
                                                ctx.arc(pt.x * w, pt.y * h, pt.size, 0, 2 * Math.PI)
                                                ctx.fillStyle = cl.color + "80"
                                                ctx.fill()
                                                ctx.strokeStyle = cl.color
                                                ctx.lineWidth = 1
                                                ctx.stroke()
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 6: Heatmap ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "6. Heatmap"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)
                                Label { text: "Phase: " + heatSlider.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                Slider { id: heatSlider; from: 0; to: 6.28; value: 0; stepSize: 0.1; Layout.fillWidth: true; onValueChanged: heatCanvas.requestPaint() }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(200)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: heatCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property int cols: 16
                                    property int rows: 10

                                    function heatColor(val) {
                                        var r, g, b
                                        if (val < 0.5) {
                                            var t = val * 2
                                            r = 0; g = Math.round(t * 255); b = Math.round((1 - t) * 255)
                                        } else {
                                            var t = (val - 0.5) * 2
                                            r = Math.round(t * 255); g = Math.round((1 - t) * 255); b = 0
                                        }
                                        return "rgb(" + r + "," + g + "," + b + ")"
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cellW = w / cols
                                        var cellH = h / rows
                                        var phase = heatSlider.value

                                        for (var r = 0; r < rows; r++) {
                                            for (var c = 0; c < cols; c++) {
                                                var val = (Math.sin(c * 0.5 + phase) + Math.cos(r * 0.6 + phase * 0.7) + Math.sin((c + r) * 0.3 - phase * 0.5) + 3) / 6
                                                val = Math.max(0, Math.min(1, val))
                                                ctx.fillStyle = heatColor(val)
                                                ctx.fillRect(c * cellW + 1, r * cellH + 1, cellW - 2, cellH - 2)
                                            }
                                        }

                                        // Color scale bar
                                        var barW = 12, barH = h - 10
                                        var barX = w - barW - 3, barY = 5
                                        for (var i = 0; i < barH; i++) {
                                            var v = 1 - i / barH
                                            ctx.fillStyle = heatColor(v)
                                            ctx.fillRect(barX, barY + i, barW, 1)
                                        }
                                        ctx.strokeStyle = "#444"
                                        ctx.lineWidth = 1
                                        ctx.strokeRect(barX, barY, barW, barH)

                                        ctx.font = "9px monospace"
                                        ctx.fillStyle = "#888"
                                        ctx.textAlign = "right"
                                        ctx.fillText("Hot", barX - 3, barY + 8)
                                        ctx.fillText("Cold", barX - 3, barY + barH - 2)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
