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
            text: "2D Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Scroll horizontally and vertically"
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
                id: gridFlickable
                anchors.fill: parent
                contentWidth: gridContent.width
                contentHeight: gridContent.height
                clip: true

                Grid {
                    id: gridContent
                    columns: 8
                    spacing: Style.resize(4)
                    padding: Style.resize(8)

                    Repeater {
                        model: 64
                        Rectangle {
                            required property int index
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: Style.resize(6)
                            color: Qt.hsla(index / 64.0, 0.6, 0.4, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                font.pixelSize: Style.resize(12)
                                color: "#FFFFFF"
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }
            }
        }

        Label {
            text: "Offset: " + Math.round(gridFlickable.contentX) + ", " + Math.round(gridFlickable.contentY)
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
        }
    }
}
