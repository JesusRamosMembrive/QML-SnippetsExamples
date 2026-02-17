import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    // ── Section title ────────────────────────────────
    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Newton's Cradle"
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

    // ── Content ──────────────────────────────────────
    Item {
        id: content
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)

        property bool running: root.active && root.sectionActive
        property real time: 0
        property real energy: 0.85  // amplitude in radians
        property real damping: 0.9995
        property int ballCount: 5
        property real stringLen: 120
        property real ballRadius: 14

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Timer {
            running: content.running
            interval: 16
            repeat: true
            onTriggered: {
                content.time += 0.05
                content.energy *= content.damping
                cradleCanvas.requestPaint()
            }
        }

        Canvas {
            id: cradleCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var cx = width / 2
                var topY = Style.resize(30)
                var sLen = Style.resize(content.stringLen)
                var bRad = Style.resize(content.ballRadius)
                var spacing = bRad * 2.1
                var n = content.ballCount
                var t = content.time
                var amp = content.energy

                // Top bar
                var barLeft = cx - (n - 1) * spacing / 2 - Style.resize(20)
                var barRight = cx + (n - 1) * spacing / 2 + Style.resize(20)
                ctx.beginPath()
                ctx.moveTo(barLeft, topY)
                ctx.lineTo(barRight, topY)
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.3)
                ctx.lineWidth = Style.resize(3)
                ctx.lineCap = "round"
                ctx.stroke()

                // Pendulum cycle: left swings out, then right swings out
                var phase = Math.sin(t * 3.5)  // oscillation
                var leftAngle = phase > 0 ? amp * phase : 0
                var rightAngle = phase < 0 ? -amp * phase : 0

                for (var i = 0; i < n; i++) {
                    var anchorX = cx + (i - (n - 1) / 2) * spacing
                    var angle = 0

                    if (i === 0) angle = -leftAngle
                    else if (i === n - 1) angle = rightAngle

                    var ballX = anchorX + sLen * Math.sin(angle)
                    var ballY = topY + sLen * Math.cos(angle)

                    // String
                    ctx.beginPath()
                    ctx.moveTo(anchorX, topY)
                    ctx.lineTo(ballX, ballY)
                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.2)
                    ctx.lineWidth = Style.resize(1.5)
                    ctx.stroke()

                    // Ball shadow
                    var shadowGrad = ctx.createRadialGradient(
                        ballX, ballY, bRad * 0.3,
                        ballX, ballY, bRad * 1.5)
                    shadowGrad.addColorStop(0, Qt.rgba(0, 0, 0, 0.2))
                    shadowGrad.addColorStop(1, "transparent")
                    ctx.beginPath()
                    ctx.arc(ballX, ballY + bRad * 0.3, bRad * 1.5, 0, 2 * Math.PI)
                    ctx.fillStyle = shadowGrad
                    ctx.fill()

                    // Ball
                    var ballGrad = ctx.createRadialGradient(
                        ballX - bRad * 0.3, ballY - bRad * 0.3, bRad * 0.1,
                        ballX, ballY, bRad)
                    ballGrad.addColorStop(0, "#E0E0E0")
                    ballGrad.addColorStop(0.5, "#A0A0A0")
                    ballGrad.addColorStop(1, "#606060")
                    ctx.beginPath()
                    ctx.arc(ballX, ballY, bRad, 0, 2 * Math.PI)
                    ctx.fillStyle = ballGrad
                    ctx.fill()

                    // Highlight
                    ctx.beginPath()
                    ctx.arc(ballX - bRad * 0.25, ballY - bRad * 0.25,
                            bRad * 0.35, 0, 2 * Math.PI)
                    ctx.fillStyle = Qt.rgba(1, 1, 1, 0.4)
                    ctx.fill()
                }
            }
        }

        // Reset button
        Button {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: Style.resize(10)
            text: "Reset"
            flat: true
            font.pixelSize: Style.resize(10)
            onClicked: {
                content.energy = 0.85
                content.time = 0
            }
        }
    }
}
