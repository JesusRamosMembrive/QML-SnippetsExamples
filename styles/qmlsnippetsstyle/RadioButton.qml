// ============================================================================
// RadioButton.qml — Override de estilo para RadioButton
// ============================================================================
//
// Este archivo redefine la apariencia visual del control RadioButton.
// La estructura es muy similar a CheckBox, pero con un indicador circular
// en lugar de cuadrado (radius: width/2 crea un círculo perfecto).
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del RadioButton ---
//   - indicator:    el círculo visual (relleno = seleccionado, gris = no)
//   - contentItem:  el texto/etiqueta junto al círculo
//   - background:   (no se usa aquí) el visual detrás de todo el control
//
// --- Auto-exclusividad ---
// Los RadioButtons dentro de un mismo padre son auto-exclusivos por defecto:
// solo uno puede estar seleccionado a la vez. No necesitas código extra
// para gestionar esto — Qt lo maneja automáticamente.
//
// --- icon.color como color de acento ---
// Igual que en CheckBox, se reutiliza icon.color como color de acento.
// Este patrón permite personalizar el color por instancia.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado, pero estos son los
// valores por defecto.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.RadioButton {
    id: root

    // --- Tamaño implícito: el tamaño "natural" sin width/height explícitos ---
    implicitWidth: Style.resize(120)
    implicitHeight: Style.resize(50)

    // icon.color reutilizado como color de acento del radio button
    icon.color: Style.mainColor

    // --- indicator: el círculo visual del radio button ---
    // radius: width/2 lo convierte en un círculo perfecto.
    // A diferencia del CheckBox (cuadrado con bordes), aquí el indicador
    // es un círculo sólido que cambia de color según el estado.
    indicator: Rectangle {
        id: indicatorRect
        width: root.height
        height: root.height
        radius: (width / 2)  // Círculo perfecto
        color: root.checked ? root.icon.color : Style.inactiveColor
    }

    // --- contentItem: el texto/etiqueta junto al indicator ---
    contentItem: Item {
        width: (parent.width - indicatorRect.width - Style.resize(10))
        height: parent.height
        anchors.left: indicatorRect.right
        anchors.leftMargin: Style.resize(10)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            color: root.checked ? root.icon.color : Style.inactiveColor
            text: root.text
        }
    }
}
