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
            text: "Arcs & Angles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Sweep angle slider
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Sweep: " + Math.round(sweepSlider.value) + "\u00B0"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }
            Slider {
                id: sweepSlider
                from: 10; to: 360; value: 270
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // PathAngleArc with sweep control
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    id: angleArcShape
                    anchors.centerIn: parent
                    width: Style.resize(180)
                    height: Style.resize(180)

                    ShapePath {
                        strokeWidth: Style.resize(6)
                        strokeColor: Style.mainColor
                        fillColor: Qt.rgba(Style.mainColor.r,
                                           Style.mainColor.g,
                                           Style.mainColor.b, 0.1)
                        startX: angleArcShape.width / 2
                        startY: angleArcShape.height / 2

                        PathAngleArc {
                            centerX: angleArcShape.width / 2
                            centerY: angleArcShape.height / 2
                            radiusX: Style.resize(75)
                            radiusY: Style.resize(75)
                            startAngle: -90
                            sweepAngle: sweepSlider.value
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PathAngleArc"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // Various arc examples
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    id: arcVariantsShape
                    anchors.centerIn: parent
                    width: Style.resize(180)
                    height: Style.resize(180)

                    // Semicircle
                    ShapePath {
                        strokeWidth: Style.resize(3)
                        strokeColor: "#FF5900"
                        fillColor: Qt.rgba(1, 0.35, 0, 0.1)
                        startX: Style.resize(15)
                        startY: arcVariantsShape.height * 0.35

                        PathArc {
                            x: arcVariantsShape.width - Style.resize(15)
                            y: arcVariantsShape.height * 0.35
                            radiusX: (arcVariantsShape.width - Style.resize(30)) / 2
                            radiusY: (arcVariantsShape.width - Style.resize(30)) / 2
                            useLargeArc: false
                        }
                    }

                    // Large arc variant
                    ShapePath {
                        strokeWidth: Style.resize(3)
                        strokeColor: "#7C4DFF"
                        fillColor: Qt.rgba(0.49, 0.30, 1, 0.1)
                        startX: Style.resize(30)
                        startY: arcVariantsShape.height * 0.7

                        PathArc {
                            x: arcVariantsShape.width - Style.resize(30)
                            y: arcVariantsShape.height * 0.7
                            radiusX: Style.resize(55)
                            radiusY: Style.resize(35)
                            useLargeArc: true
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PathArc variants"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
