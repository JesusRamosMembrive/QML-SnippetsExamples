import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Chat Bubbles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Chat area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ListView {
                id: bubbleList
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                clip: true
                spacing: Style.resize(8)
                verticalLayoutDirection: ListView.BottomToTop

                model: ListModel {
                    ListElement { msg: "Hey! How's the Qt project going?"; sent: false; time: "10:30" }
                    ListElement { msg: "Great! Just finished the PathView page"; sent: true; time: "10:31" }
                    ListElement { msg: "Nice! How many pages total now?"; sent: false; time: "10:31" }
                    ListElement { msg: "45 and counting! Working on showcases now"; sent: true; time: "10:32" }
                    ListElement { msg: "That's impressive! Any favorites?"; sent: false; time: "10:33" }
                    ListElement { msg: "The traffic light state machine is fun"; sent: true; time: "10:33" }
                    ListElement { msg: "Sounds cool, I'll check it out!"; sent: false; time: "10:34" }
                }

                delegate: Item {
                    id: bubbleDelegate
                    required property string msg
                    required property bool sent
                    required property string time
                    required property int index
                    width: bubbleList.width
                    height: bubble.height + Style.resize(4)

                    // Avatar (received only)
                    Rectangle {
                        id: avatar
                        width: Style.resize(28)
                        height: Style.resize(28)
                        radius: Style.resize(14)
                        color: "#4FC3F7"
                        visible: !bubbleDelegate.sent
                        anchors.left: parent.left
                        anchors.bottom: bubble.bottom

                        Label {
                            anchors.centerIn: parent
                            text: "A"
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }

                    // Bubble
                    Rectangle {
                        id: bubble
                        width: Math.min(bubbleDelegate.width * 0.75,
                                        msgLabel.implicitWidth + Style.resize(16))
                        height: msgLabel.height + timeLabel.height + Style.resize(18)
                        radius: Style.resize(12)
                        color: bubbleDelegate.sent ? "#00D1A9" : "#2A2D35"
                        anchors.left: bubbleDelegate.sent ? undefined : (avatar.visible ? avatar.right : parent.left)
                        anchors.leftMargin: avatar.visible ? Style.resize(6) : 0
                        anchors.right: bubbleDelegate.sent ? parent.right : undefined

                        Label {
                            id: msgLabel
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Style.resize(8)
                            text: bubbleDelegate.msg
                            font.pixelSize: Style.resize(12)
                            color: bubbleDelegate.sent ? "#000000" : "#FFFFFF"
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            id: timeLabel
                            anchors.top: msgLabel.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: Style.resize(8)
                            anchors.topMargin: Style.resize(2)
                            text: bubbleDelegate.time
                            font.pixelSize: Style.resize(9)
                            color: bubbleDelegate.sent ? "#00000060" : "#FFFFFF60"
                        }
                    }
                }
            }
        }
    }
}
