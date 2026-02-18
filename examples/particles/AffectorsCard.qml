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

        // Strength slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Strength: " + strengthSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: strengthSlider; anchors.fill: parent; from: 10; to: 200; value: 80; stepSize: 5 }
            }
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
                id: affectorSystem
                anchors.fill: parent
                running: root.active

                ImageParticle {
                    source: "qrc:/assets/images/particle.png"
                    colorVariation: 0.4
                    color: "#4A90D9"
                    alpha: 0.9
                }

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

                Gravity {
                    enabled: gravityBtn.checked
                    magnitude: strengthSlider.value
                    angle: 90
                }

                Turbulence {
                    enabled: turbulenceBtn.checked
                    anchors.fill: parent
                    strength: strengthSlider.value * 2
                }

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
