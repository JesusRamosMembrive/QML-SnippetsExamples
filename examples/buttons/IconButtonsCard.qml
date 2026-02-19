// =============================================================================
// IconButtonsCard.qml — Botones con iconos usando ToolButton
// =============================================================================
// Demuestra ToolButton, un boton ligero optimizado para barras de herramientas
// e interfaces compactas. A diferencia de Button, ToolButton tiene un estilo
// visual mas reducido (sin fondo prominente) y soporta iconos de forma nativa.
//
// CONCEPTOS CLAVE:
//
// 1. ToolButton vs Button:
//    - ToolButton hereda de AbstractButton pero tiene un estilo mas sutil.
//    - Ideal para toolbars, headers y acciones que no necesitan destacar.
//    - Soporta icon.source para mostrar imagenes junto al texto.
//
// 2. icon.source con Style.icon():
//    - Style.icon("name") genera la ruta completa al icono PNG del proyecto.
//    - Qt Quick Controls maneja automaticamente el layout texto+icono.
//    - Un ToolButton sin texto (solo icon.source) crea un boton de icono puro,
//      util para acciones compactas como toggle o power.
//
// 3. Layout.preferredWidth/Height:
//    - Establece el tamano deseado del boton dentro del RowLayout.
//    - El layout respeta estas dimensiones mientras haya espacio disponible.
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
            text: "Icon Buttons (ToolButton)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Tres variantes de ToolButton: con texto+icono, y solo icono.
        // El tercer boton (solo icono) es el patron tipico para toolbars.
        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            ToolButton {
                text: "Settings"
                icon.source: Style.icon("settings")
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
            }

            ToolButton {
                text: "Info"
                icon.source: Style.icon("status")
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
            }

            ToolButton {
                icon.source: Style.icon("onoff")
                Layout.preferredWidth: Style.resize(40)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            text: "ToolButtons are typically used in toolbars and for icon-only actions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
