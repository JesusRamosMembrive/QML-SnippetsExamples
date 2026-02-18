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
            text: "Basic Emitter"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Rate slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Rate: " + rateSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: rateSlider; anchors.fill: parent; from: 5; to: 200; value: 50; stepSize: 5 }
            }
        }

        // Lifespan slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Life: " + lifeSlider.value.toFixed(0) + "ms"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: lifeSlider; anchors.fill: parent; from: 500; to: 5000; value: 2000; stepSize: 100 }
            }
        }

        // Size slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Size: " + sizeSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: sizeSlider; anchors.fill: parent; from: 4; to: 40; value: 16; stepSize: 2 }
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
                id: basicSystem
                anchors.fill: parent
                running: root.active

                ImageParticle {
                    source: "qrc:/assets/images/particle.png"
                    colorVariation: 0.6
                    color: Style.mainColor
                    alpha: 0.8
                }

                Emitter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: Style.resize(40)
                    emitRate: rateSlider.value
                    lifeSpan: lifeSlider.value
                    size: sizeSlider.value
                    sizeVariation: sizeSlider.value / 3
                    velocity: AngleDirection {
                        angle: 270
                        angleVariation: 30
                        magnitude: 100
                        magnitudeVariation: 40
                    }
                }
            }
        }

        Label {
            text: "ParticleSystem + Emitter + ImageParticle for basic effects"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
