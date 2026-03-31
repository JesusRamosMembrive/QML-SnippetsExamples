// =============================================================================
// LensCircleEffect.qml — Lente circular GPU con magnificación real del contenido
// =============================================================================
// ShaderEffect que aplica una lente convexa circular a una textura fuente.
// Usa barrel distortion + magnificación + aberración cromática + tinte de cristal.
//
// Uso en LensTabStrip:
//   LensCircleEffect {
//       anchors.fill: track
//       source:         tabSource          // ShaderEffectSource del contenido
//       lensX:          lensProxy.x / width
//       lensY:          0.5
//       lensRadius:     0.50               // radio = semialtura del ítem → círculo inscrito
//       aspectRatio:    width / height
//       magnification:  1.6
//       aberration:     0.012
//       rimBrightness:  0.6
//   }
// =============================================================================

import QtQuick

ShaderEffect {
    id: root

    // ── Fuente de la textura ─────────────────────────────────────────────────
    property var source

    // ── Centro de la lente en UV (0..1) ─────────────────────────────────────
    property real lensX:         0.5
    property real lensY:         0.5

    // ── Radio de la lente en unidades UV-Y ──────────────────────────────────
    // lensRadius = 0.5 → círculo que ocupa exactamente la altura del ítem.
    property real lensRadius:    0.20

    // ── Corrección de aspecto ─────────────────────────────────────────────────
    property real aspectRatio:   width / height

    // ── Óptica ────────────────────────────────────────────────────────────────
    property real magnification: 1.1    // 1.0 = sin magnificación
    property real aberration:    0.008  // aberración cromática (0=off, 0.04=fuerte)
    property real rimBrightness: 1.6    // intensidad del highlight en el borde
    property real lensWiden:     1.3    // ensanche horizontal (1.0=circular, 2.0=doble ancho)

    vertexShader:   "qrc:/qt/qml/lenstabs/shaders/lens_circle.vert.qsb"
    fragmentShader: "qrc:/qt/qml/lenstabs/shaders/lens_circle.frag.qsb"
}
