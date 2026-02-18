pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
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
                onAvailableChanged: if (available) requestPaint()
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
                        required property int index

                        spacing: Style.resize(4)
                        Rectangle {
                            width: Style.resize(10)
                            height: Style.resize(10)
                            radius: Style.resize(2)
                            color: pieCanvas.slices[parent.index].color
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            text: pieCanvas.slices[parent.index].label
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
