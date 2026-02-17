import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    property bool active: false
    property bool sectionActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Breathing Circles"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
            Layout.fillWidth: true
        }
        Button {
            text: root.sectionActive ? "\u25A0 Stop" : "\u25B6 Play"
            flat: true
            font.pixelSize: Style.resize(12)
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    Item {
        id: breathSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(250)

        property real time: 0
        property bool running: root.active && root.sectionActive

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Timer {
            running: breathSection.running
            interval: 30
            repeat: true
            onTriggered: {
                breathSection.time += 0.03
                breathCanvas.requestPaint()
            }
        }

        Canvas {
            id: breathCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var cx = width / 2
                var cy = height / 2
                var t = breathSection.time

                var rings = 8
                var maxR = Math.min(cx, cy) - 20

                for (var i = rings - 1; i >= 0; i--) {
                    var baseR = maxR * (i + 1) / rings
                    var pulse = Math.sin(t * 1.8 - i * 0.5) * 0.15 + 1.0
                    var r = baseR * pulse

                    var hue = (0.47 + i * 0.04) % 1
                    var alpha = 0.08 + (1 - i / rings) * 0.12
                    var lightness = 0.3 + (1 - i / rings) * 0.25

                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.fillStyle = Qt.hsla(hue, 0.6, lightness, alpha)
                    ctx.fill()

                    // Ring border
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.strokeStyle = Qt.hsla(hue, 0.7, 0.55,
                        alpha + 0.1 * Math.max(0, Math.sin(t * 1.8 - i * 0.5)))
                    ctx.lineWidth = 1.5
                    ctx.stroke()
                }

                // Center orb
                var orbPulse = Math.sin(t * 1.8) * 0.3 + 1.0
                var orbR = 12 * orbPulse
                var orbGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, orbR * 2)
                orbGrad.addColorStop(0, Qt.rgba(0, 0.82, 0.66, 0.9))
                orbGrad.addColorStop(0.5, Qt.rgba(0, 0.82, 0.66, 0.3))
                orbGrad.addColorStop(1, "transparent")
                ctx.beginPath()
                ctx.arc(cx, cy, orbR * 2, 0, 2 * Math.PI)
                ctx.fillStyle = orbGrad
                ctx.fill()

                ctx.beginPath()
                ctx.arc(cx, cy, orbR, 0, 2 * Math.PI)
                ctx.fillStyle = "#FFFFFF"
                ctx.fill()
            }
        }

        // Breathing guide text
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Style.resize(10)
            text: {
                var phase = Math.sin(breathSection.time * 1.8)
                if (phase > 0.3) return "Inhale..."
                if (phase < -0.3) return "Exhale..."
                return "Hold..."
            }
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.mainColor
            opacity: 0.7
        }
    }
}
