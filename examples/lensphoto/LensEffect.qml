// =============================================================================
// LensEffect.qml — ShaderEffect de lente óptica con efectos GPU
// =============================================================================
// Aplica el shader GLSL compilado (QSB) sobre una imagen fuente.
//
// Uso:
//   Image { id: foto; source: "..."; visible: false }
//   LensEffect {
//       anchors.fill: parent
//       source:       foto
//       lensX:        mouseArea.mouseX / width
//       lensY:        mouseArea.mouseY / height
//       lensRadius:   sliderRadius.value / height
//   }
//
// Efectos en GPU:
//   - Magnificación con zoom configurable
//   - Distorsión barrel sutil en el borde
//   - Aberración cromática radial (R hacia fuera, B hacia dentro)
//   - Viñetado de borde
//   - Highlight especular en el rim superior
// =============================================================================

import QtQuick

ShaderEffect {
    id: root

    // Textura fuente. Qt crea automáticamente un ShaderEffectSource interno
    // cuando se asigna un Item aquí. El Item fuente debe tener visible: false
    // para evitar que se renderice dos veces.
    property var  source

    // Centro de la lente en coordenadas normalizadas 0..1
    property real lensX:          0.5
    property real lensY:          0.5

    // Radio de la lente normalizado: pixelRadius / itemHeight.
    // Se calcula en Main.qml como: radiusSlider.value / height
    property real lensRadius:     0.15

    // Corrección de aspecto para que la lente sea circular en pantalla.
    // UV space de ShaderEffect corre de (0,0) a (1,1) independientemente
    // de las dimensiones físicas del ítem; sin esta corrección la lente
    // sería elíptica en imágenes no cuadradas.
    property real aspectRatio:    width / height

    // Parámetros ópticos
    property real magnification:  2.0
    property real aberration:     0.012
    property real rimBrightness:  0.5

    // Rutas a los shaders compilados (QSB).
    // PREFIX en qt6_add_shaders es "/qt/qml/lensphoto", por lo que los
    // archivos quedan en "qrc:/qt/qml/lensphoto/shaders/lens.vert.qsb".
    vertexShader:   "qrc:/qt/qml/lensphoto/shaders/lens.vert.qsb"
    fragmentShader: "qrc:/qt/qml/lensphoto/shaders/lens.frag.qsb"
}
