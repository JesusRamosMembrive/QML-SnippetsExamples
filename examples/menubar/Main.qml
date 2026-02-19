// =============================================================================
// Main.qml — Pagina principal del modulo MenuBar
// =============================================================================
// Punto de entrada para los ejemplos de MenuBar y Menu de Qt Quick Controls.
// Sigue el patron estandar de pagina del proyecto: propiedad fullSize para
// controlar visibilidad con animacion de opacidad, ScrollView con GridLayout
// de 2x2 para organizar las tarjetas de ejemplo.
//
// Cada tarjeta muestra un aspecto diferente de los menus:
//   - BasicMenuBarCard: barra de menu clasica (File/Edit/Help)
//   - ContextMenuCard: menus contextuales con clic derecho
//   - CheckableMenuCard: items con checkbox y radio en menus
//   - InteractiveMenuCard: menus que controlan una vista interactiva
//
// Aprendizaje clave: GridLayout con fillWidth/fillHeight distribuye el espacio
// equitativamente entre las tarjetas, y minimumHeight garantiza una altura
// minima cuando el contenido es poco.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patron de visibilidad animada usado por todas las paginas del proyecto.
    //    Dashboard.qml asigna fullSize=true cuando esta pagina esta activa.
    //    La opacidad se anima suavemente y visible=false evita eventos en paginas ocultas.
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

        // -- ScrollView envuelve todo el contenido para que sea desplazable
        //    si la ventana es mas pequena que las tarjetas.
        //    contentWidth: availableWidth fuerza que el contenido ocupe todo
        //    el ancho disponible sin scroll horizontal.
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
                    text: "MenuBar Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- Grid 2x2 para las tarjetas de ejemplo.
                //    fillWidth + fillHeight en cada tarjeta hace que se
                //    repartan el espacio equitativamente.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicMenuBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ContextMenuCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    CheckableMenuCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveMenuCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
