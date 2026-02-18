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
            text: "4. Donut Chart"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "Randomize"
            onClicked: {
                var s = donutCanvas.segments
                for (var i = 0; i < s.length; i++)
                    s[i].value = Math.round(Math.random() * 40 + 5)
                donutCanvas.segments = s
                donutCanvas.requestPaint()
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(250)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: donutCanvas
            onAvailableChanged: if (available) requestPaint()
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(240))
            height: width

            property var segments: [
                { value: 35, color: "#00D1A9", label: "QML" },
                { value: 25, color: "#4A90D9", label: "C++" },
                { value: 20, color: "#FEA601", label: "Python" },
                { value: 12, color: "#9B59B6", label: "JS" },
                { value: 8, color: "#E74C3C", label: "Other" }
            ]

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var outerR = Math.min(cx, cy) - 8
                var innerR = outerR * 0.55
                var total = 0
                for (var i = 0; i < segments.length; i++) total += segments[i].value

                var startAngle = -Math.PI / 2
                for (var i = 0; i < segments.length; i++) {
                    var sweep = segments[i].value / total * 2 * Math.PI
                    ctx.beginPath()
                    ctx.arc(cx, cy, outerR, startAngle, startAngle + sweep)
                    ctx.arc(cx, cy, innerR, startAngle + sweep, startAngle, true)
                    ctx.closePath()
                    ctx.fillStyle = segments[i].color
                    ctx.fill()

                    // Segment border
                    ctx.strokeStyle = Style.surfaceColor
                    ctx.lineWidth = 2
                    ctx.stroke()

                    // Label line
                    var midAngle = startAngle + sweep / 2
                    var labelR = outerR + 12
                    var lx = cx + labelR * Math.cos(midAngle)
                    var ly = cy + labelR * Math.sin(midAngle)
                    ctx.font = "10px sans-serif"
                    ctx.textAlign = midAngle > Math.PI / 2 || midAngle < -Math.PI / 2 ? "right" : "left"
                    ctx.textBaseline = "middle"
                    ctx.fillStyle = segments[i].color
                    ctx.fillText(segments[i].label + " " + Math.round(segments[i].value / total * 100) + "%", lx, ly)

                    startAngle += sweep
                }

                // Center text
                ctx.font = "bold 22px sans-serif"
                ctx.fillStyle = "#E0E0E0"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(total.toString(), cx, cy - 6)
                ctx.font = "10px sans-serif"
                ctx.fillStyle = "#888"
                ctx.fillText("TOTAL", cx, cy + 12)
            }
        }
    }
}
