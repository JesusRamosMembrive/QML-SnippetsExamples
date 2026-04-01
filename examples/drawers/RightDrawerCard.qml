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
            text: "Right Drawer (Filtros/Info)"
            color: "#3498DB"
            font.pixelSize: Style.resize(20)
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Label {
            text: "Este Drawer se ancla a la derecha.\nUsado típicamente para paneles de control secundarios."
            color: Style.fontSecondaryColor
            font.pixelSize: Style.fontSizeS
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Abrir Filtros"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: rightDrawer.open()
            
            contentItem: Text {
                text: parent.text
                color: "#FFFFFF"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Style.resize(8)
                color: parent.down ? Qt.darker("#3498DB", 1.2) : "#3498DB"
            }
        }
    }

    Drawer {
        id: rightDrawer
        parent: root
        edge: Qt.RightEdge
        width: parent.width * 0.7
        height: parent.height
        
        interactive: true
        modal: true

        background: Rectangle {
            color: Style.bgColor
            border.color: Style.surfaceColor
            border.width: 1
            
            Rectangle {
                width: 4
                height: parent.height
                anchors.left: parent.left
                color: "#3498DB"
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(15)

            Label {
                text: "Filtros de Búsqueda"
                font.bold: true
                font.pixelSize: Style.resize(20)
                color: Style.fontPrimaryColor
            }

            Rectangle { width: parent.width; height: 1; color: Style.surfaceColor }

            Switch { text: "Mostrar Inactivos" }
            Switch { text: "Ordenar Alfabéticamente" }
            Switch { text: "Ocultar Sistema" }
            
            Item { width: 1; height: Style.resize(20) } // Spacer
            
            Button {
                text: "Aplicar y Cerrar"
                width: parent.width
                onClicked: rightDrawer.close()
            }
        }
    }
}
