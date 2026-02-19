// =============================================================================
// AnalogClock.qml — Reloj analogico en tiempo real con Canvas
// =============================================================================
// Dibuja un reloj analogico completo con esfera, marcas de hora/minuto,
// numeros, tres manecillas (hora, minuto, segundo) y lectura digital.
//
// PATRON Timer + Canvas PARA ACTUALIZACION PERIODICA:
//   El Timer se ejecuta cada 1000ms (1 segundo). En cada tick:
//   1. Lee la hora actual con new Date()
//   2. Almacena horas, minutos y segundos en properties del Canvas
//   3. Llama requestPaint() para redibujar
//   triggeredOnStart: true asegura que el reloj se dibuje inmediatamente
//   al iniciar, sin esperar el primer intervalo.
//
// TECNICAS DE DIBUJO:
//   - Marcas de hora vs minuto: se distinguen por grosor y longitud,
//     usando el modulo i % 5 === 0 para identificar las posiciones horarias.
//   - Manecillas: cada una tiene diferente longitud, grosor y color.
//     La manecilla de hora avanza suavemente (hours + minutes/60) para que
//     no salte en incrementos de 30 grados.
//   - lineCap "round" da extremos redondeados a las manecillas.
//   - El punto central rojo y la manecilla de segundo roja crean un
//     acento visual sobre la estetica gris/blanca del reloj.
//
// La lectura digital al pie usa formato monospace para que los digitos
// no "bailen" al cambiar (todos los caracteres tienen el mismo ancho).
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool clockRunning: false

    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "1. Analog Clock"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.clockRunning ? "Pause" : "Start"
            onClicked: root.clockRunning = !root.clockRunning
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)
        color: Style.surfaceColor
        radius: Style.resize(6)

        Canvas {
            id: clockCanvas
            anchors.centerIn: parent
            onAvailableChanged: if (available) requestPaint()
            width: Style.resize(240)
            height: Style.resize(240)

            property real hours: 0
            property real minutes: 0
            property real seconds: 0

            Timer {
                interval: 1000
                repeat: true
                running: root.active && root.clockRunning
                triggeredOnStart: true
                onTriggered: {
                    var now = new Date()
                    clockCanvas.hours = now.getHours() % 12
                    clockCanvas.minutes = now.getMinutes()
                    clockCanvas.seconds = now.getSeconds()
                    clockCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var cx = width / 2
                var cy = height / 2
                var r = Math.min(cx, cy) - 8

                ctx.clearRect(0, 0, width, height)

                // Fondo de la esfera: circulo oscuro con borde verde teal.
                // El anillo interior sutil agrega profundidad visual.
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.fillStyle = "#1E2128"
                ctx.fill()
                ctx.strokeStyle = "#00D1A9"
                ctx.lineWidth = 3
                ctx.stroke()

                // Inner ring
                ctx.beginPath()
                ctx.arc(cx, cy, r - 8, 0, 2 * Math.PI)
                ctx.strokeStyle = "#2A2D35"
                ctx.lineWidth = 1
                ctx.stroke()

                // Marcas: 60 ticks (uno por segundo). Cada 5to es mas largo
                // y grueso (marca de hora). El angulo se calcula restando 90
                // grados porque 0 grados en Canvas apunta a la derecha, pero
                // el 12 del reloj esta arriba.
                for (var i = 0; i < 60; i++) {
                    var tickAngle = (i * 6 - 90) * Math.PI / 180
                    var isHour = (i % 5 === 0)
                    var outerR = r - 10
                    var innerR = isHour ? r - 28 : r - 18
                    ctx.beginPath()
                    ctx.moveTo(cx + innerR * Math.cos(tickAngle), cy + innerR * Math.sin(tickAngle))
                    ctx.lineTo(cx + outerR * Math.cos(tickAngle), cy + outerR * Math.sin(tickAngle))
                    ctx.strokeStyle = isHour ? "#E0E0E0" : "#555555"
                    ctx.lineWidth = isHour ? 3 : 1
                    ctx.stroke()
                }

                // Hour numbers
                ctx.font = "bold " + Math.round(r * 0.16) + "px sans-serif"
                ctx.fillStyle = "#E0E0E0"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                for (var h = 1; h <= 12; h++) {
                    var hAngle = (h * 30 - 90) * Math.PI / 180
                    var hR = r - 42
                    ctx.fillText(h.toString(), cx + hR * Math.cos(hAngle), cy + hR * Math.sin(hAngle))
                }

                // Manecilla de hora: (hours + minutes/60) crea movimiento
                // suave entre horas. * 30 convierte a grados (360/12 = 30).
                var hourAngle = ((hours + minutes / 60) * 30 - 90) * Math.PI / 180
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.moveTo(cx - 8 * Math.cos(hourAngle), cy - 8 * Math.sin(hourAngle))
                ctx.lineTo(cx + (r * 0.5) * Math.cos(hourAngle), cy + (r * 0.5) * Math.sin(hourAngle))
                ctx.strokeStyle = "#E0E0E0"
                ctx.lineWidth = 5
                ctx.stroke()

                // Minute hand
                var minAngle = ((minutes + seconds / 60) * 6 - 90) * Math.PI / 180
                ctx.beginPath()
                ctx.moveTo(cx - 8 * Math.cos(minAngle), cy - 8 * Math.sin(minAngle))
                ctx.lineTo(cx + (r * 0.7) * Math.cos(minAngle), cy + (r * 0.7) * Math.sin(minAngle))
                ctx.strokeStyle = "#C0C0C0"
                ctx.lineWidth = 3
                ctx.stroke()

                // Second hand
                var secAngle = (seconds * 6 - 90) * Math.PI / 180
                ctx.beginPath()
                ctx.moveTo(cx - 15 * Math.cos(secAngle), cy - 15 * Math.sin(secAngle))
                ctx.lineTo(cx + (r * 0.8) * Math.cos(secAngle), cy + (r * 0.8) * Math.sin(secAngle))
                ctx.strokeStyle = "#E74C3C"
                ctx.lineWidth = 1.5
                ctx.stroke()

                // Center dot
                ctx.beginPath()
                ctx.arc(cx, cy, 5, 0, 2 * Math.PI)
                ctx.fillStyle = "#E74C3C"
                ctx.fill()

                // Digital time readout
                var hStr = hours < 10 ? "0" + Math.floor(hours) : Math.floor(hours).toString()
                var mStr = minutes < 10 ? "0" + Math.floor(minutes) : Math.floor(minutes).toString()
                var sStr = seconds < 10 ? "0" + Math.floor(seconds) : Math.floor(seconds).toString()
                ctx.font = Math.round(r * 0.1) + "px monospace"
                ctx.fillStyle = "#00D1A9"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(hStr + ":" + mStr + ":" + sStr, cx, cy + r * 0.32)
            }
        }
    }
}
