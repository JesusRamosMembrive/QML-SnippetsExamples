// =============================================================================
// ToolTip.qml - Override de estilo para ToolTip
// =============================================================================
//
// ToolTip es un popup flotante que aparece al pasar el cursor sobre un control.
// Se posiciona automaticamente encima del padre y se cierra con Escape o click.
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de ToolTip. Importar Controls causaria recursion infinita.
//   Templates provee solo la logica (texto, delay, timeout) sin apariencia.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - contentItem: el texto del tooltip
//   - background: el rectangulo oscuro de fondo
//
// POSICIONAMIENTO (x, y):
//   - x centra el tooltip horizontalmente sobre su padre:
//       (parent.width - implicitWidth) / 2
//   - y lo coloca ENCIMA del padre con un pequeño espacio:
//       -implicitHeight - 4px
//
// GUARDA CONTRA parent NULL:
//   "parent ? ... : 0" — los tooltips pueden quedar momentaneamente sin
//   padre durante la creacion o destruccion. Sin esta guarda, acceder a
//   parent.width cuando parent es null causaria un error de referencia.
//
// closePolicy:
//   Controla cuando el tooltip se cierra automaticamente. Se combinan
//   multiples flags con | (OR bit a bit):
//     - CloseOnEscape: se cierra al presionar Escape
//     - CloseOnPressOutsideParent: se cierra al hacer click fuera
//     - CloseOnReleaseOutsideParent: se cierra al soltar el click fuera
//   Usamos T.Popup.CloseOn... (de Templates) para las constantes.
//
// enter / exit Transitions:
//   Animaciones de opacidad para aparecer/desaparecer suavemente.
//   enter: 0.0 -> 1.0 en 120ms (aparece)
//   exit:  1.0 -> 0.0 en 80ms  (desaparece, mas rapido para no estorbar)
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.ToolTip {
    id: root

    // Centrar horizontalmente; colocar encima del padre con separacion
    // "parent ?" guarda contra null (tooltips pueden no tener padre momentaneamente)
    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: parent ? -implicitHeight - Style.resize(4) : 0

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Style.resize(8)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    // Politica de cierre: combina flags con | (OR bit a bit)
    // Escape + click fuera + soltar fuera = cierra el tooltip
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
                 | T.Popup.CloseOnReleaseOutsideParent

    // SLOT contentItem: texto blanco sobre fondo oscuro
    contentItem: Text {
        text: root.text
        font.pixelSize: Style.resize(12)
        color: "#FFFFFF"
        wrapMode: Text.WordWrap
    }

    // SLOT background: rectangulo oscuro con esquinas redondeadas
    background: Rectangle {
        color: "#333333"
        radius: Style.resize(6)
    }

    // Transicion de entrada: fade in (120ms)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 120 }
    }

    // Transicion de salida: fade out (80ms, mas rapido para no estorbar)
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 80 }
    }
}
