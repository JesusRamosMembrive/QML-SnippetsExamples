import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Shape & Paths"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Shapes area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(10)

                // Triangle
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(80)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#4A90D9"
                                fillColor: "#4A90D930"
                                startX: 40; startY: 5

                                PathLine { x: 75; y: 70 }
                                PathLine { x: 5; y: 70 }
                                PathLine { x: 40; y: 5 }
                            }
                        }
                    }

                    Label {
                        text: "Triangle"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Star
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(80)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#FEA601"
                                fillColor: "#FEA60130"
                                // 5-pointed star
                                startX: 40; startY: 2

                                PathLine { x: 49; y: 28 }
                                PathLine { x: 77; y: 28 }
                                PathLine { x: 54; y: 46 }
                                PathLine { x: 63; y: 74 }
                                PathLine { x: 40; y: 56 }
                                PathLine { x: 17; y: 74 }
                                PathLine { x: 26; y: 46 }
                                PathLine { x: 3; y: 28 }
                                PathLine { x: 31; y: 28 }
                                PathLine { x: 40; y: 2 }
                            }
                        }
                    }

                    Label {
                        text: "Star"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Rounded shape with arcs
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(60)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#00D1A9"
                                fillColor: "#00D1A930"

                                startX: 10; startY: 0

                                PathLine { x: 70; y: 0 }
                                PathArc { x: 80; y: 10; radiusX: 10; radiusY: 10 }
                                PathLine { x: 80; y: 50 }
                                PathArc { x: 70; y: 60; radiusX: 10; radiusY: 10 }
                                PathLine { x: 10; y: 60 }
                                PathArc { x: 0; y: 50; radiusX: 10; radiusY: 10 }
                                PathLine { x: 0; y: 10 }
                                PathArc { x: 10; y: 0; radiusX: 10; radiusY: 10 }
                            }
                        }
                    }

                    Label {
                        text: "Rounded Rect"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Heart shape
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(70)
                            height: Style.resize(70)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#E74C3C"
                                fillColor: "#E74C3C30"

                                startX: 35; startY: 60

                                PathQuad { x: 0; y: 25; controlX: 0; controlY: 60 }
                                PathQuad { x: 35; y: 15; controlX: 0; controlY: 0 }
                                PathQuad { x: 70; y: 25; controlX: 70; controlY: 0 }
                                PathQuad { x: 35; y: 60; controlX: 70; controlY: 60 }
                            }
                        }
                    }

                    Label {
                        text: "Heart"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Label {
            text: "Declarative Shape with PathLine, PathArc, and PathQuad elements"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
