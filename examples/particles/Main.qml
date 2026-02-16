import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Particles Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: Basic Emitter
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

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
                                Label { text: "Rate: " + rateSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: "#333"; Layout.preferredWidth: Style.resize(80) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: rateSlider; anchors.fill: parent; from: 5; to: 200; value: 50; stepSize: 5 }
                                }
                            }

                            // Lifespan slider
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Life: " + lifeSlider.value.toFixed(0) + "ms"; font.pixelSize: Style.resize(12); color: "#333"; Layout.preferredWidth: Style.resize(80) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: lifeSlider; anchors.fill: parent; from: 500; to: 5000; value: 2000; stepSize: 100 }
                                }
                            }

                            // Size slider
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Size: " + sizeSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: "#333"; Layout.preferredWidth: Style.resize(80) }
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
                                    running: root.fullSize

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
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: Affectors
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

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
                                Label { text: "Strength: " + strengthSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: "#333"; Layout.preferredWidth: Style.resize(80) }
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
                                    running: root.fullSize

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
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Trail Emitter
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

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
                                Label { text: "Trail rate: " + trailRateSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: "#333"; Layout.preferredWidth: Style.resize(80) }
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
                                    running: root.fullSize

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
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Interactive Particles
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

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
                                color: "#666"
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
                                    running: root.fullSize

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
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout
            }
        }
    }
}
