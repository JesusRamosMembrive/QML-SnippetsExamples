// =============================================================================
// BasicMenuBarCard.qml — Barra de menu clasica (File / Edit / Help)
// =============================================================================
// Demuestra el uso basico de MenuBar con menus desplegables estandar.
// Cada Menu contiene Actions que al ser activadas actualizan una propiedad
// de texto, mostrando la accion seleccionada en la interfaz.
//
// Conceptos clave:
//   - MenuBar: contenedor horizontal de menus, se posiciona automaticamente
//     en la parte superior del layout.
//   - Menu: desplegable con items (Action, MenuItem, MenuSeparator).
//   - Action: encapsula texto + handler, reutilizable en menus y toolbars.
//   - MenuSeparator: linea divisoria visual entre grupos logicos de acciones.
//
// Patron de diseno: usar una propiedad string en el root para rastrear la
// ultima accion ejecutada. Esto permite mostrar feedback sin logica compleja.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Propiedad reactiva: cualquier Label que la lea se actualiza
    //    automaticamente cuando cambia (binding declarativo de QML).
    property string lastAction: "None"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic MenuBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- Area de contenido con la MenuBar arriba y feedback abajo.
        //    El Rectangle interno con bgColor simula una "ventana" dentro
        //    de la tarjeta para que la MenuBar se vea contextualizada.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // -- MenuBar con estructura tipica de aplicacion de escritorio.
                //    Cada Action usa onTriggered para actualizar lastAction.
                MenuBar {
                    Layout.fillWidth: true

                    Menu {
                        title: "File"
                        Action { text: "New"; onTriggered: root.lastAction = "File > New" }
                        Action { text: "Open..."; onTriggered: root.lastAction = "File > Open" }
                        Action { text: "Save"; onTriggered: root.lastAction = "File > Save" }
                        MenuSeparator {}
                        Action { text: "Exit"; onTriggered: root.lastAction = "File > Exit" }
                    }

                    Menu {
                        title: "Edit"
                        Action { text: "Undo"; onTriggered: root.lastAction = "Edit > Undo" }
                        Action { text: "Redo"; onTriggered: root.lastAction = "Edit > Redo" }
                        MenuSeparator {}
                        Action { text: "Cut"; onTriggered: root.lastAction = "Edit > Cut" }
                        Action { text: "Copy"; onTriggered: root.lastAction = "Edit > Copy" }
                        Action { text: "Paste"; onTriggered: root.lastAction = "Edit > Paste" }
                    }

                    Menu {
                        title: "Help"
                        Action { text: "About"; onTriggered: root.lastAction = "Help > About" }
                    }
                }

                // -- Zona de feedback: Item con fillHeight ocupa el espacio restante,
                //    centrando el Label que muestra la ultima accion.
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Label {
                        anchors.centerIn: parent
                        text: "Last action: " + root.lastAction
                        font.pixelSize: Style.resize(14)
                        color: Style.fontPrimaryColor
                    }
                }
            }
        }
    }
}
