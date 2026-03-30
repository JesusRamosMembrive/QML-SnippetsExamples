// =============================================================================
// GlassCard.qml — Tarjeta glassmorphism (cristal esmerilado)
// =============================================================================
// Técnica:
//   1. ShaderEffectSource DENTRO de la tarjeta captura el ítem de fondo.
//      Posicionado en (-card.x, -card.y) para alinear con lo que hay debajo.
//   2. MultiEffect aplica blur gaussiano sobre esa captura.
//   3. clip:true en la tarjeta recorta ambos al área de la tarjeta.
//   4. Capas de tinte + gradiente + borde van encima.
//
// backgroundItem: el QML Item del fondo (NO un ShaderEffectSource).
// =============================================================================

import QtQuick
import QtQuick.Effects

Rectangle {
    id: root

    // El ítem del fondo a capturar (debe ser ancestor o sibling en el mismo
    // sistema de coordenadas que GlassCard).
    property Item backgroundItem

    property real blurRadius:    28
    property real tintOpacity:   0.10
    property real borderOpacity: 0.25

    clip:   true
    color:  "transparent"
    radius: 20

    // ── Capa 1: captura del fondo + blur ───────────────────────────────────
    ShaderEffectSource {
        id: bgCapture
        sourceItem: root.backgroundItem
        // Desplazamos el ShaderEffectSource hacia (-x, -y) de la tarjeta
        // para que la región visible a través del clip sea exactamente
        // la zona del fondo que queda detrás de la tarjeta.
        x: root.backgroundItem ? -root.x : 0
        y: root.backgroundItem ? -root.y : 0
        width:      root.backgroundItem ? root.backgroundItem.width  : root.width
        height:     root.backgroundItem ? root.backgroundItem.height : root.height
        hideSource: false
        live:       true
    }

    MultiEffect {
        source:  bgCapture
        x:       bgCapture.x
        y:       bgCapture.y
        width:   bgCapture.width
        height:  bgCapture.height

        blurEnabled:    root.backgroundItem !== null && root.backgroundItem !== undefined
        blur:           1.0
        blurMax:        Math.max(4, Math.round(root.blurRadius))
        blurMultiplier: 0.5
    }

    // ── Capa 2: tinte blanco (oscurece y da cuerpo al cristal) ────────────
    Rectangle {
        anchors.fill: parent
        radius:       root.radius
        color:        Qt.rgba(1, 1, 1, root.tintOpacity)
    }

    // ── Capa 3: gradiente de profundidad ───────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius:       root.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.12) }
            GradientStop { position: 0.4; color: Qt.rgba(1, 1, 1, 0.02) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.14) }
        }
    }

    // ── Capa 4: borde luminoso ─────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius:       root.radius
        color:        "transparent"
        border.color: Qt.rgba(1, 1, 1, root.borderOpacity)
        border.width: 1
    }
}
