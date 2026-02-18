import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var logModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(10)

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Message Log"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            Label {
                text: (root.logModel ? root.logModel.count : 0) + " messages"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Button {
                text: "Clear"
                enabled: root.logModel ? root.logModel.count > 0 : false
                onClicked: root.logModel.clear()
            }
        }

        // Log list
        ListView {
            id: logView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.logModel
            clip: true
            spacing: Style.resize(2)

            delegate: Rectangle {
                width: logView.width
                height: Style.resize(32)
                color: index % 2 === 0 ? Style.surfaceColor : Style.cardColor
                radius: Style.resize(4)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    spacing: Style.resize(10)

                    // Timestamp
                    Label {
                        text: model.time
                        font.pixelSize: Style.resize(12)
                        font.family: "Courier New"
                        color: Style.fontSecondaryColor
                        Layout.preferredWidth: Style.resize(65)
                    }

                    // Direction arrow
                    Label {
                        text: model.direction === "sent" ? "\u2192" :
                              model.direction === "received" ? "\u2190" : "\u26A0"
                        font.pixelSize: Style.resize(16)
                        color: model.direction === "sent" ? Style.mainColor :
                               model.direction === "received" ? "#4A90D9" : "#F44336"
                        Layout.preferredWidth: Style.resize(20)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Message text
                    Label {
                        text: model.text
                        font.pixelSize: Style.resize(13)
                        color: model.direction === "error" ? "#F44336" : Style.fontPrimaryColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Type tag
                    Rectangle {
                        Layout.preferredWidth: Style.resize(55)
                        Layout.preferredHeight: Style.resize(20)
                        radius: Style.resize(3)
                        color: model.direction === "sent" ? "#1B3A2A" :
                               model.direction === "received" ? "#1A2A3A" : "#3A1A1A"

                        Label {
                            anchors.centerIn: parent
                            text: model.direction === "sent" ? "sent" :
                                  model.direction === "received" ? "echo" : "error"
                            font.pixelSize: Style.resize(10)
                            color: model.direction === "sent" ? "#4CAF50" :
                                   model.direction === "received" ? "#42A5F5" : "#EF5350"
                        }
                    }
                }
            }

            // Empty state
            Label {
                anchors.centerIn: parent
                text: "No messages yet.\nConnect and send a message to see the echo response."
                font.pixelSize: Style.resize(14)
                color: Style.inactiveColor
                horizontalAlignment: Text.AlignHCenter
                visible: root.logModel ? root.logModel.count === 0 : true
            }
        }
    }
}
