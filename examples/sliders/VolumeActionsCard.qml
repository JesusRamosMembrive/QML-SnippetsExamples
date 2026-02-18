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
