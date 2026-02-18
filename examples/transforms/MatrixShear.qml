import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "5. Matrix Shear Transform"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Shear X: " + shearXSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: shearXSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Shear Y: " + shearYSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: shearYSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "Reset"
            onClicked: { shearXSlider.value = 0; shearYSlider.value = 0 }
        }
    }

    // Matrix display
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(36)
        color: Style.bgColor
        radius: Style.resize(4)

        Label {
            anchors.centerIn: parent
            text: "Matrix4x4:  [ 1.00, " + shearXSlider.value.toFixed(2) + " ;  " + shearYSlider.value.toFixed(2) + ", 1.00 ]"
            font.pixelSize: Style.resize(12)
            font.family: "Courier"
            color: Style.mainColor
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        // Grid background for reference
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = "#2A2D35"
                ctx.lineWidth = 0.5
                var grid = 30
                for (var gx = 0; gx < width; gx += grid) {
                    ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, height); ctx.stroke()
                }
                for (var gy = 0; gy < height; gy += grid) {
                    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(width, gy); ctx.stroke()
                }
            }
        }

        Rectangle {
            id: shearRect
            anchors.centerIn: parent
            width: Style.resize(100)
            height: Style.resize(100)
            radius: Style.resize(8)
            color: "#4A90D9"
            border.color: "#6AB0FF"
            border.width: 2

            transform: Matrix4x4 {
                matrix: Qt.matrix4x4(
                    1,                  shearXSlider.value, 0, -shearXSlider.value * shearRect.height / 2,
                    shearYSlider.value, 1,                  0, -shearYSlider.value * shearRect.width / 2,
                    0,                  0,                  1, 0,
                    0,                  0,                  0, 1
                )
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(4)

                Label {
                    text: "SHEAR"
                    font.pixelSize: Style.resize(18)
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Matrix4x4"
                    font.pixelSize: Style.resize(10)
                    color: Qt.rgba(1, 1, 1, 0.6)
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Ghost outline of original position
        Rectangle {
            anchors.centerIn: parent
            width: Style.resize(100)
            height: Style.resize(100)
            radius: Style.resize(8)
            color: "transparent"
            border.color: "#4A90D930"
            border.width: 1
            visible: Math.abs(shearXSlider.value) > 0.01 || Math.abs(shearYSlider.value) > 0.01
        }
    }
}
