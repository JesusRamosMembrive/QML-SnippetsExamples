// =============================================================================
// ReflectionCanvas.qml — Reflejo del portal en el suelo
// =============================================================================
// Replica el dibujo de portal_draw.js con ctx.scale(1,-1) para invertirlo,
// luego superpone un degradado negro para simular el desvanecimiento en el suelo.
//
// API pública:
//   angle       (real)  — ángulo de rotación actual (sincronizado con PortalCanvas)
//   glowValue   (int)   — shadowBlur (mismo valor que PortalCanvas)
//
// No tiene Timer propio: repinta reactivamente cuando cambia `angle`,
// que está enlazado al alias de PortalCanvas. Esto garantiza que el
// reflejo solo se actualiza cuando el portal lo hace.
// =============================================================================
import QtQuick
import "portal_draw.js" as Draw

Canvas {
    id: root

    property real angle:     0.0
    property int  glowValue: 30

    onAvailableChanged: if (available) requestPaint()
    onAngleChanged:     requestPaint()
    onGlowValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)

        // Invertir verticalmente: transladar al borde inferior, escalar Y=-1
        // Así el "suelo" del portal queda arriba del canvas de reflejo,
        // que visualmente está debajo del canvas del portal.
        ctx.save()
        ctx.translate(0, height)
        ctx.scale(1, -1)
        Draw.drawPortal(ctx, width, height, root.angle, root.glowValue * 0.5, 0.35)
        ctx.restore()

        // Degradado de desvanecimiento: transparente arriba, negro abajo
        Draw.applyReflectionGradient(ctx, width, height)
    }
}
