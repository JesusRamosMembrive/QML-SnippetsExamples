// =============================================================================
// Kaleidoscope.qml — Caleidoscopio animado con simetria rotacional
// =============================================================================
// Simula un caleidoscopio real: formas coloreadas se reflejan y repiten en
// multiples segmentos simetricos alrededor de un punto central, creando
// patrones mandala que evolucionan continuamente.
//
// TECNICA DE SIMETRIA CON Canvas:
//   El canvas se divide en 'segments' sectores angulares (por defecto 8).
//   Para cada segmento:
//   1. ctx.translate(cx, cy) mueve el origen al centro
//   2. ctx.rotate(seg * segAngle) rota al angulo del segmento
//   3. Los segmentos pares se dibujan normal; los impares se reflejan
//      con ctx.scale(1, -1), creando simetria de espejo
//   4. Se dibujan las mismas formas en cada segmento
//   ctx.save()/ctx.restore() preserva y restaura el estado de transformacion.
//
// EFECTO DE ESPEJO (seg % 2 === 1 -> scale(1, -1)):
//   En un caleidoscopio real, los espejos crean reflexiones alternas.
//   scale(1, -1) invierte el eje Y, produciendo exactamente ese efecto.
//   Sin la inversion, tendriamos simple rotacion; CON ella, la simetria
//   es mas rica y se parece mas a un caleidoscopio real.
//
// COLORES CICLICOS CON ONDAS SENO:
//   RGB se calculan con sin() desfasados 2.1 radianes entre si (~120 grados),
//   lo que produce un ciclo de colores que recorre todo el espectro suavemente.
//   El desfase por segmento (seg * 0.3) hace que segmentos adyacentes tengan
//   colores ligeramente distintos, enriqueciendo el patron.
//
// Clip circular: ctx.arc() + ctx.clip() recorta el dibujo a un circulo,
// evitando que las formas de los segmentos se salgan del area del radar.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool kaleidoRunning: false

    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "6. Kaleidoscope"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.kaleidoRunning ? "Pause" : "Start"
            onClicked: root.kaleidoRunning = !root.kaleidoRunning
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: "#0A0A14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: kaleidoCanvas
            anchors.centerIn: parent
            onAvailableChanged: if (available) requestPaint()
            width: Math.min(parent.width - Style.resize(20), Style.resize(280))
            height: width

            property real time: 0
            property int segments: 8

            Timer {
                interval: 50
                repeat: true
                running: root.active && root.kaleidoRunning
                onTriggered: {
                    kaleidoCanvas.time += 0.03
                    kaleidoCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width
                var h = height
                var cx = w / 2
                var cy = h / 2
                var r = Math.min(cx, cy) - 4

                ctx.clearRect(0, 0, w, h)

                // Recorte circular: todo lo que se dibuje fuera del circulo
                // sera invisible. ctx.save() preserva el estado sin clip
                // para poder restaurarlo al final.
                ctx.save()
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.clip()

                ctx.fillStyle = "#0A0A14"
                ctx.fillRect(0, 0, w, h)

                var segAngle = 2 * Math.PI / segments

                // Iterar por cada segmento del caleidoscopio. translate + rotate
                // posiciona cada sector. Los impares se reflejan con scale(1,-1).
                for (var seg = 0; seg < segments; seg++) {
                    ctx.save()
                    ctx.translate(cx, cy)
                    ctx.rotate(seg * segAngle)
                    if (seg % 2 === 1)
                        ctx.scale(1, -1)

                    var numShapes = 6
                    for (var i = 0; i < numShapes; i++) {
                        var phase = time + i * 0.8
                        var dist = 20 + 40 * Math.sin(phase * 0.7) + i * 15
                        var sx = dist * Math.cos(phase * 0.3 + i)
                        var sy = dist * Math.sin(phase * 0.5 + i) * 0.4
                        var size = 4 + 6 * Math.sin(phase * 1.2)

                        // Smooth color cycling via sine waves
                        var ct = time * 0.5 + i * 0.4 + seg * 0.3
                        var cr = Math.round(127 + 128 * Math.sin(ct))
                        var cg = Math.round(127 + 128 * Math.sin(ct + 2.1))
                        var cb = Math.round(127 + 128 * Math.sin(ct + 4.2))

                        ctx.beginPath()
                        ctx.arc(sx, sy, Math.abs(size), 0, 2 * Math.PI)
                        ctx.fillStyle = "rgb(" + cr + "," + cg + "," + cb + ")"
                        ctx.fill()

                        // Lineas conectoras entre puntos adyacentes del segmento
                        if (i > 0) {
                            var prevPhase = time + (i - 1) * 0.8
                            var prevDist = 20 + 40 * Math.sin(prevPhase * 0.7) + (i - 1) * 15
                            var prevSx = prevDist * Math.cos(prevPhase * 0.3 + (i - 1))
                            var prevSy = prevDist * Math.sin(prevPhase * 0.5 + (i - 1)) * 0.4

                            ctx.beginPath()
                            ctx.moveTo(prevSx, prevSy)
                            ctx.lineTo(sx, sy)
                            ctx.strokeStyle = "rgba(" + cr + "," + cg + "," + cb + ", 0.3)"
                            ctx.lineWidth = 1
                            ctx.stroke()
                        }
                    }

                    ctx.restore()
                }

                ctx.restore()

                // Border ring
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.strokeStyle = "#333355"
                ctx.lineWidth = 2
                ctx.stroke()
            }
        }
    }
}
