import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
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
