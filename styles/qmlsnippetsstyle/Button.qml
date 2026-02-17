import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Button {
    id: root
    implicitWidth: Style.resize(120)
    implicitHeight: Style.resize(40)

    palette.button: Style.mainColor
    palette.buttonText: Style.fontContrastColor

    readonly property color __bgColor: {
        if (!root.enabled)
            return Style.inactiveColor
        if (root.flat) {
            if (root.pressed)
                return Qt.rgba(root.palette.button.r, root.palette.button.g, root.palette.button.b, 0.2)
            if (root.hovered)
                return Qt.rgba(root.palette.button.r, root.palette.button.g, root.palette.button.b, 0.1)
            return "transparent"
        }
        if (root.pressed)
            return Qt.darker(root.palette.button, 1.2)
        if (root.hovered)
            return Qt.lighter(root.palette.button, 1.1)
        if (root.highlighted)
            return Qt.lighter(root.palette.button, 1.15)
        return root.palette.button
    }

    readonly property color __textColor: {
        if (!root.enabled)
            return root.flat ? Style.inactiveColor : root.palette.buttonText
        if (root.flat)
            return root.palette.button
        return root.palette.buttonText
    }

    background: Item {
        anchors.fill: parent
        DropShadow {
            anchors.fill: backgroundFill
            visible: !root.flat
            verticalOffset: root.highlighted ? Style.resize(4) : Style.resize(3)
            radius: root.highlighted ? Style.resize(12) : Style.resize(8)
            samples: 17
            color: root.highlighted ? "#90000000" : "#80000000"
            source: backgroundFill
        }
        Rectangle {
            id: backgroundFill
            anchors.fill: parent
            radius: Style.resize(30)
            color: root.__bgColor
        }
    }

    contentItem: Item {
        anchors.fill: parent
        Label {
            anchors.centerIn: parent
            color: root.__textColor
            text: root.text
            font.bold: root.highlighted
        }
    }
}
