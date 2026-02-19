// =============================================================================
// Main.qml — Pagina principal del modulo de Lists & Delegates
// =============================================================================
// Punto de entrada del ejemplo "Lists". Organiza todas las tarjetas de
// demostracion en un layout scrollable con dos secciones principales:
//
// 1. GridLayout 2x2 con los patrones fundamentales de listas en Qt Quick:
//    ListView basico, GridView, lista dinamica (add/remove), y secciones.
//    Estos demuestran la arquitectura Model-View-Delegate de Qt.
//
// 2. Una tarjeta grande con patrones de lista custom mas avanzados:
//    SwipeToAction, Accordion expandible, Chat Bubbles, Timeline,
//    Card Carousel horizontal, y Kanban Board con columnas.
//
// Patron de arquitectura: Main.qml solo es responsable del layout.
// Cada sub-componente es autocontenido con su propio modelo, logica de
// estado y animaciones. Esto permite reutilizar cualquier tarjeta
// individualmente o reorganizar el layout sin modificar los componentes.
//
// La propiedad fullSize controla la visibilidad con animacion de opacidad,
// patron estandar de navegacion en este proyecto (ver Dashboard.qml).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de navegacion: fullSize es controlado por Dashboard.qml.
    // Cuando la pagina esta activa, fullSize = true y la opacidad anima a 1.0.
    // visible depende de opacity para evitar renderizar elementos invisibles.
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

        // ScrollView envuelve todo el contenido para permitir scroll vertical.
        // contentWidth: availableWidth asegura que el contenido ocupe todo el
        // ancho disponible sin generar scroll horizontal.
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
                    text: "Lists & Delegates Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // Seccion 1: Patrones fundamentales de listas en Qt Quick
                // Cada tarjeta es independiente y demuestra un concepto
                // clave del sistema Model-View-Delegate de Qt.
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    ListViewCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GridViewCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    DynamicListCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    SectionsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ---------------------------------------------------------
                // Seccion 2: Patrones de lista custom avanzados
                // Una sola tarjeta grande contiene 6 sub-componentes
                // separados por lineas divisoras. Cada uno demuestra un
                // patron de lista diferente: swipe gestures, acordeones,
                // chat, timeline, carrusel horizontal y kanban board.
                // ---------------------------------------------------------
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2600)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom List Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        SwipeToActionList { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ExpandableAccordion { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ChatBubbles { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        Timeline { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        CardCarousel { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        KanbanBoard { }
                    }
                }
            }
        }
    }
}
