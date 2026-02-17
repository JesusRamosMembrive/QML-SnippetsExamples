import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
                    text: "Slider Examples"
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

                    // Basic Sliders Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: Style.cardColor
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
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Horizontal Slider: " + horizontalSlider.value.toFixed(2)
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)
                                    Layout.preferredWidth: root.width - 10

                                    Slider {
                                        id: horizontalSlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 100
                                        value: 50
                                    }
                                }
                            }

                            // Stepped Slider
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Stepped Slider (step: 10): " + steppedSlider.value.toFixed(0)
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)

                                    Slider {
                                        id: steppedSlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 100
                                        stepSize: 10
                                        value: 50
                                        snapMode: Slider.SnapAlways
                                    }
                                }
                            }

                            // Disabled Slider
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Disabled Slider"
                                    font.pixelSize: Style.resize(14)
                                    color: "#999"
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)

                                    Slider {
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 100
                                        value: 75
                                        enabled: false
                                    }
                                }
                            }
                        }
                    }

                    // Vertical Sliders Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(80)
                        color: Style.cardColor
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
                                        Layout.preferredWidth: Style.resize(60)
                                        Layout.preferredHeight: Style.resize(150)
                                    }

                                    Label {
                                        text: verticalSlider1.value.toFixed(0)
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
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
                                        Layout.preferredWidth: Style.resize(60)
                                        Layout.preferredHeight: Style.resize(150)
                                    }

                                    Label {
                                        text: verticalSlider2.value.toFixed(0)
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
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
                                        Layout.preferredWidth: Style.resize(60)
                                        Layout.preferredHeight: Style.resize(150)
                                    }

                                    Label {
                                        text: verticalSlider3.value.toFixed(0)
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                Label {
                                    text: "Vertical sliders can be created using orientation: Qt.Vertical"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    // Interactive Demo - Component Reusability
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: Style.cardColor
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
                                color: Style.fontSecondaryColor
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
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Glow Intensity: " + glowIntensitySlider.value.toFixed(2)
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)

                                    Slider {
                                        id: glowIntensitySlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 1
                                        value: 0.6
                                        stepSize: 0.1
                                    }
                                }
                            }

                            // Glow Radius Control
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Glow Radius: " + glowRadiusSlider.value.toFixed(0)
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)

                                    Slider {
                                        id: glowRadiusSlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 5
                                        to: 50
                                        value: 20
                                        stepSize: 5
                                    }
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
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(220)
                        color: Style.cardColor
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
                                Layout.maximumWidth: root.width - 10
                                spacing: Style.resize(8)

                                Label {
                                    text: "Volume: " + volumeSlider.value.toFixed(0) + "%"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(40)

                                    Slider {
                                        id: volumeSlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 100
                                        value: 50
                                    }
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
                                color: Style.fontSecondaryColor
                            }
                        }
                    }
                    // Dial Section — Styled Qt Quick Controls Dial
                    Rectangle {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "Dial — Styled Qt Controls"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(30)

                                // Temperature dial
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(8)

                                    Dial {
                                        id: tempDial
                                        Layout.preferredWidth: Style.resize(180)
                                        Layout.preferredHeight: Style.resize(180)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 16
                                        to: 32
                                        value: 22
                                        stepSize: 0.5
                                        valueDecimals: 1
                                        suffix: "°C"
                                        progressColor: {
                                            var ratio = tempDial.position
                                            if (ratio < 0.35) return "#4FC3F7"
                                            if (ratio < 0.65) return Style.mainColor
                                            return "#FF7043"
                                        }
                                    }

                                    Label {
                                        text: "Temperature"
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Volume dial
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(8)

                                    Dial {
                                        Layout.preferredWidth: Style.resize(180)
                                        Layout.preferredHeight: Style.resize(180)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 100
                                        value: 65
                                        stepSize: 1
                                        suffix: "%"
                                        progressColor: "#7C4DFF"
                                        trackWidth: Style.resize(12)
                                    }

                                    Label {
                                        text: "Volume"
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Speed dial (no ticks, thin)
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(8)

                                    Dial {
                                        Layout.preferredWidth: Style.resize(180)
                                        Layout.preferredHeight: Style.resize(180)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 200
                                        value: 80
                                        stepSize: 5
                                        suffix: "km/h"
                                        showTicks: false
                                        trackWidth: Style.resize(6)
                                        progressColor: "#FF5900"
                                    }

                                    Label {
                                        text: "Speed"
                                        font.pixelSize: Style.resize(14)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Info column
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: Style.resize(10)

                                    Label {
                                        text: "Custom Properties"
                                        font.pixelSize: Style.resize(16)
                                        font.bold: true
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        text: "• progressColor — arc color\n• trackWidth — arc thickness\n• showTicks / tickCount\n• suffix — unit label\n• valueDecimals — precision\n• showValue — center display"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        lineHeight: 1.4
                                    }

                                    Label {
                                        text: "Native Dial interaction:\ndrag, mouse wheel, arrow keys"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        color: Style.mainColor
                                    }
                                }
                            }
                        }
                    }
                } // End of GridLayout
            }
        }
    }
}
