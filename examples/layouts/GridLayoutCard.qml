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
            text: "GridLayout"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Column count control
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Columns: " + colSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: colSlider
                    anchors.fill: parent
                    from: 2
                    to: 4
                    value: 3
                    stepSize: 1
                }
            }
        }

        // GridLayout demo
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            GridLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                columns: colSlider.value
                rowSpacing: Style.resize(6)
                columnSpacing: Style.resize(6)

                // Wide cell (spans 2 columns)
                Rectangle {
                    Layout.columnSpan: Math.min(2, colSlider.value)
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#4A90D9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#00D1A9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                // Tall cell (spans 2 rows)
                Rectangle {
                    Layout.rowSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#FEA601"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "rowSpan\n2"; color: "white"; font.pixelSize: Style.resize(11); horizontalAlignment: Text.AlignHCenter }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#9B59B6"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#E74C3C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#1ABC9C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#FF5900"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.columnSpan: Math.min(2, colSlider.value)
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#636E72"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                }
            }
        }

        Label {
            text: "GridLayout with columnSpan and rowSpan for complex arrangements"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
