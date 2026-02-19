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
            text: "Basic ScrollView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Vertical scrollable content"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                contentWidth: availableWidth

                ColumnLayout {
                    width: parent.width
                    spacing: Style.resize(6)

                    Repeater {
                        model: 25
                        Rectangle {
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(32)
                            radius: Style.resize(4)
                            color: index % 2 === 0 ? Style.surfaceColor : Style.cardColor

                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: Style.resize(10)
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Item " + (index + 1)
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                            }
                        }
                    }
                }
            }
        }
    }
}
