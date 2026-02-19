// =============================================================================
// Oscilloscope.qml — Simulacion de osciloscopio con tres tipos de onda
// =============================================================================
// Dibuja tres senales superpuestas sobre un fondo estilo osciloscopio CRT:
//   - Senoidal (verde fosforescente): Math.sin() puro.
//   - Cuadrada (ambar): se genera con Math.sin() > 0 ? 1 : -1.
//   - Triangular (cyan): se calcula con aritmetica modular sobre la fase.
//
// CONCEPTOS DEMOSTRADOS:
//   - Canvas 2D para visualizacion cientifica: grilla de referencia, linea
//     central, y multiples curvas superpuestas con colores distintos.
//   - Generacion de formas de onda por software: en lugar de datos reales,
//     las ondas se calculan matematicamente pixel a pixel.
//   - Controles interactivos: frecuencia y amplitud ajustables con Sliders
//     que afectan las tres ondas simultaneamente gracias a bindings.
//
// ESTETICA CRT: el fondo negro (#0A100A) y la grilla verde oscuro (#0A3A0A)
// imitan la pantalla de un osciloscopio analogico. Los colores de las ondas
// (verde fosforescente, ambar, cyan) son los tipicos de fosforos CRT reales.
//
// PATRON DE LEYENDA: la Row de rectangulos coloreados + labels en la esquina
// funciona como leyenda visual para identificar cada senal.
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
    property bool sectionActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "4. Oscilloscope"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.sectionActive ? "Pause" : "Start"
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Freq: " + scopeFreq.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: scopeFreq; from: 0.5; to: 4; value: 1.5; stepSize: 0.1; Layout.preferredWidth: Style.resize(130) }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Amp: " + scopeAmp.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: scopeAmp; from: 0.2; to: 1.0; value: 0.7; stepSize: 0.05; Layout.preferredWidth: Style.resize(130) }
        }
        Item { Layout.fillWidth: true }
        // Legend
        Row {
            spacing: Style.resize(12)
            Row {
                spacing: Style.resize(4)
                Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00FF41"; anchors.verticalCenter: parent.verticalCenter }
                Label { text: "Sine"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
            }
            Row {
                spacing: Style.resize(4)
                Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#FFB800"; anchors.verticalCenter: parent.verticalCenter }
                Label { text: "Square"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
            }
            Row {
                spacing: Style.resize(4)
                Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00BFFF"; anchors.verticalCenter: parent.verticalCenter }
                Label { text: "Triangle"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)
        color: "#0A100A"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: scopeCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            property real scopePhase: 0

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.sectionActive
                onTriggered: {
                    scopeCanvas.scopePhase += 0.08
                    scopeCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cy = h / 2
                var freq = scopeFreq.value
                var amp = scopeAmp.value * (h * 0.4)
                var gridSize = 30

                // Grilla de referencia: lineas finas verde oscuro cada 30px.
                // La linea central es mas brillante para marcar el eje Y=0.
                ctx.strokeStyle = "#0A3A0A"
                ctx.lineWidth = 0.5
                for (var gx = 0; gx < w; gx += gridSize) {
                    ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, h); ctx.stroke()
                }
                for (var gy = 0; gy < h; gy += gridSize) {
                    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke()
                }
                // Center line (brighter)
                ctx.strokeStyle = "#0A5A0A"
                ctx.lineWidth = 1
                ctx.beginPath(); ctx.moveTo(0, cy); ctx.lineTo(w, cy); ctx.stroke()

                // Onda senoidal: la mas basica (Math.sin). scopePhase avanza
                // con el Timer para dar la ilusion de movimiento continuo.
                ctx.beginPath()
                for (var sx = 0; sx < w; sx++) {
                    var sy = cy - amp * Math.sin(freq * sx * 0.04 + scopePhase)
                    if (sx === 0) ctx.moveTo(sx, sy); else ctx.lineTo(sx, sy)
                }
                ctx.strokeStyle = "#00FF41"
                ctx.lineWidth = 2
                ctx.stroke()

                // Onda cuadrada: se genera evaluando el signo de sin().
                // Amplitud reducida a 60% para no solaparse con la senoidal.
                ctx.beginPath()
                for (var qx = 0; qx < w; qx++) {
                    var qPhase = freq * qx * 0.04 + scopePhase + 1.0
                    var qy = cy - amp * 0.6 * (Math.sin(qPhase) > 0 ? 1 : -1)
                    if (qx === 0) ctx.moveTo(qx, qy); else ctx.lineTo(qx, qy)
                }
                ctx.strokeStyle = "#FFB800"
                ctx.lineWidth = 1.5
                ctx.stroke()

                // Onda triangular: se calcula normalizando la fase y aplicando
                // una funcion lineal por tramos (sube de -1 a 1, luego baja).
                ctx.beginPath()
                for (var tx = 0; tx < w; tx++) {
                    var tPhase = freq * tx * 0.04 + scopePhase + 2.0
                    var tNorm = (tPhase / Math.PI) % 2
                    if (tNorm < 0) tNorm += 2
                    var tVal = tNorm < 1 ? (2 * tNorm - 1) : (3 - 2 * tNorm)
                    var ty = cy - amp * 0.5 * tVal
                    if (tx === 0) ctx.moveTo(tx, ty); else ctx.lineTo(tx, ty)
                }
                ctx.strokeStyle = "#00BFFF"
                ctx.lineWidth = 1.5
                ctx.stroke()
            }
        }
    }
}
