import QtQuick
import QtQuick.Templates as T
import utils

T.Button {
    id: root

    property color startColor: Style.mainColor
    property color endColor: Qt.lighter(Style.mainColor, 1.3)
    property int gradientOrientation: Gradient.Horizontal

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Rectangle {
        radius: Style.resize(20)
        gradient: Gradient {
            orientation: root.gradientOrientation
            GradientStop { position: 0.0; color: root.startColor }
            GradientStop { position: 1.0; color: root.endColor }
        }
        opacity: root.pressed ? 0.8 : 1.0
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
