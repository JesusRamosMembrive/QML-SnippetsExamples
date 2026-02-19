// =============================================================================
// ParticleFountain.qml — Sistema de particulas manual con Canvas + Timer
// =============================================================================
// Implementa un sistema de particulas desde cero usando JavaScript puro,
// sin el modulo QtQuick.Particles (que es mas complejo y menos didactico).
//
// PATRON Timer + Canvas para simulaciones:
//   1. Un Timer se ejecuta cada ~25ms (40 FPS aproximados).
//   2. En cada tick: spawner crea particulas nuevas, se aplican fuerzas
//      (gravedad, viento), se actualizan posiciones, y se eliminan las muertas.
//   3. Se llama requestPaint() para redibujar el Canvas con el nuevo estado.
//
// CONCEPTOS DE FISICA SIMULADA:
//   - Cada particula tiene posicion (x,y), velocidad (vx,vy) y vida (life).
//   - La gravedad se suma a vy cada frame (aceleracion constante hacia abajo).
//   - El viento se suma a vx (desplazamiento horizontal).
//   - life decrece linealmente; cuando llega a 0, la particula se elimina.
//
// El alpha de cada particula usa fade-in/fade-out: aparece gradualmente,
// se mantiene opaca, y desaparece suavemente al morir. Esto crea un efecto
// visual mas pulido que simplemente desaparecer de golpe.
//
// PATRON active/sectionActive:
//   - active: viene del padre (Main.qml), true cuando la pagina es visible.
//   - sectionActive: control individual del usuario (boton Play/Stop).
//   - El Timer solo corre cuando AMBOS son true, evitando CPU desperdiciada.
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
            text: "Particle Fountain"
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
    // 'particles' es un array JS que actua como pool de particulas activas.
    // maxParticles limita el conteo para mantener rendimiento estable.
    Item {
        id: content
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)

        property bool running: root.active && root.sectionActive
        property var particles: []
        property real gravity: gravitySlider.value
        property real wind: windSlider.value
        property int maxParticles: 120

        Canvas {
            id: particleCanvas
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(8)
                z: -1
            }

            // onPaint recorre todas las particulas vivas y las dibuja como
            // circulos con alpha variable. ctx.reset() limpia el canvas
            // completamente (mas agresivo que clearRect, resetea tambien estilos).
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var ps = content.particles
                for (var i = 0; i < ps.length; i++) {
                    var p = ps[i]
                    // Fade-in durante el primer 30% de vida, opaco en el medio,
                    // fade-out en el ultimo 30%. Crea transiciones suaves.
                    var life = p.life / p.maxLife
                    var alpha = life > 0.7 ? (1 - life) / 0.3
                              : life < 0.3 ? life / 0.3
                              : 1.0
                    var size = p.size * (0.5 + 0.5 * life)
                    ctx.beginPath()
                    ctx.arc(p.x, p.y, size, 0, 2 * Math.PI)
                    ctx.fillStyle = Qt.rgba(p.r, p.g, p.b, alpha * 0.85)
                    ctx.fill()
                }
            }
        }

        Timer {
            running: content.running
            interval: 25
            repeat: true
            onTriggered: {
                var ps = content.particles
                var w = particleCanvas.width
                var h = particleCanvas.height
                var grav = content.gravity
                var wnd = content.wind

                // Crear 3 particulas por frame desde el centro inferior.
                // El angulo se dispersa alrededor de -PI/2 (hacia arriba)
                // con variacion aleatoria para el efecto de "fuente".
                for (var s = 0; s < 3; s++) {
                    if (ps.length < content.maxParticles) {
                        var angle = -Math.PI / 2 + (Math.random() - 0.5) * 0.8
                        var speed = 3 + Math.random() * 4
                        var hue = Math.random()
                        var r, g, b
                        if (hue < 0.33) {
                            r = 0; g = 0.82; b = 0.66
                        } else if (hue < 0.66) {
                            r = 0.35; g = 0.55; b = 0.94
                        } else {
                            r = 1.0; g = 0.58; b = 0
                        }
                        ps.push({
                            x: w / 2, y: h - 10,
                            vx: Math.cos(angle) * speed,
                            vy: Math.sin(angle) * speed,
                            life: 1.0, maxLife: 1.0,
                            size: 2 + Math.random() * 4,
                            r: r, g: g, b: b
                        })
                    }
                }

                // Actualizar fisica: gravedad afecta vy, viento afecta vx.
                // Se filtran particulas muertas o fuera de pantalla.
                var alive = []
                for (var i = 0; i < ps.length; i++) {
                    var p = ps[i]
                    p.vy += grav * 0.025
                    p.vx += wnd * 0.01
                    p.x += p.vx
                    p.y += p.vy
                    p.life -= 0.012
                    if (p.life > 0 && p.x > -10 && p.x < w + 10
                        && p.y > -10 && p.y < h + 10)
                        alive.push(p)
                }
                content.particles = alive
                particleCanvas.requestPaint()
            }
        }

        // Controles superpuestos sobre el canvas para ajustar parametros
        // de fisica en tiempo real. Estan posicionados con anchors, no Layout,
        // porque viven dentro de un Item (no de un Layout).
        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Style.resize(10)
            spacing: Style.resize(15)

            Column {
                spacing: Style.resize(2)
                Label {
                    text: "Gravity: " + gravitySlider.value.toFixed(1)
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
                Slider {
                    id: gravitySlider
                    width: Style.resize(120)
                    from: -2; to: 5; value: 2.0; stepSize: 0.1
                }
            }

            Column {
                spacing: Style.resize(2)
                Label {
                    text: "Wind: " + windSlider.value.toFixed(1)
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
                Slider {
                    id: windSlider
                    width: Style.resize(120)
                    from: -3; to: 3; value: 0; stepSize: 0.1
                }
            }
        }
    }
}
