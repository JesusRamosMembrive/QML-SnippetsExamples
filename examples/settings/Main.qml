// =============================================================================
// Main.qml — Página principal del módulo Settings
// =============================================================================
// Punto de entrada para la sección "Settings" del dashboard. Organiza cuatro
// tarjetas de ejemplo en un grid 2×2, cada una demostrando un aspecto distinto
// de QSettings a través de un wrapper C++ (SettingsManager):
//   - KeyValueCard:    lectura/escritura genérica de claves
//   - PreferencesCard: Q_PROPERTY respaldadas por QSettings (persistencia)
//   - RecentFilesCard: manejo de listas (QStringList) en QSettings
//   - SettingsInfoCard: introspección de grupos, claves y ruta de almacenamiento
//
// Sigue el patrón estándar de página: fullSize controla la visibilidad con
// animación de opacidad, y el contenido se presenta dentro de un ScrollView
// para manejar resoluciones pequeñas.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // ---- Patrón de navegación del dashboard ----
    // fullSize es asignado por Dashboard.qml según el estado activo del menú.
    // La animación de opacidad da una transición suave al cambiar de página,
    // y visible: opacity > 0 evita que el Item consuma eventos de ratón cuando
    // no está activo.
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
        // cuando las tarjetas no caben en la ventana.
        // contentWidth: availableWidth fuerza al contenido a usar todo el
        // ancho disponible, evitando scroll horizontal innecesario.
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
                    text: "Settings Showcase"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2×2 para distribuir las tarjetas de forma uniforme.
                // Layout.fillWidth + Layout.fillHeight permiten que cada
                // tarjeta se expanda proporcionalmente.
                // minimumHeight garantiza un tamaño mínimo legible.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    KeyValueCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    PreferencesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    RecentFilesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    SettingsInfoCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
