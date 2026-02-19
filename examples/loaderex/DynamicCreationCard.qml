import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int objectCount: 0

    Component {
        id: bubbleComp

        Rectangle {
            id: bubble
            property real targetX: 0
            property real targetY: 0
            x: targetX
            y: targetY
            width: Style.resize(40 + Math.random() * 30)
            height: width
            radius: width / 2
            color: Qt.hsla(Math.random(), 0.7, 0.5, 0.8)
            scale: 0

            Label {
                anchors.centerIn: parent
                text: "\u2726"
                font.pixelSize: parent.width * 0.4
                color: "#FFFFFF"
            }

            // Appear animation
            NumberAnimation on scale {
                from: 0; to: 1; duration: 300
                easing.type: Easing.OutBack
            }

            // Float animation
            SequentialAnimation on y {
                loops: Animation.Infinite
                NumberAnimation {
                    to: bubble.targetY - Style.resize(10)
                    duration: 1500 + Math.random() * 1000
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    to: bubble.targetY + Style.resize(10)
                    duration: 1500 + Math.random() * 1000
                    easing.type: Easing.InOutQuad
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.objectCount--
                    bubble.destroy()
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Creation"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Click area to spawn, click bubble to remove"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item {
            id: spawnArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Style.surfaceColor
                radius: Style.resize(8)
                border.color: "#3A3D45"
                border.width: 1
            }

            // Hint when empty
            Label {
                anchors.centerIn: parent
                text: "Click to spawn objects"
                font.pixelSize: Style.resize(14)
                color: Style.inactiveColor
                visible: root.objectCount === 0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: function(mouse) {
                    var obj = bubbleComp.createObject(spawnArea, {
                        targetX: mouse.x - Style.resize(25),
                        targetY: mouse.y - Style.resize(25)
                    })
                    if (obj) root.objectCount++
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Objects: " + root.objectCount
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            Button {
                text: "Clear All"
                font.pixelSize: Style.resize(11)
                enabled: root.objectCount > 0
                onClicked: {
                    for (var i = spawnArea.children.length - 1; i >= 0; i--) {
                        var child = spawnArea.children[i]
                        if (child !== spawnArea.children[0] && child.destroy) {
                            child.destroy()
                        }
                    }
                    root.objectCount = 0
                }
            }
        }
    }
}
