import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "3. Elastic Spring"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: springSection
            anchors.fill: parent
            property bool isDragging: false

            // Center crosshair
            Rectangle {
                x: springSection.width / 2 - Style.resize(15)
                y: springSection.height / 2 - 0.5
                width: Style.resize(30); height: 1
                color: Style.inactiveColor; opacity: 0.5
            }
            Rectangle {
                x: springSection.width / 2 - 0.5
                y: springSection.height / 2 - Style.resize(15)
                width: 1; height: Style.resize(30)
                color: Style.inactiveColor; opacity: 0.5
            }

            // Trail circles (show spring path)
            Rectangle {
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(120); height: width; radius: width / 2
                color: "transparent"
                border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.3
            }
            Rectangle {
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(80); height: width; radius: width / 2
                color: "transparent"
                border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.2
            }

            Rectangle {
                id: springBall
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(50); height: width; radius: width / 2
                color: Style.mainColor

                Behavior on x {
                    enabled: !springSection.isDragging
                    SpringAnimation { spring: 3; damping: 0.12 }
                }
                Behavior on y {
                    enabled: !springSection.isDragging
                    SpringAnimation { spring: 3; damping: 0.12 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "Drag"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "white"
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: function(mouse) {
                    springSection.isDragging = true
                    springBall.x = mouse.x - springBall.width / 2
                    springBall.y = mouse.y - springBall.height / 2
                }
                onPositionChanged: function(mouse) {
                    if (pressed) {
                        springBall.x = mouse.x - springBall.width / 2
                        springBall.y = mouse.y - springBall.height / 2
                    }
                }
                onReleased: {
                    springSection.isDragging = false
                    springBall.x = springSection.width / 2 - springBall.width / 2
                    springBall.y = springSection.height / 2 - springBall.height / 2
                }
            }
        }
    }
}
