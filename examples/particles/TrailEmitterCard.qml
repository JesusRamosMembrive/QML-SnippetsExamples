// =============================================================================
// TrailEmitterCard.qml — Ejemplo de TrailEmitter (estelas de particulas)
// =============================================================================
// Demuestra TrailEmitter, un emisor especial que genera particulas "hijas"
// que siguen a las particulas de otro grupo. El resultado visual es un efecto
// de estela o cola, similar a cohetes, cometas o fuegos artificiales.
//
// Conceptos clave:
// - TrailEmitter: emite particulas relativas a las particulas de otro grupo
//   mediante la propiedad "follow". emitRatePerParticle controla cuantas
//   particulas de estela se generan por cada particula fuente.
// - burst(): metodo del Emitter para emitir N particulas instantaneamente
//   (emitRate: 0 significa que no emite continuamente, solo con burst).
// - Gravity affector: simula gravedad para que las particulas fuente
//   describan un arco parabolico realista.
// - Grupos de particulas: "source" son las particulas principales (doradas),
//   "trail" son las de la estela (naranjas, mas pequenas y efimeras).
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool active: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        Label {
            text: "Trail Emitter"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Control interactivo ---
        // El slider permite ajustar en tiempo real cuantas particulas de
        // estela genera cada particula fuente (emitRatePerParticle).
        // Valores bajos = estela sutil, valores altos = efecto denso.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Trail rate: " + trailRateSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: trailRateSlider; anchors.fill: parent; from: 5; to: 80; value: 30; stepSize: 5 }
            }
        }

        Button {
            text: "Launch"
            onClicked: trailBurstEmitter.burst(8)
        }

        // --- Area de particulas ---
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            ParticleSystem {
                id: trailSystem
                anchors.fill: parent
                running: root.active

                // ImageParticle para el grupo "source" (particulas principales).
                // Color dorado con poca variacion para que se distingan bien.
                ImageParticle {
                    groups: ["source"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FEA601"
                    colorVariation: 0.2
                    alpha: 1.0
                }

                // ImageParticle para el grupo "trail" (estela).
                // Color naranja mas oscuro, alpha reducido y mayor variacion
                // de color para dar un aspecto difuso y organico a la cola.
                ImageParticle {
                    groups: ["trail"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FF5900"
                    colorVariation: 0.4
                    alpha: 0.6
                }

                // --- Emitter principal (modo burst) ---
                // emitRate: 0 significa que no emite continuamente. Solo
                // genera particulas cuando se llama burst(N) desde el boton.
                // Las particulas salen hacia arriba (angle: 270) con variacion
                // angular para simular dispersion tipo cohete.
                Emitter {
                    id: trailBurstEmitter
                    group: "source"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    emitRate: 0
                    lifeSpan: 3000
                    size: 20
                    sizeVariation: 4
                    velocity: AngleDirection {
                        angle: 270
                        angleVariation: 40
                        magnitude: 150
                        magnitudeVariation: 50
                    }
                }

                // --- TrailEmitter (el componente protagonista) ---
                // "follow: source" hace que este emisor genere particulas
                // en la posicion de cada particula del grupo "source".
                // emitRatePerParticle se vincula al slider para control
                // interactivo. Las particulas de estela son mas pequenas
                // (size: 8 -> endSize: 2) y efimeras (lifeSpan: 800ms).
                TrailEmitter {
                    group: "trail"
                    follow: "source"
                    emitRatePerParticle: trailRateSlider.value
                    lifeSpan: 800
                    size: 8
                    sizeVariation: 4
                    endSize: 2
                    velocity: AngleDirection {
                        angleVariation: 180
                        magnitude: 20
                        magnitudeVariation: 10
                    }
                }

                // Gravity solo afecta al grupo "source" para que las
                // particulas principales caigan en arco. La estela hereda
                // la posicion pero no la gravedad, creando un efecto natural.
                Gravity {
                    groups: ["source"]
                    magnitude: 60
                    angle: 90
                }
            }
        }

        Label {
            text: "TrailEmitter creates particles that follow other particles"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
