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
            text: "Gradient Types"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // Linear Gradient
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        startX: 60; startY: 0
                        fillGradient: LinearGradient {
                            x1: 0; y1: 0
                            x2: 120; y2: 120
                            GradientStop { position: 0; color: Style.mainColor }
                            GradientStop { position: 0.5; color: "#FFE361" }
                            GradientStop { position: 1; color: "#FF5900" }
                        }
                        // Hexagon
                        PathLine { x: 105; y: 30 }
                        PathLine { x: 105; y: 90 }
                        PathLine { x: 60;  y: 120 }
                        PathLine { x: 15;  y: 90 }
                        PathLine { x: 15;  y: 30 }
                        PathLine { x: 60;  y: 0 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LinearGradient"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // Radial Gradient
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        fillGradient: RadialGradient {
                            centerX: 60; centerY: 60
                            centerRadius: 60
                            focalX: 40; focalY: 40
                            focalRadius: 0
                            GradientStop { position: 0; color: "white" }
                            GradientStop { position: 0.4; color: Style.mainColor }
                            GradientStop { position: 1; color: "#1E272E" }
                        }
                        // Circle via arcs
                        startX: 120; startY: 60
                        PathArc {
                            x: 0; y: 60
                            radiusX: 60; radiusY: 60
                        }
                        PathArc {
                            x: 120; y: 60
                            radiusX: 60; radiusY: 60
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "RadialGradient"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // Conical Gradient (animated)
            Item {
                id: conicalItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                property real conicalAngle: 0
                NumberAnimation on conicalAngle {
                    from: 0; to: 360; duration: 4000
                    loops: Animation.Infinite
                }

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        fillGradient: ConicalGradient {
                            centerX: 60; centerY: 60
                            angle: conicalItem.conicalAngle
                            GradientStop { position: 0;    color: "#FF5900" }
                            GradientStop { position: 0.33; color: "#FFE361" }
                            GradientStop { position: 0.66; color: Style.mainColor }
                            GradientStop { position: 1;    color: "#FF5900" }
                        }
                        // Circle
                        startX: 120; startY: 60
                        PathArc {
                            x: 0; y: 60
                            radiusX: 60; radiusY: 60
                        }
                        PathArc {
                            x: 120; y: 60
                            radiusX: 60; radiusY: 60
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ConicalGradient (animated)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
