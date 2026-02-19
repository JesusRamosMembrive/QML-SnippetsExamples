// =============================================================================
// EditableLabels.qml — Labels editables con click (inline editing)
// =============================================================================
// Implementa el patron "click-to-edit": campos que se muestran como texto
// estatico pero se convierten en campos editables al hacer clic. Este patron
// es comun en herramientas de gestion de proyectos (Jira, Notion, etc.)
// donde se quiere mostrar informacion compacta que el usuario puede modificar
// directamente.
//
// Patrones educativos:
//   - Alternancia de visibilidad: dos elementos (Label y TextInput) ocupan
//     el mismo espacio. Solo uno es visible segun la propiedad `editing`.
//     Es un patron mas simple que usar States/Transitions de QML.
//   - Manejo de teclado: Enter confirma la edicion, Escape la cancela.
//     onActiveFocusChanged guarda automaticamente si el foco se pierde
//     (por ejemplo, al hacer clic fuera), evitando perdida de datos.
//   - Repeater con modelo de objetos JS: el modelo es un array de objetos
//     con {label, value, color}. `modelData` da acceso a cada objeto.
//     Cada delegado mantiene su propio estado `currentValue` independiente.
//   - GridLayout con Repeater: genera 4 campos en formato 2x2 a partir
//     del modelo, sin escribir el layout 4 veces. El Repeater no es solo
//     para listas — es util para cualquier conjunto repetitivo de UI.
//   - Feedback visual: el campo cambia de fondo transparente a surfaceColor
//     y muestra un borde coloreado durante la edicion, con animacion suave.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Click-to-Edit Labels"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Style.resize(15)
        rowSpacing: Style.resize(10)

        Repeater {
            model: [
                { label: "Project Name", value: "QML Snippets", color: "#4FC3F7" },
                { label: "Version", value: "1.0.0", color: "#66BB6A" },
                { label: "Author", value: "Developer", color: "#FF8A65" },
                { label: "License", value: "MIT", color: "#CE93D8" }
            ]

            Rectangle {
                id: editableField
                required property var modelData
                required property int index

                // Estado local: controla si estamos en modo edicion
                property bool editing: false
                property string currentValue: modelData.value

                Layout.fillWidth: true
                height: Style.resize(60)
                radius: Style.resize(8)

                // En modo edicion: fondo oscuro con borde coloreado
                // En modo lectura: completamente transparente
                color: editing ? Style.surfaceColor : "transparent"
                border.color: editing ? modelData.color : "transparent"
                border.width: editing ? 2 : 0

                Behavior on color { ColorAnimation { duration: 200 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(10)
                    spacing: Style.resize(2)

                    // Etiqueta superior con el color del campo
                    Label {
                        text: editableField.modelData.label
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: editableField.modelData.color
                    }

                    // ---------------------------------------------------------
                    // Modo lectura: un Label con MouseArea. Al hacer clic,
                    // activa el modo edicion, copia el valor actual al
                    // TextInput, le da foco y selecciona todo el texto
                    // para facilitar el reemplazo rapido.
                    // ---------------------------------------------------------
                    Label {
                        visible: !editableField.editing
                        text: editableField.currentValue
                        font.pixelSize: Style.resize(15)
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                editableField.editing = true
                                inlineEditor.text = editableField.currentValue
                                inlineEditor.forceActiveFocus()
                                inlineEditor.selectAll()
                            }
                        }
                    }

                    // ---------------------------------------------------------
                    // Modo edicion: TextInput que reemplaza visualmente al
                    // Label. Maneja tres formas de confirmar/cancelar:
                    //   - Enter: guarda el valor y sale de edicion
                    //   - Escape: descarta cambios y sale
                    //   - Perdida de foco: guarda automaticamente (seguridad)
                    // ---------------------------------------------------------
                    TextInput {
                        id: inlineEditor
                        visible: editableField.editing
                        font.pixelSize: Style.resize(15)
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true
                        selectByMouse: true
                        selectionColor: editableField.modelData.color

                        Keys.onReturnPressed: {
                            editableField.currentValue = text
                            editableField.editing = false
                        }
                        Keys.onEscapePressed: {
                            editableField.editing = false
                        }
                        onActiveFocusChanged: {
                            if (!activeFocus && editableField.editing) {
                                editableField.currentValue = text
                                editableField.editing = false
                            }
                        }
                    }
                }

                // Icono indicador: lapiz en modo lectura, check en modo edicion
                Label {
                    anchors.right: parent.right
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    text: editableField.editing ? "\u2705" : "\u270F"
                    font.pixelSize: Style.resize(14)
                    opacity: editableField.editing ? 1.0 : 0.4
                }
            }
        }
    }
}
