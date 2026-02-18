import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "2. Rose Curve (Rhodonea)"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)
        Label { text: "Petals (k): " + Math.round(roseK.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
        Slider { id: roseK; from: 2; to: 12; value: 5; stepSize: 1; Layout.preferredWidth: Style.resize(200); onValueChanged: roseCanvas.requestPaint() }
        Item { Layout.fillWidth: true }
        Label {
            text: {
                var k = Math.round(roseK.value)
                return (k % 2 === 0 ? (2*k) : k) + " petals"
            }
            font.pixelSize: Style.resize(11)
            color: Style.mainColor
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: roseCanvas
            onAvailableChanged: if (available) requestPaint()
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var maxR = Math.min(cx, cy) - 10
                var k = Math.round(roseK.value)
                var steps = 1000

                ctx.beginPath()
                for (var i = 0; i <= steps; i++) {
                    var t = i / steps * 2 * Math.PI
                    var r = maxR * Math.cos(k * t)
                    var x = cx + r * Math.cos(t)
                    var y = cy + r * Math.sin(t)
                    if (i === 0) ctx.moveTo(x, y)
                    else ctx.lineTo(x, y)
                }

                var grad = ctx.createLinearGradient(0, 0, w, h)
                grad.addColorStop(0, "#00D1A9")
                grad.addColorStop(0.5, "#9B59B6")
                grad.addColorStop(1, "#E74C3C")
                ctx.strokeStyle = grad
                ctx.lineWidth = 2
                ctx.stroke()

                // Fill with semi-transparent
                ctx.fillStyle = "rgba(0,209,169,0.06)"
                ctx.fill()
            }
        }
    }
}
