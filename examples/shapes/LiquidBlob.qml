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
            text: "6. Liquid Blob"
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
        Layout.preferredHeight: Style.resize(280)
        color: "#0A0A14"
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: blobCanvas
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(270))
            height: width

            property real time: 0

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.sectionActive
                onTriggered: {
                    blobCanvas.time += 0.04
                    blobCanvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var baseR = Math.min(cx, cy) * 0.55
                var points = 120

                // Main blob
                ctx.beginPath()
                for (var i = 0; i <= points; i++) {
                    var theta = i / points * 2 * Math.PI
                    var r = baseR
                        + baseR * 0.15 * Math.sin(3 * theta + time * 1.2)
                        + baseR * 0.10 * Math.sin(5 * theta - time * 0.8)
                        + baseR * 0.08 * Math.sin(7 * theta + time * 1.5)
                        + baseR * 0.12 * Math.sin(2 * theta - time * 0.6)
                    var bx = cx + r * Math.cos(theta)
                    var by = cy + r * Math.sin(theta)
                    if (i === 0) ctx.moveTo(bx, by)
                    else ctx.lineTo(bx, by)
                }
                ctx.closePath()

                // Gradient fill
                var grad = ctx.createRadialGradient(cx - baseR * 0.3, cy - baseR * 0.3, 0, cx, cy, baseR * 1.4)
                grad.addColorStop(0, "rgba(0,209,169,0.6)")
                grad.addColorStop(0.5, "rgba(74,144,217,0.4)")
                grad.addColorStop(1, "rgba(155,89,182,0.2)")
                ctx.fillStyle = grad
                ctx.fill()
                ctx.strokeStyle = "#00D1A9"
                ctx.lineWidth = 2
                ctx.stroke()

                // Inner highlight blob (smaller, offset, brighter)
                ctx.beginPath()
                var innerR = baseR * 0.4
                for (var j = 0; j <= points; j++) {
                    var t2 = j / points * 2 * Math.PI
                    var r2 = innerR
                        + innerR * 0.2 * Math.sin(4 * t2 - time * 1.4)
                        + innerR * 0.15 * Math.sin(6 * t2 + time * 0.9)
                    var ix = cx - baseR * 0.12 + r2 * Math.cos(t2)
                    var iy = cy - baseR * 0.12 + r2 * Math.sin(t2)
                    if (j === 0) ctx.moveTo(ix, iy)
                    else ctx.lineTo(ix, iy)
                }
                ctx.closePath()
                ctx.fillStyle = "rgba(0,209,169,0.15)"
                ctx.fill()

                // Specular highlight
                ctx.beginPath()
                ctx.arc(cx - baseR * 0.25, cy - baseR * 0.25, baseR * 0.12, 0, 2 * Math.PI)
                ctx.fillStyle = "rgba(255,255,255,0.15)"
                ctx.fill()
            }
        }
    }
}
