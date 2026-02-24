// =============================================================================
// InteractiveChatCard.qml — Tarjeta de ejemplo: chat interactivo con bot
// =============================================================================
// Chat funcional donde el usuario escribe mensajes y un bot simulado responde
// tras un retardo aleatorio. Incluye cabecera con estado del bot, indicador
// de escritura animado y campo de entrada con envio por Enter o boton.
//
// Patrones clave para el aprendiz:
// - Timer con intervalo aleatorio (1000 + Math.random() * 1500) para simular
//   latencia de red y hacer el bot mas creible.
// - ListModel.insert(0, ...) para agregar mensajes al inicio del modelo,
//   combinado con BottomToTop para que aparezcan naturalmente abajo.
// - Separacion de logica en funcion sendMessage(): encapsula la creacion
//   del mensaje, limpieza del input y activacion del bot en un solo lugar.
// - onAccepted en TextField para enviar con Enter, ademas del boton.
// - Indicador de escritura con animacion de desvanecimiento en 3 puntos,
//   visible solo mientras botTyping es true.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Estado del bot: controla la visibilidad del indicador de escritura
    // y deshabilita el boton de envio mientras el bot "responde".
    property bool botTyping: false

    // Respuestas predefinidas del bot: se elige una al azar con Math.random().
    readonly property list<string> botResponses: [
        "That's interesting! Tell me more.",
        "I'm just a demo bot, but thanks!",
        "QML is awesome, isn't it?",
        "Have you tried the PathView page?",
        "Keep coding, you're doing great!",
        "That's a great question!",
        "I agree! Qt is very powerful.",
        "Let me think about that..."
    ]

    // Funcion centralizada de envio: valida texto, inserta en el modelo,
    // limpia el input y activa el temporizador de respuesta del bot.
    function sendMessage(text) {
        if (!text.trim()) return
        var time = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
        chatModel.insert(0, { msg: text.trim(), sent: true, time: time })
        msgInput.text = ""

        // Bot reply after delay
        root.botTyping = true
        botTimer.start()
    }

    // Timer de respuesta del bot: el intervalo aleatorio (1-2.5 seg) simula
    // un retardo de "pensamiento". Al dispararse, inserta la respuesta y
    // desactiva el indicador de escritura.
    Timer {
        id: botTimer
        interval: 1000 + Math.random() * 1500
        onTriggered: {
            root.botTyping = false
            var time = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
            var reply = root.botResponses[Math.floor(Math.random() * root.botResponses.length)]
            chatModel.insert(0, { msg: reply, sent: false, time: time })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        // -----------------------------------------------------------------
        // Cabecera del chat: avatar circular, nombre del bot y estado
        // ("typing..." u "online") con colores dinamicos.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Rectangle {
                width: Style.resize(32)
                height: Style.resize(32)
                radius: Style.resize(16)
                color: "#4FC3F7"

                Label {
                    anchors.centerIn: parent
                    text: "B"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: "#FFFFFF"
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Label {
                    text: "Chat Bot"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Label {
                    text: root.botTyping ? "typing..." : "online"
                    font.pixelSize: Style.resize(10)
                    color: root.botTyping ? "#FEA601" : "#00D1A9"
                }
            }

            Label {
                text: chatModel.count + " msgs"
                font.pixelSize: Style.resize(10)
                color: Style.inactiveColor
            }
        }

        // -----------------------------------------------------------------
        // Area de mensajes: ListView BottomToTop con ListModel dinamico.
        // El modelo empieza con un mensaje de bienvenida del bot.
        // Se usa insert(0, ...) para agregar nuevos mensajes al inicio,
        // que gracias a BottomToTop aparecen visualmente abajo.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ListView {
                id: chatList
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                spacing: Style.resize(6)
                verticalLayoutDirection: ListView.BottomToTop

                model: ListModel {
                    id: chatModel
                    ListElement { msg: "Hi! I'm a demo chat bot. Send me a message!"; sent: false; time: "now" }
                }

                delegate: Item {
                    id: chatDelegate
                    required property string msg
                    required property bool sent
                    required property string time
                    width: chatList.width
                    height: chatBubble.height + Style.resize(2)

                    Rectangle {
                        id: chatBubble
                        anchors.left: chatDelegate.sent ? undefined : parent.left
                        anchors.right: chatDelegate.sent ? parent.right : undefined
                        width: Math.min(parent.width * 0.8, bubbleText.implicitWidth + Style.resize(24))
                        height: bubbleText.height + timeLabel.height + Style.resize(18)
                        radius: Style.resize(12)
                        color: chatDelegate.sent ? "#00D1A9" : "#2A2D35"

                        Label {
                            id: bubbleText
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Style.resize(8)
                            text: chatDelegate.msg
                            font.pixelSize: Style.resize(12)
                            color: chatDelegate.sent ? "#000000" : "#FFFFFF"
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            id: timeLabel
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: Style.resize(6)
                            text: chatDelegate.time
                            font.pixelSize: Style.resize(8)
                            color: chatDelegate.sent ? "#00000050" : "#FFFFFF50"
                        }
                    }
                }
            }

            // Indicador de escritura del bot: 3 puntos con animacion de
            // desvanecimiento escalonado. Solo visible cuando botTyping es true.
            Rectangle {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: Style.resize(8)
                width: Style.resize(55)
                height: Style.resize(28)
                radius: Style.resize(14)
                color: "#2A2D35"
                visible: root.botTyping

                Row {
                    anchors.centerIn: parent
                    spacing: Style.resize(4)

                    Repeater {
                        model: 3
                        Rectangle {
                            required property int index
                            width: Style.resize(7)
                            height: Style.resize(7)
                            radius: Style.resize(3.5)
                            color: "#4FC3F7"

                            SequentialAnimation on opacity {
                                running: root.botTyping
                                loops: Animation.Infinite
                                PauseAnimation { duration: index * 200 }
                                NumberAnimation { from: 0.3; to: 1.0; duration: 300 }
                                NumberAnimation { from: 1.0; to: 0.3; duration: 300 }
                                PauseAnimation { duration: (2 - index) * 200 }
                            }
                        }
                    }
                }
            }
        }

        // -----------------------------------------------------------------
        // Area de entrada: TextField + boton de envio. onAccepted permite
        // enviar con Enter. El boton se deshabilita si el texto esta vacio
        // o el bot esta escribiendo, evitando spam de mensajes.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            TextField {
                id: msgInput
                Layout.fillWidth: true
                placeholderText: "Type a message..."
                font.pixelSize: Style.resize(12)
                onAccepted: root.sendMessage(text)
            }

            Button {
                text: "\u2B9E"
                font.pixelSize: Style.resize(16)
                enabled: msgInput.text.trim().length > 0 && !root.botTyping
                onClicked: root.sendMessage(msgInput.text)
            }
        }
    }
}
