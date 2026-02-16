import QtQuick
import QtQuick.Templates as T

import utils

T.CheckBox {
    id: root

    implicitWidth: Style.resize(120)
    implicitHeight: Style.resize(50)
    icon.color: Style.mainColor

    indicator: Rectangle {
        id: indicatorRect
        width: root.height * 0.6
        height: root.height * 0.6
        anchors.verticalCenter: parent.verticalCenter
        radius: Style.resize(4)
        color: root.checked || root.checkState === Qt.PartiallyChecked ? root.icon.color : "transparent"
        border.width: Style.resize(2)
        border.color: root.checked || root.checkState === Qt.PartiallyChecked ? root.icon.color : Style.inactiveColor

        Text {
            anchors.centerIn: parent
            text: root.checkState === Qt.PartiallyChecked ? "\u2013" : "\u2713"
            color: "white"
            font.pixelSize: indicatorRect.height * 0.7
            font.bold: true
            visible: root.checked || root.checkState === Qt.PartiallyChecked
        }
    }

    contentItem: Item {
        width: (parent.width - indicatorRect.width - Style.resize(10))
        height: parent.height
        anchors.left: indicatorRect.right
        anchors.leftMargin: Style.resize(10)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            color: root.checked ? root.icon.color : Style.inactiveColor
            text: root.text
        }
    }
}
