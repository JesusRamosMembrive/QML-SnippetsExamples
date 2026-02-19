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
            text: "Custom ScrollBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Styled scrollbar with position indicator"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            Flickable {
                id: customFlickable
                anchors.fill: parent
                anchors.rightMargin: Style.resize(14)
                anchors.margins: Style.resize(8)
                contentHeight: contentCol.implicitHeight
                clip: true

                ColumnLayout {
                    id: contentCol
                    width: parent.width
                    spacing: Style.resize(8)

                    Repeater {
                        model: 30
                        Rectangle {
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(28)
                            radius: Style.resize(4)
                            color: Style.surfaceColor

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                anchors.rightMargin: Style.resize(8)

                                Label {
                                    text: "\u2022 Entry " + (index + 1)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Rectangle {
                                    width: Style.resize(40 + Math.random() * 60)
                                    height: Style.resize(6)
                                    radius: Style.resize(3)
                                    color: Style.mainColor
                                    opacity: 0.3 + Math.random() * 0.7
                                }
                            }
                        }
                    }
                }
            }

            // Custom vertical ScrollBar
            ScrollBar {
                id: customScrollBar
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: Style.resize(2)
                active: true
                policy: ScrollBar.AlwaysOn
                size: customFlickable.visibleArea.heightRatio
                position: customFlickable.visibleArea.yPosition

                contentItem: Rectangle {
                    implicitWidth: Style.resize(8)
                    radius: Style.resize(4)
                    color: customScrollBar.pressed ? Style.mainColor
                         : customScrollBar.hovered ? Qt.lighter(Style.mainColor, 1.4)
                         : Style.inactiveColor
                    opacity: customScrollBar.pressed ? 1.0 : 0.7

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                background: Rectangle {
                    implicitWidth: Style.resize(8)
                    radius: Style.resize(4)
                    color: Style.bgColor
                    opacity: 0.3
                }

                onPositionChanged: customFlickable.contentY = position * customFlickable.contentHeight
            }
        }

        Label {
            text: "Position: " + (customFlickable.visibleArea.yPosition * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
        }
    }
}
