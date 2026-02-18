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
            text: "ListView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            id: contactInfoLabel
            text: "Select a contact"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            ListModel {
                id: contactModel
                ListElement { name: "Alice Johnson"; role: "Designer"; avatarColor: "#4A90D9" }
                ListElement { name: "Bob Smith"; role: "Developer"; avatarColor: "#00D1A9" }
                ListElement { name: "Carol White"; role: "Manager"; avatarColor: "#FEA601" }
                ListElement { name: "David Brown"; role: "QA Engineer"; avatarColor: "#FF5900" }
                ListElement { name: "Emma Davis"; role: "DevOps"; avatarColor: "#9B59B6" }
                ListElement { name: "Frank Miller"; role: "Architect"; avatarColor: "#E74C3C" }
                ListElement { name: "Grace Lee"; role: "Analyst"; avatarColor: "#1ABC9C" }
            }

            ListView {
                id: contactListView
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                model: contactModel
                clip: true
                spacing: Style.resize(2)
                currentIndex: -1

                highlight: Rectangle {
                    color: Qt.rgba(0, 209/255, 169/255, 0.15)
                    radius: Style.resize(6)
                }
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 200

                delegate: Item {
                    width: contactListView.width
                    height: Style.resize(52)

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(10)

                        Rectangle {
                            width: Style.resize(36)
                            height: Style.resize(36)
                            radius: width / 2
                            color: model.avatarColor

                            Label {
                                anchors.centerIn: parent
                                text: model.name[0]
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: "white"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(2)

                            Label {
                                text: model.name
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }

                            Label {
                                text: model.role
                                font.pixelSize: Style.resize(11)
                                color: Style.fontSecondaryColor
                                Layout.fillWidth: true
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            contactListView.currentIndex = index
                            contactInfoLabel.text = "Selected: " + model.name + " — " + model.role
                        }
                    }
                }
            }
        }

        Label {
            text: "ListView with custom delegates showing avatar, name, and role"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
