import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    property color pulseColor: Style.mainColor
    property int pulseDuration: 1500

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        Rectangle {
            id: pulseCircle
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: height / 2
            color: "transparent"
            border.color: root.pulseColor
            border.width: Style.resize(2)
            opacity: 0

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: root.enabled && !root.pressed
                NumberAnimation { to: 1; duration: root.pulseDuration / 2 }
                NumberAnimation { to: 0; duration: root.pulseDuration / 2 }
            }

            SequentialAnimation on scale {
                loops: Animation.Infinite
                running: root.enabled && !root.pressed
                NumberAnimation { from: 1; to: 1.3; duration: root.pulseDuration / 2 }
                NumberAnimation { from: 1.3; to: 1; duration: root.pulseDuration / 2 }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.pressed ? Qt.darker(root.pulseColor, 1.2) : root.pulseColor
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
