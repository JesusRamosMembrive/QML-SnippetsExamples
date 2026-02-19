// ============================================================================
// TextField.qml — Override de estilo para TextField (entrada de texto de una línea)
// ============================================================================
//
// Este archivo redefine la apariencia visual del control TextField.
// TextField es un campo de texto editable de una sola línea.
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del TextField ---
//   - background:   el rectángulo de fondo con borde (el único que usamos)
//   - contentItem:  (no se redefine aquí) TextField ya tiene un TextInput
//                    interno como contentItem por defecto
//   - indicator:    (no aplica) TextField no tiene indicator
//
// --- activeFocus vs hovered ---
//   - activeFocus: el campo tiene el foco de teclado (el usuario hizo clic
//     en él o navegó con Tab). El texto que escriba irá a este campo.
//   - hovered: el cursor del mouse está sobre el campo, pero no
//     necesariamente tiene foco. Es un estado visual de "pre-interacción".
//
// --- Cadena ternaria del border.color ---
// El color del borde cambia según el estado del campo, dando feedback visual:
//   1. activeFocus  → mainColor (color de acento, indica "estás escribiendo aquí")
//   2. hovered      → color inactivo más claro (indica "puedes hacer clic")
//   3. default      → color inactivo (estado de reposo)
//
// --- Behavior on border.color ---
// Anima la transición de color del borde en 150ms para que el cambio sea
// suave en lugar de abrupto. Sin esto, el borde cambiaría de color
// instantáneamente al hacer hover o clic.
//
// --- selectionColor / selectedTextColor ---
// Colores que se aplican cuando el usuario selecciona texto con el mouse
// o con Shift+flechas. selectionColor es el fondo de la selección,
// selectedTextColor es el color del texto seleccionado.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado, pero estos son los
// valores por defecto.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.TextField {
    id: root

    // --- Tamaño implícito: el tamaño "natural" sin width/height explícitos ---
    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(40)

    color: Style.fontPrimaryColor
    placeholderTextColor: Style.inactiveColor
    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS

    // Colores de selección de texto (cuando el usuario arrastra con el mouse)
    selectionColor: Style.mainColor       // Fondo de la selección
    selectedTextColor: "white"            // Texto seleccionado

    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)
    verticalAlignment: TextInput.AlignVCenter

    // --- background: el rectángulo de fondo con borde reactivo ---
    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)

        // Cadena ternaria: activeFocus → mainColor, hovered → más claro, default → inactivo
        border.color: root.activeFocus ? Style.mainColor
                      : root.hovered ? Qt.lighter(Style.inactiveColor, 1.2)
                      : Style.inactiveColor

        // Transición suave del color del borde (150ms) en vez de cambio abrupto
        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }
}
