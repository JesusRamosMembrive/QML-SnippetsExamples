import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool kaleidoRunning: false

    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "6. Kaleidoscope"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.kaleidoRunning ? "Pause" : "Start"
            onClicked: root.kaleidoRunning = !root.kaleidoRunning
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: "#0A0A14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: kaleidoCanvas
            anchors.centerIn: parent
            onAvailableChanged: if (available) requestPaint()
            width: Math.min(parent.width - Style.resize(20), Style.resize(280))
            height: width

            property real time: 0
            property int segments: 8

            Timer {
                interval: 50
                repeat: true
                running: root.active && root.kaleidoRunning
                onTriggered: {
                    kaleidoCanvas.time += 0.03
                    kaleidoCanvas.requestPaint()
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

                // Clip to circle
                ctx.save()
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.clip()

                ctx.fillStyle = "#0A0A14"
                ctx.fillRect(0, 0, w, h)

                var segAngle = 2 * Math.PI / segments

                for (var seg = 0; seg < segments; seg++) {
                    ctx.save()
                    ctx.translate(cx, cy)
                    ctx.rotate(seg * segAngle)
                    if (seg % 2 === 1)
                        ctx.scale(1, -1)

                    var numShapes = 6
                    for (var i = 0; i < numShapes; i++) {
                        var phase = time + i * 0.8
                        var dist = 20 + 40 * Math.sin(phase * 0.7) + i * 15
                        var sx = dist * Math.cos(phase * 0.3 + i)
                        var sy = dist * Math.sin(phase * 0.5 + i) * 0.4
                        var size = 4 + 6 * Math.sin(phase * 1.2)

                        // Smooth color cycling via sine waves
                        var ct = time * 0.5 + i * 0.4 + seg * 0.3
                        var cr = Math.round(127 + 128 * Math.sin(ct))
                        var cg = Math.round(127 + 128 * Math.sin(ct + 2.1))
                        var cb = Math.round(127 + 128 * Math.sin(ct + 4.2))

                        ctx.beginPath()
                        ctx.arc(sx, sy, Math.abs(size), 0, 2 * Math.PI)
                        ctx.fillStyle = "rgb(" + cr + "," + cg + "," + cb + ")"
                        ctx.fill()

                        // Connecting lines between dots
                        if (i > 0) {
                            var prevPhase = time + (i - 1) * 0.8
                            var prevDist = 20 + 40 * Math.sin(prevPhase * 0.7) + (i - 1) * 15
                            var prevSx = prevDist * Math.cos(prevPhase * 0.3 + (i - 1))
                            var prevSy = prevDist * Math.sin(prevPhase * 0.5 + (i - 1)) * 0.4

                            ctx.beginPath()
                            ctx.moveTo(prevSx, prevSy)
                            ctx.lineTo(sx, sy)
                            ctx.strokeStyle = "rgba(" + cr + "," + cg + "," + cb + ", 0.3)"
                            ctx.lineWidth = 1
                            ctx.stroke()
                        }
                    }

                    ctx.restore()
                }

                ctx.restore()

                // Border ring
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.strokeStyle = "#333355"
                ctx.lineWidth = 2
                ctx.stroke()
            }
        }
    }
}
