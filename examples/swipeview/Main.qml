// =============================================================================
// Main.qml — Pagina principal del modulo SwipeView Examples
// =============================================================================
// Este archivo es el punto de entrada del modulo de ejemplo "swipeview".
// Sigue el mismo patron estandar que todas las paginas del proyecto: un Item
// raiz con fullSize que controla la visibilidad mediante animacion de opacidad.
//
// Organiza cuatro tarjetas de ejemplo en un GridLayout 2x2 dentro de un
// ScrollView. Cada tarjeta demuestra un aspecto diferente de SwipeView:
// navegacion basica, indicadores de pagina, carrusel de tarjetas y un
// asistente paso a paso (wizard).
//
// Aprendizaje clave: estructura de pagina del proyecto y uso de GridLayout
// para organizar multiples ejemplos en una cuadricula responsiva.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad: Dashboard.qml activa fullSize=true para la pagina
    // seleccionada. La animacion de opacidad (200ms) suaviza la transicion.
    // visible: opacity > 0.0 desactiva la interaccion cuando esta oculta.
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

    // -------------------------------------------------------------------------
    // Fondo + ScrollView: el Rectangle da el color de fondo y el ScrollView
    // habilita scroll vertical. contentWidth: availableWidth evita scroll
    // horizontal no deseado.
    // -------------------------------------------------------------------------
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

                // Titulo de la seccion
                Label {
                    text: "SwipeView Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // GridLayout 2x2: cada celda contiene una tarjeta de ejemplo.
                // Layout.minimumHeight asegura espacio suficiente para el
                // SwipeView interno de cada tarjeta (necesita altura para
                // que el gesto de deslizar funcione correctamente).
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicSwipeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    IndicatorSwipeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    CarouselCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveSwipeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
