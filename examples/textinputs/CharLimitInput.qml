import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Character Limit with Progress Ring"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(46)
            radius: Style.resize(8)
            color: Style.surfaceColor
            border.color: limitInput.activeFocus ? progressColor : "#3A3D45"
            border.width: limitInput.activeFocus ? 2 : 1

            property real progress: limitInput.text.length / 140
            property string progressColor: {
                if (progress > 0.9) return "#EF5350"
                if (progress > 0.7) return "#FFA726"
                return Style.mainColor
            }

            Behavior on border.color { ColorAnimation { duration: 200 } }

            TextInput {
                id: limitInput
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                clip: true
                maximumLength: 140
                selectByMouse: true
                selectionColor: Style.mainColor
                verticalAlignment: TextInput.AlignVCenter

                Text {
                    anchors.fill: parent
                    text: "Tweet something (140 chars max)..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Progress ring
        Item {
            width: Style.resize(44)
            height: Style.resize(44)

            property real progress: limitInput.text.length / 140
            property string ringColor: {
                if (progress > 0.9) return "#EF5350"
                if (progress > 0.7) return "#FFA726"
                return Style.mainColor
            }

            Canvas {
                id: progressRing
                anchors.fill: parent

                property real prog: parent.progress
                property string rColor: parent.ringColor

                onProgChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height
                    var cx = w / 2
                    var cy = h / 2
                    var r = Math.min(cx, cy) - 4
                    var startAngle = -Math.PI / 2

                    ctx.clearRect(0, 0, w, h)

                    // Background ring
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.strokeStyle = "#3A3D45"
                    ctx.lineWidth = 3
                    ctx.stroke()

                    // Progress arc
                    if (prog > 0) {
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, startAngle,
                                startAngle + 2 * Math.PI * Math.min(prog, 1))
                        ctx.strokeStyle = rColor
                        ctx.lineWidth = 3
                        ctx.lineCap = "round"
                        ctx.stroke()
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: 140 - limitInput.text.length
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: parent.ringColor
            }
        }
    }
}
