// =============================================================================
// CandlestickChart.qml — Gráfica de velas japonesas (candlestick) con Canvas
// =============================================================================
// Gráfica financiera tipo bolsa de valores. Cada "vela" representa un periodo
// con 4 datos: apertura (open), cierre (close), máximo (high) y mínimo (low).
// Incluye una media móvil simple (SMA) superpuesta como línea amarilla.
//
// Conceptos clave:
// - Anatomía de una vela: La "mecha" (wick) es una línea vertical del mínimo
//   al máximo. El "cuerpo" es un rectángulo entre open y close.
//   Verde = close >= open (subida), Rojo = close < open (bajada).
// - Escala dinámica (yScale): La función convierte precios a píxeles.
//   Se recalcula el rango [min, max] en cada generación de datos para que
//   las velas siempre ocupen todo el espacio vertical disponible.
// - Media móvil simple (SMA): Promedio de los últimos N precios de cierre.
//   Es un indicador técnico básico usado en análisis financiero real.
//   Se dibuja como línea continua amarilla sobre las velas.
// - Generación procedural: Los precios simulan un camino aleatorio (random walk)
//   donde cada close se convierte en el open del siguiente periodo.
//   El sesgo de -0.45 (en lugar de -0.5) crea una ligera tendencia alcista.
// =============================================================================

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

            // -----------------------------------------------------------
            // Generador de datos: simula un camino aleatorio (random walk).
            // Cada vela hereda el close anterior como su open.
            // high y low se extienden aleatoriamente más allá del cuerpo
            // para crear mechas realistas.
            // -----------------------------------------------------------
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

                // Calcular rango de precios para escalar el eje Y.
                // Se busca el mínimo de todos los low y máximo de todos los high.
                var minP = 99999, maxP = 0
                for (var i = 0; i < candles.length; i++) {
                    if (candles[i].l < minP) minP = candles[i].l
                    if (candles[i].h > maxP) maxP = candles[i].h
                }
                minP -= 2; maxP += 2
                var range = maxP - minP

                // Función de escala: convierte un precio a coordenada Y en píxeles.
                // Se invierte (1 - ...) porque en Canvas Y=0 es arriba.
                function yScale(val) { return pad + (1 - (val - minP) / range) * (h - 2 * pad) }

                var candleW = (w - 2 * pad) / candles.length * 0.6
                var spacing = (w - 2 * pad) / candles.length

                // Cuadrícula horizontal con etiquetas de precio
                ctx.strokeStyle = "#1A2030"
                ctx.lineWidth = 0.5
                ctx.font = "9px monospace"
                ctx.fillStyle = "#444"
                ctx.textAlign = "left"
                for (var g = 0; g <= 4; g++) {
                    var gPrice = minP + range * g / 4
                    var gy = yScale(gPrice)
                    ctx.beginPath(); ctx.moveTo(pad, gy); ctx.lineTo(w - pad, gy); ctx.stroke()
                    ctx.fillText(Number(gPrice).toFixed(1), 2, gy - 3)
                }

                // -----------------------------------------------------------
                // Media móvil simple (SMA-5): promedio de los últimos 5 cierres.
                // Se dibuja como una sola línea continua. Empieza en la vela 4
                // (índice maWindow-1) porque necesita 5 datos previos.
                // -----------------------------------------------------------
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

                // -----------------------------------------------------------
                // Dibujo de velas: cada vela tiene dos partes.
                // 1. Mecha (wick): línea vertical de high a low.
                // 2. Cuerpo (body): rectángulo entre open y close.
                // El color depende de si el precio subió o bajó.
                // -----------------------------------------------------------
                for (var i = 0; i < candles.length; i++) {
                    var cd = candles[i]
                    var x = pad + i * spacing + spacing / 2
                    var isUp = cd.c >= cd.o
                    var color = isUp ? "#27AE60" : "#E74C3C"

                    // Mecha: línea vertical del mínimo al máximo
                    ctx.beginPath()
                    ctx.moveTo(x, yScale(cd.h))
                    ctx.lineTo(x, yScale(cd.l))
                    ctx.strokeStyle = color
                    ctx.lineWidth = 1
                    ctx.stroke()

                    // Cuerpo: rectángulo entre open y close
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
