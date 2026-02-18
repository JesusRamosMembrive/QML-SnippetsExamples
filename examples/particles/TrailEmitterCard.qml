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
                id: trailSystem
                anchors.fill: parent
                running: root.active

                ImageParticle {
                    groups: ["source"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FEA601"
                    colorVariation: 0.2
                    alpha: 1.0
                }

                ImageParticle {
                    groups: ["trail"]
                    source: "qrc:/assets/images/particle.png"
                    color: "#FF5900"
                    colorVariation: 0.4
                    alpha: 0.6
                }

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
