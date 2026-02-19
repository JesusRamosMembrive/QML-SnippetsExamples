// ============================================================================
// AffectorsCard.qml
// Demuestra los "Affectors" (modificadores) del sistema de particulas de Qt.
//
// CONCEPTO CLAVE: Los Affectors modifican el comportamiento de las particulas
// DESPUES de ser emitidas. Mientras el Emitter define las condiciones iniciales,
// los Affectors alteran posicion, velocidad o aceleracion durante la vida de
// cada particula. Se pueden combinar multiples affectors simultaneamente.
//
// Affectors mostrados aqui:
//   - Gravity: aplica una fuerza constante en una direccion (simula gravedad).
//   - Turbulence: introduce ruido aleatorio en la velocidad (efecto de viento).
//   - Wander: hace que las particulas "deambulen" desviandose de su trayectoria.
//
// Otros affectors disponibles en Qt (no mostrados):
//   - Friction: reduce la velocidad gradualmente.
//   - Attractor: atrae particulas hacia un punto.
//   - Age: envejece particulas prematuramente (las hace morir antes).
//   - SpriteGoal: cambia el estado de sprites animados.
// ============================================================================
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
            text: "Affectors"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Botones toggle para activar/desactivar cada affector ---
        // Usar 'checkable: true' convierte un Button en un toggle.
        // 'highlighted: checked' da retroalimentacion visual del estado activo.
        // Se pueden activar varios affectors a la vez para ver como interactuan.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Button {
                id: gravityBtn
                text: "Gravity"
                checkable: true
                checked: true
                highlighted: checked
            }
            Button {
                id: turbulenceBtn
                text: "Turbulence"
                checkable: true
                checked: false
                highlighted: checked
            }
            Button {
                id: wanderBtn
                text: "Wander"
                checkable: true
                checked: false
                highlighted: checked
            }
        }

        // Slider de intensidad: controla la magnitud de todos los affectors.
        // Esto demuestra como los bindings de QML permiten conectar un unico
        // control a multiples propiedades de diferentes componentes.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Strength: " + strengthSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: strengthSlider; anchors.fill: parent; from: 10; to: 200; value: 80; stepSize: 5 }
            }
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
                id: affectorSystem
                anchors.fill: parent
                running: root.active

                ImageParticle {
                    source: "qrc:/assets/images/particle.png"
                    colorVariation: 0.4
                    color: "#4A90D9"
                    alpha: 0.9
                }

                // Las particulas se emiten desde arriba (angle: 90 = hacia abajo)
                // con dispersion angular para crear un efecto de "lluvia".
                Emitter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: Style.resize(10)
                    width: parent.width * 0.6
                    emitRate: 60
                    lifeSpan: 3000
                    size: 12
                    sizeVariation: 4
                    velocity: AngleDirection {
                        angle: 90
                        angleVariation: 40
                        magnitude: 60
                        magnitudeVariation: 20
                    }
                }

                // Gravity: aplica aceleracion constante en una direccion.
                // - magnitude: fuerza de la gravedad (pixeles/s^2).
                // - angle: 90 = hacia abajo. Cambiar a 270 para "antigravedad".
                // A diferencia de velocity en Emitter, Gravity es una aceleracion
                // continua, por lo que las particulas van cada vez mas rapido.
                Gravity {
                    enabled: gravityBtn.checked
                    magnitude: strengthSlider.value
                    angle: 90
                }

                // Turbulence: agrega ruido Perlin a la velocidad de las particulas.
                // Crea movimiento caotico y organico, ideal para simular viento,
                // humo o fuego. 'strength' controla la intensidad del ruido.
                // IMPORTANTE: necesita anchors.fill para definir el area de efecto.
                Turbulence {
                    enabled: turbulenceBtn.checked
                    anchors.fill: parent
                    strength: strengthSlider.value * 2
                }

                // Wander: desvia las particulas de su trayectoria gradualmente.
                // - pace: velocidad de cambio de la desviacion (pixeles/segundo).
                // - affectedParameter: que propiedad modificar (Position, Velocity,
                //   o Acceleration). Position da un efecto mas suave y directo.
                // - xVariance/yVariance: rango maximo de desviacion en cada eje.
                // Diferencia con Turbulence: Wander es mas predecible y suave,
                // mientras que Turbulence es caotico.
                Wander {
                    enabled: wanderBtn.checked
                    anchors.fill: parent
                    pace: 200
                    affectedParameter: Wander.Position
                    xVariance: strengthSlider.value
                    yVariance: strengthSlider.value / 2
                }
            }
        }

        Label {
            text: "Gravity, Turbulence, and Wander modify particle behavior"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
