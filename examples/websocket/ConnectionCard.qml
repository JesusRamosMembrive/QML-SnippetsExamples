// =============================================================================
// ConnectionCard.qml — Tarjeta de configuracion de conexion WebSocket
// =============================================================================
// Componente reutilizable que gestiona la URL del servidor y los controles
// de conectar/desconectar. Sigue el principio de separacion de conceptos:
// esta tarjeta NO conoce al WebSocketClient directamente — solo expone
// propiedades de entrada (connected, statusText) y senales de salida
// (connectClicked, disconnectClicked). El padre (Main.qml) conecta todo.
//
// Patron importante: la propiedad "url" es readonly y apunta al texto
// del TextField. Esto permite que el padre lea la URL actual sin que
// ningun otro componente pueda modificarla directamente.
//
// Aprendizaje clave: el indicador de estado usa una SequentialAnimation
// con bucle infinito para crear un efecto de "pulsacion" durante la
// fase de conexion, dando feedback visual de que algo esta en progreso.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // API publica del componente: propiedades de entrada y senales de salida.
    // Este patron desacopla la tarjeta de la implementacion del WebSocket.
    property bool connected: false
    property string statusText: ""
    readonly property string url: urlField.text

    signal connectClicked()
    signal disconnectClicked()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(10)

        Label {
            text: "Connection"
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        // Campo de URL: se deshabilita cuando ya hay conexion activa
        // para evitar cambios de URL en medio de una sesion.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "URL:"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: urlField
                Layout.fillWidth: true
                text: "wss://echo.websocket.org"
                font.pixelSize: Style.resize(13)
                enabled: !root.connected
                selectByMouse: true
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            // Indicador circular de estado: verde conectado, rojo desconectado.
            // La SequentialAnimation pulsa la opacidad entre 0.3 y 1.0 mientras
            // el statusText contiene "Connecting", creando un efecto visual de
            // "esperando". Cuando la conexion se establece o falla, la animacion
            // se detiene automaticamente porque "running" se re-evalua.
            Rectangle {
                width: Style.resize(12)
                height: Style.resize(12)
                radius: width / 2
                color: root.connected ? "#4CAF50" : "#F44336"

                SequentialAnimation on opacity {
                    running: root.statusText.indexOf("Connecting") >= 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }

            Label {
                text: root.statusText
                font.pixelSize: Style.resize(13)
                color: root.connected ? "#4CAF50" : Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            // Botones mutuamente excluyentes: igual que en CancelTaskCard,
            // el estado "connected" determina cual boton esta activo.
            Button {
                text: "Connect"
                enabled: !root.connected
                onClicked: root.connectClicked()
            }

            Button {
                text: "Disconnect"
                enabled: root.connected
                onClicked: root.disconnectClicked()
            }
        }
    }
}
