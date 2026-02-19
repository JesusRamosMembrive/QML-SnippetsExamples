import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedIndex: -1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Photo Gallery"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: photoGrid
                anchors.fill: parent
                clip: true
                cellWidth: width / 3
                cellHeight: cellWidth

                model: ListModel {
                    id: photoModel
                    ListElement { icon: "\u2600"; clr: "#FEA601"; title: "Sunset" }
                    ListElement { icon: "\u2605"; clr: "#AB47BC"; title: "Stars" }
                    ListElement { icon: "\u2663"; clr: "#66BB6A"; title: "Nature" }
                    ListElement { icon: "\u2708"; clr: "#4FC3F7"; title: "Travel" }
                    ListElement { icon: "\u266B"; clr: "#EC407A"; title: "Music" }
                    ListElement { icon: "\u2764"; clr: "#FF7043"; title: "Love" }
                    ListElement { icon: "\u26A1"; clr: "#FEA601"; title: "Energy" }
                    ListElement { icon: "\u2602"; clr: "#4FC3F7"; title: "Rain" }
                    ListElement { icon: "\u263A"; clr: "#00D1A9"; title: "Happy" }
                }

                delegate: Item {
                    id: photoDelegate
                    required property string icon
                    required property string clr
                    required property string title
                    required property int index
                    width: photoGrid.cellWidth
                    height: photoGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(8)
                        color: photoDelegate.clr
                        opacity: root.selectedIndex === photoDelegate.index ? 1.0 : 0.7
                        scale: root.selectedIndex === photoDelegate.index ? 1.05 : 1.0

                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        Behavior on scale { NumberAnimation { duration: 150 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(2)

                            Label {
                                text: photoDelegate.icon
                                font.pixelSize: Style.resize(28)
                                color: "#FFFFFF"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: photoDelegate.title
                                font.pixelSize: Style.resize(10)
                                font.bold: true
                                color: "#FFFFFF"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.selectedIndex = photoDelegate.index
                        }
                    }
                }
            }
        }

        Label {
            text: root.selectedIndex >= 0
                  ? photoModel.get(root.selectedIndex).title
                  : "Tap a photo to select"
            font.pixelSize: Style.resize(13)
            font.bold: root.selectedIndex >= 0
            color: root.selectedIndex >= 0
                   ? photoModel.get(root.selectedIndex).clr
                   : Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
