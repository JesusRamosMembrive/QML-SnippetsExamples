import QtQuick
import QtQuick.Templates as T

import utils

T.TextField {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(40)

    color: Style.fontPrimaryColor
    placeholderTextColor: Style.inactiveColor
    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS
    selectionColor: Style.mainColor
    selectedTextColor: "white"

    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)
    verticalAlignment: TextInput.AlignVCenter

    background: Rectangle {
        radius: Style.resize(8)
        color: "white"
        border.width: Style.resize(2)
        border.color: root.activeFocus ? Style.mainColor
                      : root.hovered ? Qt.lighter(Style.inactiveColor, 1.2)
                      : Style.inactiveColor

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }
}
