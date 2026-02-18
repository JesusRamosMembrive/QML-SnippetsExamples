import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool radarRunning: false

    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "4. Radar Sweep"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.radarRunning ? "Pause" : "Start"
            onClicked: root.radarRunning = !root.radarRunning
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: "#0A0F0A"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: radarCanvas
            anchors.centerIn: parent
            onAvailableChanged: if (available) requestPaint()
            width: Math.min(parent.width - Style.resize(20), Style.resize(280))
            height: width

            property real sweepAngle: 0
            property var blips: []

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.radarRunning
                onTriggered: {
                    radarCanvas.sweepAngle = (radarCanvas.sweepAngle + 2) % 360

                    // Spawn new blips randomly
                    if (Math.random() < 0.03) {
                        var b = radarCanvas.blips.slice()
                        var dist = 0.2 + Math.random() * 0.7
                        var ang = Math.random() * 360
                        b.push({ angle: ang, dist: dist, life: 1.0 })
                        radarCanvas.blips = b
                    }

                    // Decay blips
                    var alive = []
                    for (var i = 0; i < radarCanvas.blips.length; i++) {
                        var bl = radarCanvas.blips[i]
                        bl.life -= 0.005
                        if (bl.life > 0)
                            alive.push(bl)
                    }
                    radarCanvas.blips = alive
                    radarCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width
                var h = height
                var cx = w / 2
                var cy = h / 2
                var r = Math.min(cx, cy) - 4

                ctx.clearRect(0, 0, w, h)

                // Background circle
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.fillStyle = "#0A1A0A"
                ctx.fill()
                ctx.strokeStyle = "#00AA00"
                ctx.lineWidth = 2
                ctx.stroke()

                // Range rings
                ctx.strokeStyle = "#004400"
                ctx.lineWidth = 0.5
                for (var ring = 1; ring <= 4; ring++) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r * ring / 4, 0, 2 * Math.PI)
                    ctx.stroke()
                }

                // Crosshairs
                ctx.beginPath()
                ctx.moveTo(cx - r, cy)
                ctx.lineTo(cx + r, cy)
                ctx.moveTo(cx, cy - r)
                ctx.lineTo(cx, cy + r)
                ctx.stroke()

                // Sweep beam with gradient trail
                var sweepRad = (sweepAngle - 90) * Math.PI / 180
                for (var s = 0; s < 30; s++) {
                    var trailAngle = sweepRad - s * Math.PI / 180 * 1.5
                    var alpha = (1 - s / 30) * 0.3
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + r * Math.cos(trailAngle), cy + r * Math.sin(trailAngle))
                    ctx.strokeStyle = "rgba(0, 255, 0, " + alpha + ")"
                    ctx.lineWidth = 2
                    ctx.stroke()
                }

                // Main sweep line
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + r * Math.cos(sweepRad), cy + r * Math.sin(sweepRad))
                ctx.strokeStyle = "#00FF00"
                ctx.lineWidth = 2
                ctx.stroke()

                // Blips
                for (var b = 0; b < blips.length; b++) {
                    var blip = blips[b]
                    var bRad = (blip.angle - 90) * Math.PI / 180
                    var bx = cx + blip.dist * r * Math.cos(bRad)
                    var by = cy + blip.dist * r * Math.sin(bRad)
                    var bAlpha = blip.life

                    ctx.beginPath()
                    ctx.arc(bx, by, 3, 0, 2 * Math.PI)
                    ctx.fillStyle = "rgba(0, 255, 0, " + bAlpha + ")"
                    ctx.fill()

                    // Glow
                    ctx.beginPath()
                    ctx.arc(bx, by, 6, 0, 2 * Math.PI)
                    ctx.fillStyle = "rgba(0, 255, 0, " + (bAlpha * 0.3) + ")"
                    ctx.fill()
                }

                // Center dot
                ctx.beginPath()
                ctx.arc(cx, cy, 3, 0, 2 * Math.PI)
                ctx.fillStyle = "#00FF00"
                ctx.fill()

                // Range labels
                ctx.font = Math.round(r * 0.08) + "px monospace"
                ctx.fillStyle = "#006600"
                ctx.textAlign = "left"
                ctx.textBaseline = "bottom"
                for (var rl = 1; rl <= 4; rl++) {
                    ctx.fillText(rl * 25 + "nm", cx + r * rl / 4 + 3, cy - 3)
                }
            }
        }
    }
}
