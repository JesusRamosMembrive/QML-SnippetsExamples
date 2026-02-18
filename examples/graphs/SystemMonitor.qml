import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool monitorActive: false

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
            text: root.monitorActive ? "Pause" : "Start"
            onClicked: root.monitorActive = !root.monitorActive
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
                running: root.active && root.monitorActive
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
