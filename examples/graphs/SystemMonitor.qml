// =============================================================================
// SystemMonitor.qml — Monitor de CPU con gráfica de áreas apiladas (Canvas)
// =============================================================================
// Simula un monitor de sistema tipo htop/Task Manager con 4 "cores" de CPU.
// Cada core tiene un historial de uso que se grafica como áreas apiladas
// (stacked area chart) dibujadas manualmente con Canvas 2D.
//
// Conceptos clave:
// - Canvas + Timer vs. GraphsView + FrameAnimation: Este ejemplo usa Canvas
//   con Timer(60ms) porque las áreas apiladas no tienen un componente nativo
//   en QtGraphs. Canvas da libertad total para dibujar cualquier visualización.
// - Interpolación suave (lerp): Los valores actuales se acercan al objetivo
//   con `cur += (target - cur) * 0.15`, creando transiciones orgánicas en
//   lugar de saltos bruscos. Este patrón es fundamental en animación.
// - Historial circular: push() + shift() mantiene un buffer fijo de N puntos.
//   Cuando se agrega un nuevo dato, se elimina el más antiguo.
// - Áreas apiladas: Se dibujan de atrás hacia adelante. Cada área suma los
//   valores de los cores anteriores para que se "apilen" visualmente.
//   El path va de izquierda a derecha (borde superior) y vuelve de derecha
//   a izquierda (borde inferior), formando una forma cerrada para fill().
// - requestPaint(): En Canvas, los cambios de datos NO redibujan automáticamente.
//   Hay que llamar requestPaint() explícitamente después de modificar los datos.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool monitorActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "1. System Monitor"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.monitorActive ? "Pause" : "Start"
            onClicked: root.monitorActive = !root.monitorActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)
        color: "#0A0E14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: monitorCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            // Estado del monitor: historial de cada core, objetivos y valores actuales.
            // coreHistory: array de 4 arrays, cada uno con `histLen` puntos.
            // coreTargets: hacia dónde se dirige cada core (cambia aleatoriamente).
            // coreCurrent: valor actual de cada core (se interpola hacia target).
            property var coreHistory: []
            property var coreTargets: [0.3, 0.5, 0.2, 0.4]
            property var coreCurrent: [0.3, 0.5, 0.2, 0.4]
            property int histLen: 100

            // Inicialización: crea 4 historiales con valor uniforme (0.25 = 25% uso)
            Component.onCompleted: {
                var h = []
                for (var c = 0; c < 4; c++) {
                    var ch = []
                    for (var i = 0; i < histLen; i++) ch.push(0.25)
                    h.push(ch)
                }
                coreHistory = h
            }

            // Timer a 60ms (~16fps): suficiente para un monitor de sistema.
            // No necesitamos FrameAnimation (60fps) para datos que cambian lentamente.
            // Cada 8% de probabilidad, un core cambia su objetivo de uso.
            // La interpolación (lerp) suaviza la transición hacia el nuevo objetivo.
            Timer {
                interval: 60
                repeat: true
                running: root.active && root.monitorActive
                onTriggered: {
                    var h = monitorCanvas.coreHistory
                    var tgts = monitorCanvas.coreTargets
                    var cur = monitorCanvas.coreCurrent
                    if (!h || h.length < 4) return

                    for (var c = 0; c < 4; c++) {
                        if (Math.random() < 0.08) tgts[c] = Math.random() * 0.8 + 0.05
                        cur[c] += (tgts[c] - cur[c]) * 0.15
                        h[c].push(cur[c])
                        if (h[c].length > monitorCanvas.histLen) h[c].shift()
                    }
                    monitorCanvas.coreTargets = tgts
                    monitorCanvas.coreCurrent = cur
                    monitorCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var colors = ["#00D1A9", "#4A90D9", "#FEA601", "#9B59B6"]
                var data = coreHistory
                if (!data || data.length < 4 || !data[0] || data[0].length < 2) return
                var len = data[0].length

                // Líneas de cuadrícula horizontales (fondo de referencia)
                ctx.strokeStyle = "#1A2030"
                ctx.lineWidth = 0.5
                for (var g = 0; g <= 4; g++) {
                    var gy = h - g / 4 * h * 0.9
                    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke()
                }

                // -----------------------------------------------------------
                // Áreas apiladas: se dibujan de atrás (core 3) hacia adelante
                // (core 0) para que las de abajo no tapen a las de arriba.
                // Cada área es un path cerrado: borde superior de izq a der,
                // luego borde inferior de der a izq. El borde inferior de un
                // core es la suma de los cores que están debajo de él.
                // El sufijo "40" en el color es opacidad hexadecimal (25%).
                // -----------------------------------------------------------
                for (var c = 3; c >= 0; c--) {
                    ctx.beginPath()
                    for (var i = 0; i < len; i++) {
                        var x = i / (len - 1) * w
                        var sv = 0
                        for (var j = 0; j <= c; j++) sv += data[j][i]
                        var y = h - sv / 4 * h * 0.88
                        if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y)
                    }
                    for (var i = len - 1; i >= 0; i--) {
                        var x = i / (len - 1) * w
                        var sv = 0
                        for (var j = 0; j < c; j++) sv += data[j][i]
                        var y = h - sv / 4 * h * 0.88
                        ctx.lineTo(x, y)
                    }
                    ctx.closePath()
                    ctx.fillStyle = colors[c] + "40"
                    ctx.fill()
                    ctx.strokeStyle = colors[c]
                    ctx.lineWidth = 1.5
                    ctx.stroke()
                }

                // Etiquetas de porcentaje de cada core (esquina superior derecha)
                ctx.font = "10px monospace"
                ctx.textAlign = "right"
                var cur = coreCurrent
                for (var c = 0; c < 4; c++) {
                    ctx.fillStyle = colors[c]
                    ctx.fillText("Core " + c + ": " + Math.round((cur[c] || 0) * 100) + "%", w - 5, 14 + c * 14)
                }
            }
        }
    }
}
