import QtQuick
import QtQuick.Templates as T

import utils

T.SpinBox {
    id: root

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS
    editable: false

    leftPadding: Style.resize(40)
    rightPadding: Style.resize(40)

    contentItem: TextInput {
        text: root.textFromValue(root.value, root.locale)
        font: root.font
        color: Style.fontPrimaryColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !root.editable
        validator: root.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Rectangle {
        x: root.mirrored ? 0 : parent.width - width
        implicitWidth: Style.resize(36)
        implicitHeight: Style.resize(40)
        height: parent.height
        width: Style.resize(36)
        radius: Style.resize(8)
        color: root.up.pressed ? Style.mainColor : "transparent"
        border.color: Style.inactiveColor
        border.width: Style.resize(1)

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Text {
            anchors.centerIn: parent
            text: "+"
            font.pixelSize: Style.fontSizeM
            font.bold: true
            color: root.up.pressed ? "white" : Style.mainColor
        }
    }

    down.indicator: Rectangle {
        x: root.mirrored ? parent.width - width : 0
        implicitWidth: Style.resize(36)
        implicitHeight: Style.resize(40)
        height: parent.height
        width: Style.resize(36)
        radius: Style.resize(8)
        color: root.down.pressed ? Style.mainColor : "transparent"
        border.color: Style.inactiveColor
        border.width: Style.resize(1)

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Text {
            anchors.centerIn: parent
            text: "\u2013"
            font.pixelSize: Style.fontSizeM
            font.bold: true
            color: root.down.pressed ? "white" : Style.mainColor
        }
    }

    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        border.color: root.activeFocus ? Style.mainColor : Style.inactiveColor
    }
}
