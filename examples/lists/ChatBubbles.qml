// =============================================================================
// ChatBubbles.qml — Interfaz de chat con burbujas y entrada de mensajes
// =============================================================================
// Implementa una UI de chat completa con mensajes alineados por emisor:
// los mensajes propios ("isMe") se alinean a la derecha con color de acento,
// y los ajenos a la izquierda con un avatar circular.
//
// Tecnicas clave:
//   1. Alineacion condicional: anchors.right se activa solo si isMe=true,
//      y anchors.left si isMe=false. En QML se usa 'undefined' para
//      desactivar un anchor (ej: anchors.right: isMe ? parent.right : undefined)
//   2. Ancho adaptativo: Math.min(maxWidth, implicitWidth + padding) asegura
//      que las burbujas nunca excedan el 70% del ancho pero se ajusten al
//      texto cuando este es corto.
//   3. Lista con entrada: combina ListView (mensajes) con TextField + Button
//      para enviar nuevos mensajes. chatModel.append() agrega al modelo y
//      positionViewAtEnd() scrollea automaticamente al ultimo mensaje.
//   4. Component.onCompleted: positionViewAtEnd() asegura que al cargar,
//      el chat muestre los mensajes mas recientes (como cualquier app de chat).
//
// El avatar usa sender[0] (primera letra del nombre) como inicial,
// patron comun cuando no hay imagenes de perfil disponibles.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Chat Bubbles"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(400)
        color: Style.bgColor
        radius: Style.resize(8)
        clip: true

        ListModel {
            id: chatModel
            ListElement { text: "Hey! How's the project going?"; isMe: false; sender: "Alice"; time: "10:30" }
            ListElement { text: "Going well! Just finished the animations page."; isMe: true; sender: "Me"; time: "10:31" }
            ListElement { text: "Nice! Did you add the particle system?"; isMe: false; sender: "Alice"; time: "10:32" }
            ListElement { text: "Yes, plus orbital motion, wave bars, Lissajous curves, Newton's cradle, and a Matrix rain effect 🎉"; isMe: true; sender: "Me"; time: "10:33" }
            ListElement { text: "That sounds amazing! Can't wait to see it."; isMe: false; sender: "Alice"; time: "10:34" }
            ListElement { text: "I also added play/pause toggles so it doesn't kill the GPU 😅"; isMe: true; sender: "Me"; time: "10:35" }
            ListElement { text: "Smart move. Performance matters!"; isMe: false; sender: "Alice"; time: "10:36" }
            ListElement { text: "Now working on custom list patterns. This chat is one of them!"; isMe: true; sender: "Me"; time: "10:37" }
        }

        ListView {
            id: chatListView
            anchors.fill: parent
            anchors.margins: Style.resize(10)
            anchors.bottomMargin: Style.resize(52)
            model: chatModel
            clip: true
            spacing: Style.resize(8)
            verticalLayoutDirection: ListView.TopToBottom

            Component.onCompleted: positionViewAtEnd()

            delegate: Item {
                id: chatDelegate
                width: chatListView.width
                height: chatBubble.height + Style.resize(4)

                required property int index
                required property string text
                required property bool isMe
                required property string sender
                required property string time

                // Burbuja: se alinea a derecha (isMe) o izquierda (!isMe).
                // El ancho es el minimo entre 70% del ListView y el ancho
                // natural del texto + padding, para no desperdiciar espacio.
                Rectangle {
                    id: chatBubble
                    anchors.right: chatDelegate.isMe ? parent.right : undefined
                    anchors.left: chatDelegate.isMe ? undefined : parent.left
                    anchors.leftMargin: chatDelegate.isMe ? 0 : Style.resize(36)
                    anchors.rightMargin: chatDelegate.isMe ? 0 : 0

                    width: Math.min(chatListView.width * 0.7,
                           chatText.implicitWidth + Style.resize(30))
                    height: chatContent.height + Style.resize(16)
                    radius: Style.resize(14)
                    color: chatDelegate.isMe ? Style.mainColor : Style.surfaceColor

                    Column {
                        id: chatContent
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(10)
                        spacing: Style.resize(4)

                        Label {
                            id: chatText
                            width: parent.width
                            text: chatDelegate.text
                            font.pixelSize: Style.resize(13)
                            color: chatDelegate.isMe ? "#000" : Style.fontPrimaryColor
                            wrapMode: Text.WordWrap
                        }

                        Label {
                            text: chatDelegate.time
                            font.pixelSize: Style.resize(9)
                            color: chatDelegate.isMe
                                   ? Qt.rgba(0, 0, 0, 0.5)
                                   : Style.inactiveColor
                            anchors.right: parent.right
                        }
                    }
                }

                // Avatar: solo visible para mensajes ajenos (!isMe).
                // Circulo con la inicial del nombre, anclado al pie de la burbuja.
                Rectangle {
                    visible: !chatDelegate.isMe
                    anchors.left: parent.left
                    anchors.bottom: chatBubble.bottom
                    width: Style.resize(28)
                    height: Style.resize(28)
                    radius: width / 2
                    color: "#5B8DEF"

                    Label {
                        anchors.centerIn: parent
                        text: chatDelegate.sender[0]
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: "#FFF"
                    }
                }
            }
        }

        // Barra de entrada: TextField + Button. onAccepted (Enter) y
        // el click del boton ambos invocan la misma logica de envio.
        // chatModel.append() agrega el mensaje y positionViewAtEnd()
        // scrollea al final para mostrar el mensaje nuevo.
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Style.resize(46)
            color: Style.surfaceColor
            radius: Style.resize(8)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                spacing: Style.resize(8)

                TextField {
                    id: chatInput
                    Layout.fillWidth: true
                    placeholderText: "Type a message..."
                    onAccepted: {
                        if (text.trim() !== "") {
                            var now = new Date()
                            var h = now.getHours().toString().padStart(2, '0')
                            var m = now.getMinutes().toString().padStart(2, '0')
                            chatModel.append({
                                text: text.trim(),
                                isMe: true,
                                sender: "Me",
                                time: h + ":" + m
                            })
                            text = ""
                            chatListView.positionViewAtEnd()
                        }
                    }
                }

                Button {
                    text: "Send"
                    onClicked: chatInput.accepted()
                }
            }
        }
    }
}
