// =============================================================================
// MenuItem.qml — Override de estilo para MenuItem (item individual dentro de Menu)
// =============================================================================
//
// Cada MenuItem tiene tres partes visuales:
//   1. contentItem — el texto del item
//   2. indicator — marca de verificacion (solo para items checkable)
//   3. background — rectangulo de fondo (resaltado al pasar el cursor)
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.MenuItem con la logica (text, checked, checkable,
// highlighted, etc.) sin visual.
//
// ---- highlighted vs hovered ----
// MenuItem usa "highlighted" en vez de "hovered". Es el Menu padre quien
// establece highlighted cuando el item esta bajo el cursor. Esto permite
// al Menu controlar la navegacion con teclado (flechas arriba/abajo)
// ademas del raton.
//
// ---- leftPadding en contentItem cuando checkable ----
// Cuando el item es checkable, el texto se desplaza a la derecha para
// dejar espacio al indicador (checkbox) a la izquierda.
//
// ---- Indicator: checkbox para items checkable ----
// Solo visible cuando checkable es true. Muestra un cuadrado con borde
// y una marca de verificacion (unicode checkmark) cuando checked es true.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.MenuItem {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             indicator ? indicator.implicitHeight + topPadding + bottomPadding : 0)

    padding: Style.resize(8)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    // --- contentItem: texto del item ---
    // leftPadding condicional: si es checkable, desplaza el texto a la derecha
    // para dejar espacio al indicador (checkbox)
    contentItem: Text {
        leftPadding: root.checkable ? root.indicator.width + root.spacing : 0
        text: root.text
        font.pixelSize: Style.resize(14)
        // highlighted: lo establece el Menu padre cuando el item esta bajo el cursor
        // (no es lo mismo que "hovered" — permite navegacion por teclado tambien)
        color: root.enabled ? (root.highlighted ? Style.mainColor : Style.fontPrimaryColor) : Style.inactiveColor
        verticalAlignment: Text.AlignVCenter
    }

    // --- Indicator: checkbox para items marcables ---
    // Solo visible cuando checkable es true.
    // Muestra cuadrado con borde + marca de verificacion unicode cuando checked.
    indicator: Rectangle {
        x: Style.resize(8)
        y: root.topPadding + (root.availableHeight - height) / 2
        width: Style.resize(16)
        height: Style.resize(16)
        radius: Style.resize(3)
        visible: root.checkable
        color: "transparent"
        border.color: root.checked ? Style.mainColor : Style.inactiveColor
        border.width: 1

        // Marca de verificacion (checkmark unicode)
        Text {
            anchors.centerIn: parent
            text: "\u2713"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
            visible: root.checked
        }
    }

    // --- Background: fondo con resaltado ---
    // Se ilumina con bgColor cuando highlighted (cursor sobre el item)
    background: Rectangle {
        implicitWidth: Style.resize(170)
        implicitHeight: Style.resize(36)
        radius: Style.resize(4)
        color: root.highlighted ? Style.bgColor : "transparent"
    }
}
