// =============================================================================
// Main.qml — Pagina principal del modulo Chat UI
// =============================================================================
// Punto de entrada de la pagina "Chat UI". Sigue el patron estandar de
// navegacion del proyecto: la propiedad `fullSize` controla la visibilidad
// con una animacion de opacidad de 200 ms. Cuando Dashboard.qml activa
// esta pagina, fullSize pasa a true y el contenido aparece suavemente.
//
// Organiza 4 tarjetas en un GridLayout 2x2 dentro de un ScrollView,
// mostrando distintos patrones de chat: burbujas, indicadores de escritura,
// selector de emojis y un chat interactivo con bot simulado.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de navegacion: fullSize controla si esta pagina es la activa.
    // La vinculacion opacity + visible evita que paginas ocultas consuman
    // eventos de raton o ciclos de renderizado innecesarios.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView envuelve todo el contenido para que sea desplazable
        // si las tarjetas exceden la altura de la ventana.
        // contentWidth: availableWidth fuerza layout vertical (sin scroll horizontal).
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "Chat UI Showcase"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // GridLayout 2x2: cada tarjeta ocupa una celda y se expande
                // uniformemente gracias a fillWidth + fillHeight. Se usa
                // minimumHeight para garantizar espacio suficiente para
                // el contenido de cada tarjeta de ejemplo.
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    ChatBubblesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    TypingIndicatorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    EmojiPickerCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    InteractiveChatCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
