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

                // ========================================
                // Card 7: Custom Shape Creations
                // ========================================
                Rectangle {
                    id: card7Shapes
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3000)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    property bool gearsActive: false
                    property bool dnaActive: false
                    property bool scopeActive: false
                    property bool blobActive: false

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Shape Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: gear systems, mathematical curves, scientific visualizations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // --- Section 1: Gear Train ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "1. Gear Train"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card7Shapes.gearsActive ? "Pause" : "Start"
                                    onClicked: card7Shapes.gearsActive = !card7Shapes.gearsActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(250)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: gearCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property real gearAngle: 0

                                    Timer {
                                        interval: 40
                                        repeat: true
                                        running: root.fullSize && card7Shapes.gearsActive
                                        onTriggered: {
                                            gearCanvas.gearAngle = (gearCanvas.gearAngle + 1.5) % 360
                                            gearCanvas.requestPaint()
                                        }
                                    }

                                    function drawGear(ctx, gx, gy, pitchR, teeth, angleDeg, fillCol, strokeCol) {
                                        var toothH = pitchR * 0.18
                                        var outerR = pitchR + toothH
                                        var innerR = pitchR - toothH
                                        ctx.save()
                                        ctx.translate(gx, gy)
                                        ctx.rotate(angleDeg * Math.PI / 180)

                                        ctx.beginPath()
                                        for (var i = 0; i < teeth; i++) {
                                            var a = i * 2 * Math.PI / teeth
                                            var hw = Math.PI / teeth * 0.65
                                            var a0 = a - hw, a1 = a - hw * 0.45
                                            var a2 = a + hw * 0.45, a3 = a + hw
                                            if (i === 0) ctx.moveTo(innerR * Math.cos(a0), innerR * Math.sin(a0))
                                            else ctx.lineTo(innerR * Math.cos(a0), innerR * Math.sin(a0))
                                            ctx.lineTo(outerR * Math.cos(a1), outerR * Math.sin(a1))
                                            ctx.lineTo(outerR * Math.cos(a2), outerR * Math.sin(a2))
                                            ctx.lineTo(innerR * Math.cos(a3), innerR * Math.sin(a3))
                                        }
                                        ctx.closePath()
                                        ctx.fillStyle = fillCol
                                        ctx.fill()
                                        ctx.strokeStyle = strokeCol
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()

                                        // Hub
                                        ctx.beginPath()
                                        ctx.arc(0, 0, pitchR * 0.22, 0, 2 * Math.PI)
                                        ctx.fillStyle = Style.surfaceColor
                                        ctx.fill()
                                        ctx.strokeStyle = strokeCol
                                        ctx.stroke()

                                        // Spokes
                                        ctx.beginPath()
                                        for (var s = 0; s < 4; s++) {
                                            var sa = s * Math.PI / 2
                                            ctx.moveTo(pitchR * 0.22 * Math.cos(sa), pitchR * 0.22 * Math.sin(sa))
                                            ctx.lineTo(innerR * 0.78 * Math.cos(sa), innerR * 0.78 * Math.sin(sa))
                                        }
                                        ctx.lineWidth = 2
                                        ctx.stroke()
                                        ctx.restore()
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        var cy = height / 2
                                        var r1 = height * 0.3, teeth1 = 16
                                        var r2 = r1 * 10 / 16, teeth2 = 10
                                        var r3 = r1 * 8 / 16, teeth3 = 8

                                        var x1 = width / 2 - r2 - r3
                                        var x2 = x1 + r1 + r2
                                        var x3 = x2 + r2 + r3

                                        var a1 = gearAngle
                                        var a2 = -gearAngle * teeth1 / teeth2 + 180 / teeth2
                                        var a3 = gearAngle * teeth1 / teeth3 + 180 / teeth3

                                        drawGear(ctx, x1, cy, r1, teeth1, a1, "rgba(0,209,169,0.2)", "#00D1A9")
                                        drawGear(ctx, x2, cy, r2, teeth2, a2, "rgba(255,89,0,0.2)", "#FF5900")
                                        drawGear(ctx, x3, cy, r3, teeth3, a3, "rgba(74,144,217,0.2)", "#4A90D9")
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 2: Rose Curve ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "2. Rose Curve (Rhodonea)"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)
                                Label { text: "Petals (k): " + Math.round(roseK.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                Slider { id: roseK; from: 2; to: 12; value: 5; stepSize: 1; Layout.preferredWidth: Style.resize(200); onValueChanged: roseCanvas.requestPaint() }
                                Item { Layout.fillWidth: true }
                                Label {
                                    text: {
                                        var k = Math.round(roseK.value)
                                        return (k % 2 === 0 ? (2*k) : k) + " petals"
                                    }
                                    font.pixelSize: Style.resize(11)
                                    color: Style.mainColor
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(260)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: roseCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cx = w / 2, cy = h / 2
                                        var maxR = Math.min(cx, cy) - 10
                                        var k = Math.round(roseK.value)
                                        var steps = 1000

                                        ctx.beginPath()
                                        for (var i = 0; i <= steps; i++) {
                                            var t = i / steps * 2 * Math.PI
                                            var r = maxR * Math.cos(k * t)
                                            var x = cx + r * Math.cos(t)
                                            var y = cy + r * Math.sin(t)
                                            if (i === 0) ctx.moveTo(x, y)
                                            else ctx.lineTo(x, y)
                                        }

                                        var grad = ctx.createLinearGradient(0, 0, w, h)
                                        grad.addColorStop(0, "#00D1A9")
                                        grad.addColorStop(0.5, "#9B59B6")
                                        grad.addColorStop(1, "#E74C3C")
                                        ctx.strokeStyle = grad
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        // Fill with semi-transparent
                                        ctx.fillStyle = "rgba(0,209,169,0.06)"
                                        ctx.fill()
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 3: DNA Double Helix ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "3. DNA Double Helix"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card7Shapes.dnaActive ? "Pause" : "Start"
                                    onClicked: card7Shapes.dnaActive = !card7Shapes.dnaActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(200)
                                color: "#0A0E14"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: dnaCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property real phase: 0
                                    property var basePairColors: ["#E74C3C", "#4A90D9", "#27AE60", "#FEA601"]

                                    Timer {
                                        interval: 40
                                        repeat: true
                                        running: root.fullSize && card7Shapes.dnaActive
                                        onTriggered: {
                                            dnaCanvas.phase += 0.06
                                            dnaCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cy = h / 2
                                        var amp = h * 0.35
                                        var freq = 0.035
                                        var pairSpacing = 22

                                        // Draw base pairs first (behind strands)
                                        for (var px = 0; px < w; px += pairSpacing) {
                                            var py1 = cy + amp * Math.sin(freq * px + phase)
                                            var py2 = cy - amp * Math.sin(freq * px + phase)
                                            var colorIdx = Math.floor(px / pairSpacing) % 4
                                            ctx.beginPath()
                                            ctx.moveTo(px, py1)
                                            ctx.lineTo(px, py2)
                                            ctx.strokeStyle = basePairColors[colorIdx]
                                            ctx.lineWidth = 2.5
                                            ctx.stroke()

                                            // Base pair dots
                                            ctx.beginPath()
                                            ctx.arc(px, (py1 + py2) / 2 - 3, 3, 0, 2 * Math.PI)
                                            ctx.fillStyle = basePairColors[colorIdx]
                                            ctx.fill()
                                            ctx.beginPath()
                                            ctx.arc(px, (py1 + py2) / 2 + 3, 3, 0, 2 * Math.PI)
                                            ctx.fillStyle = basePairColors[(colorIdx + 2) % 4]
                                            ctx.fill()
                                        }

                                        // Strand 1
                                        ctx.beginPath()
                                        for (var x1 = 0; x1 < w; x1 += 2) {
                                            var y1 = cy + amp * Math.sin(freq * x1 + phase)
                                            if (x1 === 0) ctx.moveTo(x1, y1)
                                            else ctx.lineTo(x1, y1)
                                        }
                                        ctx.strokeStyle = "#00D1A9"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // Strand 2
                                        ctx.beginPath()
                                        for (var x2 = 0; x2 < w; x2 += 2) {
                                            var y2 = cy - amp * Math.sin(freq * x2 + phase)
                                            if (x2 === 0) ctx.moveTo(x2, y2)
                                            else ctx.lineTo(x2, y2)
                                        }
                                        ctx.strokeStyle = "#FF5900"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // Labels
                                        ctx.font = "bold 10px monospace"
                                        ctx.textAlign = "left"
                                        ctx.fillStyle = "#555"
                                        ctx.fillText("5'", 5, cy + amp + 15)
                                        ctx.fillText("3'", w - 18, cy + amp + 15)
                                        ctx.fillText("3'", 5, cy - amp - 8)
                                        ctx.fillText("5'", w - 18, cy - amp - 8)
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 4: Oscilloscope ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "4. Oscilloscope"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card7Shapes.scopeActive ? "Pause" : "Start"
                                    onClicked: card7Shapes.scopeActive = !card7Shapes.scopeActive
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Freq: " + scopeFreq.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: scopeFreq; from: 0.5; to: 4; value: 1.5; stepSize: 0.1; Layout.preferredWidth: Style.resize(130) }
                                }
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Amp: " + scopeAmp.value.toFixed(1); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: scopeAmp; from: 0.2; to: 1.0; value: 0.7; stepSize: 0.05; Layout.preferredWidth: Style.resize(130) }
                                }
                                Item { Layout.fillWidth: true }
                                // Legend
                                Row {
                                    spacing: Style.resize(12)
                                    Row {
                                        spacing: Style.resize(4)
                                        Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00FF41"; anchors.verticalCenter: parent.verticalCenter }
                                        Label { text: "Sine"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    }
                                    Row {
                                        spacing: Style.resize(4)
                                        Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#FFB800"; anchors.verticalCenter: parent.verticalCenter }
                                        Label { text: "Square"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    }
                                    Row {
                                        spacing: Style.resize(4)
                                        Rectangle { width: Style.resize(12); height: Style.resize(3); color: "#00BFFF"; anchors.verticalCenter: parent.verticalCenter }
                                        Label { text: "Triangle"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(220)
                                color: "#0A100A"
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: scopeCanvas
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)

                                    property real scopePhase: 0

                                    Timer {
                                        interval: 40
                                        repeat: true
                                        running: root.fullSize && card7Shapes.scopeActive
                                        onTriggered: {
                                            scopeCanvas.scopePhase += 0.08
                                            scopeCanvas.requestPaint()
                                        }
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cy = h / 2
                                        var freq = scopeFreq.value
                                        var amp = scopeAmp.value * (h * 0.4)
                                        var gridSize = 30

                                        // Grid
                                        ctx.strokeStyle = "#0A3A0A"
                                        ctx.lineWidth = 0.5
                                        for (var gx = 0; gx < w; gx += gridSize) {
                                            ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, h); ctx.stroke()
                                        }
                                        for (var gy = 0; gy < h; gy += gridSize) {
                                            ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(w, gy); ctx.stroke()
                                        }
                                        // Center line (brighter)
                                        ctx.strokeStyle = "#0A5A0A"
                                        ctx.lineWidth = 1
                                        ctx.beginPath(); ctx.moveTo(0, cy); ctx.lineTo(w, cy); ctx.stroke()

                                        // Sine wave (green phosphor)
                                        ctx.beginPath()
                                        for (var sx = 0; sx < w; sx++) {
                                            var sy = cy - amp * Math.sin(freq * sx * 0.04 + scopePhase)
                                            if (sx === 0) ctx.moveTo(sx, sy); else ctx.lineTo(sx, sy)
                                        }
                                        ctx.strokeStyle = "#00FF41"
                                        ctx.lineWidth = 2
                                        ctx.stroke()

                                        // Square wave (amber)
                                        ctx.beginPath()
                                        for (var qx = 0; qx < w; qx++) {
                                            var qPhase = freq * qx * 0.04 + scopePhase + 1.0
                                            var qy = cy - amp * 0.6 * (Math.sin(qPhase) > 0 ? 1 : -1)
                                            if (qx === 0) ctx.moveTo(qx, qy); else ctx.lineTo(qx, qy)
                                        }
                                        ctx.strokeStyle = "#FFB800"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()

                                        // Triangle wave (cyan)
                                        ctx.beginPath()
                                        for (var tx = 0; tx < w; tx++) {
                                            var tPhase = freq * tx * 0.04 + scopePhase + 2.0
                                            var tNorm = (tPhase / Math.PI) % 2
                                            if (tNorm < 0) tNorm += 2
                                            var tVal = tNorm < 1 ? (2 * tNorm - 1) : (3 - 2 * tNorm)
                                            var ty = cy - amp * 0.5 * tVal
                                            if (tx === 0) ctx.moveTo(tx, ty); else ctx.lineTo(tx, ty)
                                        }
                                        ctx.strokeStyle = "#00BFFF"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 5: Geometric Mandala ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "5. Geometric Mandala"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Axes: " + Math.round(mandalaAxes.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: mandalaAxes; from: 4; to: 16; value: 8; stepSize: 1; Layout.preferredWidth: Style.resize(130); onValueChanged: mandalaCanvas.requestPaint() }
                                }
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Layers: " + Math.round(mandalaLayers.value); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: mandalaLayers; from: 3; to: 8; value: 5; stepSize: 1; Layout.preferredWidth: Style.resize(130); onValueChanged: mandalaCanvas.requestPaint() }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(300)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Canvas {
                                    id: mandalaCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - Style.resize(20), Style.resize(290))
                                    height: width

                                    property var palette: ["#00D1A9", "#FF5900", "#9B59B6", "#4A90D9", "#E74C3C", "#FEA601", "#27AE60", "#F39C12"]

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width, h = height
                                        ctx.clearRect(0, 0, w, h)

                                        var cx = w / 2, cy = h / 2
                                        var maxR = Math.min(cx, cy) - 8
                                        var N = Math.round(mandalaAxes.value)
                                        var layers = Math.round(mandalaLayers.value)

                                        // Spoke lines
                                        ctx.strokeStyle = "#333"
                                        ctx.lineWidth = 0.5
                                        for (var s = 0; s < N; s++) {
                                            var sa = s * 2 * Math.PI / N
                                            ctx.beginPath()
                                            ctx.moveTo(cx, cy)
                                            ctx.lineTo(cx + maxR * Math.cos(sa), cy + maxR * Math.sin(sa))
                                            ctx.stroke()
                                        }

                                        // Layers
                                        for (var layer = 0; layer < layers; layer++) {
                                            var r = (layer + 1) / (layers + 1) * maxR
                                            var color = palette[layer % palette.length]

                                            // Concentric ring
                                            ctx.beginPath()
                                            ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                            ctx.strokeStyle = color
                                            ctx.lineWidth = 0.8
                                            ctx.stroke()

                                            // Decorations at each axis point
                                            var dotR = 3 + layer * 1.2
                                            for (var p = 0; p < N; p++) {
                                                var pa = p * 2 * Math.PI / N
                                                var ppx = cx + r * Math.cos(pa)
                                                var ppy = cy + r * Math.sin(pa)

                                                if (layer % 3 === 0) {
                                                    // Filled circles
                                                    ctx.beginPath()
                                                    ctx.arc(ppx, ppy, dotR, 0, 2 * Math.PI)
                                                    ctx.fillStyle = color
                                                    ctx.fill()
                                                } else if (layer % 3 === 1) {
                                                    // Diamonds
                                                    ctx.beginPath()
                                                    ctx.moveTo(ppx, ppy - dotR)
                                                    ctx.lineTo(ppx + dotR, ppy)
                                                    ctx.lineTo(ppx, ppy + dotR)
                                                    ctx.lineTo(ppx - dotR, ppy)
                                                    ctx.closePath()
                                                    ctx.fillStyle = color
                                                    ctx.fill()
                                                } else {
                                                    // Rings
                                                    ctx.beginPath()
                                                    ctx.arc(ppx, ppy, dotR, 0, 2 * Math.PI)
                                                    ctx.strokeStyle = color
                                                    ctx.lineWidth = 2
                                                    ctx.stroke()
                                                }
                                            }

                                            // Petal arcs on odd layers
                                            if (layer % 2 === 1) {
                                                var bulge = r * 0.12
                                                for (var p2 = 0; p2 < N; p2++) {
                                                    var startA = p2 * 2 * Math.PI / N
                                                    var endA = (p2 + 1) * 2 * Math.PI / N
                                                    ctx.beginPath()
                                                    ctx.arc(cx, cy, r + bulge, startA, endA)
                                                    ctx.arc(cx, cy, r - bulge, endA, startA, true)
                                                    ctx.closePath()
                                                    ctx.fillStyle = color.substring(0, 7) + "20"
                                                    ctx.fill()
                                                    ctx.strokeStyle = color
                                                    ctx.lineWidth = 0.5
                                                    ctx.stroke()
                                                }
                                            }
                                        }

                                        // Outer border
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, maxR, 0, 2 * Math.PI)
                                        ctx.strokeStyle = "#444"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()

                                        // Center dot
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, maxR * 0.06, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#00D1A9"
                                        ctx.fill()
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 6: Liquid Blob ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

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
                                    text: card7Shapes.blobActive ? "Pause" : "Start"
                                    onClicked: card7Shapes.blobActive = !card7Shapes.blobActive
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
                                        running: root.fullSize && card7Shapes.blobActive
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
                    }
                }
            }
        }
    }
}
