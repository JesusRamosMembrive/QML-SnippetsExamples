import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Color Picker"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        id: colorPickerRow
        Layout.fillWidth: true
        spacing: Style.resize(10)

        property string selectedColor: "#00D1A9"

        // Color swatches
        Repeater {
            model: [
                "#EF5350", "#FF7043", "#FFA726", "#FFCA28",
                "#66BB6A", "#26A69A", "#00D1A9", "#42A5F5",
                "#5C6BC0", "#AB47BC", "#EC407A", "#8D6E63"
            ]

            Rectangle {
                id: swatch
                required property string modelData
                required property int index

                width: Style.resize(32)
                height: Style.resize(32)
                radius: Style.resize(6)
                color: modelData
                border.color: colorPickerRow.selectedColor === modelData
                              ? "white" : "transparent"
                border.width: 2

                scale: swatchMa.containsMouse ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                MouseArea {
                    id: swatchMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: colorPickerRow.selectedColor = swatch.modelData
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Selected color preview + hex
        Rectangle {
            width: Style.resize(120)
            height: Style.resize(32)
            radius: Style.resize(6)
            color: colorPickerRow.selectedColor

            Label {
                anchors.centerIn: parent
                text: colorPickerRow.selectedColor
                font.pixelSize: Style.resize(12)
                font.bold: true
                font.family: "monospace"
                color: "white"
            }
        }
    }
}
