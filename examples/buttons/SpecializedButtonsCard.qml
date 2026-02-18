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
        spacing: Style.resize(15)

        Label {
            text: "Specialized Button Components"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Flow {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            GlowButton {
                text: "Glow Effect"
                glowColor: "#00D1A8"
                width: Style.resize(150)
                height: Style.resize(40)
            }

            GradientButton {
                text: "Gradient"
                startColor: "#FF5900"
                endColor: "#FFE361"
                width: Style.resize(150)
                height: Style.resize(40)
            }

            PulseButton {
                text: "Pulse Animation"
                pulseColor: Style.mainColor
                width: Style.resize(150)
                height: Style.resize(40)
            }

            NeumorphicButton {
                text: "Neumorphic"
                baseColor: Style.bgColor
                width: Style.resize(150)
                height: Style.resize(40)
            }
        }

        Label {
            text: "These specialized components are reusable across all examples"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
