import QtQuick
import QtQuick.Controls
import utils

Rectangle {
    id: root

    property real heading: 0

    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: Style.resize(15)
    anchors.bottomMargin: Style.resize(65)
    width: Style.resize(140)
    height: width
    radius: width / 2
    color: Qt.rgba(0, 0, 0, 0.65)
    border.color: Qt.rgba(1, 1, 1, 0.25)
    border.width: 1

    Canvas {
        id: compassCanvas
        anchors.fill: parent
        anchors.margins: Style.resize(5)

        property real hdg: root.heading

        onHdgChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height
            var cx = w / 2
            var cy = h / 2
            var r = Math.min(cx, cy) - 14

            ctx.clearRect(0, 0, w, h)

            var green = "#00FF00"
            var white = "#FFFFFF"

            // Outer ring
            ctx.strokeStyle = "#666666"
            ctx.lineWidth = 1.5
            ctx.beginPath()
            ctx.arc(cx, cy, r + 4, 0, 2 * Math.PI)
            ctx.stroke()

            // Rotating compass card
            ctx.save()
            ctx.translate(cx, cy)
            ctx.rotate(-hdg * Math.PI / 180)

            // Tick marks every 5 degrees
            for (var deg = 0; deg < 360; deg += 5) {
                var rad = (deg - 90) * Math.PI / 180
                var isCardinal = (deg % 90 === 0)
                var isMajor = (deg % 10 === 0)
                var innerR
                if (isCardinal) innerR = r - 16
                else if (isMajor) innerR = r - 9
                else innerR = r - 5

                ctx.strokeStyle = isCardinal ? white : "#888888"
                ctx.lineWidth = isCardinal ? 2 : 1
                ctx.beginPath()
                ctx.moveTo(Math.cos(rad) * innerR, Math.sin(rad) * innerR)
                ctx.lineTo(Math.cos(rad) * r, Math.sin(rad) * r)
                ctx.stroke()
            }

            // Labels every 30 degrees
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.font = "bold " + (r * 0.13) + "px sans-serif"

            var labels = [
                { deg: 0, text: "N", color: white },
                { deg: 30, text: "3", color: green },
                { deg: 60, text: "6", color: green },
                { deg: 90, text: "E", color: white },
                { deg: 120, text: "12", color: green },
                { deg: 150, text: "15", color: green },
                { deg: 180, text: "S", color: white },
                { deg: 210, text: "21", color: green },
                { deg: 240, text: "24", color: green },
                { deg: 270, text: "W", color: white },
                { deg: 300, text: "30", color: green },
                { deg: 330, text: "33", color: green }
            ]

            for (var i = 0; i < labels.length; i++) {
                var l = labels[i]
                var lrad = (l.deg - 90) * Math.PI / 180
                var labelR = r - 26
                ctx.fillStyle = l.color
                ctx.fillText(l.text,
                    Math.cos(lrad) * labelR,
                    Math.sin(lrad) * labelR)
            }

            // North arrow (red triangle)
            ctx.fillStyle = "#FF4444"
            var nRad = -Math.PI / 2
            var nR = r + 1
            ctx.beginPath()
            ctx.moveTo(Math.cos(nRad) * nR, Math.sin(nRad) * nR)
            ctx.lineTo(Math.cos(nRad - 0.08) * (nR - 12),
                       Math.sin(nRad - 0.08) * (nR - 12))
            ctx.lineTo(Math.cos(nRad + 0.08) * (nR - 12),
                       Math.sin(nRad + 0.08) * (nR - 12))
            ctx.closePath()
            ctx.fill()

            ctx.restore()

            // Fixed lubber line (yellow triangle at top)
            ctx.fillStyle = "#FFFF00"
            ctx.beginPath()
            ctx.moveTo(cx, cy - r - 6)
            ctx.lineTo(cx - 6, cy - r + 4)
            ctx.lineTo(cx + 6, cy - r + 4)
            ctx.closePath()
            ctx.fill()

            // Center dot
            ctx.fillStyle = white
            ctx.beginPath()
            ctx.arc(cx, cy, 2.5, 0, 2 * Math.PI)
            ctx.fill()

            // Heading readout box
            var hdgStr = Math.round(hdg).toString().padStart(3, "0")
            ctx.fillStyle = "#000000"
            ctx.fillRect(cx - 20, 3, 40, 16)
            ctx.strokeStyle = green
            ctx.lineWidth = 1
            ctx.strokeRect(cx - 20, 3, 40, 16)
            ctx.fillStyle = green
            ctx.font = "bold " + (r * 0.10) + "px sans-serif"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.fillText(hdgStr + "\u00B0", cx, 11)
        }
    }
}
