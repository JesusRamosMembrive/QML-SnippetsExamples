import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.ComboBox {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(40)

    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS

    indicator: Label {
        anchors.right: parent.right
        anchors.rightMargin: Style.resize(12)
        anchors.verticalCenter: parent.verticalCenter
        text: "\u25BE"
        color: Style.mainColor
        font.pixelSize: Style.fontSizeM
    }

    contentItem: Text {
        leftPadding: Style.resize(12)
        rightPadding: Style.resize(30)
        text: root.displayText
        font: root.font
        color: Style.fontPrimaryColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        border.color: root.pressed || root.popup.visible ? Style.mainColor : Style.inactiveColor

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }

    delegate: T.ItemDelegate {
        width: root.width
        height: Style.resize(36)
        contentItem: Text {
            text: root.textRole ? (Array.isArray(root.model) ? modelData : model[root.textRole]) : modelData
            font.family: Style.fontFamilyRegular
            font.pixelSize: Style.fontSizeS
            color: highlighted ? Style.mainColor : Style.fontPrimaryColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: Style.resize(12)
        }
        highlighted: root.highlightedIndex === index
        background: Rectangle {
            color: highlighted ? Style.bgColor : Style.cardColor
        }
    }

    popup: T.Popup {
        y: root.height + Style.resize(4)
        width: root.width
        implicitHeight: contentItem.implicitHeight + Style.resize(4)
        padding: Style.resize(2)

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
        }

        background: Rectangle {
            radius: Style.resize(8)
            color: Style.cardColor
            border.width: Style.resize(1)
            border.color: Style.inactiveColor

            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: Style.resize(3)
                radius: Style.resize(8)
                samples: 17
                color: "#40000000"
            }
        }
    }
}
