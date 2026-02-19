import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Drawing Canvas"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem — mouse events + QPainter strokes"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Canvas area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            DrawCanvas {
                id: drawCanvas
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                penColor: root.selectedColor
                penWidth: widthSlider.value
            }

            // Hint when empty
            Label {
                anchors.centerIn: parent
                text: "Draw here with the mouse"
                font.pixelSize: Style.resize(14)
                color: "#FFFFFF30"
                visible: drawCanvas.strokeCount === 0
            }
        }

        // Color selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Color:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Repeater {
                model: ["#00D1A9", "#FF6B6B", "#4FC3F7", "#FFD93D",
                        "#C084FC", "#FFFFFF", "#FF9F43"]

                Rectangle {
                    required property string modelData
                    required property int index
                    width: Style.resize(22)
                    height: Style.resize(22)
                    radius: Style.resize(11)
                    color: modelData
                    border.width: root.selectedColor === modelData ? 2 : 0
                    border.color: "#FFFFFF"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.selectedColor = parent.modelData
                    }
                }
            }
        }

        // Width + controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Width:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: widthSlider
                Layout.fillWidth: true
                from: 1; to: 12; value: 3; stepSize: 1
            }

            Label {
                text: widthSlider.value.toFixed(0) + "px"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(35)
            }

            Button {
                text: "Clear"
                implicitHeight: Style.resize(34)
                onClicked: drawCanvas.clear()
            }

            Label {
                text: drawCanvas.strokeCount + " strokes"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }
        }
    }

    property string selectedColor: "#00D1A9"
}
