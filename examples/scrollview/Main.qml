// =============================================================================
// Main.qml — Página principal del módulo ScrollView Examples
// =============================================================================
// Punto de entrada para los ejemplos de scroll. Sigue el patrón estándar del
// proyecto: un Item raíz con la propiedad fullSize que controla la visibilidad
// mediante una animación de opacidad. Dentro, un GridLayout 2x2 organiza las
// cuatro tarjetas de ejemplo.
//
// Conceptos clave:
// - Patrón de navegación con fullSize + opacity + visible (evita renderizar
//   páginas ocultas ya que visible: false desactiva el renderizado)
// - ScrollView envolviendo el contenido de la página para que los ejemplos
//   sean accesibles incluso si la ventana es pequeña
// - GridLayout para distribuir las tarjetas uniformemente
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patrón de visibilidad: Dashboard.qml asigna fullSize = true cuando el
    // usuario navega a esta página. La animación de opacidad crea una
    // transición suave, y visible se desactiva para no consumir recursos.
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

    // Fondo que cubre toda el área disponible
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView externo: si el contenido de las tarjetas excede el alto
        // de la ventana, el usuario puede hacer scroll verticalmente.
        // contentWidth: availableWidth evita scroll horizontal innecesario.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Título de la sección
                Label {
                    text: "ScrollView Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // GridLayout 2x2: cada tarjeta es un componente autocontenido
                // con su propio ejemplo. Layout.minimumHeight garantiza que las
                // tarjetas tengan espacio suficiente para mostrar su contenido.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicScrollCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    CustomScrollBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    FlickableCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveScrollCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
