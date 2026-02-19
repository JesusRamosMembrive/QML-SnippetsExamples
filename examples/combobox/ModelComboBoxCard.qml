// =============================================================================
// ModelComboBoxCard.qml — Tarjeta de ComboBox con ListModel y roles
// =============================================================================
// Demuestra como usar ComboBox con modelos estructurados (ListModel) en lugar
// de simples arrays de strings. Esto es fundamental en aplicaciones reales
// donde cada elemento tiene multiples propiedades (ej: nombre + codigo).
//
// Tres ejemplos progresivos:
//   1. textRole + valueRole: separar lo que se muestra de lo que se usa como valor.
//   2. displayText personalizado: formato libre para el texto del ComboBox cerrado.
//   3. Modelo numerico grande: model: 50 genera 50 indices automaticamente.
//
// Aprendizaje clave:
//   - textRole indica que rol del modelo mostrar al usuario.
//   - valueRole indica que rol usar como valor interno (accesible via currentValue).
//   - displayText permite personalizar el texto mostrado en el ComboBox cerrado,
//     a diferencia de currentText que refleja directamente el textRole.
//   - model: <numero> crea un modelo de enteros de 0 a N-1 (util para pruebas).
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
            text: "ListModel & Roles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Ejemplo 1: textRole y valueRole
        // Patron clave para listas de datos estructurados. El ComboBox
        // muestra "name" (nombre legible) pero internamente trabaja con
        // "code" (codigo de pais). Esto permite separar la presentacion
        // del valor logico, similar a un <select> HTML con value/text.
        // currentText -> "Spain", currentValue -> "ES"
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "textRole + valueRole"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: roleCombo
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "code"
                model: ListModel {
                    ListElement { name: "United States"; code: "US" }
                    ListElement { name: "United Kingdom"; code: "UK" }
                    ListElement { name: "Germany"; code: "DE" }
                    ListElement { name: "Japan"; code: "JP" }
                    ListElement { name: "Spain"; code: "ES" }
                    ListElement { name: "France"; code: "FR" }
                }
            }

            Label {
                text: "Country: " + roleCombo.currentText + " — Code: " + roleCombo.currentValue
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 2: displayText personalizado
        // displayText sobreescribe el texto que se muestra en el ComboBox
        // cuando esta cerrado. Aqui se combina currentText con currentValue
        // para un formato "High (3)". Tambien se muestra un placeholder
        // cuando currentIndex es -1 (sin seleccion). Nota: en la practica,
        // ComboBox siempre arranca en indice 0, pero el patron es valido
        // si se establece currentIndex: -1 programaticamente.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Custom displayText"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: displayCombo
                Layout.fillWidth: true
                textRole: "label"
                valueRole: "value"
                displayText: currentIndex === -1 ? "-- Select priority --" : currentText + " (" + currentValue + ")"
                model: ListModel {
                    ListElement { label: "Low"; value: 1 }
                    ListElement { label: "Medium"; value: 2 }
                    ListElement { label: "High"; value: 3 }
                    ListElement { label: "Critical"; value: 4 }
                }
            }

            Label {
                text: displayCombo.currentIndex >= 0
                      ? "Priority level: " + displayCombo.currentValue
                      : "No selection"
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 3: Modelo numerico grande
        // model: 50 genera automaticamente 50 elementos (indices 0..49).
        // El popup del ComboBox se vuelve scrollable cuando hay muchos
        // elementos. displayText se usa aqui para dar formato al texto
        // mostrado porque un modelo numerico no tiene roles de texto.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Large model (scrollable popup)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: largeCombo
                Layout.fillWidth: true
                model: 50
                displayText: "Item " + currentIndex
            }

            Label {
                text: "Selected index: " + largeCombo.currentIndex
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }
    }
}
