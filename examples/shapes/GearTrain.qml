import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "1. Gear Train"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.sectionActive ? "Pause" : "Start"
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(250)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: gearCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            property real gearAngle: 0

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.sectionActive
                onTriggered: {
                    gearCanvas.gearAngle = (gearCanvas.gearAngle + 1.5) % 360
                    gearCanvas.requestPaint()
                }
            }

            function drawGear(ctx, gx, gy, pitchR, teeth, angleDeg, fillCol, strokeCol) {
                var toothH = pitchR * 0.18
                var outerR = pitchR + toothH
                var innerR = pitchR - toothH
                ctx.save()
                ctx.translate(gx, gy)
                ctx.rotate(angleDeg * Math.PI / 180)

                ctx.beginPath()
                for (var i = 0; i < teeth; i++) {
                    var a = i * 2 * Math.PI / teeth
                    var hw = Math.PI / teeth * 0.65
                    var a0 = a - hw, a1 = a - hw * 0.45
                    var a2 = a + hw * 0.45, a3 = a + hw
                    if (i === 0) ctx.moveTo(innerR * Math.cos(a0), innerR * Math.sin(a0))
                    else ctx.lineTo(innerR * Math.cos(a0), innerR * Math.sin(a0))
                    ctx.lineTo(outerR * Math.cos(a1), outerR * Math.sin(a1))
                    ctx.lineTo(outerR * Math.cos(a2), outerR * Math.sin(a2))
                    ctx.lineTo(innerR * Math.cos(a3), innerR * Math.sin(a3))
                }
                ctx.closePath()
                ctx.fillStyle = fillCol
                ctx.fill()
                ctx.strokeStyle = strokeCol
                ctx.lineWidth = 1.5
                ctx.stroke()

                // Hub
                ctx.beginPath()
                ctx.arc(0, 0, pitchR * 0.22, 0, 2 * Math.PI)
                ctx.fillStyle = Style.surfaceColor
                ctx.fill()
                ctx.strokeStyle = strokeCol
                ctx.stroke()

                // Spokes
                ctx.beginPath()
                for (var s = 0; s < 4; s++) {
                    var sa = s * Math.PI / 2
                    ctx.moveTo(pitchR * 0.22 * Math.cos(sa), pitchR * 0.22 * Math.sin(sa))
                    ctx.lineTo(innerR * 0.78 * Math.cos(sa), innerR * 0.78 * Math.sin(sa))
                }
                ctx.lineWidth = 2
                ctx.stroke()
                ctx.restore()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                var cy = height / 2
                var r1 = height * 0.3, teeth1 = 16
                var r2 = r1 * 10 / 16, teeth2 = 10
                var r3 = r1 * 8 / 16, teeth3 = 8

                var x1 = width / 2 - r2 - r3
                var x2 = x1 + r1 + r2
                var x3 = x2 + r2 + r3

                var a1 = gearAngle
                var a2 = -gearAngle * teeth1 / teeth2 + 180 / teeth2
                var a3 = gearAngle * teeth1 / teeth3 + 180 / teeth3

                drawGear(ctx, x1, cy, r1, teeth1, a1, "rgba(0,209,169,0.2)", "#00D1A9")
                drawGear(ctx, x2, cy, r2, teeth2, a2, "rgba(255,89,0,0.2)", "#FF5900")
                drawGear(ctx, x3, cy, r3, teeth3, a3, "rgba(74,144,217,0.2)", "#4A90D9")
            }
        }
    }
}
