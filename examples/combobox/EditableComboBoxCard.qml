// =============================================================================
// EditableComboBoxCard.qml — Tarjeta de ComboBox editable
// =============================================================================
// Explora la propiedad editable de ComboBox, que permite al usuario escribir
// texto libre ademas de seleccionar de la lista desplegable.
//
// Se cubren tres escenarios progresivos:
//   1. Editable basico: el usuario puede teclear un valor personalizado.
//   2. Modelo dinamico: se agregan nuevos items al presionar Enter (onAccepted).
//   3. Validador: IntValidator restringe la entrada a numeros en un rango.
//
// Aprendizaje clave:
//   - editable: true convierte el ComboBox en un campo de texto + desplegable.
//   - editText (no currentText) refleja lo que el usuario ha escrito.
//   - onAccepted se emite cuando el usuario presiona Enter; ideal para agregar
//     elementos dinamicos al modelo.
//   - find() busca un texto en el modelo y devuelve -1 si no existe.
//   - validator restringe los caracteres que el usuario puede ingresar.
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
        spacing: Style.resize(20)

        Label {
            text: "Editable ComboBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Ejemplo 1: ComboBox editable basico
        // editable: true permite escribir libremente. editText contiene
        // lo que el usuario escribe (puede diferir de currentText si el
        // texto escrito no coincide con ningun elemento de la lista).
        // Caso de uso tipico: selector de tamano de fuente.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Type or select a font size"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: editableCombo
                Layout.fillWidth: true
                editable: true
                model: ["8", "10", "12", "14", "16", "18", "20", "24", "28", "32", "48", "72"]
                currentIndex: 4
            }

            Label {
                text: "Current value: " + editableCombo.editText + " pt"
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 2: Agregar items dinamicamente con onAccepted
        // Cuando el usuario escribe un texto nuevo y presiona Enter,
        // onAccepted se dispara. Usamos find() para verificar que el
        // texto no exista ya en el modelo antes de agregarlo con append().
        // Necesitamos un ListModel (no un array JS) porque los arrays
        // no soportan append() para modificacion dinamica.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Add custom items (press Enter)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: dynamicCombo
                Layout.fillWidth: true
                editable: true
                model: ListModel {
                    id: dynamicModel
                    ListElement { text: "Red" }
                    ListElement { text: "Green" }
                    ListElement { text: "Blue" }
                }
                onAccepted: {
                    if (find(editText) === -1) {
                        dynamicModel.append({text: editText})
                        currentIndex = dynamicModel.count - 1
                    }
                }
            }

            Label {
                text: "Items: " + dynamicModel.count
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 3: Validador numerico
        // IntValidator restringe la entrada para que el usuario solo pueda
        // escribir numeros enteros entre 0 y 999. Esto es util cuando el
        // ComboBox necesita aceptar valores numericos personalizados pero
        // dentro de un rango valido. El validador actua a nivel de
        // caracteres: impide escribir letras o numeros fuera de rango.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Numeric only (IntValidator 0-999)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: validatorCombo
                Layout.fillWidth: true
                editable: true
                model: ["100", "200", "300", "500"]
                validator: IntValidator { bottom: 0; top: 999 }
            }

            Label {
                text: "Value: " + validatorCombo.editText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }
    }
}
