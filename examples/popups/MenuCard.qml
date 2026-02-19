// =============================================================================
// MenuCard.qml — Ejemplos de Menu dropdown y menu contextual
// =============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Menu en Qt Quick Controls:
//    - Menu es un componente emergente que muestra una lista vertical de acciones.
//    - Se puede abrir de dos formas:
//      a) Como dropdown: menu.popup(parent, x, y) posicionado relativo a un boton
//      b) Como context menu: menu.popup() en la posicion del cursor (clic derecho)
//
// 2. MenuItem y sus variantes:
//    - MenuItem: accion simple. onTriggered se ejecuta al seleccionarla.
//    - MenuItem con checkable: true — actua como toggle (on/off).
//      La propiedad checked refleja el estado actual.
//    - MenuSeparator: linea divisoria para agrupar acciones relacionadas.
//
// 3. Menu contextual (clic derecho):
//    - Se implementa con un MouseArea que acepta Qt.RightButton.
//    - onClicked llama a contextMenu.popup() sin coordenadas — Qt usa
//      automaticamente la posicion del cursor.
//    - Es el patron estandar para menus contextuales en apps de escritorio.
//
// 4. popup() con posicionamiento:
//    - popup(parent, x, y) posiciona el menu relativo a un componente.
//    - popup(menuButton, 0, menuButton.height) lo abre justo debajo del
//      boton, creando un efecto de "dropdown" clasico.
//
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // --- Menu dropdown ---
    // Combina items normales, un separador, e items checkable.
    // Cada MenuItem reporta su seleccion actualizando un Label externo,
    // lo que demuestra como capturar acciones del menu.
    Menu {
        id: dropdownMenu

        MenuItem {
            text: "Cut"
            onTriggered: menuResultLabel.text = "Selected: Cut"
        }
        MenuItem {
            text: "Copy"
            onTriggered: menuResultLabel.text = "Selected: Copy"
        }
        MenuItem {
            text: "Paste"
            onTriggered: menuResultLabel.text = "Selected: Paste"
        }

        MenuSeparator {}

        // Items checkable: mantienen estado on/off.
        // checked se actualiza automaticamente al pulsar.
        MenuItem {
            text: "Bold"
            checkable: true
            checked: true
            onTriggered: menuResultLabel.text = "Bold: " + (checked ? "ON" : "OFF")
        }
        MenuItem {
            text: "Italic"
            checkable: true
            onTriggered: menuResultLabel.text = "Italic: " + (checked ? "ON" : "OFF")
        }
    }

    // --- Menu contextual (clic derecho) ---
    // No tiene posicion fija — aparece donde el usuario hace clic derecho.
    Menu {
        id: contextMenu

        MenuItem {
            text: "Select All"
            onTriggered: menuResultLabel.text = "Context: Select All"
        }
        MenuItem {
            text: "Delete"
            onTriggered: menuResultLabel.text = "Context: Delete"
        }

        MenuSeparator {}

        MenuItem {
            text: "Properties"
            onTriggered: menuResultLabel.text = "Context: Properties"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Menu"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Boton que abre el dropdown posicionado justo debajo.
        // popup(menuButton, 0, menuButton.height) usa el boton como
        // referencia y coloca el menu en (0, altura_del_boton).
        Button {
            id: menuButton
            text: "Open Menu"
            Layout.fillWidth: true
            onClicked: dropdownMenu.popup(menuButton, 0, menuButton.height)
        }

        // Area interactiva para clic derecho.
        // acceptedButtons: Qt.RightButton ignora clics izquierdos,
        // permitiendo que solo el clic derecho abra el menu contextual.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            color: Style.bgColor
            radius: Style.resize(8)
            border.color: Style.inactiveColor
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "Right-click here"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: function(mouse) {
                    contextMenu.popup()
                }
            }
        }

        // Label que refleja la ultima accion seleccionada en cualquiera
        // de los dos menus, demostrando la captura de eventos onTriggered.
        Label {
            id: menuResultLabel
            text: "Selected: —"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.mainColor
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: menuInfoCol.implicitHeight + Style.resize(20)
            color: Style.bgColor
            radius: Style.resize(6)

            ColumnLayout {
                id: menuInfoCol
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Menu supports:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Regular items, separators"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Checkable items (Bold, Italic)"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Context menu (right-click)"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }

        Label {
            text: "Menu provides dropdown and context menus with rich item types"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
