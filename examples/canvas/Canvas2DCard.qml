import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Canvas 2D"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Canvas area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            Canvas {
                id: primitiveCanvas
                anchors.fill: parent
                anchors.margins: Style.resize(4)

                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height

                    ctx.clearRect(0, 0, w, h)

                    // 1. Gradient rectangle
                    var grad = ctx.createLinearGradient(10, 10, 140, 70)
                    grad.addColorStop(0, "#00D1A9")
                    grad.addColorStop(1, "#4A90D9")
                    ctx.fillStyle = grad
                    ctx.beginPath()
                    ctx.roundedRect(10, 10, 130, 60, 8, 8)
                    ctx.fill()

                    // 2. Stroked circle
                    ctx.beginPath()
                    ctx.arc(200, 40, 28, 0, 2 * Math.PI)
                    ctx.fillStyle = "#FEA60140"
                    ctx.fill()
                    ctx.strokeStyle = "#FEA601"
                    ctx.lineWidth = 3
                    ctx.stroke()

                    // 3. Filled circle
                    ctx.beginPath()
                    ctx.arc(270, 40, 20, 0, 2 * Math.PI)
                    ctx.fillStyle = "#FF5900"
                    ctx.fill()

                    // 4. Lines
                    ctx.strokeStyle = "#9B59B6"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(10, 90)
                    ctx.lineTo(60, 120)
                    ctx.lineTo(110, 85)
                    ctx.lineTo(160, 130)
                    ctx.stroke()

                    // 5. Dashed rectangle
                    ctx.strokeStyle = "#E74C3C"
                    ctx.lineWidth = 2
                    ctx.setLineDash([6, 4])
                    ctx.strokeRect(180, 80, 80, 55)
                    ctx.setLineDash([])

                    // 6. Text with shadow
                    ctx.shadowColor = "#00D1A9"
                    ctx.shadowBlur = 8
                    ctx.shadowOffsetX = 2
                    ctx.shadowOffsetY = 2
                    ctx.font = "bold 22px sans-serif"
                    ctx.fillStyle = "#E0E0E0"
                    ctx.fillText("Canvas!", 10, 170)
                    ctx.shadowBlur = 0
                    ctx.shadowOffsetX = 0
                    ctx.shadowOffsetY = 0

                    // 7. Bezier curve
                    ctx.strokeStyle = "#00D1A9"
                    ctx.lineWidth = 3
                    ctx.beginPath()
                    ctx.moveTo(150, 160)
                    ctx.bezierCurveTo(180, 110, 240, 200, 290, 150)
                    ctx.stroke()
                }
            }
        }

        Label {
            text: "Imperative drawing with context2D: gradients, arcs, text, bezier curves"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
