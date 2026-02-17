import QtQuick
import Qt5Compat.GraphicalEffects

import utils

Item {
    id: root

    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 0

    property color trackColor: Qt.rgba(0.66, 0.66, 0.66, 0.3)
    property color progressColor: Style.mainColor
    property color handleColor: "white"
    property color textColor: Style.fontPrimaryColor

    property real trackWidth: Style.resize(10)
    property real handleRadius: Style.resize(14)
    property bool showValue: true
    property string suffix: ""
    property int decimals: 0
    property bool showTicks: true
    property int tickCount: 10

    signal moved()

    // Internal geometry
    readonly property real _startAngle: 135 * Math.PI / 180
    readonly property real _sweepAngle: 270 * Math.PI / 180
    readonly property real _endAngle: _startAngle + _sweepAngle
    readonly property real _centerX: width / 2
    readonly property real _centerY: height / 2
    readonly property real _radius: Math.min(width, height) / 2 - handleRadius - Style.resize(4)
    readonly property real _valueRatio: (to > from) ? (value - from) / (to - from) : 0
    readonly property real _valueAngle: _startAngle + _valueRatio * _sweepAngle

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(200)

    // Glow behind progress arc
    Canvas {
        id: glowCanvas
        anchors.fill: parent
        visible: root._valueRatio > 0.01

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            if (root._valueRatio <= 0.01)
                return

            ctx.beginPath()
            ctx.arc(root._centerX, root._centerY, root._radius,
                    root._startAngle, root._valueAngle, false)
            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = root.trackWidth + Style.resize(6)
            ctx.lineCap = "round"
            ctx.globalAlpha = 0.25
            ctx.stroke()
        }
    }

    // Main canvas: track, progress, ticks, handle
    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var cx = root._centerX
            var cy = root._centerY
            var r  = root._radius

            // -- Tick marks --
            if (root.showTicks) {
                for (var i = 0; i <= root.tickCount; i++) {
                    var tickAngle = root._startAngle + (i / root.tickCount) * root._sweepAngle
                    var major = (i % 5 === 0)
                    var innerR = r - root.trackWidth / 2 - Style.resize(major ? 14 : 8)
                    var outerR = r - root.trackWidth / 2 - Style.resize(2)

                    ctx.beginPath()
                    ctx.moveTo(cx + innerR * Math.cos(tickAngle),
                               cy + innerR * Math.sin(tickAngle))
                    ctx.lineTo(cx + outerR * Math.cos(tickAngle),
                               cy + outerR * Math.sin(tickAngle))
                    ctx.strokeStyle = Qt.rgba(0, 0, 0, major ? 0.3 : 0.12)
                    ctx.lineWidth = major ? Style.resize(2) : 1
                    ctx.stroke()
                }
            }

            // -- Background track --
            ctx.beginPath()
            ctx.arc(cx, cy, r, root._startAngle, root._endAngle, false)
            ctx.strokeStyle = root.trackColor
            ctx.lineWidth = root.trackWidth
            ctx.lineCap = "round"
            ctx.stroke()

            // -- Progress arc --
            if (root._valueRatio > 0.005) {
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._startAngle, root._valueAngle, false)
                ctx.strokeStyle = root.progressColor
                ctx.lineWidth = root.trackWidth
                ctx.lineCap = "round"
                ctx.stroke()
            }

            // -- Handle --
            var hx = cx + r * Math.cos(root._valueAngle)
            var hy = cy + r * Math.sin(root._valueAngle)

            // shadow
            ctx.beginPath()
            ctx.arc(hx, hy + Style.resize(2), root.handleRadius, 0, 2 * Math.PI)
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.2)
            ctx.fill()

            // body
            ctx.beginPath()
            ctx.arc(hx, hy, root.handleRadius, 0, 2 * Math.PI)
            ctx.fillStyle = root.handleColor
            ctx.fill()
            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = Style.resize(3)
            ctx.stroke()

            // inner dot
            ctx.beginPath()
            ctx.arc(hx, hy, Style.resize(4), 0, 2 * Math.PI)
            ctx.fillStyle = root.progressColor
            ctx.fill()
        }
    }

    // Center value display
    Column {
        visible: root.showValue
        anchors.centerIn: parent
        spacing: Style.resize(2)

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.value.toFixed(root.decimals)
            font.pixelSize: root._radius * 0.38
            font.bold: true
            font.family: Style.fontFamilyBold
            color: root.textColor
        }

        Text {
            visible: root.suffix !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.suffix
            font.pixelSize: root._radius * 0.15
            font.family: Style.fontFamilyRegular
            color: Style.inactiveColor
        }
    }

    // Mouse / drag interaction
    MouseArea {
        anchors.fill: parent

        function angleToValue(mx, my) {
            var dx = mx - root._centerX
            var dy = my - root._centerY
            var angle = Math.atan2(dy, dx)
            if (angle < 0) angle += 2 * Math.PI

            var deg = angle * 180 / Math.PI

            // Dead zone: 45° – 135° (gap at bottom of arc)
            if (deg > 45 && deg < 135) {
                angle = (deg < 90)
                        ? (root._endAngle - 2 * Math.PI)   // snap to max
                        : root._startAngle                  // snap to min
            }

            var rel = angle - root._startAngle
            if (rel < 0) rel += 2 * Math.PI

            var ratio = Math.max(0, Math.min(1, rel / root._sweepAngle))
            var v = root.from + ratio * (root.to - root.from)

            if (root.stepSize > 0)
                v = Math.round(v / root.stepSize) * root.stepSize

            root.value = Math.max(root.from, Math.min(root.to, v))
            root.moved()
        }

        onPressed: function(mouse) { angleToValue(mouse.x, mouse.y) }
        onPositionChanged: function(mouse) {
            if (pressed) angleToValue(mouse.x, mouse.y)
        }
    }

    // Repaint triggers
    onValueChanged:         { canvas.requestPaint(); glowCanvas.requestPaint() }
    on_ValueRatioChanged:   { canvas.requestPaint(); glowCanvas.requestPaint() }
    onWidthChanged:         { canvas.requestPaint(); glowCanvas.requestPaint() }
    onHeightChanged:        { canvas.requestPaint(); glowCanvas.requestPaint() }
    onTrackColorChanged:    { canvas.requestPaint(); glowCanvas.requestPaint() }
    onProgressColorChanged: { canvas.requestPaint(); glowCanvas.requestPaint() }
    Component.onCompleted:  { canvas.requestPaint(); glowCanvas.requestPaint() }
}
