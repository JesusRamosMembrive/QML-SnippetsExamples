import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int easingIndex: 0
    readonly property var easings: [
        { name: "Linear",       type: Easing.Linear },
        { name: "InOutQuad",    type: Easing.InOutQuad },
        { name: "OutBounce",    type: Easing.OutBounce },
        { name: "OutElastic",   type: Easing.OutElastic },
        { name: "InOutBack",    type: Easing.InOutBack },
        { name: "OutCubic",     type: Easing.OutCubic }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Transition Easings"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Track
            Rectangle {
                id: track
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: Style.resize(4)
                radius: Style.resize(2)
                color: "#3A3D45"
            }

            // Start marker
            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: Style.resize(2)
                height: Style.resize(30)
                color: Style.inactiveColor
            }

            // End marker
            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: Style.resize(2)
                height: Style.resize(30)
                color: Style.inactiveColor
            }

            // Animated ball
            Rectangle {
                id: ball
                width: Style.resize(40)
                height: Style.resize(40)
                radius: Style.resize(20)
                color: "#00D1A9"
                y: parent.height / 2 - height / 2

                Label {
                    anchors.centerIn: parent
                    text: "\u2192"
                    font.pixelSize: Style.resize(18)
                    color: "#FFFFFF"
                    rotation: ball.state === "end" ? 0 : 180
                }

                states: [
                    State {
                        name: "start"
                        PropertyChanges { target: ball; x: 0 }
                    },
                    State {
                        name: "end"
                        PropertyChanges { target: ball; x: track.width - ball.width }
                    }
                ]

                state: "start"

                transitions: Transition {
                    NumberAnimation {
                        property: "x"
                        duration: 1000
                        easing.type: root.easings[root.easingIndex].type
                    }
                }
            }
        }

        // Easing curve preview
        Canvas {
            id: easingCanvas
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(60)
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                // Background
                ctx.fillStyle = Style.surfaceColor
                ctx.fillRect(0, 0, width, height)

                // Draw easing curve
                ctx.strokeStyle = "#00D1A9"
                ctx.lineWidth = 2
                ctx.beginPath()
                for (var i = 0; i <= 100; i++) {
                    var t = i / 100
                    // Approximate easing output
                    var v = t // Will be overridden
                    var eType = root.easingIndex
                    if (eType === 0) v = t
                    else if (eType === 1) v = t < 0.5 ? 2*t*t : 1-Math.pow(-2*t+2,2)/2
                    else if (eType === 2) {
                        var n1 = 7.5625, d1 = 2.75
                        var t2 = 1 - t
                        if (t2 < 1/d1) v = 1 - n1*t2*t2
                        else if (t2 < 2/d1) v = 1 - (n1*(t2-=1.5/d1)*t2+0.75)
                        else if (t2 < 2.5/d1) v = 1 - (n1*(t2-=2.25/d1)*t2+0.9375)
                        else v = 1 - (n1*(t2-=2.625/d1)*t2+0.984375)
                    }
                    else if (eType === 3) v = t===0?0:t===1?1:Math.pow(2,-10*t)*Math.sin((t*10-0.75)*(2*Math.PI)/3)+1
                    else if (eType === 4) {
                        var c = 1.70158 * 1.525
                        v = t<0.5?(Math.pow(2*t,2)*((c+1)*2*t-c))/2:(Math.pow(2*t-2,2)*((c+1)*(t*2-2)+c)+2)/2
                    }
                    else v = 1 - Math.pow(1-t, 3)

                    var px = i / 100 * width
                    var py = height - v * height
                    if (i === 0) ctx.moveTo(px, py)
                    else ctx.lineTo(px, py)
                }
                ctx.stroke()
            }

            // Repaint when easing changes
            Connections {
                target: root
                function onEasingIndexChanged() { easingCanvas.requestPaint() }
            }
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            ComboBox {
                Layout.fillWidth: true
                model: root.easings.map(function(e) { return e.name })
                currentIndex: root.easingIndex
                onCurrentIndexChanged: root.easingIndex = currentIndex
                font.pixelSize: Style.resize(11)
            }

            Button {
                text: "Play"
                onClicked: {
                    ball.state = ball.state === "start" ? "end" : "start"
                }
            }
        }
    }
}
