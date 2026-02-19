// =============================================================================
// ScatterPlot.qml — Grafica de dispersion (scatter plot) con Canvas 2D
// =============================================================================
// Dibuja un grafico de dispersion con 3 clusters de puntos, cada uno con su
// propio color y centro. Es tipico en visualizacion de datos para mostrar
// correlaciones, agrupamientos o distribuciones bidimensionales.
//
// Patrones clave:
//   - Generacion procedural de clusters: la funcion regenerate() crea 3 grupos
//     de 18 puntos cada uno, distribuidos aleatoriamente alrededor de un centro
//     (cx, cy) con un radio de dispersion de 0.22. Esto simula datos reales
//     con agrupamiento natural (clustering).
//   - Coordenadas normalizadas (0-1): los puntos se almacenan en espacio
//     normalizado y se escalan a pixeles al pintar (pt.x * w, pt.y * h).
//     Esto hace que la grafica se adapte a cualquier tamano de Canvas.
//   - Transparencia con sufijo hex: cl.color + "80" agrega 50% de opacidad
//     al color del relleno (80 hex = 128/255), creando un efecto de
//     superposicion donde se ven los puntos que se solapan.
//   - Cuadricula de fondo: lineas verticales (10) y horizontales (8) dan
//     referencia visual sin datos numericos en los ejes — estilo minimalista.
//   - Boton Randomize: permite al usuario regenerar los datos y ver como
//     cambian los clusters. Llama a regenerate() que reemplaza el array
//     completo de clusters y solicita repintado.
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
            text: "5. Scatter Plot"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        // Legend
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#00D1A9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "A"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#FF5900"; anchors.verticalCenter: parent.verticalCenter } Label { text: "B"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(8); height: width; radius: width/2; color: "#4A90D9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "C"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
        Item { width: Style.resize(8) }
        Button {
            text: "Randomize"
            onClicked: scatterCanvas.regenerate()
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)
        color: "#0A0E14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: scatterCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            property var clusters: []

            function regenerate() {
                var c = []
                var centers = [
                    { cx: 0.22, cy: 0.3, color: "#00D1A9" },
                    { cx: 0.55, cy: 0.65, color: "#FF5900" },
                    { cx: 0.8, cy: 0.25, color: "#4A90D9" }
                ]
                for (var i = 0; i < 3; i++) {
                    var pts = []
                    for (var j = 0; j < 18; j++) {
                        pts.push({
                            x: centers[i].cx + (Math.random() - 0.5) * 0.22,
                            y: centers[i].cy + (Math.random() - 0.5) * 0.22,
                            size: 3 + Math.random() * 4
                        })
                    }
                    c.push({ points: pts, color: centers[i].color })
                }
                clusters = c
                requestPaint()
            }

            Component.onCompleted: regenerate()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // Grid
                ctx.strokeStyle = "#1A2030"
                ctx.lineWidth = 0.5
                for (var gx = 0; gx <= 10; gx++) {
                    var x = gx / 10 * w
                    ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke()
                }
                for (var gy = 0; gy <= 8; gy++) {
                    var y = gy / 8 * h
                    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke()
                }

                // Axes
                ctx.strokeStyle = "#333"
                ctx.lineWidth = 1
                ctx.beginPath(); ctx.moveTo(0, h); ctx.lineTo(w, h); ctx.stroke()
                ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, h); ctx.stroke()

                // Points
                for (var ci = 0; ci < clusters.length; ci++) {
                    var cl = clusters[ci]
                    for (var pi = 0; pi < cl.points.length; pi++) {
                        var pt = cl.points[pi]
                        ctx.beginPath()
                        ctx.arc(pt.x * w, pt.y * h, pt.size, 0, 2 * Math.PI)
                        ctx.fillStyle = cl.color + "80"
                        ctx.fill()
                        ctx.strokeStyle = cl.color
                        ctx.lineWidth = 1
                        ctx.stroke()
                    }
                }
            }
        }
    }
}
