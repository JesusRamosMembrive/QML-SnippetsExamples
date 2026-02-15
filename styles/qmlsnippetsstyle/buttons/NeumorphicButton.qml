import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    property color baseColor: Style.bgColor
    property real shadowDistance: 10
    property real shadowBlur: 20

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        // Sombra externa (luz desde arriba-izquierda)
        DropShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: -Style.resize(root.shadowDistance)
            verticalOffset: -Style.resize(root.shadowDistance)
            radius: Style.resize(root.shadowBlur)
            samples: 17
            color: Qt.lighter(root.baseColor, 1.3)
            visible: !root.pressed
        }

        // Sombra externa (oscura desde abajo-derecha)
        DropShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: Style.resize(root.shadowDistance)
            verticalOffset: Style.resize(root.shadowDistance)
            radius: Style.resize(root.shadowBlur)
            samples: 17
            color: Qt.darker(root.baseColor, 1.3)
            visible: !root.pressed
        }

        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.baseColor
        }

        // Sombra interna cuando está presionado
        InnerShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: Style.resize(root.shadowDistance / 2)
            verticalOffset: Style.resize(root.shadowDistance / 2)
            radius: Style.resize(root.shadowBlur / 2)
            samples: 17
            color: Qt.darker(root.baseColor, 1.5)
            visible: root.pressed
        }
    }

    contentItem: Text {
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Style.mainColor
        font.family: Style.fontFamilyRegular
        font.pixelSize: Style.fontSizeM
    }
}
