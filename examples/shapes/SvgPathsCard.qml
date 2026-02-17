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
            text: "SVG Paths"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(20)

            // Airplane silhouette
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(100)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: Style.mainColor
                        fillColor: Qt.rgba(Style.mainColor.r,
                                           Style.mainColor.g,
                                           Style.mainColor.b, 0.15)
                        // Simplified airplane top-down
                        PathSvg {
                            path: "M 50 0 L 55 30 L 95 50 L 95 58 L 55 48 L 55 85 L 70 95 L 70 100 L 50 95 L 30 100 L 30 95 L 45 85 L 45 48 L 5 58 L 5 50 L 45 30 Z"
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Airplane"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // Gear / cog
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(100)
                    height: Style.resize(100)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#FF5900"
                        fillColor: Qt.rgba(1, 0.35, 0, 0.15)
                        PathSvg {
                            path: "M 43 0 L 57 0 L 60 15 L 70 18 L 82 8 L 92 18 L 82 30 L 85 40 L 100 43 L 100 57 L 85 60 L 82 70 L 92 82 L 82 92 L 70 82 L 60 85 L 57 100 L 43 100 L 40 85 L 30 82 L 18 92 L 8 82 L 18 70 L 15 60 L 0 57 L 0 43 L 15 40 L 18 30 L 8 18 L 18 8 L 30 18 L 40 15 Z M 50 30 A 20 20 0 1 0 50 70 A 20 20 0 1 0 50 30 Z"
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Gear (with hole)"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // Lightning bolt
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(80)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#FFE361"
                        fillColor: "#FFE361"
                        PathSvg {
                            path: "M 35 0 L 55 0 L 40 45 L 65 45 L 20 120 L 30 60 L 10 60 Z"
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Lightning"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }

        Label {
            text: "PathSvg renders standard SVG path data strings"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
