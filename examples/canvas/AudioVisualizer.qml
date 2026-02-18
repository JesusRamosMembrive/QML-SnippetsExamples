import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool vizRunning: false

    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "3. Audio Visualizer"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.vizRunning ? "Pause" : "Start"
            onClicked: root.vizRunning = !root.vizRunning
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: "#0A0A14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: vizCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)
            onAvailableChanged: if (available) requestPaint()

            property var levels: []
            property var targets: []
            property var peaks: []
            property int barCount: 32

            Component.onCompleted: {
                var l = [], t = [], p = []
                for (var i = 0; i < barCount; i++) {
                    l.push(0); t.push(0); p.push(0)
                }
                levels = l; targets = t; peaks = p
            }

            Timer {
                interval: 60
                repeat: true
                running: root.active && root.vizRunning
                onTriggered: {
                    var l = vizCanvas.levels.slice()
                    var t = vizCanvas.targets.slice()
                    var p = vizCanvas.peaks.slice()

                    for (var i = 0; i < vizCanvas.barCount; i++) {
                        if (Math.random() < 0.15)
                            t[i] = Math.random() * 0.3 + 0.05
                        else if (Math.random() < 0.08)
                            t[i] = Math.random() * 0.9 + 0.1

                        l[i] += (t[i] - l[i]) * 0.2
                        if (l[i] > p[i]) p[i] = l[i]
                        else p[i] = Math.max(0, p[i] - 0.008)
                        t[i] *= 0.95
                    }

                    vizCanvas.levels = l
                    vizCanvas.targets = t
                    vizCanvas.peaks = p
                    vizCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width
                var h = height
                ctx.clearRect(0, 0, w, h)

                var barW = (w - (barCount + 1) * 2) / barCount
                var gap = 2

                for (var i = 0; i < barCount; i++) {
                    var barH = levels[i] * h * 0.9
                    var x = gap + i * (barW + gap)
                    var y = h - barH

                    var grad = ctx.createLinearGradient(x, h, x, 0)
                    grad.addColorStop(0, "#00D1A9")
                    grad.addColorStop(0.5, "#FEA601")
                    grad.addColorStop(1, "#E74C3C")
                    ctx.fillStyle = grad
                    ctx.fillRect(x, y, barW, barH)

                    // Peak indicator
                    var peakY = h - peaks[i] * h * 0.9
                    ctx.fillStyle = "#FFFFFF"
                    ctx.fillRect(x, peakY - 2, barW, 2)
                }
            }
        }
    }
}
