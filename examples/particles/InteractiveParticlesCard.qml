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

        // Particle area
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

                ImageParticle {
                    groups: ["mouse"]
                    source: "qrc:/assets/images/particle.png"
                    color: Style.mainColor
                    colorVariation: 0.5
                    alpha: 0.7
                }

                ImageParticle {
                    groups: ["burst"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FEA601"
                    colorVariation: 0.3
                    alpha: 0.9
                }

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
