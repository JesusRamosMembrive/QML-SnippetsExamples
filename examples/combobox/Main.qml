// =============================================================================
// Main.qml — Pagina principal de ejemplos de ComboBox
// =============================================================================
// Punto de entrada del modulo "combobox". Sigue el patron estandar de paginas
// de ejemplo del proyecto: un Item raiz con la propiedad fullSize que controla
// la visibilidad mediante una animacion de opacidad.
//
// El contenido se organiza en un GridLayout 2x2 dentro de un ScrollView, donde
// cada celda es una tarjeta (Card) independiente que muestra un aspecto
// diferente del componente ComboBox de Qt Quick Controls 2:
//   - BasicComboBoxCard:       Uso basico con listas de strings e indice.
//   - EditableComboBoxCard:    ComboBox editable, validadores y modelo dinamico.
//   - ModelComboBoxCard:       ListModel con roles (textRole/valueRole).
//   - InteractiveComboBoxCard: Demo visual que combina varios ComboBox.
//
// Aprendizaje clave: como estructurar una pagina de ejemplo scrollable con
// GridLayout para distribuir tarjetas de forma responsiva.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad: fullSize controla si esta pagina esta activa.
    // Dashboard.qml enlaza esta propiedad al estado del menu. La animacion
    // de opacidad da una transicion suave de 200ms al cambiar de pagina.
    // visible depende de opacity para que QML no renderice el Item cuando
    // esta completamente transparente (optimizacion de rendimiento).
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

    // Fondo solido que cubre toda la pagina con el color de fondo del tema
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView permite hacer scroll cuando las tarjetas exceden el
        // alto disponible. contentWidth = availableWidth fuerza que el
        // contenido ocupe solo el ancho visible (sin scroll horizontal).
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
                    text: "ComboBox Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // GridLayout 2x2: cada tarjeta ocupa una celda.
                // Layout.fillWidth + Layout.fillHeight permiten que las
                // tarjetas se expandan uniformemente. Layout.minimumHeight
                // garantiza un alto minimo para que el contenido no se
                // recorte en resoluciones bajas.
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicComboBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    EditableComboBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    ModelComboBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveComboBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
