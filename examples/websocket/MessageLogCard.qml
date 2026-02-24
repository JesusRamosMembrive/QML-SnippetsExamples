// =============================================================================
// MessageLogCard.qml — Tarjeta de historial de mensajes WebSocket
// =============================================================================
// Muestra un log en tiempo real de todos los mensajes enviados, recibidos y
// errores. Cada entrada tiene timestamp, indicador de direccion, texto y
// una etiqueta de tipo coloreada (sent/echo/error).
//
// El delegate del ListView es un ejemplo completo de como disenar filas
// complejas con multiples elementos alineados en un RowLayout: timestamp
// monoespaciado a la izquierda, flecha de direccion, texto con elide, y
// badge de estado a la derecha.
//
// Patron de colores por direccion: teal para enviados, azul para recibidos,
// rojo para errores. Los fondos de los badges usan colores oscuros (#1B3A2A)
// con texto brillante para mantener contraste en el tema oscuro.
//
// Aprendizaje clave: el modelo (logModel) viene del padre como propiedad
// var, permitiendo que Main.qml sea el unico que lo manipula. Este
// componente es puramente de lectura/presentacion.
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

    // logModel viene inyectado por el padre (Main.qml).
    // Se usa "var" porque ListModel no tiene un tipo QML importable
    // como propiedad tipada.
    property var logModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(10)

        // Cabecera con titulo, contador de mensajes y boton de limpiar.
        // El operador ternario con "? root.logModel.count : 0" protege
        // contra el caso donde logModel aun no ha sido asignado.
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Message Log"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            Label {
                text: (root.logModel ? root.logModel.count : 0) + " messages"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Button {
                text: "Clear"
                enabled: root.logModel ? root.logModel.count > 0 : false
                onClicked: root.logModel.clear()
            }
        }

        // ListView que muestra el historial. clip: true es esencial para
        // que los items no se dibujen fuera del area visible del ListView.
        ListView {
            id: logView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.logModel
            clip: true
            spacing: Style.resize(2)

            // Delegate: cada fila representa un mensaje. La alternancia de
            // color de fondo (index % 2) mejora la legibilidad en listas
            // densas, un patron comun en interfaces tipo log/terminal.
            delegate: Rectangle {
                width: logView.width
                height: Style.resize(32)
                color: index % 2 === 0 ? Style.surfaceColor : Style.cardColor
                radius: Style.resize(4)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    spacing: Style.resize(10)

                    // Timestamp en fuente monoespaciada para alinear
                    // visualmente todas las horas
                    Label {
                        text: model.time
                        font.pixelSize: Style.resize(12)
                        font.family: "Courier New"
                        color: Style.fontSecondaryColor
                        Layout.preferredWidth: Style.resize(65)
                    }

                    // Flecha de direccion: unicode para flechas y advertencia.
                    // El color diferenciado ayuda a escanear rapidamente
                    // el tipo de mensaje sin leer el texto.
                    Label {
                        text: model.direction === "sent" ? "\u2192" :
                              model.direction === "received" ? "\u2190" : "\u26A0"
                        font.pixelSize: Style.resize(16)
                        color: model.direction === "sent" ? Style.mainColor :
                               model.direction === "received" ? "#4A90D9" : "#F44336"
                        Layout.preferredWidth: Style.resize(20)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Texto del mensaje con elide: si es muy largo, se
                    // trunca con "..." en lugar de romper el layout.
                    Label {
                        text: model.text
                        font.pixelSize: Style.resize(13)
                        color: model.direction === "error" ? "#F44336" : Style.fontPrimaryColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Badge/etiqueta de tipo: rectangulo coloreado con texto.
                    // Los colores de fondo son versiones muy oscuras de los
                    // colores del texto, creando un efecto "chip" sutil.
                    Rectangle {
                        Layout.preferredWidth: Style.resize(55)
                        Layout.preferredHeight: Style.resize(20)
                        radius: Style.resize(3)
                        color: model.direction === "sent" ? "#1B3A2A" :
                               model.direction === "received" ? "#1A2A3A" : "#3A1A1A"

                        Label {
                            anchors.centerIn: parent
                            text: model.direction === "sent" ? "sent" :
                                  model.direction === "received" ? "echo" : "error"
                            font.pixelSize: Style.resize(10)
                            color: model.direction === "sent" ? "#4CAF50" :
                                   model.direction === "received" ? "#42A5F5" : "#EF5350"
                        }
                    }
                }
            }

            // Estado vacio: texto centrado que desaparece cuando hay mensajes.
            // Guia al usuario sobre que hacer (conectar y enviar un mensaje).
            Label {
                anchors.centerIn: parent
                text: "No messages yet.\nConnect and send a message to see the echo response."
                font.pixelSize: Style.resize(14)
                color: Style.inactiveColor
                horizontalAlignment: Text.AlignHCenter
                visible: root.logModel ? root.logModel.count === 0 : true
            }
        }
    }
}
