import QtQuick
import QtQuick.Templates as T

import utils

T.RangeSlider {
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
            x: root.orientation === Qt.Horizontal ? (root.first.visualPosition * parent.width) : 0
            y: root.orientation === Qt.Vertical ? (root.first.visualPosition * parent.height) : 0
            width: root.orientation === Qt.Horizontal
                   ? ((root.second.visualPosition - root.first.visualPosition) * parent.width)
                   : parent.width
            height: root.orientation === Qt.Vertical
                    ? ((root.second.visualPosition - root.first.visualPosition) * parent.height)
                    : parent.height
            color: Style.mainColor
            radius: Style.resize(20)
        }
    }

    first.handle: Rectangle {
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        x: root.orientation === Qt.Horizontal
           ? (root.first.visualPosition * (root.width - calcDim))
           : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical
           ? (root.first.visualPosition * (root.height - calcDim))
           : ((root.height - calcDim) / 2)
        radius: (width / 2)
        color: root.first.pressed ? Qt.lighter(Style.mainColor, 1.3) : Style.mainColor
    }

    second.handle: Rectangle {
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        x: root.orientation === Qt.Horizontal
           ? (root.second.visualPosition * (root.width - calcDim))
           : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical
           ? (root.second.visualPosition * (root.height - calcDim))
           : ((root.height - calcDim) / 2)
        radius: (width / 2)
        color: root.second.pressed ? Qt.lighter(Style.mainColor, 1.3) : Style.mainColor
    }
}
