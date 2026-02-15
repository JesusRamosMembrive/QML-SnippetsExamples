import QtQuick
import QtQuick.Templates as T

import utils

T.Slider {
    id: root

    implicitWidth: root.orientation === Qt.Horizontal ? Style.resize(270) : Style.resize(20)
    implicitHeight: root.orientation === Qt.Horizontal ? Style.resize(20) : Style.resize(270)

    background: Rectangle {
        width: root.orientation === Qt.Horizontal ? parent.width : (parent.width / 4)
        height: root.orientation === Qt.Horizontal ? (parent.height / 4) : parent.height
        anchors.verticalCenter: root.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.orientation === Qt.Vertical ? parent.horizontalCenter : undefined
        radius: Style.resize(20)
        color: Style.inactiveColor
        Rectangle {
            width: root.orientation === Qt.Horizontal ? (root.visualPosition * parent.width) : parent.width
            height: root.orientation === Qt.Horizontal ? parent.height : (root.visualPosition * parent.height)
            color: Style.mainColor
            radius: Style.resize(20)
            anchors.top: root.orientation === Qt.Vertical ? parent.top : undefined
        }
    }

    handle: Rectangle {
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        anchors.verticalCenter: root.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.orientation === Qt.Vertical ? parent.horizontalCenter : undefined
        x: root.orientation === Qt.Horizontal ? (root.visualPosition * (root.width - calcDim)) : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical ? (root.visualPosition * (root.height - calcDim)) : 0
        radius: (width / 2)
        color: Style.mainColor
    }
}
