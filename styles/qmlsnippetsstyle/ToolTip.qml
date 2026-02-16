import QtQuick
import QtQuick.Templates as T

import utils

T.ToolTip {
    id: root

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: parent ? -implicitHeight - Style.resize(4) : 0

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Style.resize(8)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
                 | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Text {
        text: root.text
        font.pixelSize: Style.resize(12)
        color: "#FFFFFF"
        wrapMode: Text.WordWrap
    }

    background: Rectangle {
        color: "#333333"
        radius: Style.resize(6)
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 120 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 80 }
    }
}
