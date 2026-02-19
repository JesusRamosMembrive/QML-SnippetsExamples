// =============================================================================
// Main.qml — Página principal del módulo GridView Examples
// =============================================================================
// Punto de entrada de la sección "GridView" del dashboard. Presenta cuatro
// tarjetas en un grid 2×2 que demuestran distintos usos de GridView:
//   - BasicGridCard:       GridView con selección y highlight
//   - PhotoGridCard:       galería de "fotos" con celdas adaptativas al ancho
//   - DynamicGridCard:     agregar/eliminar items con transiciones animadas
//   - InteractiveGridCard: filtrado en tiempo real con modelo secundario
//
// GridView vs Grid: GridView es un view con modelo/delegado que recicla
// delegates eficientemente (solo crea los visibles), ideal para muchos items.
// Grid es un posicionador simple que instancia todos los hijos — solo útil
// para pocos elementos estáticos.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // ---- Patrón de navegación del dashboard ----
    // fullSize controla la visibilidad con animación de opacidad.
    // Todas las páginas Main.qml del proyecto comparten este mismo patrón.
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

        // ScrollView para hacer scrollable todo el contenido.
        // contentWidth: availableWidth desactiva el scroll horizontal.
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
                    text: "GridView Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2×2 con las cuatro tarjetas de ejemplo.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicGridCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    PhotoGridCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    DynamicGridCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveGridCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
