import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
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
