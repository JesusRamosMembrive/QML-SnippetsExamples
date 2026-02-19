// =============================================================================
// BasicToolBarCard.qml — Barra de herramientas basica con ToolButtons
// =============================================================================
// Ejemplo introductorio de ToolBar con botones de navegacion tipo navegador
// web (Home, Back, Forward, Refresh, Settings). Cada boton usa un caracter
// Unicode como icono y muestra un ToolTip al pasar el mouse.
//
// Conceptos clave:
//   - ToolBar: contenedor con fondo tematico para agrupar herramientas.
//     A diferencia de MenuBar, no tiene comportamiento de menu desplegable.
//   - ToolButton: variante de Button optimizada para toolbars (mas compacta,
//     sin borde por defecto en muchos estilos).
//   - ToolTip.text + ToolTip.visible: propiedades attached que agregan tooltips
//     a cualquier control sin necesidad de un componente ToolTip separado.
//   - Item { Layout.fillWidth: true }: espaciador invisible que empuja el
//     boton Settings hacia la derecha, creando la distribucion tipica de
//     "acciones principales a la izquierda, ajustes a la derecha".
//   - background: override del fondo del ToolBar para personalizar su aspecto.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string lastAction: "None"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- ToolBar con fondo personalizado.
        //    El RowLayout interior distribuye los ToolButtons horizontalmente.
        //    Los iconos Unicode evitan dependencias de imagenes externas.
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: Style.bgColor
                radius: Style.resize(4)
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(4)

                ToolButton { text: "\u2302"; onClicked: root.lastAction = "Home"; ToolTip.text: "Home"; ToolTip.visible: hovered }
                ToolButton { text: "\u2190"; onClicked: root.lastAction = "Back"; ToolTip.text: "Back"; ToolTip.visible: hovered }
                ToolButton { text: "\u2192"; onClicked: root.lastAction = "Forward"; ToolTip.text: "Forward"; ToolTip.visible: hovered }
                ToolButton { text: "\u21BB"; onClicked: root.lastAction = "Refresh"; ToolTip.text: "Refresh"; ToolTip.visible: hovered }

                // -- Espaciador flexible: empuja todo lo que sigue hacia la derecha
                Item { Layout.fillWidth: true }

                ToolButton { text: "\u2699"; onClicked: root.lastAction = "Settings"; ToolTip.text: "Settings"; ToolTip.visible: hovered }
            }
        }

        // -- Area de contenido que muestra la ultima accion ejecutada
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            Label {
                anchors.centerIn: parent
                text: "ToolBar with ToolButtons and ToolTips\n\nLast action: " + root.lastAction
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
