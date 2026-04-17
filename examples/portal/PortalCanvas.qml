// =============================================================================
// PortalCanvas.qml — Portal Rick & Morty basado en AnimatedImage + Glow
// =============================================================================
// Capas (de abajo hacia arriba):
//   1. Glow (Qt5Compat.GraphicalEffects) — halo verde, actúa sobre gifCapture
//   2. AnimatedImage — el GIF nítido
//   3. ShaderEffectSource — captura offscreen del GIF para el Glow
//   4. MouseArea — click para abrir/cerrar, hover para ampliar glow
//
// API pública:
//   active    (bool)  — activa/pausa la reproducción del GIF
//   open      (bool)  — escala entre 0 y 1 con Easing.OutBack
//   glowValue (int)   — radio base del glow (0–60), controlado por slider
//   hovered   (bool)  — true mientras el ratón está dentro
//   gifItem   (alias) — expone el AnimatedImage interno para ReflectionCanvas
// =============================================================================
import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property bool active:    false
    property bool open:      true
    property int  glowValue: 30
    property bool hovered:   false
    property alias gifItem:  gif

    // ── Animación de apertura/cierre ─────────────────────────────────────────
    scale: open ? 1.0 : 0.0
    Behavior on scale {
        NumberAnimation { duration: 600; easing.type: Easing.OutBack }
    }

    // ── 1. Glow detrás — emite el halo verde ────────────────────────────────
    // Declarado primero para quedar debajo del GIF en el z-order.
    // Usa gifCapture como fuente para no interferir con la visibilidad de gif.
    Glow {
        anchors.fill: gif
        source:  gifCapture
        radius:  root.hovered ? Math.min(root.glowValue * 1.5, 80)
                              : root.glowValue
        samples: 17
        color:   "#7FFF00"
        spread:  0.0
        Behavior on radius {
            NumberAnimation { duration: 200 }
        }
    }

    // ── 2. GIF principal (nítido, encima del glow) ───────────────────────────
    AnimatedImage {
        id: gif
        anchors.fill: parent
        source:   "qrc:/assets/images/portalRickAndMorty.gif"
        fillMode: Image.PreserveAspectFit
        playing:  root.active
    }

    // ── 3. Captura offscreen del GIF para el Glow ────────────────────────────
    // hideSource: false — gif permanece visible. visible: false — este item
    // no se renderiza directamente, solo sirve de fuente al efecto Glow.
    ShaderEffectSource {
        id: gifCapture
        sourceItem: gif
        anchors.fill: gif
        hideSource: false
        live:       true
        visible:    false
    }

    // ── 4. MouseArea ─────────────────────────────────────────────────────────
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked:              root.open    = !root.open
        onContainsMouseChanged: root.hovered = containsMouse
    }
}
