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
        NumberAnimation { duration: 200 }
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
                spacing: Style.resize(30)

                // Header
                Label {
                    text: "Shape Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ═════════════════════════════════════
                    // 1. Bezier Curves
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "Bezier Curves"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // PathQuad — 1 control point
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property real bSize: Math.min(width, height - Style.resize(20))

                                    Item {
                                        id: quadArea
                                        width: parent.bSize
                                        height: parent.bSize
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.top: parent.top

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.surfaceColor
                                            radius: Style.resize(6)
                                            border.color: "#3A3D45"
                                            border.width: 1
                                        }

                                        Canvas {
                                            id: quadGuides
                                            anchors.fill: parent
                                            onPaint: {
                                                var ctx = getContext("2d")
                                                ctx.reset()
                                                var pad = Style.resize(15)
                                                ctx.setLineDash([4, 4])
                                                ctx.strokeStyle = "#bbb"
                                                ctx.lineWidth = 1
                                                ctx.beginPath()
                                                ctx.moveTo(pad, quadArea.height - pad)
                                                ctx.lineTo(quadCp.x + quadCp.width/2, quadCp.y + quadCp.height/2)
                                                ctx.lineTo(quadArea.width - pad, quadArea.height - pad)
                                                ctx.stroke()
                                            }
                                        }

                                        Shape {
                                            anchors.fill: parent
                                            ShapePath {
                                                strokeWidth: Style.resize(3)
                                                strokeColor: Style.mainColor
                                                fillColor: Qt.rgba(Style.mainColor.r,
                                                                   Style.mainColor.g,
                                                                   Style.mainColor.b, 0.08)
                                                property real pad: Style.resize(15)
                                                startX: pad
                                                startY: quadArea.height - pad

                                                PathQuad {
                                                    x: quadArea.width - Style.resize(15)
                                                    y: quadArea.height - Style.resize(15)
                                                    controlX: quadCp.x + quadCp.width / 2
                                                    controlY: quadCp.y + quadCp.height / 2
                                                }
                                            }
                                        }

                                        // Endpoint dots
                                        Rectangle {
                                            x: Style.resize(15) - width/2
                                            y: quadArea.height - Style.resize(15) - height/2
                                            width: Style.resize(10); height: width; radius: width/2
                                            color: Style.mainColor; opacity: 0.5
                                        }
                                        Rectangle {
                                            x: quadArea.width - Style.resize(15) - width/2
                                            y: quadArea.height - Style.resize(15) - height/2
                                            width: Style.resize(10); height: width; radius: width/2
                                            color: Style.mainColor; opacity: 0.5
                                        }

                                        // Draggable control point
                                        Rectangle {
                                            id: quadCp
                                            x: quadArea.width / 2 - width / 2
                                            y: Style.resize(20)
                                            width: Style.resize(20); height: width
                                            radius: width / 2
                                            color: "#FF5900"
                                            border.color: "white"; border.width: 2

                                            DragHandler {
                                                xAxis.minimum: 0
                                                xAxis.maximum: quadArea.width - quadCp.width
                                                yAxis.minimum: 0
                                                yAxis.maximum: quadArea.height - quadCp.height
                                            }

                                            onXChanged: quadGuides.requestPaint()
                                            onYChanged: quadGuides.requestPaint()
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "PathQuad — drag the point"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // PathCubic — 2 control points
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property real bSize: Math.min(width, height - Style.resize(20))

                                    Item {
                                        id: cubicArea
                                        width: parent.bSize
                                        height: parent.bSize
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.top: parent.top

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.surfaceColor
                                            radius: Style.resize(6)
                                            border.color: "#3A3D45"
                                            border.width: 1
                                        }

                                        Canvas {
                                            id: cubicGuides
                                            anchors.fill: parent
                                            onPaint: {
                                                var ctx = getContext("2d")
                                                ctx.reset()
                                                var pad = Style.resize(15)
                                                ctx.setLineDash([4, 4])
                                                ctx.strokeStyle = "#bbb"
                                                ctx.lineWidth = 1
                                                // Guide line from start to cp1
                                                ctx.beginPath()
                                                ctx.moveTo(pad, cubicArea.height - pad)
                                                ctx.lineTo(cubicCp1.x + cubicCp1.width/2, cubicCp1.y + cubicCp1.height/2)
                                                ctx.stroke()
                                                // Guide line from end to cp2
                                                ctx.beginPath()
                                                ctx.moveTo(cubicArea.width - pad, cubicArea.height - pad)
                                                ctx.lineTo(cubicCp2.x + cubicCp2.width/2, cubicCp2.y + cubicCp2.height/2)
                                                ctx.stroke()
                                            }
                                        }

                                        Shape {
                                            anchors.fill: parent
                                            ShapePath {
                                                strokeWidth: Style.resize(3)
                                                strokeColor: "#7C4DFF"
                                                fillColor: Qt.rgba(0.49, 0.30, 1, 0.08)
                                                property real pad: Style.resize(15)
                                                startX: pad
                                                startY: cubicArea.height - pad

                                                PathCubic {
                                                    x: cubicArea.width - Style.resize(15)
                                                    y: cubicArea.height - Style.resize(15)
                                                    control1X: cubicCp1.x + cubicCp1.width / 2
                                                    control1Y: cubicCp1.y + cubicCp1.height / 2
                                                    control2X: cubicCp2.x + cubicCp2.width / 2
                                                    control2Y: cubicCp2.y + cubicCp2.height / 2
                                                }
                                            }
                                        }

                                        // Endpoint dots
                                        Rectangle {
                                            x: Style.resize(15) - width/2
                                            y: cubicArea.height - Style.resize(15) - height/2
                                            width: Style.resize(10); height: width; radius: width/2
                                            color: "#7C4DFF"; opacity: 0.5
                                        }
                                        Rectangle {
                                            x: cubicArea.width - Style.resize(15) - width/2
                                            y: cubicArea.height - Style.resize(15) - height/2
                                            width: Style.resize(10); height: width; radius: width/2
                                            color: "#7C4DFF"; opacity: 0.5
                                        }

                                        Rectangle {
                                            id: cubicCp1
                                            x: cubicArea.width * 0.25 - width / 2
                                            y: Style.resize(15)
                                            width: Style.resize(20); height: width
                                            radius: width / 2
                                            color: "#FF5900"
                                            border.color: "white"; border.width: 2
                                            DragHandler {
                                                xAxis.minimum: 0; xAxis.maximum: cubicArea.width - cubicCp1.width
                                                yAxis.minimum: 0; yAxis.maximum: cubicArea.height - cubicCp1.height
                                            }
                                            onXChanged: cubicGuides.requestPaint()
                                            onYChanged: cubicGuides.requestPaint()
                                        }

                                        Rectangle {
                                            id: cubicCp2
                                            x: cubicArea.width * 0.75 - width / 2
                                            y: Style.resize(15)
                                            width: Style.resize(20); height: width
                                            radius: width / 2
                                            color: "#2196F3"
                                            border.color: "white"; border.width: 2
                                            DragHandler {
                                                xAxis.minimum: 0; xAxis.maximum: cubicArea.width - cubicCp2.width
                                                yAxis.minimum: 0; yAxis.maximum: cubicArea.height - cubicCp2.height
                                            }
                                            onXChanged: cubicGuides.requestPaint()
                                            onYChanged: cubicGuides.requestPaint()
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "PathCubic — 2 control points"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }

                    // ═════════════════════════════════════
                    // 2. Arcs & Angles
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "Arcs & Angles"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Sweep angle slider
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Label {
                                    text: "Sweep: " + Math.round(sweepSlider.value) + "°"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                    Layout.preferredWidth: Style.resize(90)
                                }
                                Slider {
                                    id: sweepSlider
                                    from: 10; to: 360; value: 270
                                    Layout.fillWidth: true
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // PathAngleArc with sweep control
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        id: angleArcShape
                                        anchors.centerIn: parent
                                        width: Style.resize(180)
                                        height: Style.resize(180)

                                        ShapePath {
                                            strokeWidth: Style.resize(6)
                                            strokeColor: Style.mainColor
                                            fillColor: Qt.rgba(Style.mainColor.r,
                                                               Style.mainColor.g,
                                                               Style.mainColor.b, 0.1)
                                            startX: angleArcShape.width / 2
                                            startY: angleArcShape.height / 2

                                            PathAngleArc {
                                                centerX: angleArcShape.width / 2
                                                centerY: angleArcShape.height / 2
                                                radiusX: Style.resize(75)
                                                radiusY: Style.resize(75)
                                                startAngle: -90
                                                sweepAngle: sweepSlider.value
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "PathAngleArc"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // Various arc examples
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        id: arcVariantsShape
                                        anchors.centerIn: parent
                                        width: Style.resize(180)
                                        height: Style.resize(180)

                                        // Semicircle
                                        ShapePath {
                                            strokeWidth: Style.resize(3)
                                            strokeColor: "#FF5900"
                                            fillColor: Qt.rgba(1, 0.35, 0, 0.1)
                                            startX: Style.resize(15)
                                            startY: arcVariantsShape.height * 0.35

                                            PathArc {
                                                x: arcVariantsShape.width - Style.resize(15)
                                                y: arcVariantsShape.height * 0.35
                                                radiusX: (arcVariantsShape.width - Style.resize(30)) / 2
                                                radiusY: (arcVariantsShape.width - Style.resize(30)) / 2
                                                useLargeArc: false
                                            }
                                        }

                                        // Large arc variant
                                        ShapePath {
                                            strokeWidth: Style.resize(3)
                                            strokeColor: "#7C4DFF"
                                            fillColor: Qt.rgba(0.49, 0.30, 1, 0.1)
                                            startX: Style.resize(30)
                                            startY: arcVariantsShape.height * 0.7

                                            PathArc {
                                                x: arcVariantsShape.width - Style.resize(30)
                                                y: arcVariantsShape.height * 0.7
                                                radiusX: Style.resize(55)
                                                radiusY: Style.resize(35)
                                                useLargeArc: true
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "PathArc variants"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }

                    // ═════════════════════════════════════
                    // 3. SVG Paths
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "SVG Paths"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(20)

                                // Airplane silhouette
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(100)
                                        height: Style.resize(120)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: Style.mainColor
                                            fillColor: Qt.rgba(Style.mainColor.r,
                                                               Style.mainColor.g,
                                                               Style.mainColor.b, 0.15)
                                            // Simplified airplane top-down
                                            PathSvg {
                                                path: "M 50 0 L 55 30 L 95 50 L 95 58 L 55 48 L 55 85 L 70 95 L 70 100 L 50 95 L 30 100 L 30 95 L 45 85 L 45 48 L 5 58 L 5 50 L 45 30 Z"
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Airplane"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // Gear / cog
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(100)
                                        height: Style.resize(100)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#FF5900"
                                            fillColor: Qt.rgba(1, 0.35, 0, 0.15)
                                            PathSvg {
                                                path: "M 43 0 L 57 0 L 60 15 L 70 18 L 82 8 L 92 18 L 82 30 L 85 40 L 100 43 L 100 57 L 85 60 L 82 70 L 92 82 L 82 92 L 70 82 L 60 85 L 57 100 L 43 100 L 40 85 L 30 82 L 18 92 L 8 82 L 18 70 L 15 60 L 0 57 L 0 43 L 15 40 L 18 30 L 8 18 L 18 8 L 30 18 L 40 15 Z M 50 30 A 20 20 0 1 0 50 70 A 20 20 0 1 0 50 30 Z"
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Gear (with hole)"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // Lightning bolt
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(80)
                                        height: Style.resize(120)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#FFE361"
                                            fillColor: "#FFE361"
                                            PathSvg {
                                                path: "M 35 0 L 55 0 L 40 45 L 65 45 L 20 120 L 30 60 L 10 60 Z"
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Lightning"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }

                            Label {
                                text: "PathSvg renders standard SVG path data strings"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                            }
                        }
                    }

                    // ═════════════════════════════════════
                    // 4. Fill Rules
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "Fill Rules"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(30)

                                // OddEvenFill
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(140)
                                        height: Style.resize(140)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: Style.mainColor
                                            fillColor: Style.mainColor
                                            fillRule: ShapePath.OddEvenFill

                                            // 5-point star
                                            startX: 70; startY: 5
                                            PathLine { x: 85;  y: 55 }
                                            PathLine { x: 135; y: 55 }
                                            PathLine { x: 95;  y: 85 }
                                            PathLine { x: 110; y: 135 }
                                            PathLine { x: 70;  y: 105 }
                                            PathLine { x: 30;  y: 135 }
                                            PathLine { x: 45;  y: 85 }
                                            PathLine { x: 5;   y: 55 }
                                            PathLine { x: 55;  y: 55 }
                                            PathLine { x: 70;  y: 5 }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "OddEvenFill"
                                        font.pixelSize: Style.resize(13)
                                        font.bold: true
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: Style.resize(-15)
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Center is hollow"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // WindingFill
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(140)
                                        height: Style.resize(140)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#7C4DFF"
                                            fillColor: "#7C4DFF"
                                            fillRule: ShapePath.WindingFill

                                            // Same 5-point star
                                            startX: 70; startY: 5
                                            PathLine { x: 85;  y: 55 }
                                            PathLine { x: 135; y: 55 }
                                            PathLine { x: 95;  y: 85 }
                                            PathLine { x: 110; y: 135 }
                                            PathLine { x: 70;  y: 105 }
                                            PathLine { x: 30;  y: 135 }
                                            PathLine { x: 45;  y: 85 }
                                            PathLine { x: 5;   y: 55 }
                                            PathLine { x: 55;  y: 55 }
                                            PathLine { x: 70;  y: 5 }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "WindingFill"
                                        font.pixelSize: Style.resize(13)
                                        font.bold: true
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: Style.resize(-15)
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Fully solid"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }

                    // ═════════════════════════════════════
                    // 5. Gradient Types
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "Gradient Types"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // Linear Gradient
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(120)
                                        height: Style.resize(120)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#666666"
                                            startX: 60; startY: 0
                                            fillGradient: LinearGradient {
                                                x1: 0; y1: 0
                                                x2: 120; y2: 120
                                                GradientStop { position: 0; color: Style.mainColor }
                                                GradientStop { position: 0.5; color: "#FFE361" }
                                                GradientStop { position: 1; color: "#FF5900" }
                                            }
                                            // Hexagon
                                            PathLine { x: 105; y: 30 }
                                            PathLine { x: 105; y: 90 }
                                            PathLine { x: 60;  y: 120 }
                                            PathLine { x: 15;  y: 90 }
                                            PathLine { x: 15;  y: 30 }
                                            PathLine { x: 60;  y: 0 }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "LinearGradient"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // Radial Gradient
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(120)
                                        height: Style.resize(120)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#666666"
                                            fillGradient: RadialGradient {
                                                centerX: 60; centerY: 60
                                                centerRadius: 60
                                                focalX: 40; focalY: 40
                                                focalRadius: 0
                                                GradientStop { position: 0; color: "white" }
                                                GradientStop { position: 0.4; color: Style.mainColor }
                                                GradientStop { position: 1; color: "#1E272E" }
                                            }
                                            // Circle via arcs
                                            startX: 120; startY: 60
                                            PathArc {
                                                x: 0; y: 60
                                                radiusX: 60; radiusY: 60
                                            }
                                            PathArc {
                                                x: 120; y: 60
                                                radiusX: 60; radiusY: 60
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "RadialGradient"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                    }
                                }

                                // Conical Gradient (animated)
                                Item {
                                    id: conicalItem
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property real conicalAngle: 0
                                    NumberAnimation on conicalAngle {
                                        from: 0; to: 360; duration: 4000
                                        loops: Animation.Infinite
                                    }

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(120)
                                        height: Style.resize(120)

                                        ShapePath {
                                            strokeWidth: Style.resize(2)
                                            strokeColor: "#666666"
                                            fillGradient: ConicalGradient {
                                                centerX: 60; centerY: 60
                                                angle: conicalItem.conicalAngle
                                                GradientStop { position: 0;    color: "#FF5900" }
                                                GradientStop { position: 0.33; color: "#FFE361" }
                                                GradientStop { position: 0.66; color: Style.mainColor }
                                                GradientStop { position: 1;    color: "#FF5900" }
                                            }
                                            // Circle
                                            startX: 120; startY: 60
                                            PathArc {
                                                x: 0; y: 60
                                                radiusX: 60; radiusY: 60
                                            }
                                            PathArc {
                                                x: 120; y: 60
                                                radiusX: 60; radiusY: 60
                                            }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "ConicalGradient (animated)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }

                    // ═════════════════════════════════════
                    // 6. Animated Shapes (Morphing)
                    // ═════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                        color: Style.cardColor
                        radius: Style.resize(8)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(15)
                            spacing: Style.resize(8)

                            Label {
                                text: "Animated Shapes"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // Morphing shape
                                Item {
                                    id: morphItem
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property real morph: 0.0

                                    SequentialAnimation on morph {
                                        id: morphAnim
                                        loops: Animation.Infinite
                                        running: true
                                        NumberAnimation { from: 0; to: 1; duration: 1500; easing.type: Easing.InOutQuad }
                                        PauseAnimation { duration: 500 }
                                        NumberAnimation { from: 1; to: 2; duration: 1500; easing.type: Easing.InOutQuad }
                                        PauseAnimation { duration: 500 }
                                        NumberAnimation { from: 2; to: 0; duration: 1500; easing.type: Easing.InOutQuad }
                                        PauseAnimation { duration: 500 }
                                    }

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(160)
                                        height: Style.resize(160)

                                        ShapePath {
                                            id: morphPath
                                            strokeWidth: Style.resize(3)
                                            strokeColor: Style.mainColor
                                            fillColor: Qt.rgba(Style.mainColor.r,
                                                               Style.mainColor.g,
                                                               Style.mainColor.b, 0.2)

                                            property real m: morphItem.morph
                                            property real cx: 80
                                            property real cy: 80
                                            property real r: 65

                                            // Triangle (m=0), Square (m=1), Circle (m=2)
                                            // Interpolate via 4 cubic curves
                                            property real triTop:    cy - r
                                            property real triBot:    cy + r * 0.6
                                            property real triLeft:   cx - r * 0.85
                                            property real triRight:  cx + r * 0.85

                                            property real sqLeft:    cx - r * 0.75
                                            property real sqRight:   cx + r * 0.75
                                            property real sqTop:     cy - r * 0.75
                                            property real sqBot:     cy + r * 0.75

                                            // lerp helpers
                                            function lerp3(a, b, c, t) {
                                                if (t < 1) return a + (b - a) * t
                                                return b + (c - b) * (t - 1)
                                            }

                                            // Top point
                                            startX: lerp3(cx, sqRight, cx + r, m)
                                            startY: lerp3(triTop, sqTop, cy, m)

                                            PathCubic {
                                                // Top-right to bottom-right
                                                x: morphPath.lerp3(morphPath.triRight, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                                                y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy, morphPath.m)
                                                control1X: morphPath.lerp3(morphPath.cx + 10, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                                                control1Y: morphPath.lerp3(morphPath.triTop + 20, morphPath.sqTop, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                                                control2X: morphPath.lerp3(morphPath.triRight, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                                                control2Y: morphPath.lerp3(morphPath.triBot - 30, morphPath.sqBot - 20, morphPath.cy + morphPath.r * 0.55, morphPath.m)
                                            }

                                            PathCubic {
                                                // Bottom-right to bottom-left
                                                x: morphPath.lerp3(morphPath.triLeft, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                                                y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy, morphPath.m)
                                                control1X: morphPath.lerp3(morphPath.triRight - 10, morphPath.sqRight, morphPath.cx + morphPath.r * 0.55, morphPath.m)
                                                control1Y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy + morphPath.r, morphPath.m)
                                                control2X: morphPath.lerp3(morphPath.triLeft + 10, morphPath.sqLeft, morphPath.cx - morphPath.r * 0.55, morphPath.m)
                                                control2Y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy + morphPath.r, morphPath.m)
                                            }

                                            PathCubic {
                                                // Bottom-left to top
                                                x: morphPath.startX
                                                y: morphPath.startY
                                                control1X: morphPath.lerp3(morphPath.triLeft, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                                                control1Y: morphPath.lerp3(morphPath.triBot - 30, morphPath.sqTop + 20, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                                                control2X: morphPath.lerp3(morphPath.cx - 10, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                                                control2Y: morphPath.lerp3(morphPath.triTop + 20, morphPath.sqTop, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                                            }
                                        }
                                    }

                                    // Shape label
                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: {
                                            var m = parent.morph
                                            if (m < 0.5) return "Triangle"
                                            if (m < 1.5) return "Square"
                                            return "Circle"
                                        }
                                        font.pixelSize: Style.resize(14)
                                        font.bold: true
                                        color: Style.mainColor
                                    }
                                }

                                // Spinning / pulsing shape
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property real spin: 0
                                    NumberAnimation on spin {
                                        from: 0; to: 360; duration: 6000
                                        loops: Animation.Infinite
                                    }

                                    property real pulse: 0.8
                                    SequentialAnimation on pulse {
                                        loops: Animation.Infinite
                                        NumberAnimation { from: 0.8; to: 1.2; duration: 1000; easing.type: Easing.InOutSine }
                                        NumberAnimation { from: 1.2; to: 0.8; duration: 1000; easing.type: Easing.InOutSine }
                                    }

                                    Shape {
                                        anchors.centerIn: parent
                                        width: Style.resize(140)
                                        height: Style.resize(140)
                                        rotation: parent.spin
                                        scale: parent.pulse

                                        // 3 interleaved triangles
                                        ShapePath {
                                            strokeWidth: Style.resize(3)
                                            strokeColor: Style.mainColor
                                            fillColor: Qt.rgba(Style.mainColor.r, Style.mainColor.g, Style.mainColor.b, 0.2)
                                            startX: 70; startY: 10
                                            PathLine { x: 120; y: 110 }
                                            PathLine { x: 20;  y: 110 }
                                            PathLine { x: 70;  y: 10 }
                                        }
                                        ShapePath {
                                            strokeWidth: Style.resize(3)
                                            strokeColor: "#FF5900"
                                            fillColor: Qt.rgba(1, 0.35, 0, 0.15)
                                            startX: 70; startY: 130
                                            PathLine { x: 20;  y: 30 }
                                            PathLine { x: 120; y: 30 }
                                            PathLine { x: 70;  y: 130 }
                                        }
                                    }

                                    Label {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Rotation + Scale"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
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
