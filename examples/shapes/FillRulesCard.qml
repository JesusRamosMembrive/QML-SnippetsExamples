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
            text: "Fill Rules"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(30)

            // OddEvenFill
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(140)
                    height: Style.resize(140)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: Style.mainColor
                        fillColor: Style.mainColor
                        fillRule: ShapePath.OddEvenFill

                        // 5-point star
                        startX: 70; startY: 5
                        PathLine { x: 85;  y: 55 }
                        PathLine { x: 135; y: 55 }
                        PathLine { x: 95;  y: 85 }
                        PathLine { x: 110; y: 135 }
                        PathLine { x: 70;  y: 105 }
                        PathLine { x: 30;  y: 135 }
                        PathLine { x: 45;  y: 85 }
                        PathLine { x: 5;   y: 55 }
                        PathLine { x: 55;  y: 55 }
                        PathLine { x: 70;  y: 5 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "OddEvenFill"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Style.resize(-15)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Center is hollow"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // WindingFill
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(140)
                    height: Style.resize(140)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#7C4DFF"
                        fillColor: "#7C4DFF"
                        fillRule: ShapePath.WindingFill

                        // Same 5-point star
                        startX: 70; startY: 5
                        PathLine { x: 85;  y: 55 }
                        PathLine { x: 135; y: 55 }
                        PathLine { x: 95;  y: 85 }
                        PathLine { x: 110; y: 135 }
                        PathLine { x: 70;  y: 105 }
                        PathLine { x: 30;  y: 135 }
                        PathLine { x: 45;  y: 85 }
                        PathLine { x: 5;   y: 55 }
                        PathLine { x: 55;  y: 55 }
                        PathLine { x: 70;  y: 5 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "WindingFill"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Style.resize(-15)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Fully solid"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
