// =============================================================================
// Main.qml — Punto de entrada de la página de ejemplo "Buttons"
// =============================================================================
// Todas las páginas de ejemplo siguen este mismo patrón:
//
//   1. Patrón de visibilidad animada (fullSize/opacity/visible)
//   2. ScrollView con ColumnLayout como contenedor scrollable
//   3. GridLayout con tarjetas (*Card) como cuadrícula de ejemplos
//
// Este patrón se repite en TODOS los Main.qml de examples/. Entender
// este archivo es entender la estructura de cualquier página de ejemplo.
//
// Flujo de carga:
//   Dashboard.qml cambia state → Loader carga este Main.qml →
//   Loader asigna item.fullSize = true → la animación de opacity
//   hace aparecer la página con fade-in de 200ms.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0          // Style singleton
import qmlsnippetsstyle   // Garantiza que los controles usen nuestro estilo

Item {
    id: root

    // --- Patrón de visibilidad animada ---
    // fullSize es asignado por el Loader de Dashboard.qml al terminar de cargar.
    // El binding ternario en opacity y el Behavior crean un fade-in suave.
    // visible: opacity > 0.0 desactiva el item completamente cuando es transparente.
    // Este patrón se usa en TODAS las páginas de ejemplo sin excepción.
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // Fondo sólido para evitar que se vea el contenido anterior durante la transición
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView permite scroll vertical cuando el contenido excede el área visible.
        // contentWidth: availableWidth fuerza a que el contenido se ajuste al ancho
        // (solo scroll vertical, no horizontal).
        // clip: true recorta el contenido que sale del área visible.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            // ColumnLayout apila título + cuadrícula verticalmente
            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Título de la página
                Label {
                    text: "Button Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // --- Cuadrícula de tarjetas de ejemplo ---
                // GridLayout organiza las tarjetas en una cuadrícula 2x3.
                // Cada tarjeta (*Card) es un componente autocontenido que
                // demuestra un aspecto específico de los botones.
                // Layout.fillWidth: true hace que cada tarjeta ocupe
                // la mitad del ancho disponible (2 columnas).
                // Layout.preferredHeight fija la altura de cada tarjeta.
                GridLayout {
                    columns: 2
                    rows: 3
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    StandardButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(180)
                    }

                    IconButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(180)
                    }

                    ButtonStatesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(240)
                    }

                    CustomStyledCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(240)
                    }

                    SpecializedButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(200)
                    }

                    ToolButtonMenuCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(200)
                    }
                }
            }
        }
    }
}
