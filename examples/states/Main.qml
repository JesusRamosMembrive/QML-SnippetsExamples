// =============================================================================
// Main.qml — Pagina principal del modulo States & Transitions
// =============================================================================
// Punto de entrada para los ejemplos de estados y transiciones en QML.
// Organiza cuatro tarjetas en un grid 2x2:
//   - BasicStatesCard: estados basicos con PropertyChanges
//   - TransitionCard: curvas de easing en transiciones
//   - StateMachineCard: maquina de estados (semaforo con Timer)
//   - InteractiveStatesCard: estados reactivos con clausula 'when'
//
// Los estados son uno de los conceptos mas potentes de QML: permiten
// definir "configuraciones" de propiedades con nombre y cambiar entre
// ellas declarativamente, en vez de escribir logica imperativa.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: Dashboard.qml controla fullSize
    // para mostrar/ocultar paginas con animacion de opacidad.
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
                    text: "States & Transitions"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2: cada tarjeta demuestra un aspecto diferente
                // del sistema de estados de QML.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicStatesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    TransitionCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    StateMachineCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveStatesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
