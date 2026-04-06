// =============================================================================
// PortalCanvas.qml — Canvas principal del portal de Rick & Morty
// =============================================================================
// Dibuja el portal (espiral verde, glow, destellos) usando Canvas 2D.
// Delega el dibujo a portal_draw.js para compartir la lógica con
// ReflectionCanvas.
//
// API pública:
//   active      (bool)  — activa/desactiva el Timer (CPU off cuando no visible)
//   open        (bool)  — anima apertura/cierre del portal via scale
//   rotSpeed    (real)  — velocidad de rotación (incremento de angle por tick)
//   glowValue   (int)   — shadowBlur pasado a drawPortal (0–60)
//   hovered     (bool)  — true mientras el ratón está dentro (leído por Main)
//   angle       (alias) — alias de canvas.angle, expuesto para ReflectionCanvas
// =============================================================================
import QtQuick
import utils
import "portal_draw.js" as Draw

Item {
    id: root

    // ── API pública ──────────────────────────────────────────────────────────
    property bool active:    false
    property bool open:      true
    property real rotSpeed:  0.025   // radianes por tick
    property int  glowValue: 30
    property bool hovered:   false

    // Expone el ángulo interno para que ReflectionCanvas lo sincronice
    // (los ids internos de un componente no son accesibles desde fuera)
    property alias angle: canvas.angle

    // ── Animación de apertura/cierre ─────────────────────────────────────────
    // scale va de 0 (cerrado) a 1 (abierto). OutBack da el "rebote" característico.
    scale: open ? 1.0 : 0.0
    Behavior on scale {
        NumberAnimation { duration: 600; easing.type: Easing.OutBack }
    }

    // ── Canvas ───────────────────────────────────────────────────────────────
    Canvas {
        id: canvas
        anchors.fill: parent
        onAvailableChanged: if (available) requestPaint()

        // Estado interno de animación
        property real angle: 0.0

        Timer {
            interval: 30
            repeat:   true
            running:  root.active
            onTriggered: {
                canvas.angle = canvas.angle + root.rotSpeed
                canvas.requestPaint()
            }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            Draw.drawPortal(ctx, width, height, canvas.angle, root.glowValue, 1.0)
        }
    }

    // ── MouseArea: click para abrir/cerrar ───────────────────────────────────
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked:              root.open    = !root.open
        onContainsMouseChanged: root.hovered = containsMouse
    }
}
