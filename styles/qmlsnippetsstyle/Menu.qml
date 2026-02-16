import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Menu {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Style.resize(4)

    delegate: MenuItem {}

    contentItem: ListView {
        implicitHeight: contentHeight
        model: root.contentModel
        interactive: Window.window
                     ? contentHeight + root.topPadding + root.bottomPadding > Window.window.height
                     : false
        clip: true
        currentIndex: root.currentIndex
    }

    background: Rectangle {
        implicitWidth: Style.resize(180)
        color: "white"
        radius: Style.resize(8)
        border.color: Style.bgColor
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: Style.resize(4)
            radius: Style.resize(12)
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 100 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 80 }
    }
}
