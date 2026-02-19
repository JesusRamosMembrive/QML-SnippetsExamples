// =============================================================================
// GeometricMandala.qml — Mandala geometrica parametrica con Canvas 2D
// =============================================================================
// Genera un mandala (patron radial simetrico) controlado por dos parametros:
//   - Ejes de simetria (N): cuantas veces se repite el patron alrededor
//     del centro. N=8 crea simetria octogonal (como un copo de nieve).
//   - Capas: anillos concentricos con decoraciones diferentes segun la capa.
//
// ESTRUCTURA DEL MANDALA (de adentro hacia afuera):
//   1. Punto central (dot).
//   2. Lineas radiales (spokes) que dividen el circulo en N sectores.
//   3. Capas concentricas con decoraciones que alternan segun layer % 3:
//      - 0: circulos rellenos.
//      - 1: diamantes (rombos).
//      - 2: anillos vacios (circulos con solo borde).
//   4. Petalos en capas impares: arcos concentricos con relleno translucido
//      que crean un efecto de flor.
//   5. Borde circular exterior.
//
// PATRON INTERACTIVO: los Sliders modifican mandalaAxes y mandalaLayers.
// onValueChanged dispara requestPaint() para redibujar el Canvas.
// A diferencia de Shape (que se actualiza automaticamente con bindings),
// Canvas necesita que le pidamos explicitamente que se repinte.
//
// PALETA DE COLORES: un array de 8 colores que se rota con el operador
// modulo (layer % palette.length) para que nunca se repitan colores
// adyacentes aunque haya muchas capas.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "5. Geometric Mandala"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Axes: " + Math.round(mandalaAxes.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: mandalaAxes; from: 4; to: 16; value: 8; stepSize: 1; Layout.preferredWidth: Style.resize(130); onValueChanged: mandalaCanvas.requestPaint() }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Layers: " + Math.round(mandalaLayers.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: mandalaLayers; from: 3; to: 8; value: 5; stepSize: 1; Layout.preferredWidth: Style.resize(130); onValueChanged: mandalaCanvas.requestPaint() }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: mandalaCanvas
            onAvailableChanged: if (available) requestPaint()
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(290))
            height: width

            property var palette: ["#00D1A9", "#FF5900", "#9B59B6", "#4A90D9", "#E74C3C", "#FEA601", "#27AE60", "#F39C12"]

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var maxR = Math.min(cx, cy) - 8
                var N = Math.round(mandalaAxes.value)
                var layers = Math.round(mandalaLayers.value)

                // Lineas radiales (spokes): dividen el circulo en N sectores iguales.
                ctx.strokeStyle = "#333"
                ctx.lineWidth = 0.5
                for (var s = 0; s < N; s++) {
                    var sa = s * 2 * Math.PI / N
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + maxR * Math.cos(sa), cy + maxR * Math.sin(sa))
                    ctx.stroke()
                }

                // Capas concentricas: cada capa tiene un radio proporcional
                // y decoraciones que varian segun (layer % 3) para dar
                // variedad visual sin repetir patrones adyacentes.
                for (var layer = 0; layer < layers; layer++) {
                    var r = (layer + 1) / (layers + 1) * maxR
                    var color = palette[layer % palette.length]

                    // Concentric ring
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.strokeStyle = color
                    ctx.lineWidth = 0.8
                    ctx.stroke()

                    // Decorations at each axis point
                    var dotR = 3 + layer * 1.2
                    for (var p = 0; p < N; p++) {
                        var pa = p * 2 * Math.PI / N
                        var ppx = cx + r * Math.cos(pa)
                        var ppy = cy + r * Math.sin(pa)

                        if (layer % 3 === 0) {
                            // Filled circles
                            ctx.beginPath()
                            ctx.arc(ppx, ppy, dotR, 0, 2 * Math.PI)
                            ctx.fillStyle = color
                            ctx.fill()
                        } else if (layer % 3 === 1) {
                            // Diamonds
                            ctx.beginPath()
                            ctx.moveTo(ppx, ppy - dotR)
                            ctx.lineTo(ppx + dotR, ppy)
                            ctx.lineTo(ppx, ppy + dotR)
                            ctx.lineTo(ppx - dotR, ppy)
                            ctx.closePath()
                            ctx.fillStyle = color
                            ctx.fill()
                        } else {
                            // Rings
                            ctx.beginPath()
                            ctx.arc(ppx, ppy, dotR, 0, 2 * Math.PI)
                            ctx.strokeStyle = color
                            ctx.lineWidth = 2
                            ctx.stroke()
                        }
                    }

                    // Petalos en capas impares: dos arcos concentricos (uno hacia
                    // afuera, otro hacia adentro) crean una forma de hoja/petalo.
                    // El relleno translucido (hex + "20" = alfa ~12%) permite ver capas debajo.
                    if (layer % 2 === 1) {
                        var bulge = r * 0.12
                        for (var p2 = 0; p2 < N; p2++) {
                            var startA = p2 * 2 * Math.PI / N
                            var endA = (p2 + 1) * 2 * Math.PI / N
                            ctx.beginPath()
                            ctx.arc(cx, cy, r + bulge, startA, endA)
                            ctx.arc(cx, cy, r - bulge, endA, startA, true)
                            ctx.closePath()
                            ctx.fillStyle = color.substring(0, 7) + "20"
                            ctx.fill()
                            ctx.strokeStyle = color
                            ctx.lineWidth = 0.5
                            ctx.stroke()
                        }
                    }
                }

                // Outer border
                ctx.beginPath()
                ctx.arc(cx, cy, maxR, 0, 2 * Math.PI)
                ctx.strokeStyle = "#444"
                ctx.lineWidth = 1.5
                ctx.stroke()

                // Center dot
                ctx.beginPath()
                ctx.arc(cx, cy, maxR * 0.06, 0, 2 * Math.PI)
                ctx.fillStyle = "#00D1A9"
                ctx.fill()
            }
        }
    }
}
