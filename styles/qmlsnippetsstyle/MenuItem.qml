import QtQuick
import QtQuick.Templates as T

import utils

T.MenuItem {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             indicator ? indicator.implicitHeight + topPadding + bottomPadding : 0)

    padding: Style.resize(8)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    contentItem: Text {
        leftPadding: root.checkable ? root.indicator.width + root.spacing : 0
        text: root.text
        font.pixelSize: Style.resize(14)
        color: root.enabled ? (root.highlighted ? Style.mainColor : "#333") : Style.inactiveColor
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        x: Style.resize(8)
        y: root.topPadding + (root.availableHeight - height) / 2
        width: Style.resize(16)
        height: Style.resize(16)
        radius: Style.resize(3)
        visible: root.checkable
        color: "transparent"
        border.color: root.checked ? Style.mainColor : Style.inactiveColor
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "\u2713"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
            visible: root.checked
        }
    }

    background: Rectangle {
        implicitWidth: Style.resize(170)
        implicitHeight: Style.resize(36)
        radius: Style.resize(4)
        color: root.highlighted ? Style.bgColor : "transparent"
    }
}
