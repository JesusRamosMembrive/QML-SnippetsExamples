pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
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
                    required property string modelData

                    width: Style.resize(24)
                    height: Style.resize(24)
                    radius: width / 2
                    color: modelData
                    border.width: drawCanvas.strokeColor === modelData ? 3 : 1
                    border.color: drawCanvas.strokeColor === modelData ? Style.fontPrimaryColor : "#3A3D45"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: drawCanvas.strokeColor = parent.modelData
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
