// =============================================================================
// Main.qml — Pagina principal del modulo de ejemplos de Network
// =============================================================================
// Punto de entrada de la seccion "Network" del proyecto. Organiza cuatro
// tarjetas en un GridLayout 2x2 que cubren diferentes aspectos de las
// peticiones HTTP desde QML:
//
//   - XHRCard: peticion GET basica con XMLHttpRequest
//   - RestApiCard: consumo de multiples endpoints REST
//   - JsonParserCard: parsing y formateo de JSON
//   - InteractiveNetworkCard: constructor de peticiones (metodo, URL, body)
//
// PATRON DE PAGINA:
// Sigue la misma estructura que todas las paginas del dashboard:
//   1. fullSize controla la visibilidad con animacion de opacidad
//   2. ScrollView envuelve el contenido para scroll vertical
//   3. GridLayout distribuye las tarjetas en cuadricula
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // --- Patron de visibilidad animada ---
    // fullSize es controlada por Dashboard.qml segun el menu lateral.
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
                    text: "Network Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 con las cuatro tarjetas de ejemplo.
                // Cada tarjeta es un componente QML independiente que
                // demuestra un patron diferente de comunicacion HTTP.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    XHRCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    RestApiCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    JsonParserCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveNetworkCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
