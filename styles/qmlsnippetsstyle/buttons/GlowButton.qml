import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    // Propiedades personalizables
    property color glowColor: Style.mainColor
    property real glowIntensity: 0.6
    property real glowRadius: 20

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        // Efecto glow
        Glow {
            anchors.fill: backgroundRect
            source: backgroundRect
            radius: Style.resize(root.glowRadius)
            samples: 17
            color: root.glowColor
            opacity: root.glowIntensity
            visible: root.enabled
        }

        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.pressed ? Qt.darker(root.glowColor, 1.2) : root.glowColor
        }
    }

    contentItem: Text {
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        font.family: Style.fontFamilyRegular
        font.pixelSize: Style.fontSizeM
    }
}
