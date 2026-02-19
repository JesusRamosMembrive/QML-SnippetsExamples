// =============================================================================
// Main.qml — Pagina principal del ECAM (Electronic Centralized Aircraft Monitor)
// =============================================================================
// El ECAM es el sistema de monitorizacion centralizada de Airbus. En la cabina
// real consta de dos pantallas: la superior muestra parametros de motor (E/WD)
// y la inferior muestra sinopticos de sistemas (SD).
//
// Esta pagina organiza cuatro tarjetas en un GridLayout 2x2:
//   - EngineGaugesCard: indicadores de N1 con arcos de color
//   - WarningPanelCard: panel de alertas con Master Warning/Caution
//   - FuelSynopticCard: esquema sinoptico de combustible con valvulas
//   - SystemStatusCard: estado de hidraulica, electrica y aire acondicionado
//
// Sigue el patron estandar del proyecto: ScrollView con ColumnLayout,
// fullSize para visibilidad animada, y Style.resize() para escalado.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad: el Dashboard controla fullSize.
    // La opacidad anima suavemente y visible evita renderizado innecesario.
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
                    text: "ECAM — Engine & System Monitoring"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -------------------------------------------------------------
                // Grid 2x2 con los cuatro paneles del ECAM:
                // Fila superior: motores + alertas (datos criticos primero)
                // Fila inferior: combustible + estado de sistemas
                // minimumHeight garantiza espacio suficiente para cada Canvas.
                // -------------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    EngineGaugesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    WarningPanelCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    FuelSynopticCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    SystemStatusCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }
                }
            }
        }
    }
}
