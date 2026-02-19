// =============================================================================
// MatrixRain.qml — Efecto "lluvia de Matrix" con caracteres Katakana
// =============================================================================
// Recrea el iconico efecto visual de la pelicula Matrix: columnas de caracteres
// japoneses (Katakana) cayendo con un brillo verde fosforescente.
//
// TECNICA DE FADE CON CANVAS (sin clearRect):
//   En vez de limpiar el canvas completamente cada frame, se pinta un
//   rectangulo semi-transparente oscuro encima (alpha 0.15). Esto hace que
//   los caracteres anteriores se "desvanezcan" gradualmente, creando el
//   efecto de persistencia/trail sin necesidad de almacenar historial.
//   Este truco es clasico en demos graficas y visualizaciones.
//
// ESTRUCTURA DE COLUMNAS:
//   Cada columna tiene una posicion Y (cabeza), velocidad de caida,
//   y un array de caracteres Katakana pre-generados. Unicode 0x30A0-0x30FF
//   cubre el rango de Katakana. Algunos caracteres se cambian aleatoriamente
//   cada frame para crear el efecto de "parpadeo" del original.
//
// COLORES POR DISTANCIA A LA CABEZA:
//   - Cabeza (dist 0): blanco brillante #FFFFFF
//   - Cerca (dist < 3): verde claro intenso
//   - Lejos (dist >= 3): verde oscuro con opacidad decreciente
//   Esto simula el efecto de fosforescencia del CRT original.
//
// La inicializacion lazy (initialized flag) evita recrear las columnas
// en cada tick del Timer, solo se inicializan cuando cambia el tamanio
// del canvas o en el primer frame.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool sectionActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Matrix Rain"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
            Layout.fillWidth: true
        }
        Button {
            text: root.sectionActive ? "\u25A0 Stop" : "\u25B6 Play"
            flat: true
            font.pixelSize: Style.resize(12)
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    Item {
        id: matrixSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(250)

        property bool running: root.active && root.sectionActive
        property var columns: []
        property bool initialized: false

        Rectangle {
            anchors.fill: parent
            color: "#0A0A0A"
            radius: Style.resize(8)
        }

        Timer {
            running: matrixSection.running && matrixCanvas.width > 0
            interval: 50
            repeat: true
            onTriggered: {
                var cols = matrixSection.columns
                var colCount = Math.floor(matrixCanvas.width / 14)
                var rowCount = Math.floor(matrixCanvas.height / 16)

                // Initialize columns
                if (!matrixSection.initialized || cols.length !== colCount) {
                    cols = []
                    for (var c = 0; c < colCount; c++) {
                        cols.push({
                            y: Math.floor(Math.random() * rowCount),
                            speed: 0.3 + Math.random() * 0.7,
                            chars: []
                        })
                        // Pre-fill chars
                        for (var ch = 0; ch < rowCount; ch++) {
                            cols[c].chars.push(
                                String.fromCharCode(0x30A0 + Math.floor(Math.random() * 96)))
                        }
                    }
                    matrixSection.initialized = true
                }

                // Advance columns
                for (var i = 0; i < cols.length; i++) {
                    cols[i].y += cols[i].speed
                    if (cols[i].y > rowCount + 8) {
                        cols[i].y = -Math.floor(Math.random() * 8)
                        cols[i].speed = 0.3 + Math.random() * 0.7
                    }
                    // Randomize a char occasionally
                    if (Math.random() < 0.05) {
                        var ri = Math.floor(Math.random() * rowCount)
                        cols[i].chars[ri] =
                            String.fromCharCode(0x30A0 + Math.floor(Math.random() * 96))
                    }
                }
                matrixSection.columns = cols
                matrixCanvas.requestPaint()
            }
        }

        Canvas {
            id: matrixCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(1)

            onPaint: {
                var ctx = getContext("2d")
                // Efecto de desvanecimiento: en vez de clearRect(), se pinta
                // un rectangulo semi-transparente oscuro. Los dibujos anteriores
                // se oscurecen gradualmente creando el trail caracteristico.
                ctx.fillStyle = Qt.rgba(0.04, 0.04, 0.04, 0.15)
                ctx.fillRect(0, 0, width, height)

                var cols = matrixSection.columns
                if (!cols || cols.length === 0) return

                var fontSize = 14
                var rowH = 16
                var rowCount = Math.floor(height / rowH)

                ctx.font = fontSize + "px monospace"

                for (var c = 0; c < cols.length; c++) {
                    var col = cols[c]
                    var headY = Math.floor(col.y)

                    for (var r = 0; r < rowCount; r++) {
                        var dist = headY - r
                        if (dist < 0 || dist > 20) continue

                        var alpha = dist === 0 ? 1.0 : Math.max(0, 1 - dist / 20)

                        if (dist === 0) {
                            ctx.fillStyle = "#FFFFFF"
                        } else if (dist < 3) {
                            ctx.fillStyle = Qt.rgba(0.3, 1, 0.3, alpha)
                        } else {
                            ctx.fillStyle = Qt.rgba(0, 0.7, 0, alpha * 0.7)
                        }

                        var ch = col.chars[r % col.chars.length]
                        ctx.fillText(ch, c * 14 + 2, r * rowH + fontSize)
                    }
                }
            }
        }
    }
}
