import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "5. Fractal Tree"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Angle: " + Math.round(treeAngle.value) + "\u00B0"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: treeAngle; from: 10; to: 60; value: 25; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: treeCanvas.requestPaint() }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Depth: " + Math.round(treeDepth.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: treeDepth; from: 4; to: 12; value: 9; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: treeCanvas.requestPaint() }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Wind: " + treeWind.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: treeWind; from: -20; to: 20; value: 0; stepSize: 0.5; Layout.preferredWidth: Style.resize(120); onValueChanged: treeCanvas.requestPaint() }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: treeCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)
            onAvailableChanged: if (available) requestPaint()

            function drawBranch(ctx, x, y, len, angle, depth, maxDepth) {
                if (depth > maxDepth || len < 2)
                    return

                var rad = angle * Math.PI / 180
                var x2 = x + len * Math.cos(rad)
                var y2 = y + len * Math.sin(rad)

                // Color from brown (trunk) to green (leaves)
                var t = depth / maxDepth
                var cr = Math.round(101 + (34 - 101) * t)
                var cg = Math.round(67 + (139 - 67) * t)
                var cb = Math.round(33 + (34 - 33) * t)
                ctx.strokeStyle = "rgb(" + cr + "," + cg + "," + cb + ")"
                ctx.lineWidth = Math.max(1, (maxDepth - depth) * 1.2)
                ctx.lineCap = "round"

                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x2, y2)
                ctx.stroke()

                // Leaves at tips
                if (depth >= maxDepth - 1) {
                    ctx.beginPath()
                    ctx.arc(x2, y2, 2.5 - (depth - maxDepth + 1) * 0.5, 0, 2 * Math.PI)
                    ctx.fillStyle = "rgba(34, 139, 34, 0.7)"
                    ctx.fill()
                }

                var windOffset = treeWind.value * (depth / maxDepth)
                var branchAngle = treeAngle.value
                var newLen = len * 0.72

                drawBranch(ctx, x2, y2, newLen, angle - branchAngle + windOffset, depth + 1, maxDepth)
                drawBranch(ctx, x2, y2, newLen, angle + branchAngle + windOffset, depth + 1, maxDepth)
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var startX = width / 2
                var startY = height - 10
                var trunkLen = height * 0.28

                drawBranch(ctx, startX, startY, trunkLen, -90, 0, Math.round(treeDepth.value))
            }
        }
    }
}
