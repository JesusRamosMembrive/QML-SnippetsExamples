import QtQuick
import QtQuick.Templates as T

import utils

T.MenuSeparator {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: Style.resize(4)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    contentItem: Rectangle {
        implicitWidth: Style.resize(160)
        implicitHeight: 1
        color: Style.bgColor
    }
}
