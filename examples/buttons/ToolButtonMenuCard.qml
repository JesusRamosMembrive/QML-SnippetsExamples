// =============================================================================
// ToolButtonMenuCard.qml — ToolButton con Menu desplegable
// =============================================================================
// Demuestra el patron de combinar un ToolButton con un Menu hijo para crear
// botones de menu desplegable (dropdown). Este patron es la base de barras
// de menu, toolbars con opciones y selectores de accion.
//
// CONCEPTOS CLAVE:
//
// 1. Menu como hijo de ToolButton:
//    - El Menu se declara dentro del ToolButton. Al hacer clic en el boton,
//      se llama a menu.open() para mostrar las opciones.
//    - "y: toolBtn.height" posiciona el menu justo debajo del boton,
//      creando el efecto de dropdown clasico.
//
// 2. MenuItem con variantes:
//    - MenuItem basico: texto + onTriggered para acciones simples.
//    - MenuItem con checkable: true: actua como toggle persistente
//      (ej: "Notifications" checked/unchecked).
//    - MenuSeparator: linea divisoria entre grupos logicos de acciones.
//
// 3. ToolButton con icono:
//    - icon.source apunta a los iconos del proyecto via Style.icon().
//    - El tercer boton ("more") usa solo icono sin texto, patron comun
//      para menus de opciones adicionales (...).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ToolButton with Menu"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Tres ToolButtons con menus desplegables de diferente complejidad.
        RowLayout {
            spacing: Style.resize(20)
            Layout.fillWidth: true

            // Menu "File" con acciones basicas + separador
            ToolButton {
                id: fileToolBtn
                text: "File"
                icon.source: Style.icon("inbox")
                Layout.preferredWidth: Style.resize(100)
                Layout.preferredHeight: Style.resize(40)
                onClicked: fileMenu.open()

                Menu {
                    id: fileMenu
                    y: fileToolBtn.height

                    MenuItem { text: "New" }
                    MenuItem { text: "Open" }
                    MenuItem { text: "Save" }
                    MenuSeparator {}
                    MenuItem { text: "Close" }
                }
            }

            ToolButton {
                id: settingsToolBtn
                text: "Settings"
                icon.source: Style.icon("settings")
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
                onClicked: settingsMenu.open()

                Menu {
                    id: settingsMenu
                    y: settingsToolBtn.height

                    MenuItem { text: "Preferences" }
                    MenuItem { text: "Account" }
                    MenuItem { text: "Notifications"; checkable: true; checked: true }
                }
            }

            ToolButton {
                id: moreToolBtn
                icon.source: Style.icon("expand")
                Layout.preferredWidth: Style.resize(40)
                Layout.preferredHeight: Style.resize(40)
                onClicked: moreMenu.open()

                Menu {
                    id: moreMenu
                    y: moreToolBtn.height

                    MenuItem { text: "Help" }
                    MenuItem { text: "About" }
                }
            }
        }

        Label {
            text: "Click each ToolButton to open its dropdown Menu"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
