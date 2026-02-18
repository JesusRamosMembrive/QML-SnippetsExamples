import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "2. Spirograph Generator"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "R (outer): " + Math.round(spiroR.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: spiroR; from: 40; to: 100; value: 75; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "r (inner): " + Math.round(spiroInner.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: spiroInner; from: 5; to: 60; value: 28; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "d (pen): " + Math.round(spiroPen.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: spiroPen; from: 5; to: 80; value: 55; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: spiroCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)
            onAvailableChanged: if (available) requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width
                var h = height
                ctx.clearRect(0, 0, w, h)

                var R = spiroR.value
                var ri = spiroInner.value
                var d = spiroPen.value
                var centerX = w / 2
                var centerY = h / 2
                var scale = Math.min(w, h) / (2 * (R + d + 10))

                var steps = 2000
                var maxT = 2 * Math.PI * 20

                ctx.beginPath()
                for (var i = 0; i <= steps; i++) {
                    var t = (i / steps) * maxT
                    var x = (R - ri) * Math.cos(t) + d * Math.cos((R - ri) / ri * t)
                    var y = (R - ri) * Math.sin(t) - d * Math.sin((R - ri) / ri * t)

                    var px = centerX + x * scale
                    var py = centerY + y * scale

                    if (i === 0)
                        ctx.moveTo(px, py)
                    else
                        ctx.lineTo(px, py)
                }

                var grad = ctx.createLinearGradient(0, 0, w, h)
                grad.addColorStop(0, "#00D1A9")
                grad.addColorStop(0.33, "#4A90D9")
                grad.addColorStop(0.66, "#9B59B6")
                grad.addColorStop(1, "#E74C3C")
                ctx.strokeStyle = grad
                ctx.lineWidth = 1.5
                ctx.stroke()
            }
        }
    }
}
