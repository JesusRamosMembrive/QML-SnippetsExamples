// =============================================================================
// InteractiveParticlesCard.qml — Particulas controladas por el mouse
// =============================================================================
// Demuestra como vincular emisores de particulas a la posicion del cursor
// para crear efectos interactivos. Dos modos de emision: continuo al mover
// el mouse y explosivo (burst) al hacer clic.
//
// CONCEPTOS CLAVE:
//
// 1. Emitter posicionado por el mouse:
//    - Las propiedades x/y del Emitter se vinculan a mouseX/mouseY del
//      MouseArea. Esto hace que las particulas se emitan desde donde esta
//      el cursor, creando un efecto de "pincel de particulas".
//    - hoverEnabled: true permite rastrear el mouse sin necesidad de clic.
//
// 2. burst() para emision instantanea:
//    - burstEmitter tiene emitRate: 0 (no emite continuamente).
//    - Al hacer clic, burstEmitter.burst(50) emite 50 particulas de golpe.
//    - La combinacion de emision continua (mouse) + burst (clic) crea
//      una experiencia interactiva rica con dos capas visuales.
//
// 3. Grupos de particulas:
//    - "mouse" y "burst" son grupos independientes, cada uno con su propio
//      ImageParticle (color distinto: teal vs dorado).
//    - Los grupos permiten que diferentes emisores generen particulas con
//      apariencias y comportamientos distintos en el mismo sistema.
//
// 4. containsMouse como control de emision:
//    - enabled: interactiveMouseArea.containsMouse activa el mouseEmitter
//      solo cuando el cursor esta dentro del area de particulas.
//    - Sin esto, el emisor seguiria activo incluso fuera del area.
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
            text: "Interactive Particles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Move mouse to emit. Click to burst."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }

        // Area de particulas interactivas: el mouse controla la posicion
        // de emision y el clic dispara una explosion de particulas.
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
                id: interactiveSystem
                anchors.fill: parent
                running: root.active

                // Particulas del grupo "mouse": color teal con variacion.
                // Se emiten continuamente mientras el cursor esta en el area.
                ImageParticle {
                    groups: ["mouse"]
                    source: "qrc:/assets/images/particle.png"
                    color: Style.mainColor
                    colorVariation: 0.5
                    alpha: 0.7
                }

                // Particulas del grupo "burst": color dorado, alpha alto.
                // Solo se emiten con burst() al hacer clic.
                ImageParticle {
                    groups: ["burst"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FEA601"
                    colorVariation: 0.3
                    alpha: 0.9
                }

                // Emitter continuo: sigue al cursor. enabled se vincula a
                // containsMouse para pausar cuando el cursor sale del area.
                Emitter {
                    id: mouseEmitter
                    group: "mouse"
                    enabled: interactiveMouseArea.containsMouse
                    x: interactiveMouseArea.mouseX - width / 2
                    y: interactiveMouseArea.mouseY - height / 2
                    width: Style.resize(10)
                    height: Style.resize(10)
                    emitRate: 80
                    lifeSpan: 1500
                    size: 12
                    sizeVariation: 6
                    endSize: 2
                    velocity: AngleDirection {
                        angleVariation: 180
                        magnitude: 40
                        magnitudeVariation: 20
                    }
                }

                // Emitter de explosiones: emitRate: 0 significa que solo emite
                // cuando se llama burst(N). Las particulas salen en todas
                // las direcciones (angleVariation: 180) con alta velocidad.
                Emitter {
                    id: burstEmitter
                    group: "burst"
                    enabled: false
                    x: interactiveMouseArea.mouseX - width / 2
                    y: interactiveMouseArea.mouseY - height / 2
                    width: Style.resize(4)
                    height: Style.resize(4)
                    emitRate: 0
                    lifeSpan: 1200
                    size: 16
                    sizeVariation: 8
                    endSize: 2
                    velocity: AngleDirection {
                        angleVariation: 180
                        magnitude: 120
                        magnitudeVariation: 60
                    }
                }
            }

            // MouseArea con hoverEnabled: rastrea la posicion del cursor
            // continuamente. El clic dispara burst(50) en el burstEmitter.
            MouseArea {
                id: interactiveMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: function(mouse) {
                    burstEmitter.burst(50)
                }
            }
        }

        Label {
            text: "Mouse-driven Emitter position and burst() for click effects"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
