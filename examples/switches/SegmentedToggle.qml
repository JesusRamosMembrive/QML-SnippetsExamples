import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Segmented Toggle"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: segmentedItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(50)

        property int selectedSegment: 1

        Rectangle {
            anchors.centerIn: parent
            width: Style.resize(400)
            height: Style.resize(42)
            radius: Style.resize(8)
            color: Style.surfaceColor
            border.color: "#3A3D45"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(3)
                spacing: Style.resize(3)

                Repeater {
                    model: [
                        { text: "\u2600  Light",   idx: 0 },
                        { text: "\uD83C\uDF19  Dark",    idx: 1 },
                        { text: "\u2699  System",  idx: 2 }
                    ]

                    Rectangle {
                        id: segItem
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: segmentedItem.selectedSegment === modelData.idx
                               ? Style.mainColor : "transparent"

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Label {
                            anchors.centerIn: parent
                            text: segItem.modelData.text
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: segmentedItem.selectedSegment === segItem.modelData.idx
                                   ? "#1A1D23" : Style.fontSecondaryColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: segmentedItem.selectedSegment = segItem.modelData.idx
                        }
                    }
                }
            }
        }
    }
}
