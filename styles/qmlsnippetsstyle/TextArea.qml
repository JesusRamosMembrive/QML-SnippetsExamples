import QtQuick
import QtQuick.Templates as T

import utils

T.TextArea {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(120)

    color: Style.fontPrimaryColor
    placeholderTextColor: Style.inactiveColor
    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS
    selectionColor: Style.mainColor
    selectedTextColor: "white"
    wrapMode: TextArea.Wrap

    padding: Style.resize(12)

    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        border.color: root.activeFocus ? Style.mainColor
                      : root.hovered ? Qt.lighter(Style.inactiveColor, 1.2)
                      : Style.inactiveColor

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }
}
