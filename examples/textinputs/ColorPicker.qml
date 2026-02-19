// =============================================================================
// ColorPicker.qml — Selector de color con paleta de muestras (swatches)
// =============================================================================
// Implementa un selector de color simple basado en una paleta predefinida de
// 12 colores. El usuario hace clic en una muestra (swatch) para seleccionar
// el color, que se refleja en un rectangulo de preview con el codigo hex.
//
// Patrones educativos:
//   - Repeater con modelo de strings: el modelo es un array de colores
//     hexadecimales. `modelData` da acceso directo al string de cada color
//     sin necesidad de definir roles. Es la forma mas simple de modelo.
//   - Seleccion visual con binding comparativo: `border.color` compara
//     el color del swatch con `selectedColor`. Solo el swatch seleccionado
//     muestra un borde blanco — los demas son transparentes.
//   - Hover con escala animada: `scale: containsMouse ? 1.15 : 1.0` con
//     Behavior da un efecto sutil de "pop" al pasar el cursor, reforzando
//     la interactividad sin necesidad de estados complejos.
//   - Item spacer: `Item { Layout.fillWidth: true }` actua como un
//     espaciador flexible que empuja el rectangulo de preview a la derecha.
//     Es el equivalente de `flex-grow: 1` en CSS Flexbox.
//   - font.family: "monospace" para el codigo hexadecimal, porque los
//     caracteres de ancho fijo alinean mejor los codigos de color.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Color Picker"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        id: colorPickerRow
        Layout.fillWidth: true
        spacing: Style.resize(10)

        // Color actualmente seleccionado
        property string selectedColor: "#00D1A9"

        // -----------------------------------------------------------------
        // Paleta de colores: 12 muestras generadas con Repeater. Cada una
        // es un Rectangle clickeable con animacion de escala al hover.
        // El borde blanco indica la seleccion actual.
        // -----------------------------------------------------------------
        Repeater {
            model: [
                "#EF5350", "#FF7043", "#FFA726", "#FFCA28",
                "#66BB6A", "#26A69A", "#00D1A9", "#42A5F5",
                "#5C6BC0", "#AB47BC", "#EC407A", "#8D6E63"
            ]

            Rectangle {
                id: swatch
                required property string modelData
                required property int index

                width: Style.resize(32)
                height: Style.resize(32)
                radius: Style.resize(6)
                color: modelData
                border.color: colorPickerRow.selectedColor === modelData
                              ? "white" : "transparent"
                border.width: 2

                scale: swatchMa.containsMouse ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                MouseArea {
                    id: swatchMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: colorPickerRow.selectedColor = swatch.modelData
                }
            }
        }

        // Spacer flexible: empuja la preview hacia la derecha
        Item { Layout.fillWidth: true }

        // -----------------------------------------------------------------
        // Preview del color seleccionado: muestra el rectangulo coloreado
        // con el codigo hexadecimal superpuesto en fuente monospace.
        // -----------------------------------------------------------------
        Rectangle {
            width: Style.resize(120)
            height: Style.resize(32)
            radius: Style.resize(6)
            color: colorPickerRow.selectedColor

            Label {
                anchors.centerIn: parent
                text: colorPickerRow.selectedColor
                font.pixelSize: Style.resize(12)
                font.bold: true
                font.family: "monospace"
                color: "white"
            }
        }
    }
}
