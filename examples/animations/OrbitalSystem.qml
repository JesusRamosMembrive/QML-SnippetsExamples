// =============================================================================
// OrbitalSystem.qml — Sistema planetario animado con Canvas
// =============================================================================
// Dibuja un sistema solar simplificado con orbitas circulares, estelas de
// movimiento (trails) y efectos de brillo (glow) usando Canvas 2D.
//
// CONCEPTOS CLAVE DE CANVAS AVANZADO:
//   - createRadialGradient(): crea gradientes circulares para efectos de
//     brillo/glow alrededor de planetas y el sol central.
//   - Trails (estelas): se dibujan multiples circulos semi-transparentes
//     detras de cada planeta, con opacidad decreciente, creando la ilusion
//     de movimiento suave.
//   - Matematica orbital: cada planeta usa cos(t * speed) y sin(t * speed)
//     para moverse en circulos. Diferentes velocidades crean ritmos variados.
//
// PATRON DE ANIMACION CON Timer:
//   El Timer incrementa content.time cada 30ms. El Canvas observa este
//   cambio via 'property real t: content.time' + 'onTChanged: requestPaint()'
//   lo que desencadena el repintado automaticamente cuando cambia t.
//   Este es un patron alternativo a llamar requestPaint() directamente
//   desde el Timer — ambos funcionan, pero este hace la dependencia explicita.
//
// El slider de velocidad multiplica el incremento de tiempo, permitiendo
// acelerar o ralentizar la simulacion sin cambiar la logica de dibujo.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    // ── Titulo + boton Play/Stop ────────────────────
    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Orbital System"
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

    // ── Area de simulacion ────────────────────────────
    Item {
        id: content
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)

        property real time: 0
        property bool running: root.active && root.sectionActive
        property real speedMul: orbitSpeedSlider.value

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Timer {
            running: content.running
            interval: 30
            repeat: true
            onTriggered: {
                content.time += 0.03 * content.speedMul
            }
        }

        Canvas {
            id: orbitCanvas
            anchors.fill: parent

            property real t: content.time
            onTChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var cx = width / 2
                var cy = height / 2
                var t = content.time

                var orbits = [
                    { r: 40,  speed: 2.0,  size: 6,  color: "#5B8DEF", trail: 20 },
                    { r: 70,  speed: 1.3,  size: 8,  color: "#00D1A9", trail: 25 },
                    { r: 105, speed: 0.8,  size: 10, color: "#FF9500", trail: 30 },
                    { r: 135, speed: 0.5,  size: 7,  color: "#FF3B30", trail: 22 }
                ]

                // Dibujar las trayectorias orbitales como circulos tenues.
                // Esto da contexto visual de por donde se mueven los planetas.
                for (var o = 0; o < orbits.length; o++) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, orbits[o].r, 0, 2 * Math.PI)
                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                    ctx.lineWidth = 1
                    ctx.stroke()
                }

                // Dibujar estelas y planetas. Cada planeta tiene un trail
                // de puntos semi-transparentes que decrecen en tamanio y opacidad,
                // creando la ilusion de estela de movimiento.
                for (var j = 0; j < orbits.length; j++) {
                    var orb = orbits[j]
                    var trailLen = orb.trail

                    // Trail
                    for (var k = trailLen; k >= 0; k--) {
                        var tt = t * orb.speed - k * 0.04
                        var tx = cx + orb.r * Math.cos(tt)
                        var ty = cy + orb.r * Math.sin(tt)
                        var alpha = (1 - k / trailLen) * 0.4
                        var sz = orb.size * (1 - k / trailLen) * 0.6
                        ctx.beginPath()
                        ctx.arc(tx, ty, sz, 0, 2 * Math.PI)
                        ctx.fillStyle = Qt.hsla(0, 0, 1, alpha * 0.3)
                        ctx.fill()
                    }

                    // Planet
                    var px = cx + orb.r * Math.cos(t * orb.speed)
                    var py = cy + orb.r * Math.sin(t * orb.speed)
                    ctx.beginPath()
                    ctx.arc(px, py, orb.size, 0, 2 * Math.PI)
                    ctx.fillStyle = orb.color
                    ctx.fill()

                    // Glow
                    var grad = ctx.createRadialGradient(px, py, 0, px, py, orb.size * 2.5)
                    grad.addColorStop(0, Qt.rgba(
                        Qt.color(orb.color).r,
                        Qt.color(orb.color).g,
                        Qt.color(orb.color).b, 0.3))
                    grad.addColorStop(1, "transparent")
                    ctx.beginPath()
                    ctx.arc(px, py, orb.size * 2.5, 0, 2 * Math.PI)
                    ctx.fillStyle = grad
                    ctx.fill()
                }

                // Sol central: gradiente radial de blanco calido a naranja
                // transparente, creando un efecto de resplandor natural.
                var sunGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, 18)
                sunGrad.addColorStop(0, "#FFF4D4")
                sunGrad.addColorStop(0.6, "#FEA601")
                sunGrad.addColorStop(1, Qt.rgba(1, 0.65, 0, 0))
                ctx.beginPath()
                ctx.arc(cx, cy, 18, 0, 2 * Math.PI)
                ctx.fillStyle = sunGrad
                ctx.fill()

                // Sun core
                ctx.beginPath()
                ctx.arc(cx, cy, 8, 0, 2 * Math.PI)
                ctx.fillStyle = "#FFFFFF"
                ctx.fill()
            }
        }

        // Speed control
        Row {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: Style.resize(10)
            spacing: Style.resize(8)

            Label {
                text: "Speed"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Slider {
                id: orbitSpeedSlider
                width: Style.resize(120)
                from: 0.1; to: 5; value: 1; stepSize: 0.1
            }
        }
    }
}
