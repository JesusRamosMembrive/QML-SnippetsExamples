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
            text: "Lissajous Curve Tracer"
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
        Layout.preferredHeight: Style.resize(300)

        property real time: 0
        property bool running: root.active && root.sectionActive
        property int freqA: lissASlider.value
        property int freqB: lissBSlider.value
        property real phase: lissPhaseSlider.value
        property var trail: []
        property int maxTrail: 500

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
                content.time += 0.025
                var t = content.time
                var cx = lissajousCanvas.width / 2
                var cy = lissajousCanvas.height / 2
                var rx = cx - 30
                var ry = cy - 30
                var x = cx + rx * Math.sin(content.freqA * t + content.phase)
                var y = cy + ry * Math.sin(content.freqB * t)
                var tr = content.trail
                tr.push({ x: x, y: y })
                if (tr.length > content.maxTrail)
                    tr.splice(0, tr.length - content.maxTrail)
                content.trail = tr
                lissajousCanvas.requestPaint()
            }
        }

        Canvas {
            id: lissajousCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var tr = content.trail
                if (tr.length < 2) return

                for (var i = 1; i < tr.length; i++) {
                    var frac = i / tr.length
                    ctx.beginPath()
                    ctx.moveTo(tr[i-1].x, tr[i-1].y)
                    ctx.lineTo(tr[i].x, tr[i].y)

                    var hue = (frac * 0.3 + 0.47) % 1
                    ctx.strokeStyle = Qt.hsla(hue, 0.75, 0.55, frac * 0.9)
                    ctx.lineWidth = 1 + frac * 2.5
                    ctx.lineCap = "round"
                    ctx.stroke()
                }

                // Head dot
                var last = tr[tr.length - 1]
                ctx.beginPath()
                ctx.arc(last.x, last.y, 5, 0, 2 * Math.PI)
                ctx.fillStyle = "#FFFFFF"
                ctx.fill()

                // Glow
                var glow = ctx.createRadialGradient(last.x, last.y, 0, last.x, last.y, 15)
                glow.addColorStop(0, Qt.rgba(0, 0.82, 0.66, 0.5))
                glow.addColorStop(1, "transparent")
                ctx.beginPath()
                ctx.arc(last.x, last.y, 15, 0, 2 * Math.PI)
                ctx.fillStyle = glow
                ctx.fill()
            }
        }

        // Controls
        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Style.resize(10)
            spacing: Style.resize(12)

            Column {
                spacing: Style.resize(2)
                Label {
                    text: "A: " + lissASlider.value
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
                Slider {
                    id: lissASlider
                    width: Style.resize(80)
                    from: 1; to: 7; value: 3; stepSize: 1
                }
            }

            Column {
                spacing: Style.resize(2)
                Label {
                    text: "B: " + lissBSlider.value
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
                Slider {
                    id: lissBSlider
                    width: Style.resize(80)
                    from: 1; to: 7; value: 2; stepSize: 1
                }
            }

            Column {
                spacing: Style.resize(2)
                Label {
                    text: "\u03C6: " + lissPhaseSlider.value.toFixed(1)
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
                Slider {
                    id: lissPhaseSlider
                    width: Style.resize(80)
                    from: 0; to: 3.14; value: 1.57; stepSize: 0.1
                }
            }

            Button {
                text: "Clear"
                flat: true
                font.pixelSize: Style.resize(10)
                onClicked: {
                    content.trail = []
                    content.time = 0
                }
            }
        }
    }
}
