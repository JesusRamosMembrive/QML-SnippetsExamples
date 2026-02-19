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
            text: "Basic Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Scroll to explore the content"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Flickable {
                id: basicFlick
                anchors.fill: parent
                contentWidth: contentCol.width
                contentHeight: contentCol.height
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: contentCol
                    width: basicFlick.width
                    spacing: Style.resize(6)

                    Repeater {
                        model: 20

                        Rectangle {
                            required property int index
                            width: contentCol.width
                            height: Style.resize(40)
                            radius: Style.resize(4)
                            color: Qt.hsla(index / 20.0, 0.5, 0.4, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: "Row " + (index + 1)
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: "#FFFFFF"
                            }
                        }
                    }
                }
            }

            // Vertical scroll indicator
            Rectangle {
                anchors.right: parent.right
                y: basicFlick.visibleArea.yPosition * parent.height
                width: Style.resize(4)
                height: basicFlick.visibleArea.heightRatio * parent.height
                radius: Style.resize(2)
                color: Style.mainColor
                opacity: basicFlick.moving ? 0.8 : 0.3

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        Label {
            text: "Position: " + (basicFlick.contentY).toFixed(0) + " / " + (basicFlick.contentHeight - basicFlick.height).toFixed(0)
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
