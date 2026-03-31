// =============================================================================
// LensCircleEffect.qml — Lente GPU con forma de cápsula (pill)
// =============================================================================
import QtQuick

ShaderEffect {
    id: root

    property var  source

    property real lensX:                0.5
    property real lensY:                0.5
    property real lensRadius:           0.20
    property real aspectRatio:          width / height
    property real magnification:        0.6    // distorsión en los caps (0=plana)
    property real aberration:           0.008
    property real rimBrightness:        0.0    // sheen superior (0=off)
    property real lensWiden:            1.8    // ensanche horizontal

    // ── Efectos de vidrio configurables ──────────────────────────────────────
    property real tintStrength:         0.0    // tinte teal (0=off)
    property real noiseStrength:        0.0    // micro-textura (0=off)
    property real vignetteStrength:     0.0    // viñeta lateral (0=off)
    property real causticStrength:      0.0    // destellos en los caps (0=off)
    property real bottomShadowStrength: 0.0    // sombra inferior / grosor (0=off)

    vertexShader:   "qrc:/qt/qml/lenstabs/shaders/lens_circle.vert.qsb"
    fragmentShader: "qrc:/qt/qml/lenstabs/shaders/lens_circle.frag.qsb"
}
