// =============================================================================
// ChatBubblesCard.qml — Tarjeta de ejemplo: burbujas de chat estaticas
// =============================================================================
// Muestra un historial de chat con burbujas alineadas a izquierda (recibidas)
// y derecha (enviadas), un avatar circular para mensajes entrantes y marcas
// de hora en cada burbuja.
//
// Patrones clave para el aprendiz:
// - ListView con verticalLayoutDirection: BottomToTop para que los mensajes
//   mas recientes aparezcan abajo (como en apps de mensajeria reales).
// - required property en delegates para acceso seguro a datos del modelo.
// - Uso de Math.min() para limitar el ancho de la burbuja al 75% del
//   espacio disponible, evitando burbujas demasiado anchas.
// - Colores condicionales (ternario) segun si el mensaje fue enviado o
//   recibido, patron comun en interfaces de chat.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Chat Bubbles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Area de chat: un Rectangle oscuro como fondo con un ListView
        // que muestra mensajes de abajo hacia arriba (BottomToTop).
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ListView {
                id: bubbleList
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                clip: true
                spacing: Style.resize(8)
                // BottomToTop hace que el indice 0 aparezca abajo,
                // imitando el scroll natural de apps de mensajeria.
                verticalLayoutDirection: ListView.BottomToTop

                // Modelo estatico con datos de ejemplo para demostrar
                // el layout. En una app real, esto seria un modelo C++
                // o datos de red.
                model: ListModel {
                    ListElement { msg: "Hey! How's the Qt project going?"; sent: false; time: "10:30" }
                    ListElement { msg: "Great! Just finished the PathView page"; sent: true; time: "10:31" }
                    ListElement { msg: "Nice! How many pages total now?"; sent: false; time: "10:31" }
                    ListElement { msg: "45 and counting! Working on showcases now"; sent: true; time: "10:32" }
                    ListElement { msg: "That's impressive! Any favorites?"; sent: false; time: "10:33" }
                    ListElement { msg: "The traffic light state machine is fun"; sent: true; time: "10:33" }
                    ListElement { msg: "Sounds cool, I'll check it out!"; sent: false; time: "10:34" }
                }

                delegate: Item {
                    id: bubbleDelegate
                    required property string msg
                    required property bool sent
                    required property string time
                    required property int index
                    width: bubbleList.width
                    height: bubble.height + Style.resize(4)

                    // Avatar circular: solo visible en mensajes recibidos.
                    // Se ancla a la parte inferior de la burbuja para
                    // alinearse visualmente con la ultima linea del texto.
                    Rectangle {
                        id: avatar
                        width: Style.resize(28)
                        height: Style.resize(28)
                        radius: Style.resize(14)
                        color: "#4FC3F7"
                        visible: !bubbleDelegate.sent
                        anchors.left: parent.left
                        anchors.bottom: bubble.bottom

                        Label {
                            anchors.centerIn: parent
                            text: "A"
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }

                    // Burbuja del mensaje: se ancla a la derecha si fue
                    // enviado, o a la izquierda (junto al avatar) si fue
                    // recibido. El ancho se limita al 75% para legibilidad.
                    Rectangle {
                        id: bubble
                        width: Math.min(bubbleDelegate.width * 0.75,
                                        msgLabel.implicitWidth + Style.resize(16))
                        height: msgLabel.height + timeLabel.height + Style.resize(18)
                        radius: Style.resize(12)
                        color: bubbleDelegate.sent ? "#00D1A9" : "#2A2D35"
                        anchors.left: bubbleDelegate.sent ? undefined : (avatar.visible ? avatar.right : parent.left)
                        anchors.leftMargin: avatar.visible ? Style.resize(6) : 0
                        anchors.right: bubbleDelegate.sent ? parent.right : undefined

                        Label {
                            id: msgLabel
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Style.resize(8)
                            text: bubbleDelegate.msg
                            font.pixelSize: Style.resize(12)
                            color: bubbleDelegate.sent ? "#000000" : "#FFFFFF"
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            id: timeLabel
                            anchors.top: msgLabel.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: Style.resize(8)
                            anchors.topMargin: Style.resize(2)
                            text: bubbleDelegate.time
                            font.pixelSize: Style.resize(9)
                            color: bubbleDelegate.sent ? "#00000060" : "#FFFFFF60"
                        }
                    }
                }
            }
        }
    }
}
