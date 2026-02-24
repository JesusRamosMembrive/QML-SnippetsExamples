// =============================================================================
// ContextToolBarCard.qml — ToolBar contextual que cambia segun la seleccion
// =============================================================================
// Demuestra el patron de "barra contextual" comun en apps como Gmail o
// editores: cuando no hay items seleccionados se muestran acciones generales
// (New, Refresh, Settings), y al seleccionar items la barra cambia a acciones
// de seleccion (Delete, Copy, Clear) con un contador.
//
// Conceptos clave:
//   - Dos RowLayouts con visible condicional: tecnica simple para alternar
//     entre dos sets de botones. Solo uno es visible a la vez segun el
//     estado de selectedItems.
//   - Behavior on color en el background: la transicion de color del fondo
//     (gris -> azul oscuro) anima suavemente el cambio de contexto.
//   - CheckBox con contador: onToggled suma o resta 1 al contador.
//     Este patron es simple pero tiene una limitacion: si el Repeater se
//     recrea (por cambio de modelo), el contador se desincroniza.
//   - Patron visual: el color azul (#1A3A5C, #4FC3F7) indica modo de
//     seleccion activo, una convencion de Material Design.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Contador de items seleccionados. Controla que set de botones
    //    se muestra y el color de fondo de la toolbar.
    property int selectedItems: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Contextual ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "ToolBar changes based on selection"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // -- ToolBar con fondo animado: cambia de color cuando hay seleccion.
        //    Contiene dos RowLayouts mutuamente excluyentes.
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: root.selectedItems > 0 ? "#1A3A5C" : Style.bgColor
                radius: Style.resize(4)
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(6)

                // -- Modo normal: acciones generales cuando no hay seleccion
                RowLayout {
                    visible: root.selectedItems === 0
                    spacing: Style.resize(6)
                    ToolButton { text: "\u2795 New" }
                    ToolButton { text: "\u21BB Refresh" }
                    ToolButton { text: "\u2699 Settings" }
                }

                // -- Modo seleccion: acciones sobre los items seleccionados.
                //    Delete y Clear resetean el contador a 0.
                RowLayout {
                    visible: root.selectedItems > 0
                    spacing: Style.resize(6)

                    Label {
                        text: root.selectedItems + " selected"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#4FC3F7"
                    }

                    ToolSeparator {}

                    ToolButton { text: "\u2702 Delete"; onClicked: root.selectedItems = 0 }
                    ToolButton { text: "\u2398 Copy" }
                    ToolButton { text: "\u2717 Clear"; onClicked: root.selectedItems = 0 }
                }

                Item { Layout.fillWidth: true }
            }
        }

        // -- Lista de documentos seleccionables con CheckBox.
        //    Cada cambio de checked incrementa o decrementa el contador.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Repeater {
                    model: ["Document A", "Document B", "Document C", "Document D"]

                    CheckBox {
                        required property string modelData
                        text: modelData
                        onToggled: {
                            root.selectedItems += checked ? 1 : -1
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
