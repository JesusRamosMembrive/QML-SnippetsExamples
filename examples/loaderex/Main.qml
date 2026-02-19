// =============================================================================
// Main.qml — Página principal del módulo Loader Examples
// =============================================================================
// Punto de entrada de la sección "Loader" del dashboard. Presenta cuatro
// tarjetas en un grid 2×2, cada una demostrando un uso distinto del
// componente Loader de QML:
//   - BasicLoaderCard:       cambio de sourceComponent entre varias vistas
//   - ComponentLoaderCard:   control de active para cargar/descargar y observar estados
//   - DynamicCreationCard:   Component.createObject() para instanciación imperativa
//   - InteractiveLoaderCard: patrón de View Switcher tipo tabs con Loader
//
// El Loader es clave para:
// 1. Carga diferida (lazy loading) — no instanciar componentes hasta que se necesiten
// 2. Gestión de memoria — destruir componentes cuando no se usan
// 3. Cambio dinámico de vistas — sustituir contenido en tiempo de ejecución
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // ---- Patrón de navegación del dashboard ----
    // fullSize es controlado por Dashboard.qml. La animación de opacidad
    // (200ms) suaviza las transiciones entre páginas, y visible: opacity > 0
    // desactiva completamente el Item cuando no está en uso.
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

        // ScrollView con contentWidth: availableWidth para scroll solo vertical.
        // Todas las páginas del proyecto usan este mismo patrón de ScrollView
        // envolviendo un ColumnLayout para garantizar que el contenido sea
        // desplazable en pantallas pequeñas.
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
                    text: "Loader Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2×2 con las cuatro tarjetas de ejemplo.
                // Cada tarjeta tiene minimumHeight para garantizar espacio
                // suficiente para su contenido interactivo.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicLoaderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    ComponentLoaderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    DynamicCreationCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveLoaderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
