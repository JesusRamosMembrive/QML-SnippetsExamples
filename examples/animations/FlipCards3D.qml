import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    Label {
        text: "3D Flip Cards"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(20)
        Layout.alignment: Qt.AlignHCenter

        Repeater {
            model: [
                { front: "Click Me", back: "Hello!", clr: "#00D1A9" },
                { front: "Hover", back: "Surprise!", clr: "#5B8DEF" },
                { front: "Flip", back: "Magic!", clr: "#FF9500" },
                { front: "Touch", back: "Nice!", clr: "#FF3B30" }
            ]

            delegate: Item {
                id: flipCard
                Layout.preferredWidth: Style.resize(140)
                Layout.preferredHeight: Style.resize(180)

                required property var modelData
                required property int index

                property bool flipped: false
                property real flipAngle: 0

                Behavior on flipAngle {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                }

                // Front face
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: flipCard.modelData.clr
                    visible: flipCard.flipAngle < 90
                    opacity: visible ? 1 : 0

                    transform: Rotation {
                        origin.x: flipCard.width / 2
                        origin.y: flipCard.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: flipCard.flipAngle
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "\u25B6"
                            font.pixelSize: Style.resize(30)
                            color: "#FFFFFF"
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: flipCard.modelData.front
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }

                // Back face
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: Style.surfaceColor
                    border.color: flipCard.modelData.clr
                    border.width: Style.resize(2)
                    visible: flipCard.flipAngle >= 90
                    opacity: visible ? 1 : 0

                    transform: Rotation {
                        origin.x: flipCard.width / 2
                        origin.y: flipCard.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: flipCard.flipAngle - 180
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "\u2726"
                            font.pixelSize: Style.resize(30)
                            color: flipCard.modelData.clr
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: flipCard.modelData.back
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: flipCard.modelData.clr
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        flipCard.flipped = !flipCard.flipped
                        flipCard.flipAngle = flipCard.flipped ? 180 : 0
                    }
                }
            }
        }
    }
}
