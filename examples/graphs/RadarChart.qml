// =============================================================================
// RadarChart.qml — Gráfica de radar (araña) con Canvas 2D
// =============================================================================
// Dibuja un gráfico de radar/araña pentagonal comparando dos conjuntos de datos
// (Player vs Enemy), típico de juegos RPG para mostrar estadísticas.
//
// Conceptos clave:
// - Geometría polar: Todos los puntos se calculan con coordenadas polares
//   (ángulo + radio) y se convierten a cartesianas con cos/sin.
//   El offset -PI/2 hace que el primer eje apunte hacia arriba.
// - Función reutilizable drawDataset(): Encapsula la lógica de dibujar un
//   polígono de datos + puntos. Se llama dos veces con diferentes colores.
// - Capas de dibujo: Se dibuja en orden de atrás a adelante —
//   cuadrícula > radios > dataset enemigo > dataset jugador > etiquetas.
//   El jugador se dibuja ÚLTIMO para que quede encima del enemigo.
// - onAvailableChanged: Canvas necesita que su contexto GL esté listo antes
//   de pintar. Este signal asegura el primer pintado en el momento correcto.
// - Transparencia con rgba(): Los rellenos usan baja opacidad (0.15, 0.2)
//   para que las áreas superpuestas sean visibles.
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
            text: "2. Radar Chart"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        // Randomize genera valores nuevos y llama requestPaint() manualmente.
        // En Canvas, los cambios de propiedades NO disparan repintado automático.
        Button {
            text: "Randomize"
            onClicked: {
                var p = [], e = []
                for (var i = 0; i < 5; i++) {
                    p.push(Math.round(Math.random() * 40 + 60))
                    e.push(Math.round(Math.random() * 50 + 30))
                }
                radarCanvas.playerStats = p
                radarCanvas.enemyStats = e
                radarCanvas.requestPaint()
            }
        }
    }

    // Leyenda manual con rectángulos de color + texto
    RowLayout {
        spacing: Style.resize(15)
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00D1A9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Player"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#FF5900"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Enemy"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: radarCanvas
            onAvailableChanged: if (available) requestPaint()
            // El canvas se centra y su tamaño se limita al menor entre el ancho
            // disponible y 270px, manteniendo forma cuadrada (height: width).
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(270))
            height: width

            // Datos: arrays de 5 valores (0-100) para cada estadística
            property list<real> playerStats: [85, 70, 60, 90, 55]
            property list<real> enemyStats: [60, 80, 75, 45, 70]
            property list<string> labels: ["ATK", "DEF", "SPD", "HP", "MP"]

            // -----------------------------------------------------------
            // Función auxiliar para dibujar un dataset como polígono.
            // Recibe centro (cx,cy), radio máximo, datos y colores.
            // Cada valor se normaliza a 0-1 (data[i]/100) y se escala al radio.
            // Primero dibuja el polígono relleno, luego los puntos individuales.
            // -----------------------------------------------------------
            function drawDataset(ctx, cx, cy, r, data, strokeColor, fillColor) {
                ctx.beginPath()
                for (var i = 0; i < data.length; i++) {
                    var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                    var val = data[i] / 100 * r
                    var px = cx + val * Math.cos(angle)
                    var py = cy + val * Math.sin(angle)
                    if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                }
                ctx.closePath()
                ctx.fillStyle = fillColor
                ctx.fill()
                ctx.strokeStyle = strokeColor
                ctx.lineWidth = 2
                ctx.stroke()

                // Puntos circulares en cada vértice del polígono de datos
                for (var i = 0; i < data.length; i++) {
                    var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                    var val = data[i] / 100 * r
                    ctx.beginPath()
                    ctx.arc(cx + val * Math.cos(angle), cy + val * Math.sin(angle), 3, 0, 2 * Math.PI)
                    ctx.fillStyle = strokeColor
                    ctx.fill()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var r = Math.min(cx, cy) - 30
                var N = 5

                // -----------------------------------------------------------
                // Cuadrícula: 5 pentágonos concéntricos como líneas de referencia.
                // El pentágono exterior (ring=5) tiene trazo más grueso y visible.
                // Cada pentágono se dibuja conectando N puntos equidistantes
                // a distancia proporcional al anillo (ring/5 * radio_total).
                // -----------------------------------------------------------
                for (var ring = 1; ring <= 5; ring++) {
                    var rr = r * ring / 5
                    ctx.beginPath()
                    for (var i = 0; i < N; i++) {
                        var angle = i * 2 * Math.PI / N - Math.PI / 2
                        var px = cx + rr * Math.cos(angle)
                        var py = cy + rr * Math.sin(angle)
                        if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                    }
                    ctx.closePath()
                    ctx.strokeStyle = ring === 5 ? "#444" : "#2A2D35"
                    ctx.lineWidth = ring === 5 ? 1.5 : 0.5
                    ctx.stroke()
                }

                // Radios (spokes): líneas del centro a cada vértice
                for (var i = 0; i < N; i++) {
                    var angle = i * 2 * Math.PI / N - Math.PI / 2
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + r * Math.cos(angle), cy + r * Math.sin(angle))
                    ctx.strokeStyle = "#2A2D35"
                    ctx.lineWidth = 0.5
                    ctx.stroke()
                }

                // Datasets: el enemigo se dibuja primero (queda debajo)
                drawDataset(ctx, cx, cy, r, enemyStats, "#FF5900", "rgba(255,89,0,0.15)")
                drawDataset(ctx, cx, cy, r, playerStats, "#00D1A9", "rgba(0,209,169,0.2)")

                // Etiquetas de ejes: posicionadas más allá del radio máximo
                ctx.font = "bold 12px sans-serif"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                for (var i = 0; i < N; i++) {
                    var angle = i * 2 * Math.PI / N - Math.PI / 2
                    var lx = cx + (r + 18) * Math.cos(angle)
                    var ly = cy + (r + 18) * Math.sin(angle)
                    ctx.fillStyle = "#888"
                    ctx.fillText(labels[i], lx, ly)
                }
            }
        }
    }
}
