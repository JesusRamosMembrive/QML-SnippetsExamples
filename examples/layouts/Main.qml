// =============================================================================
// Main.qml — Pagina principal del modulo de ejemplos de Layouts
// =============================================================================
// Este archivo es el punto de entrada de la seccion "Layouts" del showcase.
// Organiza todas las tarjetas de ejemplo en una cuadricula de 2 columnas
// (GridLayout) para los 4 layouts basicos, y luego una tarjeta grande que
// contiene los 6 patrones de layout personalizados.
//
// Patrones clave demostrados:
// - fullSize / opacity: mecanismo de visibilidad con animacion para la
//   navegacion del Dashboard (solo la pagina activa es visible).
// - ScrollView + ColumnLayout: scroll vertical con contenido que ocupa
//   todo el ancho disponible (contentWidth: availableWidth).
// - GridLayout de 2x2: distribucion uniforme de las tarjetas basicas.
// - Separadores con Rectangle de 1px entre componentes personalizados.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    // -------------------------------------------------------------------------
    // Animacion de aparicion/desaparicion
    // Se usa opacity + visible para que la pagina no consuma eventos de raton
    // cuando esta oculta (visible: false). El Behavior anima la transicion.
    // -------------------------------------------------------------------------
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

        // ---------------------------------------------------------------------
        // ScrollView envuelve todo el contenido para permitir scroll vertical.
        // contentWidth: availableWidth evita scroll horizontal — el contenido
        // se adapta al ancho disponible y solo crece verticalmente.
        // ---------------------------------------------------------------------
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Titulo de la pagina
                Label {
                    text: "Layouts Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -------------------------------------------------------------
                // Cuadricula 2x2 con los 4 layouts basicos de Qt Quick Layouts:
                // RowLayout, ColumnLayout, GridLayout, Flow y StackLayout.
                // Cada tarjeta tiene fillWidth + fillHeight para que se
                // distribuyan uniformemente, con minimumHeight para garantizar
                // un tamano minimo legible.
                // -------------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    RowColumnLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GridLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    FlowCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    StackLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ═════════════════════════════════════════════════════════════
                // Tarjeta grande: Patrones de layout personalizados
                // Contiene 6 sub-componentes separados por lineas divisorias.
                // Se usa un Rectangle con preferredHeight fijo porque el
                // contenido interno no es un layout puro — cada componente
                // tiene su propia altura preferida.
                // ═════════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2400)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Layout Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        CollapsibleSidebar { }

                        // Separadores visuales: Rectangle de 1px que actuan
                        // como <hr> en HTML, separando cada patron
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        DraggableSplitPane { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        MasonryGrid { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        HolyGrailLayout { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ResponsiveBreakpoints { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        NestedDashboard { }
                    }
                }
            }
        }
    }
}
