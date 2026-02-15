import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qdashboardstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

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
                    text: "Slider Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Basic Sliders Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(280)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(20)

                        Label {
                            text: "Basic Sliders"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // Horizontal Slider
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Horizontal Slider: " + horizontalSlider.value.toFixed(2)
                                font.pixelSize: Style.resize(14)
                                color: "#333"
                            }

                            Slider {
                                id: horizontalSlider
                                from: 0
                                to: 100
                                value: 50
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        // Stepped Slider
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Stepped Slider (step: 10): " + steppedSlider.value.toFixed(0)
                                font.pixelSize: Style.resize(14)
                                color: "#333"
                            }

                            Slider {
                                id: steppedSlider
                                from: 0
                                to: 100
                                stepSize: 10
                                value: 50
                                snapMode: Slider.SnapAlways
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        // Disabled Slider
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Disabled Slider"
                                font.pixelSize: Style.resize(14)
                                color: "#999"
                            }

                            Slider {
                                from: 0
                                to: 100
                                value: 75
                                enabled: false
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }
                    }
                }

                // Vertical Sliders Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(280)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Vertical Sliders"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        RowLayout {
                            spacing: Style.resize(30)
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            // Vertical Slider 1
                            ColumnLayout {
                                spacing: Style.resize(10)

                                Slider {
                                    id: verticalSlider1
                                    from: 0
                                    to: 100
                                    value: 30
                                    orientation: Qt.Vertical
                                    Layout.preferredWidth: Style.resize(40)
                                    Layout.preferredHeight: Style.resize(150)
                                }

                                Label {
                                    text: verticalSlider1.value.toFixed(0)
                                    font.pixelSize: Style.resize(14)
                                    color: "#333"
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            // Vertical Slider 2
                            ColumnLayout {
                                spacing: Style.resize(10)

                                Slider {
                                    id: verticalSlider2
                                    from: 0
                                    to: 100
                                    value: 60
                                    orientation: Qt.Vertical
                                    Layout.preferredWidth: Style.resize(40)
                                    Layout.preferredHeight: Style.resize(150)
                                }

                                Label {
                                    text: verticalSlider2.value.toFixed(0)
                                    font.pixelSize: Style.resize(14)
                                    color: "#333"
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            // Vertical Slider 3
                            ColumnLayout {
                                spacing: Style.resize(10)

                                Slider {
                                    id: verticalSlider3
                                    from: 0
                                    to: 100
                                    value: 90
                                    orientation: Qt.Vertical
                                    Layout.preferredWidth: Style.resize(40)
                                    Layout.preferredHeight: Style.resize(150)
                                }

                                Label {
                                    text: verticalSlider3.value.toFixed(0)
                                    font.pixelSize: Style.resize(14)
                                    color: "#333"
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            Label {
                                text: "Vertical sliders can be created using orientation: Qt.Vertical"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                // Interactive Demo - Component Reusability
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(320)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(20)

                        Label {
                            text: "Interactive Demo - Reusable Components"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Control the GlowButton intensity with the slider below"
                            font.pixelSize: Style.resize(14)
                            color: "#666"
                        }

                        // Interactive GlowButton
                        GlowButton {
                            id: demoGlowButton
                            text: "Glow Button"
                            glowColor: "#00D1A8"
                            glowIntensity: glowIntensitySlider.value
                            glowRadius: glowRadiusSlider.value
                            Layout.alignment: Qt.AlignHCenter
                            width: Style.resize(180)
                            height: Style.resize(50)
                        }

                        // Glow Intensity Control
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Glow Intensity: " + glowIntensitySlider.value.toFixed(2)
                                font.pixelSize: Style.resize(14)
                                color: "#333"
                            }

                            Slider {
                                id: glowIntensitySlider
                                from: 0
                                to: 1
                                value: 0.6
                                stepSize: 0.1
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        // Glow Radius Control
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Glow Radius: " + glowRadiusSlider.value.toFixed(0)
                                font.pixelSize: Style.resize(14)
                                color: "#333"
                            }

                            Slider {
                                id: glowRadiusSlider
                                from: 5
                                to: 50
                                value: 20
                                stepSize: 5
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        Label {
                            text: "✓ This demonstrates component reusability - GlowButton from the Buttons example is used here!"
                            font.pixelSize: Style.resize(12)
                            color: Style.mainColor
                            font.bold: true
                        }
                    }
                }

                // Custom Range Slider
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(220)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Slider with Actions"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "Volume: " + volumeSlider.value.toFixed(0) + "%"
                                font.pixelSize: Style.resize(14)
                                color: "#333"
                            }

                            Slider {
                                id: volumeSlider
                                from: 0
                                to: 100
                                value: 50
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        RowLayout {
                            spacing: Style.resize(10)
                            Layout.fillWidth: true

                            GradientButton {
                                text: "Mute"
                                startColor: "#FF5900"
                                endColor: "#FF8C00"
                                width: Style.resize(100)
                                height: Style.resize(35)
                                onClicked: volumeSlider.value = 0
                            }

                            PulseButton {
                                text: "50%"
                                pulseColor: Style.mainColor
                                width: Style.resize(100)
                                height: Style.resize(35)
                                onClicked: volumeSlider.value = 50
                            }

                            GlowButton {
                                text: "Max"
                                glowColor: "#00D1A8"
                                width: Style.resize(100)
                                height: Style.resize(35)
                                onClicked: volumeSlider.value = 100
                            }
                        }

                        Label {
                            text: "Using GradientButton, PulseButton, and GlowButton - all reusable components!"
                            font.pixelSize: Style.resize(12)
                            color: "#666"
                        }
                    }
                }
            }
        }
    }
}
