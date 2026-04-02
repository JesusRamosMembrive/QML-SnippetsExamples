import QtQuick
import QtQuick.Controls

import utils
import qmlsnippetsstyle

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(10)
    border.color: Style.surfaceColor
    border.width: 1
    clip: true // Important to contain the drawer inside the card boundaries

    Column {
        anchors.centerIn: parent
        spacing: Style.resize(15)
        
        Label {
            text: "Left Drawer (Sidebar)"
            color: Style.mainColor
            font.pixelSize: Style.resize(20)
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Label {
            text: "Tira hacia la derecha del borde izquierdo de esta tarjeta\no pulsa el botón."
            color: Style.fontSecondaryColor
            font.pixelSize: Style.fontSizeS
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Abrir Menú Lateral"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: leftDrawer.open()
            
            contentItem: Text {
                text: parent.text
                color: "#FFFFFF"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Style.resize(8)
                color: parent.down ? Qt.darker(Style.mainColor, 1.2) : Style.mainColor
            }
        }
    }

    ContainedDrawer {
        id: leftDrawer
        edge: Qt.LeftEdge
        sizeRatio: 0.6
        accentColor: Style.mainColor

        Column {
            anchors.fill: parent
            spacing: Style.resize(20)

            Label {
                text: "Menu"
                font.bold: true
                font.pixelSize: Style.resize(22)
                color: Style.fontPrimaryColor
            }

            Rectangle { width: parent.width; height: 1; color: Style.surfaceColor }

            Repeater {
                model: ["Perfil", "Ajustes", "Notificaciones", "Cerrar Sesión"]
                ItemDelegate {
                    width: parent.width
                    text: modelData
                    font.pixelSize: Style.resize(16)
                    onClicked: leftDrawer.close()
                }
            }
        }
    }
}
