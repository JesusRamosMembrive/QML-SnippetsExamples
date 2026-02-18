import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    id: root
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
