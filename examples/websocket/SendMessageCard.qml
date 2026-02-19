// =============================================================================
// SendMessageCard.qml — Tarjeta de envio de mensajes WebSocket
// =============================================================================
// Campo de texto con boton de envio. Demuestra dos formas de enviar:
//   1. Presionar Enter (onAccepted del TextField)
//   2. Hacer clic en el boton Send
//
// El componente emite la senal messageSent(string) y limpia el campo
// automaticamente despues del envio. No maneja la logica de red — solo
// captura la intencion del usuario y la comunica al padre via senal.
//
// Aprendizaje clave: tanto el TextField como el Button validan que haya
// texto antes de emitir la senal. El boton ademas requiere conexion
// activa (enabled: root.connected && messageField.text.length > 0),
// dando feedback visual inmediato sobre que acciones estan disponibles.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Propiedades de entrada y senal de salida. El padre vincula "connected"
    // al estado real del WebSocket y escucha "messageSent" para enviar datos.
    property bool connected: false

    signal messageSent(string message)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(10)

        Label {
            text: "Send Message"
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            // TextField con doble mecanismo de envio: onAccepted (tecla Enter)
            // y el boton externo. Ambos limpian el campo despues de enviar
            // para preparar el siguiente mensaje. Se deshabilita si no hay
            // conexion para indicar que no se puede escribir sin servidor.
            TextField {
                id: messageField
                Layout.fillWidth: true
                placeholderText: "Type a message..."
                font.pixelSize: Style.resize(13)
                enabled: root.connected
                selectByMouse: true

                onAccepted: {
                    if (text.length > 0) {
                        root.messageSent(text)
                        text = ""
                    }
                }
            }

            Button {
                text: "Send"
                enabled: root.connected && messageField.text.length > 0
                onClicked: {
                    root.messageSent(messageField.text)
                    messageField.text = ""
                }
            }
        }
    }
}
