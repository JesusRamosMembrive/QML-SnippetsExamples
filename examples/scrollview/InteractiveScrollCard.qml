import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int itemCount: 10

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Scroll-to & Load More"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "\u2191 Top"
                onClicked: scrollListView.positionViewAtBeginning()
            }
            Button {
                text: "\u2193 Bottom"
                onClicked: scrollListView.positionViewAtEnd()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: root.itemCount + " items"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            ListView {
                id: scrollListView
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: root.itemCount
                spacing: Style.resize(4)
                clip: true

                delegate: Rectangle {
                    required property int index
                    width: scrollListView.width
                    height: Style.resize(36)
                    radius: Style.resize(4)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(10)
                        anchors.rightMargin: Style.resize(10)

                        Rectangle {
                            width: Style.resize(24)
                            height: Style.resize(24)
                            radius: Style.resize(12)
                            color: Qt.hsla(index * 0.08, 0.6, 0.5, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                font.pixelSize: Style.resize(10)
                                color: "#FFFFFF"
                            }
                        }

                        Label {
                            text: "Item " + (index + 1)
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }
                    }
                }

                // Load more when reaching the bottom
                onAtYEndChanged: {
                    if (atYEnd && root.itemCount < 50) {
                        root.itemCount += 5
                    }
                }

                // Scroll position indicator
                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AsNeeded
                }
            }

            // "Loading more" indicator
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: Style.resize(8)
                width: Style.resize(120)
                height: Style.resize(28)
                radius: Style.resize(14)
                color: Style.cardColor
                visible: root.itemCount < 50

                Label {
                    anchors.centerIn: parent
                    text: "Scroll for more..."
                    font.pixelSize: Style.resize(11)
                    color: Style.mainColor
                }
            }
        }
    }
}
