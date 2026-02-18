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
            text: "Card Flip"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: flipCard.flipped ? "Showing: Back" : "Showing: Front"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.fontSecondaryColor
        }

        // Flip area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(6)
            }

            Item {
                id: flipCard
                anchors.centerIn: parent
                width: Style.resize(180)
                height: Style.resize(220)

                property bool flipped: false
                property real flipAngle: 0

                Behavior on flipAngle {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                }

                transform: Rotation {
                    origin.x: flipCard.width / 2
                    origin.y: flipCard.height / 2
                    axis { x: 0; y: 1; z: 0 }
                    angle: flipCard.flipAngle
                }

                // Front face
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: Style.mainColor
                    visible: flipCard.flipAngle < 90 || flipCard.flipAngle > 270

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Rectangle {
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: width / 2
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                anchors.centerIn: parent
                                text: "Qt"
                                font.pixelSize: Style.resize(24)
                                font.bold: true
                                color: Style.mainColor
                            }
                        }

                        Label {
                            text: "FRONT"
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Click to flip"
                            font.pixelSize: Style.resize(13)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Back face (mirrored horizontally so text reads correctly)
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: "#FEA601"
                    visible: flipCard.flipAngle >= 90 && flipCard.flipAngle <= 270

                    // Mirror to counteract the Y rotation
                    transform: Scale {
                        origin.x: flipCard.width / 2
                        xScale: -1
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Rectangle {
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: Style.resize(8)
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                anchors.centerIn: parent
                                text: "QML"
                                font.pixelSize: Style.resize(18)
                                font.bold: true
                                color: "#FEA601"
                            }
                        }

                        Label {
                            text: "BACK"
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Click to flip back"
                            font.pixelSize: Style.resize(13)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flipCard.flipped = !flipCard.flipped
                        flipCard.flipAngle = flipCard.flipped ? 180 : 0
                    }
                }
            }
        }

        Label {
            text: "3D Y-axis Rotation to create a card flip. Click to toggle front/back"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
