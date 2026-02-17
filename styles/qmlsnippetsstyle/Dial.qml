import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Dial {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(200)

    inputMode: T.Dial.Circular

    // Customizable per-instance
    property color progressColor: Style.mainColor
    property color trackColor: Qt.rgba(0.66, 0.66, 0.66, 0.3)
    property real trackWidth: Style.resize(10)
    property bool showTicks: true
    property int tickCount: 10
    property bool showValue: true
    property string suffix: ""
    property int valueDecimals: 0

    // Arc geometry — Dial default sweep is -140° to 140° (relative to 12 o'clock)
    // Canvas coords: 0 rad = 3 o'clock, clockwise
    // Convert: canvasDeg = dialDeg + 90  →  start = -140+90=−50 → +360=310° → but easier:
    //   Dial -140° (from 12 o'clock CW) = 12 o'clock − 140° CCW = 220° from 3 o'clock = ~130°
    //   Dial  140° (from 12 o'clock CW) = 12 o'clock + 140° CW  = 230° from east...
    // Simplification: start=130°, sweep=280°, end=410°=50°
    readonly property real _arcStart:  130 * Math.PI / 180
    readonly property real _arcSweep:  280 * Math.PI / 180
    readonly property real _arcEnd:    _arcStart + _arcSweep
    readonly property real _dialSize:  Math.min(width, height)
    readonly property real _arcRadius: _dialSize / 2 - _dialSize * 0.09
    readonly property real _progressAngle: _arcStart + root.position * _arcSweep

    background: Item {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight

        Canvas {
            id: dialCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.clearRect(0, 0, width, height)

                var cx = width / 2
                var cy = height / 2
                var r  = root._arcRadius

                // -- Glow behind progress --
                if (root.position > 0.01) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, root._arcStart, root._progressAngle, false)
                    ctx.strokeStyle = root.progressColor
                    ctx.lineWidth = root.trackWidth + root._dialSize * 0.03
                    ctx.lineCap = "round"
                    ctx.globalAlpha = 0.2
                    ctx.stroke()
                    ctx.globalAlpha = 1.0
                }

                // -- Tick marks --
                if (root.showTicks) {
                    var s = root._dialSize
                    for (var i = 0; i <= root.tickCount; i++) {
                        var ta  = root._arcStart + (i / root.tickCount) * root._arcSweep
                        var maj = (i % 5 === 0)
                        var ri  = r - root.trackWidth / 2 - s * (maj ? 0.07 : 0.04)
                        var ro  = r - root.trackWidth / 2 - s * 0.01

                        ctx.beginPath()
                        ctx.moveTo(cx + ri * Math.cos(ta), cy + ri * Math.sin(ta))
                        ctx.lineTo(cx + ro * Math.cos(ta), cy + ro * Math.sin(ta))
                        ctx.strokeStyle = Qt.rgba(1, 1, 1, maj ? 0.3 : 0.12)
                        ctx.lineWidth = maj ? Math.max(1.5, s * 0.01) : 1
                        ctx.stroke()
                    }
                }

                // -- Background track --
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._arcStart, root._arcEnd, false)
                ctx.strokeStyle = root.trackColor
                ctx.lineWidth = root.trackWidth
                ctx.lineCap = "round"
                ctx.stroke()

                // -- Progress arc --
                if (root.position > 0.005) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, root._arcStart, root._progressAngle, false)
                    ctx.strokeStyle = root.progressColor
                    ctx.lineWidth = root.trackWidth
                    ctx.lineCap = "round"
                    ctx.stroke()
                }
            }
        }

        // Center value display
        Column {
            visible: root.showValue
            anchors.centerIn: parent
            spacing: Style.resize(2)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.value.toFixed(root.valueDecimals)
                font.pixelSize: root._arcRadius * 0.38
                font.bold: true
                font.family: Style.fontFamilyBold
                color: Style.fontPrimaryColor
            }

            Text {
                visible: root.suffix !== ""
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.suffix
                font.pixelSize: root._arcRadius * 0.15
                font.family: Style.fontFamilyRegular
                color: Style.inactiveColor
            }
        }
    }

    handle: Item {
        id: handleItem
        width: root._dialSize * 0.14
        height: width

        x: root.background.x + root.background.width / 2 - width / 2
           + root._arcRadius * Math.cos(root._progressAngle)
        y: root.background.y + root.background.height / 2 - height / 2
           + root._arcRadius * Math.sin(root._progressAngle)

        // Shadow
        Rectangle {
            width: parent.width
            height: width
            radius: width / 2
            y: root._dialSize * 0.01
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        // Body
        Rectangle {
            id: handleBody
            width: parent.width
            height: width
            radius: width / 2
            color: Style.cardColor
            border.color: root.progressColor
            border.width: Math.max(2, root._dialSize * 0.015)
            scale: root.pressed ? 1.15 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }

            // Inner dot
            Rectangle {
                width: root._dialSize * 0.04
                height: width
                radius: width / 2
                color: root.progressColor
                anchors.centerIn: parent
            }
        }
    }

    // Repaint on value/state/size changes
    onPositionChanged:     dialCanvas.requestPaint()
    onPressedChanged:      dialCanvas.requestPaint()
    onProgressColorChanged: dialCanvas.requestPaint()
    onTrackColorChanged:   dialCanvas.requestPaint()
    onWidthChanged:        dialCanvas.requestPaint()
    onHeightChanged:       dialCanvas.requestPaint()
    Component.onCompleted: dialCanvas.requestPaint()
}
