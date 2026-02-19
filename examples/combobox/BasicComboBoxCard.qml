// =============================================================================
// BasicComboBoxCard.qml — Tarjeta de ComboBox basico
// =============================================================================
// Muestra los usos mas fundamentales de ComboBox: alimentarlo con un array
// de strings, establecer un indice inicial con currentIndex, y deshabilitarlo.
//
// Conceptos clave para el aprendiz:
//   - La forma mas sencilla de usar ComboBox: model con un array JS de strings.
//   - currentText devuelve el texto del elemento seleccionado (binding reactivo).
//   - currentIndex permite preseleccionar un elemento al inicializar.
//   - enabled: false deshabilita la interaccion (util para estados de la UI).
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

        // Titulo de la tarjeta
        Label {
            text: "Basic ComboBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Ejemplo 1: Lista simple de strings
        // La forma mas directa de usar ComboBox: pasar un array JS como
        // modelo. QML convierte cada string en un elemento seleccionable.
        // El Label inferior muestra currentText, que se actualiza
        // automaticamente gracias al sistema de bindings de QML.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "String list"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: basicCombo
                Layout.fillWidth: true
                model: ["Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"]
            }

            Label {
                text: "Selected: " + basicCombo.currentText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 2: Indice preseleccionado
        // currentIndex: 2 hace que el ComboBox arranque con "Large" activo
        // en vez del primer elemento. El Label muestra tanto el indice
        // numerico como el texto, demostrando ambas propiedades reactivas.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Pre-selected index (2)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: indexCombo
                Layout.fillWidth: true
                model: ["Small", "Medium", "Large", "Extra Large"]
                currentIndex: 2
            }

            Label {
                text: "Index: " + indexCombo.currentIndex + " — Value: " + indexCombo.currentText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // -----------------------------------------------------------------
        // Ejemplo 3: ComboBox deshabilitado
        // enabled: false impide toda interaccion del usuario. El estilo
        // personalizado (qmlsnippetsstyle) se encarga de mostrar la
        // apariencia visual atenuada automaticamente.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Disabled ComboBox"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            ComboBox {
                Layout.fillWidth: true
                model: ["Cannot select"]
                enabled: false
            }
        }
    }
}
