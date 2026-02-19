import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Pinch to Zoom"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Use scroll wheel or slider to zoom"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Flickable {
                id: zoomFlick
                anchors.fill: parent
                contentWidth: zoomContent.width * zoomContent.scale
                contentHeight: zoomContent.height * zoomContent.scale
                boundsBehavior: Flickable.StopAtBounds

                Item {
                    id: zoomContent
                    width: Style.resize(400)
                    height: Style.resize(400)
                    transformOrigin: Item.TopLeft
                    scale: zoomSlider.value

                    // Grid pattern
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            // Background
                            ctx.fillStyle = Style.surfaceColor
                            ctx.fillRect(0, 0, width, height)

                            // Grid lines
                            var step = 40
                            ctx.strokeStyle = "#3A3D45"
                            ctx.lineWidth = 1
                            for (var x = 0; x <= width; x += step) {
                                ctx.beginPath()
                                ctx.moveTo(x, 0)
                                ctx.lineTo(x, height)
                                ctx.stroke()
                            }
                            for (var y = 0; y <= height; y += step) {
                                ctx.beginPath()
                                ctx.moveTo(0, y)
                                ctx.lineTo(width, y)
                                ctx.stroke()
                            }

                            // Colored shapes
                            ctx.fillStyle = "#00D1A9"
                            ctx.fillRect(60, 60, 80, 80)

                            ctx.fillStyle = "#FEA601"
                            ctx.beginPath()
                            ctx.arc(260, 100, 50, 0, 2 * Math.PI)
                            ctx.fill()

                            ctx.fillStyle = "#FF7043"
                            ctx.beginPath()
                            ctx.moveTo(160, 240)
                            ctx.lineTo(220, 340)
                            ctx.lineTo(100, 340)
                            ctx.closePath()
                            ctx.fill()

                            ctx.fillStyle = "#AB47BC"
                            ctx.fillRect(260, 260, 100, 60)

                            // Labels
                            ctx.fillStyle = "#FFFFFF"
                            ctx.font = "bold 14px sans-serif"
                            ctx.textAlign = "center"
                            ctx.fillText("Rectangle", 100, 110)
                            ctx.fillText("Circle", 260, 105)
                            ctx.fillText("Triangle", 160, 300)
                            ctx.fillText("Box", 310, 295)
                        }
                    }
                }

                WheelHandler {
                    onWheel: function(event) {
                        var delta = event.angleDelta.y / 120
                        zoomSlider.value = Math.max(0.5, Math.min(3.0, zoomSlider.value + delta * 0.2))
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Zoom: " + zoomSlider.value.toFixed(1) + "x"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: zoomSlider
                Layout.fillWidth: true
                from: 0.5; to: 3.0; value: 1.0
            }
            Button {
                text: "Reset"
                font.pixelSize: Style.resize(11)
                onClicked: {
                    zoomSlider.value = 1.0
                    zoomFlick.contentX = 0
                    zoomFlick.contentY = 0
                }
            }
        }
    }
}
