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
    clip: true

    Column {
        anchors.centerIn: parent
        spacing: Style.resize(15)
        
        Label {
            text: "Bottom Drawer (BottomSheet)"
            color: "#9B59B6"
            font.pixelSize: Style.resize(20)
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Label {
            text: "Arrastra desde la base hacia arriba.\nMuy útil en interfaces móviles (reproductor musical, acciones)."
            color: Style.fontSecondaryColor
            font.pixelSize: Style.fontSizeS
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Subir Panel"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: bottomDrawer.open()
            
            contentItem: Text {
                text: parent.text
                color: Style.bgColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Style.resize(8)
                color: parent.down ? Qt.darker("#9B59B6", 1.2) : "#9B59B6"
            }
        }
    }

    ContainedDrawer {
        id: bottomDrawer
        edge: Qt.BottomEdge
        sizeRatio: 0.6
        accentColor: "#9B59B6"

        Column {
            anchors.fill: parent
            spacing: Style.resize(15)

            Label {
                text: "Opciones de Elemento"
                font.bold: true
                font.pixelSize: Style.resize(20)
                color: Style.fontPrimaryColor
            }

            Rectangle { width: parent.width; height: 1; color: Style.surfaceColor }

            ItemDelegate {
                width: parent.width
                text: "Compartir enlace"
                icon.name: "share"
                onClicked: bottomDrawer.close()
            }
            ItemDelegate {
                width: parent.width
                text: "Eliminar"
                icon.name: "delete"
                onClicked: bottomDrawer.close()
            }
            ItemDelegate {
                width: parent.width
                text: "Silenciar alertas"
                icon.name: "volume-off"
                onClicked: bottomDrawer.close()
            }
            ItemDelegate {
                width: parent.width
                text: "Cancelar"
                onClicked: bottomDrawer.close()
            }
        }
    }
}
