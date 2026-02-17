import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    // ── Section title ────────────────────────────────
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

    // ── Content ──────────────────────────────────────
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

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var ps = content.particles
                for (var i = 0; i < ps.length; i++) {
                    var p = ps[i]
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

                // Spawn new particles
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

                // Update particles
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

        // Controls overlay
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
