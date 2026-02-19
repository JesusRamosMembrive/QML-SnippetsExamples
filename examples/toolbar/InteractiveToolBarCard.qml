// =============================================================================
// InteractiveToolBarCard.qml — Barra de formato de texto tipo editor
// =============================================================================
// Simula la barra de herramientas de un editor de texto con controles de
// formato (negrita, cursiva, subrayado), alineacion y tamano de fuente.
// El TextArea inferior refleja los cambios en tiempo real.
//
// Conceptos clave:
//   - ToolButton checkable: funciona como toggle (on/off). La propiedad
//     checked se sincroniza bidireccionalmente con las propiedades de
//     formato del root (isBold, isItalic, isUnderline).
//   - TextArea con bindings de formato: font.bold, font.italic, etc. se
//     vinculan a las propiedades del root, asi que cuando el usuario pulsa
//     un boton de la toolbar, el texto cambia instantaneamente.
//   - Math.max/Math.min para limitar el tamano: patron defensivo que evita
//     valores fuera de rango (minimo 10px, maximo 32px).
//   - horizontalAlignment con ternario encadenado: selecciona la alineacion
//     del texto segun la propiedad textAlign.
//   - background: null elimina el fondo predeterminado del TextArea para
//     que se integre visualmente con el Rectangle contenedor.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Estado del formato de texto: cada propiedad se vincula tanto a un
    //    ToolButton como al TextArea, creando sincronizacion automatica.
    property string textContent: "Hello World"
    property bool isBold: false
    property bool isItalic: false
    property bool isUnderline: false
    property string textAlign: "left"
    property int fontSize: 16

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Text Editor ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- Barra de formato con 3 grupos: estilo | alineacion | tamano.
        //    Los botones B/I/U son checkable (toggle), los de alineacion y
        //    tamano son acciones simples (onClicked).
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
                spacing: Style.resize(2)

                // -- Grupo de estilo: botones toggle para B/I/U.
                //    El propio texto del boton usa el estilo que representa,
                //    sirviendo como preview visual del efecto.
                ToolButton {
                    text: "B"
                    font.bold: true
                    checkable: true
                    checked: root.isBold
                    onCheckedChanged: root.isBold = checked
                }
                ToolButton {
                    text: "I"
                    font.italic: true
                    checkable: true
                    checked: root.isItalic
                    onCheckedChanged: root.isItalic = checked
                }
                ToolButton {
                    text: "U"
                    font.underline: true
                    checkable: true
                    checked: root.isUnderline
                    onCheckedChanged: root.isUnderline = checked
                }

                ToolSeparator {}

                // -- Grupo de alineacion: acciones simples que asignan un valor
                ToolButton { text: "\u2261"; onClicked: root.textAlign = "left" }
                ToolButton { text: "\u2550"; onClicked: root.textAlign = "center" }
                ToolButton { text: "\u2261"; onClicked: root.textAlign = "right" }

                ToolSeparator {}

                // -- Grupo de tamano: botones A- y A+ con limites min/max
                ToolButton { text: "A\u207B"; onClicked: root.fontSize = Math.max(10, root.fontSize - 2) }
                Label { text: root.fontSize + "px"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }
                ToolButton { text: "A\u207A"; onClicked: root.fontSize = Math.min(32, root.fontSize + 2) }
            }
        }

        // -- Area de texto editable que refleja el formato seleccionado.
        //    Los bindings declarativos garantizan que cualquier cambio en las
        //    propiedades de formato se refleja inmediatamente en el texto.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            TextArea {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                text: root.textContent
                onTextChanged: root.textContent = text
                font.pixelSize: Style.resize(root.fontSize)
                font.bold: root.isBold
                font.italic: root.isItalic
                font.underline: root.isUnderline
                horizontalAlignment: root.textAlign === "center" ? Text.AlignHCenter
                                   : root.textAlign === "right" ? Text.AlignRight
                                   : Text.AlignLeft
                color: Style.fontPrimaryColor
                wrapMode: Text.WordWrap
                background: null
            }
        }

        // -- Barra de estado mostrando la configuracion actual
        Label {
            text: "Bold: " + root.isBold + " | Italic: " + root.isItalic + " | Size: " + root.fontSize + "px | Align: " + root.textAlign
            font.pixelSize: Style.resize(11)
            color: Style.inactiveColor
            Layout.fillWidth: true
        }
    }
}
