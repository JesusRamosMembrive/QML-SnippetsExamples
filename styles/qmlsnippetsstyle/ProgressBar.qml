import QtQuick
import QtQuick.Templates as T

import utils

T.ProgressBar {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(8)

    background: Rectangle {
        width: root.width
        height: root.height
        radius: height / 2
        color: Style.bgColor
    }

    contentItem: Item {
        clip: true

        Rectangle {
            id: fillRect
            width: root.indeterminate ? parent.width * 0.3 : parent.width * root.position
            height: parent.height
            radius: height / 2
            color: Style.mainColor

            Behavior on width {
                enabled: !root.indeterminate
                NumberAnimation { duration: 150 }
            }
        }

        SequentialAnimation {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite

            NumberAnimation {
                target: fillRect
                property: "x"
                from: -fillRect.width
                to: root.width
                duration: 1200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
