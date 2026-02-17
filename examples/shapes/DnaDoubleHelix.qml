import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool sectionActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "3. DNA Double Helix"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.sectionActive ? "Pause" : "Start"
            onClicked: root.sectionActive = !root.sectionActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: "#0A0E14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: dnaCanvas
            anchors.fill: parent
            anchors.margins: Style.resize(4)

            property real phase: 0
            property var basePairColors: ["#E74C3C", "#4A90D9", "#27AE60", "#FEA601"]

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.sectionActive
                onTriggered: {
                    dnaCanvas.phase += 0.06
                    dnaCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cy = h / 2
                var amp = h * 0.35
                var freq = 0.035
                var pairSpacing = 22

                // Draw base pairs first (behind strands)
                for (var px = 0; px < w; px += pairSpacing) {
                    var py1 = cy + amp * Math.sin(freq * px + phase)
                    var py2 = cy - amp * Math.sin(freq * px + phase)
                    var colorIdx = Math.floor(px / pairSpacing) % 4
                    ctx.beginPath()
                    ctx.moveTo(px, py1)
                    ctx.lineTo(px, py2)
                    ctx.strokeStyle = basePairColors[colorIdx]
                    ctx.lineWidth = 2.5
                    ctx.stroke()

                    // Base pair dots
                    ctx.beginPath()
                    ctx.arc(px, (py1 + py2) / 2 - 3, 3, 0, 2 * Math.PI)
                    ctx.fillStyle = basePairColors[colorIdx]
                    ctx.fill()
                    ctx.beginPath()
                    ctx.arc(px, (py1 + py2) / 2 + 3, 3, 0, 2 * Math.PI)
                    ctx.fillStyle = basePairColors[(colorIdx + 2) % 4]
                    ctx.fill()
                }

                // Strand 1
                ctx.beginPath()
                for (var x1 = 0; x1 < w; x1 += 2) {
                    var y1 = cy + amp * Math.sin(freq * x1 + phase)
                    if (x1 === 0) ctx.moveTo(x1, y1)
                    else ctx.lineTo(x1, y1)
                }
                ctx.strokeStyle = "#00D1A9"
                ctx.lineWidth = 3
                ctx.stroke()

                // Strand 2
                ctx.beginPath()
                for (var x2 = 0; x2 < w; x2 += 2) {
                    var y2 = cy - amp * Math.sin(freq * x2 + phase)
                    if (x2 === 0) ctx.moveTo(x2, y2)
                    else ctx.lineTo(x2, y2)
                }
                ctx.strokeStyle = "#FF5900"
                ctx.lineWidth = 3
                ctx.stroke()

                // Labels
                ctx.font = "bold 10px monospace"
                ctx.textAlign = "left"
                ctx.fillStyle = "#555"
                ctx.fillText("5'", 5, cy + amp + 15)
                ctx.fillText("3'", w - 18, cy + amp + 15)
                ctx.fillText("3'", 5, cy - amp - 8)
                ctx.fillText("5'", w - 18, cy - amp - 8)
            }
        }
    }
}
