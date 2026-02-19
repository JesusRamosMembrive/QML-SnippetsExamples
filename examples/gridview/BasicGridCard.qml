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
            text: "Basic GridView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Click cells to select"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: gridView
                anchors.fill: parent
                clip: true
                cellWidth: Style.resize(70)
                cellHeight: Style.resize(70)
                model: 24

                highlight: Rectangle {
                    color: Style.mainColor
                    opacity: 0.3
                    radius: Style.resize(6)
                }
                highlightFollowsCurrentItem: true

                delegate: Item {
                    id: gridDelegate
                    required property int index
                    width: gridView.cellWidth
                    height: gridView.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(6)
                        color: Qt.hsla(gridDelegate.index / 24.0, 0.6, 0.45, 1.0)
                        scale: gridView.currentIndex === gridDelegate.index ? 1.05 : 1.0

                        Behavior on scale { NumberAnimation { duration: 150 } }

                        Label {
                            anchors.centerIn: parent
                            text: (gridDelegate.index + 1).toString()
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: gridView.currentIndex = gridDelegate.index
                        }
                    }
                }
            }
        }

        Label {
            text: "Selected: cell " + (gridView.currentIndex + 1)
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
