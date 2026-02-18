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
            text: "Dynamic List"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            TextField {
                id: addItemField
                Layout.fillWidth: true
                placeholderText: "New item..."

                onAccepted: {
                    if (text.trim() !== "") {
                        dynamicModel.append({ itemText: text.trim() })
                        text = ""
                    }
                }
            }

            Button {
                text: "Add"
                onClicked: {
                    if (addItemField.text.trim() !== "") {
                        dynamicModel.append({ itemText: addItemField.text.trim() })
                        addItemField.text = ""
                    }
                }
            }
        }

        Label {
            text: "Items: " + dynamicModel.count
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
                id: dynamicModel
                ListElement { itemText: "Buy groceries" }
                ListElement { itemText: "Review pull request" }
                ListElement { itemText: "Update documentation" }
                ListElement { itemText: "Fix login bug" }
            }

            ListView {
                id: dynamicListView
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                model: dynamicModel
                clip: true
                spacing: Style.resize(4)

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
                    NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
                }

                remove: Transition {
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
                    NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
                }

                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutQuad }
                }

                delegate: Rectangle {
                    id: dynamicDelegate
                    width: dynamicListView.width
                    height: Style.resize(40)
                    radius: Style.resize(6)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(8)

                        Rectangle {
                            width: Style.resize(6)
                            height: Style.resize(6)
                            radius: width / 2
                            color: Style.mainColor
                        }

                        Label {
                            text: model.itemText
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            width: Style.resize(24)
                            height: Style.resize(24)
                            radius: Style.resize(4)
                            color: removeMouseArea.containsMouse ? "#3D2020" : "transparent"

                            Label {
                                anchors.centerIn: parent
                                text: "\u2715"
                                font.pixelSize: Style.resize(12)
                                color: removeMouseArea.containsMouse ? "#E74C3C" : Style.inactiveColor
                            }

                            MouseArea {
                                id: removeMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: dynamicModel.remove(index)
                            }
                        }
                    }
                }

                // Empty state
                Label {
                    anchors.centerIn: parent
                    text: "List is empty"
                    font.pixelSize: Style.resize(14)
                    color: Style.inactiveColor
                    visible: dynamicModel.count === 0
                }
            }
        }

        Label {
            text: "Add and remove items with animated transitions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
