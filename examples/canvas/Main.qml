import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Canvas & Shapes Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: Canvas 2D
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
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

                    // ========================================
                    // Card 2: Shape & Paths
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Shape & Paths"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Shapes area
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(6)
                                clip: true

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(10)

                                    // Triangle
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(4)

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            Shape {
                                                anchors.centerIn: parent
                                                width: Style.resize(80)
                                                height: Style.resize(80)

                                                ShapePath {
                                                    strokeWidth: 2
                                                    strokeColor: "#4A90D9"
                                                    fillColor: "#4A90D930"
                                                    startX: 40; startY: 5

                                                    PathLine { x: 75; y: 70 }
                                                    PathLine { x: 5; y: 70 }
                                                    PathLine { x: 40; y: 5 }
                                                }
                                            }
                                        }

                                        Label {
                                            text: "Triangle"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }

                                    // Star
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(4)

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            Shape {
                                                id: starShape
                                                anchors.centerIn: parent
                                                width: Style.resize(80)
                                                height: Style.resize(80)

                                                ShapePath {
                                                    strokeWidth: 2
                                                    strokeColor: "#FEA601"
                                                    fillColor: "#FEA60130"
                                                    // 5-pointed star
                                                    startX: 40; startY: 2

                                                    PathLine { x: 49; y: 28 }
                                                    PathLine { x: 77; y: 28 }
                                                    PathLine { x: 54; y: 46 }
                                                    PathLine { x: 63; y: 74 }
                                                    PathLine { x: 40; y: 56 }
                                                    PathLine { x: 17; y: 74 }
                                                    PathLine { x: 26; y: 46 }
                                                    PathLine { x: 3; y: 28 }
                                                    PathLine { x: 31; y: 28 }
                                                    PathLine { x: 40; y: 2 }
                                                }
                                            }
                                        }

                                        Label {
                                            text: "Star"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }

                                    // Rounded shape with arcs
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(4)

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            Shape {
                                                anchors.centerIn: parent
                                                width: Style.resize(80)
                                                height: Style.resize(60)

                                                ShapePath {
                                                    strokeWidth: 2
                                                    strokeColor: "#00D1A9"
                                                    fillColor: "#00D1A930"

                                                    startX: 10; startY: 0

                                                    PathLine { x: 70; y: 0 }
                                                    PathArc { x: 80; y: 10; radiusX: 10; radiusY: 10 }
                                                    PathLine { x: 80; y: 50 }
                                                    PathArc { x: 70; y: 60; radiusX: 10; radiusY: 10 }
                                                    PathLine { x: 10; y: 60 }
                                                    PathArc { x: 0; y: 50; radiusX: 10; radiusY: 10 }
                                                    PathLine { x: 0; y: 10 }
                                                    PathArc { x: 10; y: 0; radiusX: 10; radiusY: 10 }
                                                }
                                            }
                                        }

                                        Label {
                                            text: "Rounded Rect"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }

                                    // Heart shape
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(4)

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            Shape {
                                                anchors.centerIn: parent
                                                width: Style.resize(70)
                                                height: Style.resize(70)

                                                ShapePath {
                                                    strokeWidth: 2
                                                    strokeColor: "#E74C3C"
                                                    fillColor: "#E74C3C30"

                                                    startX: 35; startY: 60

                                                    PathQuad { x: 0; y: 25; controlX: 0; controlY: 60 }
                                                    PathQuad { x: 35; y: 15; controlX: 0; controlY: 0 }
                                                    PathQuad { x: 70; y: 25; controlX: 70; controlY: 0 }
                                                    PathQuad { x: 35; y: 60; controlX: 70; controlY: 60 }
                                                }
                                            }
                                        }

                                        Label {
                                            text: "Heart"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "Declarative Shape with PathLine, PathArc, and PathQuad elements"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Gradients & Arcs
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Gradients & Pie Chart"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(10)

                                // Linear gradient shape
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Style.resize(4)

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(80)

                                        Shape {
                                            anchors.centerIn: parent
                                            width: Style.resize(100)
                                            height: Style.resize(70)

                                            ShapePath {
                                                strokeWidth: 1
                                                strokeColor: "#3A3D45"
                                                startX: 0; startY: 0
                                                PathLine { x: 100; y: 0 }
                                                PathLine { x: 100; y: 70 }
                                                PathLine { x: 0; y: 70 }
                                                PathLine { x: 0; y: 0 }

                                                fillGradient: LinearGradient {
                                                    x1: 0; y1: 0
                                                    x2: 100; y2: 70
                                                    GradientStop { position: 0; color: "#00D1A9" }
                                                    GradientStop { position: 0.5; color: "#4A90D9" }
                                                    GradientStop { position: 1; color: "#9B59B6" }
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Linear Gradient"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Radial gradient shape (circle via PathArc)
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Style.resize(4)

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(80)

                                        Shape {
                                            anchors.centerIn: parent
                                            width: Style.resize(70)
                                            height: Style.resize(70)

                                            ShapePath {
                                                strokeWidth: 0
                                                strokeColor: "transparent"
                                                startX: 35; startY: 0

                                                PathArc {
                                                    x: 35; y: 70
                                                    radiusX: 35; radiusY: 35
                                                    useLargeArc: true
                                                }
                                                PathArc {
                                                    x: 35; y: 0
                                                    radiusX: 35; radiusY: 35
                                                    useLargeArc: true
                                                }

                                                fillGradient: RadialGradient {
                                                    centerX: 35; centerY: 35
                                                    centerRadius: 35
                                                    focalX: 25; focalY: 25
                                                    focalRadius: 0
                                                    GradientStop { position: 0; color: "#FFFFFF" }
                                                    GradientStop { position: 0.5; color: "#FEA601" }
                                                    GradientStop { position: 1; color: "#FF5900" }
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Radial Gradient"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            // Pie chart
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Canvas {
                                    id: pieCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width, Style.resize(200))
                                    height: width

                                    property var slices: [
                                        { value: 35, color: "#00D1A9", label: "QML 35%" },
                                        { value: 25, color: "#4A90D9", label: "C++ 25%" },
                                        { value: 20, color: "#FEA601", label: "JS 20%" },
                                        { value: 15, color: "#9B59B6", label: "Python 15%" },
                                        { value: 5, color: "#E74C3C", label: "Other 5%" }
                                    ]

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var cx = width / 2
                                        var cy = height / 2
                                        var r = Math.min(cx, cy) - 10
                                        var startAngle = -Math.PI / 2
                                        var total = 0

                                        for (var i = 0; i < slices.length; i++)
                                            total += slices[i].value

                                        ctx.clearRect(0, 0, width, height)

                                        for (var j = 0; j < slices.length; j++) {
                                            var sliceAngle = (slices[j].value / total) * 2 * Math.PI
                                            ctx.beginPath()
                                            ctx.moveTo(cx, cy)
                                            ctx.arc(cx, cy, r, startAngle, startAngle + sliceAngle)
                                            ctx.closePath()
                                            ctx.fillStyle = slices[j].color
                                            ctx.fill()
                                            ctx.strokeStyle = Style.cardColor
                                            ctx.lineWidth = 2
                                            ctx.stroke()
                                            startAngle += sliceAngle
                                        }
                                    }
                                }

                                // Legend
                                Column {
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: Style.resize(4)

                                    Repeater {
                                        model: pieCanvas.slices.length
                                        Row {
                                            spacing: Style.resize(4)
                                            Rectangle {
                                                width: Style.resize(10)
                                                height: Style.resize(10)
                                                radius: Style.resize(2)
                                                color: pieCanvas.slices[index].color
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Label {
                                                text: pieCanvas.slices[index].label
                                                font.pixelSize: Style.resize(10)
                                                color: Style.fontSecondaryColor
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "Shape gradients (Linear, Radial) and Canvas pie chart with arcs"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Drawing Pad
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Drawing Pad"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Controls
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                // Color buttons
                                Repeater {
                                    model: ["#FFFFFF", "#00D1A9", "#4A90D9", "#E74C3C", "#FEA601"]

                                    Rectangle {
                                        width: Style.resize(24)
                                        height: Style.resize(24)
                                        radius: width / 2
                                        color: modelData
                                        border.width: drawCanvas.strokeColor === modelData ? 3 : 1
                                        border.color: drawCanvas.strokeColor === modelData ? Style.fontPrimaryColor : "#3A3D45"

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: drawCanvas.strokeColor = modelData
                                        }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                Label {
                                    text: "Size:"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }

                                Item {
                                    Layout.preferredWidth: Style.resize(80)
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: brushSlider
                                        anchors.fill: parent
                                        from: 1
                                        to: 12
                                        value: 3
                                        stepSize: 1
                                    }
                                }

                                Button {
                                    text: "Clear"
                                    onClicked: {
                                        drawCanvas.paths = []
                                        drawCanvas.requestPaint()
                                    }
                                }
                            }

                            // Drawing canvas
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                border.color: Style.inactiveColor
                                border.width: 1
                                clip: true

                                Canvas {
                                    id: drawCanvas
                                    anchors.fill: parent
                                    anchors.margins: 1

                                    property var paths: []
                                    property string strokeColor: "#FFFFFF"
                                    property bool isDrawing: false

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.lineCap = "round"
                                        ctx.lineJoin = "round"

                                        for (var i = 0; i < paths.length; i++) {
                                            var p = paths[i]
                                            if (p.points.length < 2)
                                                continue

                                            ctx.beginPath()
                                            ctx.strokeStyle = p.color
                                            ctx.lineWidth = p.size
                                            ctx.moveTo(p.points[0].x, p.points[0].y)

                                            for (var j = 1; j < p.points.length; j++) {
                                                ctx.lineTo(p.points[j].x, p.points[j].y)
                                            }
                                            ctx.stroke()
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        onPressed: function(mouse) {
                                            var newPath = {
                                                color: drawCanvas.strokeColor,
                                                size: brushSlider.value,
                                                points: [Qt.point(mouse.x, mouse.y)]
                                            }
                                            var p = drawCanvas.paths
                                            p.push(newPath)
                                            drawCanvas.paths = p
                                            drawCanvas.isDrawing = true
                                        }

                                        onPositionChanged: function(mouse) {
                                            if (!drawCanvas.isDrawing)
                                                return
                                            var p = drawCanvas.paths
                                            var current = p[p.length - 1]
                                            current.points.push(Qt.point(mouse.x, mouse.y))
                                            drawCanvas.paths = p
                                            drawCanvas.requestPaint()
                                        }

                                        onReleased: {
                                            drawCanvas.isDrawing = false
                                        }
                                    }
                                }

                                // Hint text
                                Label {
                                    anchors.centerIn: parent
                                    text: "Draw here!"
                                    font.pixelSize: Style.resize(16)
                                    color: Style.inactiveColor
                                    opacity: 0.4
                                    visible: drawCanvas.paths.length === 0
                                }
                            }

                            Label {
                                text: "Interactive canvas: pick color, adjust brush size, draw with mouse"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout

                // ========================================
                // Card 5: Custom Canvas Creations
                // ========================================
                Rectangle {
                    id: card5Canvas
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    property bool clockActive: false
                    property bool vizActive: false
                    property bool radarActive: false
                    property bool kaleidoActive: false

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Canvas Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced Canvas techniques: real-time rendering, mathematical curves, simulations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // --- Section 1: Analog Clock ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "1. Analog Clock"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Canvas.clockActive ? "Pause" : "Start"
                                    onClicked: card5Canvas.clockActive = !card5Canvas.clockActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(260)
                                color: Style.surfaceColor
                                radius: Style.resize(6)

                                Canvas {
                                    id: clockCanvas
                                    anchors.centerIn: parent
                                    width: Style.resize(240)
                                    height: Style.resize(240)

                                    property real hours: 0
                                    property real minutes: 0
                                    property real seconds: 0

                                    Timer {
                                        interval: 1000
                                        repeat: true
                                        running: root.fullSize && card5Canvas.clockActive
                                        triggeredOnStart: true
                                        onTriggered: {
                                            var now = new Date()
                                            clockCanvas.hours = now.getHours() % 12
                                            clockCanvas.minutes = now.getMinutes()
                                            clockCanvas.seconds = now.getSeconds()
                                            clockCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var cx = width / 2
                                        var cy = height / 2
                                        var r = Math.min(cx, cy) - 8

                                        ctx.clearRect(0, 0, width, height)

                                        // Face background
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#1E2128"
                                        ctx.fill()
                                        ctx.strokeStyle = "#00D1A9"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // Inner ring
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r - 8, 0, 2 * Math.PI)
                                        ctx.strokeStyle = "#2A2D35"
                                        ctx.lineWidth = 1
                                        ctx.stroke()

                                        // Tick marks
                                        for (var i = 0; i < 60; i++) {
                                            var tickAngle = (i * 6 - 90) * Math.PI / 180
                                            var isHour = (i % 5 === 0)
                                            var outerR = r - 10
                                            var innerR = isHour ? r - 28 : r - 18
                                            ctx.beginPath()
                                            ctx.moveTo(cx + innerR * Math.cos(tickAngle), cy + innerR * Math.sin(tickAngle))
                                            ctx.lineTo(cx + outerR * Math.cos(tickAngle), cy + outerR * Math.sin(tickAngle))
                                            ctx.strokeStyle = isHour ? "#E0E0E0" : "#555555"
                                            ctx.lineWidth = isHour ? 3 : 1
                                            ctx.stroke()
                                        }

                                        // Hour numbers
                                        ctx.font = "bold " + Math.round(r * 0.16) + "px sans-serif"
                                        ctx.fillStyle = "#E0E0E0"
                                        ctx.textAlign = "center"
                                        ctx.textBaseline = "middle"
                                        for (var h = 1; h <= 12; h++) {
                                            var hAngle = (h * 30 - 90) * Math.PI / 180
                                            var hR = r - 42
                                            ctx.fillText(h.toString(), cx + hR * Math.cos(hAngle), cy + hR * Math.sin(hAngle))
                                        }

                                        // Hour hand
                                        var hourAngle = ((hours + minutes / 60) * 30 - 90) * Math.PI / 180
                                        ctx.lineCap = "round"
                                        ctx.beginPath()
                                        ctx.moveTo(cx - 8 * Math.cos(hourAngle), cy - 8 * Math.sin(hourAngle))
                                        ctx.lineTo(cx + (r * 0.5) * Math.cos(hourAngle), cy + (r * 0.5) * Math.sin(hourAngle))
                                        ctx.strokeStyle = "#E0E0E0"
                                        ctx.lineWidth = 5
                                        ctx.stroke()

                                        // Minute hand
                                        var minAngle = ((minutes + seconds / 60) * 6 - 90) * Math.PI / 180
                                        ctx.beginPath()
                                        ctx.moveTo(cx - 8 * Math.cos(minAngle), cy - 8 * Math.sin(minAngle))
                                        ctx.lineTo(cx + (r * 0.7) * Math.cos(minAngle), cy + (r * 0.7) * Math.sin(minAngle))
                                        ctx.strokeStyle = "#C0C0C0"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // Second hand
                                        var secAngle = (seconds * 6 - 90) * Math.PI / 180
                                        ctx.beginPath()
                                        ctx.moveTo(cx - 15 * Math.cos(secAngle), cy - 15 * Math.sin(secAngle))
                                        ctx.lineTo(cx + (r * 0.8) * Math.cos(secAngle), cy + (r * 0.8) * Math.sin(secAngle))
                                        ctx.strokeStyle = "#E74C3C"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()

                                        // Center dot
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, 5, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#E74C3C"
                                        ctx.fill()

                                        // Digital time readout
                                        var hStr = hours < 10 ? "0" + Math.floor(hours) : Math.floor(hours).toString()
                                        var mStr = minutes < 10 ? "0" + Math.floor(minutes) : Math.floor(minutes).toString()
                                        var sStr = seconds < 10 ? "0" + Math.floor(seconds) : Math.floor(seconds).toString()
                                        ctx.font = Math.round(r * 0.1) + "px monospace"
                                        ctx.fillStyle = "#00D1A9"
                                        ctx.textAlign = "center"
                                        ctx.textBaseline = "middle"
                                        ctx.fillText(hStr + ":" + mStr + ":" + sStr, cx, cy + r * 0.32)
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 2: Spirograph Generator ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "2. Spirograph Generator"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "R (outer): " + Math.round(spiroR.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: spiroR; from: 40; to: 100; value: 75; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
                                }
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "r (inner): " + Math.round(spiroInner.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: spiroInner; from: 5; to: 60; value: 28; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
                                }
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "d (pen): " + Math.round(spiroPen.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: spiroPen; from: 5; to: 80; value: 55; stepSize: 1; Layout.preferredWidth: Style.resize(120); onValueChanged: spiroCanvas.requestPaint() }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(280)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: spiroCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width
                                        var h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var R = spiroR.value
                                        var ri = spiroInner.value
                                        var d = spiroPen.value
                                        var centerX = w / 2
                                        var centerY = h / 2
                                        var scale = Math.min(w, h) / (2 * (R + d + 10))

                                        var steps = 2000
                                        var maxT = 2 * Math.PI * 20

                                        ctx.beginPath()
                                        for (var i = 0; i <= steps; i++) {
                                            var t = (i / steps) * maxT
                                            var x = (R - ri) * Math.cos(t) + d * Math.cos((R - ri) / ri * t)
                                            var y = (R - ri) * Math.sin(t) - d * Math.sin((R - ri) / ri * t)

                                            var px = centerX + x * scale
                                            var py = centerY + y * scale

                                            if (i === 0)
                                                ctx.moveTo(px, py)
                                            else
                                                ctx.lineTo(px, py)
                                        }

                                        var grad = ctx.createLinearGradient(0, 0, w, h)
                                        grad.addColorStop(0, "#00D1A9")
                                        grad.addColorStop(0.33, "#4A90D9")
                                        grad.addColorStop(0.66, "#9B59B6")
                                        grad.addColorStop(1, "#E74C3C")
                                        ctx.strokeStyle = grad
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 3: Audio Visualizer ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "3. Audio Visualizer"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Canvas.vizActive ? "Pause" : "Start"
                                    onClicked: card5Canvas.vizActive = !card5Canvas.vizActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(200)
                                color: "#0A0A14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: vizCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property var levels: []
                                    property var targets: []
                                    property var peaks: []
                                    property int barCount: 32

                                    Component.onCompleted: {
                                        var l = [], t = [], p = []
                                        for (var i = 0; i < barCount; i++) {
                                            l.push(0); t.push(0); p.push(0)
                                        }
                                        levels = l; targets = t; peaks = p
                                    }

                                    Timer {
                                        interval: 60
                                        repeat: true
                                        running: root.fullSize && card5Canvas.vizActive
                                        onTriggered: {
                                            var l = vizCanvas.levels.slice()
                                            var t = vizCanvas.targets.slice()
                                            var p = vizCanvas.peaks.slice()

                                            for (var i = 0; i < vizCanvas.barCount; i++) {
                                                if (Math.random() < 0.15)
                                                    t[i] = Math.random() * 0.3 + 0.05
                                                else if (Math.random() < 0.08)
                                                    t[i] = Math.random() * 0.9 + 0.1

                                                l[i] += (t[i] - l[i]) * 0.2
                                                if (l[i] > p[i]) p[i] = l[i]
                                                else p[i] = Math.max(0, p[i] - 0.008)
                                                t[i] *= 0.95
                                            }

                                            vizCanvas.levels = l
                                            vizCanvas.targets = t
                                            vizCanvas.peaks = p
                                            vizCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width
                                        var h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var barW = (w - (barCount + 1) * 2) / barCount
                                        var gap = 2

                                        for (var i = 0; i < barCount; i++) {
                                            var barH = levels[i] * h * 0.9
                                            var x = gap + i * (barW + gap)
                                            var y = h - barH

                                            var grad = ctx.createLinearGradient(x, h, x, 0)
                                            grad.addColorStop(0, "#00D1A9")
                                            grad.addColorStop(0.5, "#FEA601")
                                            grad.addColorStop(1, "#E74C3C")
                                            ctx.fillStyle = grad
                                            ctx.fillRect(x, y, barW, barH)

                                            // Peak indicator
                                            var peakY = h - peaks[i] * h * 0.9
                                            ctx.fillStyle = "#FFFFFF"
                                            ctx.fillRect(x, peakY - 2, barW, 2)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 4: Radar Sweep ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "4. Radar Sweep"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Canvas.radarActive ? "Pause" : "Start"
                                    onClicked: card5Canvas.radarActive = !card5Canvas.radarActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(300)
                                color: "#0A0F0A"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: radarCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - Style.resize(20), Style.resize(280))
                                    height: width

                                    property real sweepAngle: 0
                                    property var blips: []

                                    Timer {
                                        interval: 40
                                        repeat: true
                                        running: root.fullSize && card5Canvas.radarActive
                                        onTriggered: {
                                            radarCanvas.sweepAngle = (radarCanvas.sweepAngle + 2) % 360

                                            // Spawn new blips randomly
                                            if (Math.random() < 0.03) {
                                                var b = radarCanvas.blips.slice()
                                                var dist = 0.2 + Math.random() * 0.7
                                                var ang = Math.random() * 360
                                                b.push({ angle: ang, dist: dist, life: 1.0 })
                                                radarCanvas.blips = b
                                            }

                                            // Decay blips
                                            var alive = []
                                            for (var i = 0; i < radarCanvas.blips.length; i++) {
                                                var bl = radarCanvas.blips[i]
                                                bl.life -= 0.005
                                                if (bl.life > 0)
                                                    alive.push(bl)
                                            }
                                            radarCanvas.blips = alive
                                            radarCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width
                                        var h = height
                                        var cx = w / 2
                                        var cy = h / 2
                                        var r = Math.min(cx, cy) - 4

                                        ctx.clearRect(0, 0, w, h)

                                        // Background circle
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#0A1A0A"
                                        ctx.fill()
                                        ctx.strokeStyle = "#00AA00"
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        // Range rings
                                        ctx.strokeStyle = "#004400"
                                        ctx.lineWidth = 0.5
                                        for (var ring = 1; ring <= 4; ring++) {
                                            ctx.beginPath()
                                            ctx.arc(cx, cy, r * ring / 4, 0, 2 * Math.PI)
                                            ctx.stroke()
                                        }

                                        // Crosshairs
                                        ctx.beginPath()
                                        ctx.moveTo(cx - r, cy)
                                        ctx.lineTo(cx + r, cy)
                                        ctx.moveTo(cx, cy - r)
                                        ctx.lineTo(cx, cy + r)
                                        ctx.stroke()

                                        // Sweep beam with gradient trail
                                        var sweepRad = (sweepAngle - 90) * Math.PI / 180
                                        for (var s = 0; s < 30; s++) {
                                            var trailAngle = sweepRad - s * Math.PI / 180 * 1.5
                                            var alpha = (1 - s / 30) * 0.3
                                            ctx.beginPath()
                                            ctx.moveTo(cx, cy)
                                            ctx.lineTo(cx + r * Math.cos(trailAngle), cy + r * Math.sin(trailAngle))
                                            ctx.strokeStyle = "rgba(0, 255, 0, " + alpha + ")"
                                            ctx.lineWidth = 2
                                            ctx.stroke()
                                        }

                                        // Main sweep line
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy)
                                        ctx.lineTo(cx + r * Math.cos(sweepRad), cy + r * Math.sin(sweepRad))
                                        ctx.strokeStyle = "#00FF00"
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        // Blips
                                        for (var b = 0; b < blips.length; b++) {
                                            var blip = blips[b]
                                            var bRad = (blip.angle - 90) * Math.PI / 180
                                            var bx = cx + blip.dist * r * Math.cos(bRad)
                                            var by = cy + blip.dist * r * Math.sin(bRad)
                                            var bAlpha = blip.life

                                            ctx.beginPath()
                                            ctx.arc(bx, by, 3, 0, 2 * Math.PI)
                                            ctx.fillStyle = "rgba(0, 255, 0, " + bAlpha + ")"
                                            ctx.fill()

                                            // Glow
                                            ctx.beginPath()
                                            ctx.arc(bx, by, 6, 0, 2 * Math.PI)
                                            ctx.fillStyle = "rgba(0, 255, 0, " + (bAlpha * 0.3) + ")"
                                            ctx.fill()
                                        }

                                        // Center dot
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, 3, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#00FF00"
                                        ctx.fill()

                                        // Range labels
                                        ctx.font = Math.round(r * 0.08) + "px monospace"
                                        ctx.fillStyle = "#006600"
                                        ctx.textAlign = "left"
                                        ctx.textBaseline = "bottom"
                                        for (var rl = 1; rl <= 4; rl++) {
                                            ctx.fillText(rl * 25 + "nm", cx + r * rl / 4 + 3, cy - 3)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 5: Fractal Tree ---
                        ColumnLayout {
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

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 6: Kaleidoscope ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "6. Kaleidoscope"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Canvas.kaleidoActive ? "Pause" : "Start"
                                    onClicked: card5Canvas.kaleidoActive = !card5Canvas.kaleidoActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(300)
                                color: "#0A0A14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: kaleidoCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - Style.resize(20), Style.resize(280))
                                    height: width

                                    property real time: 0
                                    property int segments: 8

                                    Timer {
                                        interval: 50
                                        repeat: true
                                        running: root.fullSize && card5Canvas.kaleidoActive
                                        onTriggered: {
                                            kaleidoCanvas.time += 0.03
                                            kaleidoCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width
                                        var h = height
                                        var cx = w / 2
                                        var cy = h / 2
                                        var r = Math.min(cx, cy) - 4

                                        ctx.clearRect(0, 0, w, h)

                                        // Clip to circle
                                        ctx.save()
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.clip()

                                        ctx.fillStyle = "#0A0A14"
                                        ctx.fillRect(0, 0, w, h)

                                        var segAngle = 2 * Math.PI / segments

                                        for (var seg = 0; seg < segments; seg++) {
                                            ctx.save()
                                            ctx.translate(cx, cy)
                                            ctx.rotate(seg * segAngle)
                                            if (seg % 2 === 1)
                                                ctx.scale(1, -1)

                                            var numShapes = 6
                                            for (var i = 0; i < numShapes; i++) {
                                                var phase = time + i * 0.8
                                                var dist = 20 + 40 * Math.sin(phase * 0.7) + i * 15
                                                var sx = dist * Math.cos(phase * 0.3 + i)
                                                var sy = dist * Math.sin(phase * 0.5 + i) * 0.4
                                                var size = 4 + 6 * Math.sin(phase * 1.2)

                                                // Smooth color cycling via sine waves
                                                var ct = time * 0.5 + i * 0.4 + seg * 0.3
                                                var cr = Math.round(127 + 128 * Math.sin(ct))
                                                var cg = Math.round(127 + 128 * Math.sin(ct + 2.1))
                                                var cb = Math.round(127 + 128 * Math.sin(ct + 4.2))

                                                ctx.beginPath()
                                                ctx.arc(sx, sy, Math.abs(size), 0, 2 * Math.PI)
                                                ctx.fillStyle = "rgb(" + cr + "," + cg + "," + cb + ")"
                                                ctx.fill()

                                                // Connecting lines between dots
                                                if (i > 0) {
                                                    var prevPhase = time + (i - 1) * 0.8
                                                    var prevDist = 20 + 40 * Math.sin(prevPhase * 0.7) + (i - 1) * 15
                                                    var prevSx = prevDist * Math.cos(prevPhase * 0.3 + (i - 1))
                                                    var prevSy = prevDist * Math.sin(prevPhase * 0.5 + (i - 1)) * 0.4

                                                    ctx.beginPath()
                                                    ctx.moveTo(prevSx, prevSy)
                                                    ctx.lineTo(sx, sy)
                                                    ctx.strokeStyle = "rgba(" + cr + "," + cg + "," + cb + ", 0.3)"
                                                    ctx.lineWidth = 1
                                                    ctx.stroke()
                                                }
                                            }

                                            ctx.restore()
                                        }

                                        ctx.restore()

                                        // Border ring
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.strokeStyle = "#333355"
                                        ctx.lineWidth = 2
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
