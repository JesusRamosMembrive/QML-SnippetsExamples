// =============================================================================
// Main.qml — Pagina principal del modulo ToolBar
// =============================================================================
// Punto de entrada para los ejemplos de ToolBar de Qt Quick Controls.
// Estructura identica a las demas paginas del proyecto: fullSize controla
// la visibilidad animada, ScrollView contiene un GridLayout 2x2 con las
// tarjetas de ejemplo.
//
// Las cuatro tarjetas cubren diferentes usos de ToolBar:
//   - BasicToolBarCard: barra con ToolButtons y ToolTips
//   - ActionToolBarCard: acciones con log, ToolSeparator y ComboBox integrado
//   - ContextToolBarCard: barra que cambia segun el contexto de seleccion
//   - InteractiveToolBarCard: barra de formato de texto con botones checkable
//
// Aprendizaje clave: ToolBar es un contenedor simple que proporciona un fondo
// y contexto visual. Los controles dentro (ToolButton, ToolSeparator, etc.)
// son los que aportan la funcionalidad.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patron de visibilidad animada estandar del proyecto.
    //    Todas las paginas usan este mismo bloque para integrarse con Dashboard.
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
                    text: "ToolBar Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- Grid 2x2: cada tarjeta llena su celda equitativamente.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicToolBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ActionToolBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ContextToolBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveToolBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
