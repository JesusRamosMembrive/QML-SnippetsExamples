import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "RPM Tachometer"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(30)
        Layout.alignment: Qt.AlignHCenter

        Item {
            id: rpmContainer
            Layout.preferredWidth: Style.resize(240)
            Layout.preferredHeight: Style.resize(240)

            property real rpm: rpmSlider.value
            property real maxRpm: 8000

            Canvas {
                id: rpmCanvas
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var cx = width / 2, cy = height / 2
                    var r = Math.min(cx, cy) - Style.resize(10)

                    var startAngle = (135) * Math.PI / 180
                    var endAngle = (405) * Math.PI / 180
                    var totalSweep = endAngle - startAngle

                    // Background arc
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, startAngle, endAngle, false)
                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                    ctx.lineWidth = Style.resize(14)
                    ctx.lineCap = "butt"
                    ctx.stroke()

                    // Red zone (6000-8000)
                    var redStart = startAngle + (6000 / rpmContainer.maxRpm) * totalSweep
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, redStart, endAngle, false)
                    ctx.strokeStyle = Qt.rgba(1, 0.23, 0.19, 0.3)
                    ctx.lineWidth = Style.resize(14)
                    ctx.stroke()

                    // Active arc
                    var rpmFrac = rpmContainer.rpm / rpmContainer.maxRpm
                    var rpmAngle = startAngle + rpmFrac * totalSweep
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, startAngle, rpmAngle, false)
                    ctx.strokeStyle = rpmContainer.rpm > 6000 ? "#FF3B30" : "#5B8DEF"
                    ctx.lineWidth = Style.resize(14)
                    ctx.lineCap = "butt"
                    ctx.stroke()

                    // Tick marks (0-8 for x1000)
                    for (var t = 0; t <= 8; t++) {
                        var tickAngle = startAngle + (t / 8) * totalSweep
                        var innerR = r - Style.resize(20)
                        var outerR = r - Style.resize(8)

                        ctx.beginPath()
                        ctx.moveTo(cx + outerR * Math.cos(tickAngle),
                                   cy + outerR * Math.sin(tickAngle))
                        ctx.lineTo(cx + innerR * Math.cos(tickAngle),
                                   cy + innerR * Math.sin(tickAngle))
                        ctx.strokeStyle = t >= 6 ? "#FF3B30" : Style.fontPrimaryColor
                        ctx.lineWidth = Style.resize(2)
                        ctx.stroke()

                        // Labels
                        var labelR = r - Style.resize(32)
                        ctx.font = "bold " + Style.resize(11) + "px sans-serif"
                        ctx.fillStyle = t >= 6 ? "#FF3B30" : Style.fontSecondaryColor
                        ctx.textAlign = "center"
                        ctx.textBaseline = "middle"
                        ctx.fillText(t,
                            cx + labelR * Math.cos(tickAngle),
                            cy + labelR * Math.sin(tickAngle))
                    }

                    // Needle
                    var needleAngle = startAngle + rpmFrac * totalSweep
                    var needleLen = r - Style.resize(26)
                    ctx.beginPath()
                    ctx.moveTo(cx - Style.resize(6) * Math.cos(needleAngle + Math.PI / 2),
                               cy - Style.resize(6) * Math.sin(needleAngle + Math.PI / 2))
                    ctx.lineTo(cx + needleLen * Math.cos(needleAngle),
                               cy + needleLen * Math.sin(needleAngle))
                    ctx.lineTo(cx + Style.resize(6) * Math.cos(needleAngle + Math.PI / 2),
                               cy + Style.resize(6) * Math.sin(needleAngle + Math.PI / 2))
                    ctx.closePath()
                    ctx.fillStyle = "#FF3B30"
                    ctx.fill()

                    // Center cap
                    ctx.beginPath()
                    ctx.arc(cx, cy, Style.resize(10), 0, 2 * Math.PI)
                    ctx.fillStyle = "#444"
                    ctx.fill()
                    ctx.beginPath()
                    ctx.arc(cx, cy, Style.resize(5), 0, 2 * Math.PI)
                    ctx.fillStyle = "#222"
                    ctx.fill()
                }

                Connections {
                    target: rpmContainer
                    function onRpmChanged() { rpmCanvas.requestPaint() }
                }
                Component.onCompleted: requestPaint()
            }

            // Digital readout
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(50)
                spacing: Style.resize(2)

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(rpmContainer.rpm).toString()
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: rpmContainer.rpm > 6000 ? "#FF3B30" : Style.fontPrimaryColor
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "\u00d7 1000 RPM"
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // RPM control
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: Style.resize(10)

            Label {
                text: "RPM"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: rpmSlider
                Layout.preferredWidth: Style.resize(200)
                from: 0
                to: 8000
                value: 3200
                stepSize: 100
            }

            Label {
                text: Math.round(rpmSlider.value) + " RPM"
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: rpmSlider.value > 6000 ? "#FF3B30" : "#5B8DEF"
            }

            // Gear indicator
            RowLayout {
                spacing: Style.resize(5)

                Repeater {
                    model: ["N", "1", "2", "3", "4", "5", "6"]
                    delegate: Rectangle {
                        id: gearRect
                        required property string modelData
                        required property int index

                        readonly property int gear: {
                            var r = rpmSlider.value
                            if (r < 200)  return 0  // N
                            if (r < 1500) return 1
                            if (r < 2800) return 2
                            if (r < 4200) return 3
                            if (r < 5500) return 4
                            if (r < 6800) return 5
                            return 6
                        }
                        readonly property bool active: gearRect.index === gear

                        width: Style.resize(28)
                        height: Style.resize(28)
                        radius: Style.resize(4)
                        color: active ? Style.mainColor : Qt.rgba(1, 1, 1, 0.06)

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }

                        Label {
                            anchors.centerIn: parent
                            text: gearRect.modelData
                            font.pixelSize: Style.resize(12)
                            font.bold: active
                            color: active ? "#000" : Style.fontSecondaryColor
                        }
                    }
                }
            }
        }
    }
}
