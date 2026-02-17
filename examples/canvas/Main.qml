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
            }
        }
    }
}
