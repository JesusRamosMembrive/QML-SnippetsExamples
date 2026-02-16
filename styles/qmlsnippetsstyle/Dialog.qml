import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Layouts

import utils

T.Dialog {
    id: root

    implicitWidth: Style.resize(400)
    implicitHeight: contentHeight + header.implicitHeight + footer.implicitHeight
                    + topPadding + bottomPadding

    padding: Style.resize(20)
    topPadding: Style.resize(10)

    parent: Overlay.overlay
    anchors.centerIn: parent

    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        color: "white"
        radius: Style.resize(12)
        border.color: Style.bgColor
        border.width: 1
    }

    header: Rectangle {
        color: "transparent"
        implicitHeight: Style.resize(48)
        radius: Style.resize(12)

        Label {
            anchors.left: parent.left
            anchors.leftMargin: Style.resize(20)
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Style.bgColor
        }
    }

    footer: DialogButtonBox {
        visible: count > 0
    }

    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }
}
