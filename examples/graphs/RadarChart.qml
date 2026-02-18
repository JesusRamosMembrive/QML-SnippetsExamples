import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "2. Radar Chart"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "Randomize"
            onClicked: {
                var p = [], e = []
                for (var i = 0; i < 5; i++) {
                    p.push(Math.round(Math.random() * 40 + 60))
                    e.push(Math.round(Math.random() * 50 + 30))
                }
                radarCanvas.playerStats = p
                radarCanvas.enemyStats = e
                radarCanvas.requestPaint()
            }
        }
    }

    // Legend
    RowLayout {
        spacing: Style.resize(15)
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00D1A9"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Player"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
        Row { spacing: Style.resize(4); Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#FF5900"; anchors.verticalCenter: parent.verticalCenter } Label { text: "Enemy"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor } }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: radarCanvas
            onAvailableChanged: if (available) requestPaint()
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(270))
            height: width

            property var playerStats: [85, 70, 60, 90, 55]
            property var enemyStats: [60, 80, 75, 45, 70]
            property var labels: ["ATK", "DEF", "SPD", "HP", "MP"]

            function drawDataset(ctx, cx, cy, r, data, strokeColor, fillColor) {
                ctx.beginPath()
                for (var i = 0; i < data.length; i++) {
                    var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                    var val = data[i] / 100 * r
                    var px = cx + val * Math.cos(angle)
                    var py = cy + val * Math.sin(angle)
                    if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                }
                ctx.closePath()
                ctx.fillStyle = fillColor
                ctx.fill()
                ctx.strokeStyle = strokeColor
                ctx.lineWidth = 2
                ctx.stroke()

                // Data point dots
                for (var i = 0; i < data.length; i++) {
                    var angle = i * 2 * Math.PI / data.length - Math.PI / 2
                    var val = data[i] / 100 * r
                    ctx.beginPath()
                    ctx.arc(cx + val * Math.cos(angle), cy + val * Math.sin(angle), 3, 0, 2 * Math.PI)
                    ctx.fillStyle = strokeColor
                    ctx.fill()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var r = Math.min(cx, cy) - 30
                var N = 5

                // Grid pentagons
                for (var ring = 1; ring <= 5; ring++) {
                    var rr = r * ring / 5
                    ctx.beginPath()
                    for (var i = 0; i < N; i++) {
                        var angle = i * 2 * Math.PI / N - Math.PI / 2
                        var px = cx + rr * Math.cos(angle)
                        var py = cy + rr * Math.sin(angle)
                        if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                    }
                    ctx.closePath()
                    ctx.strokeStyle = ring === 5 ? "#444" : "#2A2D35"
                    ctx.lineWidth = ring === 5 ? 1.5 : 0.5
                    ctx.stroke()
                }

                // Spokes
                for (var i = 0; i < N; i++) {
                    var angle = i * 2 * Math.PI / N - Math.PI / 2
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + r * Math.cos(angle), cy + r * Math.sin(angle))
                    ctx.strokeStyle = "#2A2D35"
                    ctx.lineWidth = 0.5
                    ctx.stroke()
                }

                // Datasets
                drawDataset(ctx, cx, cy, r, enemyStats, "#FF5900", "rgba(255,89,0,0.15)")
                drawDataset(ctx, cx, cy, r, playerStats, "#00D1A9", "rgba(0,209,169,0.2)")

                // Axis labels
                ctx.font = "bold 12px sans-serif"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                for (var i = 0; i < N; i++) {
                    var angle = i * 2 * Math.PI / N - Math.PI / 2
                    var lx = cx + (r + 18) * Math.cos(angle)
                    var ly = cy + (r + 18) * Math.sin(angle)
                    ctx.fillStyle = "#888"
                    ctx.fillText(labels[i], lx, ly)
                }
            }
        }
    }
}
