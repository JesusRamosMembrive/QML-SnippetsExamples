import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
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
