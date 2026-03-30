// =============================================================================
// LensEffectRect.qml — Overlay de cristal GPU con forma de píldora
// =============================================================================
// ShaderEffect que dibuja una píldora de cristal (rectángulo con esquinas
// totalmente redondeadas) usando un SDF en la GPU. No necesita textura fuente:
// genera el cristal desde cero y es transparente fuera de la píldora.
//
// Uso en LensTabStrip:
//   LensEffectRect {
//       anchors.fill: track        // cubre todo el track
//       lensUVX:  (lensWindow.x + lensWindow.width  / 2.0) / width
//       lensUVY:  0.5
//       lensHalfWUV: lensWindow.width  / (2.0 * width)
//       lensHalfHUV: lensWindow.height / (2.0 * height)
//       cornerRadiusUV: lensWindow.height / (2.0 * height)  // píldora completa
//   }
//
// El componente es transparente fuera de la píldora, por lo que el track
// y el texto base son visibles a través de él. Dentro de la píldora dibuja:
//   - Gradiente blanco-frío → menta suave (cuerpo de cristal)
//   - Specular superior (reflejo de luz cenital)
//   - Rim highlight (borde luminoso que da espesor al cristal)
//   - Aberración cromática en el contorno (franja roja/azul)
//   - Halo teal exterior (resplandor ambiente)
// =============================================================================

import QtQuick

ShaderEffect {
    id: root

    // ── Centro de la píldora en coordenadas UV normalizadas (0..1) ──────────
    property real lensUVX:         0.25
    property real lensUVY:         0.5

    // ── Dimensiones de la píldora en UV ─────────────────────────────────────
    // Expresadas relativas a las dimensiones del propio ítem ShaderEffect.
    // lensHalfWUV = pillWidth  / (2 * itemWidth)
    // lensHalfHUV = pillHeight / (2 * itemHeight)
    property real lensHalfWUV:     0.10
    property real lensHalfHUV:     0.42

    // ── Radio de esquina ──────────────────────────────────────────────────────
    // En unidades Y-UV (igual que lensHalfHUV).
    // cornerRadiusUV = lensHalfHUV → píldora completa (stadium/cápsula).
    property real cornerRadiusUV:  0.42

    // ── Corrección de aspecto ─────────────────────────────────────────────────
    // El espacio UV no es isótropo (X va de 0..1 en el ancho, Y en el alto).
    // Multiplicar X por aspectRatio hace que el SDF opere en un espacio
    // donde ambos ejes tienen la misma escala física, produciendo una píldora
    // correctamente circular en pantalla independientemente de las dimensiones.
    property real aspectRatio:     width / height

    // ── Efecto óptico ─────────────────────────────────────────────────────────
    property real aberration:      0.010   // aberración cromática (0=off, 0.02=fuerte)
    property real glowStrength:    0.30    // intensidad del halo teal exterior

    // Rutas a los shaders compilados (QSB).
    // PREFIX en qt6_add_shaders de lenstabs es "/qt/qml/lenstabs".
    vertexShader:   "qrc:/qt/qml/lenstabs/shaders/lens_rect.vert.qsb"
    fragmentShader: "qrc:/qt/qml/lenstabs/shaders/lens_rect.frag.qsb"
}
