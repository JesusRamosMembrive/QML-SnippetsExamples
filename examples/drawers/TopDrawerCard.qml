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
            text: "Top Drawer (Notificaciones)"
            color: "#F39C12"
            font.pixelSize: Style.resize(20)
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Label {
            text: "Arrastra desde el borde superior hacia abajo."
            color: Style.fontSecondaryColor
            font.pixelSize: Style.fontSizeS
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Bajar Panel de Opciones"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: topDrawer.open()
            
            contentItem: Text {
                text: parent.text
                color: Style.bgColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Style.resize(8)
                color: parent.down ? Qt.darker("#F39C12", 1.2) : "#F39C12"
            }
        }
    }

    ContainedDrawer {
        id: topDrawer
        edge: Qt.TopEdge
        sizeRatio: 0.45
        accentColor: "#F39C12"

        Row {
            anchors.centerIn: parent
            spacing: Style.resize(30)

            Button {
                text: "WiFi"
                display: AbstractButton.TextUnderIcon
                palette.button: "#F39C12"
                onClicked: topDrawer.close()
            }
            Button {
                text: "Bluetooth"
                display: AbstractButton.TextUnderIcon
                palette.button: "#F39C12"
                onClicked: topDrawer.close()
            }
            Button {
                text: "Silencio"
                display: AbstractButton.TextUnderIcon
                palette.button: "#F39C12"
                onClicked: topDrawer.close()
            }
        }
    }
}
