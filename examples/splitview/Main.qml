// =============================================================================
// Main.qml — Página principal del módulo SplitView
// =============================================================================
// Punto de entrada para los ejemplos de SplitView. Organiza cuatro tarjetas
// en un GridLayout 2x2, cada una demostrando un uso distinto del componente
// SplitView de Qt Quick Controls: división horizontal, vertical, anidada
// e interactiva (mezclador de colores).
//
// Patrón clave: fullSize controla la visibilidad con animación de opacidad,
// permitiendo transiciones suaves al navegar entre páginas del Dashboard.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patrón de visibilidad animada --
    // El Dashboard asigna fullSize = true cuando esta página está activa.
    // La opacidad se anima de 0 a 1 en 200ms. visible se vincula a opacity > 0
    // para que el Item deje de participar en el layout cuando está oculto.
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // Fondo principal que cubre toda la página
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView permite desplazar el contenido si la ventana es pequeña.
        // contentWidth: availableWidth evita el scroll horizontal, forzando
        // que el contenido se adapte al ancho disponible.
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
                    text: "SplitView Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- Cuadrícula de tarjetas de ejemplo --
                // Cada tarjeta es un componente auto-contenido que demuestra
                // un aspecto diferente de SplitView. Layout.minimumHeight
                // garantiza que cada tarjeta tenga espacio suficiente para
                // que los paneles divisibles sean interactuables.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    HorizontalSplitCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    VerticalSplitCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    NestedSplitCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveSplitCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
