import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int tabCounter: 3

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Tabs (Add / Close)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Button {
                text: "+ Add Tab"
                onClicked: {
                    root.tabCounter++
                    tabModel.append({ title: "Tab " + root.tabCounter })
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: tabModel.count + " tabs"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }
        }

        // Dynamic TabBar
        TabBar {
            id: dynamicTabBar
            Layout.fillWidth: true

            Repeater {
                model: ListModel {
                    id: tabModel
                    ListElement { title: "Tab 1" }
                    ListElement { title: "Tab 2" }
                    ListElement { title: "Tab 3" }
                }

                TabButton {
                    required property int index
                    required property string title
                    text: title
                    width: implicitWidth

                    // Close button
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: Style.resize(4)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(18)
                        height: Style.resize(18)
                        radius: width / 2
                        color: closeArea.containsMouse ? "#44FFFFFF" : "transparent"
                        visible: tabModel.count > 1

                        Label {
                            anchors.centerIn: parent
                            text: "\u00D7"
                            font.pixelSize: Style.resize(14)
                            color: Style.fontSecondaryColor
                        }

                        MouseArea {
                            id: closeArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var removeIdx = index
                                if (dynamicTabBar.currentIndex >= removeIdx && dynamicTabBar.currentIndex > 0)
                                    dynamicTabBar.currentIndex--
                                tabModel.remove(removeIdx)
                            }
                        }
                    }
                }
            }
        }

        // Content area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)

            Label {
                anchors.centerIn: parent
                text: dynamicTabBar.currentIndex >= 0 && dynamicTabBar.currentIndex < tabModel.count
                      ? tabModel.get(dynamicTabBar.currentIndex).title + " content"
                      : "No tab selected"
                font.pixelSize: Style.resize(16)
                color: Style.fontPrimaryColor
            }
        }
    }
}
