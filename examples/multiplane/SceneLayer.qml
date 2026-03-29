// =============================================================================
// SceneLayer.qml — Capa individual de la cámara multiplano
// =============================================================================
// Aplica la transformación de cámara multiplano a sus hijos.
// Este componente encapsula SOLO la matemática del efecto; el contenido visual
// (Canvas, Image, shapes…) se pone directamente como hijo de este item.
//
// MATEMÁTICAS:
//
//   Traslación (paralaje):
//     layerOffsetX = -cameraX × parallaxFactor
//     layerOffsetY = -cameraY × parallaxFactor
//
//   Escala (zoom):
//     layerScale = 1.0 + (cameraZoom − 1.0) × scaleResponse
//
//   Atenuación no lineal con exponente γ (falloff):
//     parallaxFactor = depth^γ     →  γ=1.5 aumenta el contraste perceptivo
//     scaleResponse  = depth^γ
//
// Por qué funciona la ilusión de profundidad:
//   depth=0.0 → parallaxFactor=0, scaleResponse=0
//     → capa estática: simula distancia infinita (fondo de cielo).
//   depth=1.0 → parallaxFactor=1, scaleResponse=1
//     → capa se mueve y escala igual que la cámara: parece muy cercana.
//   Las capas intermedias se interpolan entre estos extremos con la curva γ.
//
// Por qué la capa tiene 1.6× el tamaño del padre:
//   Al desplazar la capa por paralaje, su borde puede quedar visible.
//   Con 1.6× hay un margen de (0.3 × ancho) en cada lado, suficiente
//   para el paneo máximo de ±300 unidades en el slider.
// =============================================================================

import QtQuick

Item {
    id: root

    // ── Parámetros de profundidad (ajuste artístico) ───────────────────────
    // depth: define la posición en el espacio 3D simulado.
    //   0.0 = fondo infinitamente lejano (cielo)
    //   1.0 = primer plano muy cercano
    property real depth: 0.5

    // Respuesta al paneo de la cámara. Por defecto sigue la curva depth^1.5
    // (no lineal: las capas lejanas se mueven proporcionalmente MUCHO menos).
    // Se puede sobreescribir para control artístico manual.
    property real parallaxFactor: Math.pow(Math.max(0.0, Math.min(1.0, depth)), 1.5)

    // Respuesta al zoom de la cámara. Misma curva que parallaxFactor por defecto.
    property real scaleResponse: Math.pow(Math.max(0.0, Math.min(1.0, depth)), 1.5)

    // ── Estado de la cámara virtual (alimentado desde MultiplaneScene) ─────
    property real cameraX:    0.0   // paneo horizontal (unidades de mundo)
    property real cameraY:    0.0   // paneo vertical   (unidades de mundo)
    property real cameraZoom: 1.0   // factor de zoom (1.0=normal, >1=acercar)

    // ── Valores derivados (calculados, no configurables directamente) ──────
    // layerScale: cuánto se amplía esta capa concreta con el zoom de cámara.
    //   Con cameraZoom=2.0 y scaleResponse=0.0 (fondo) → layerScale=1.0  (sin cambio)
    //   Con cameraZoom=2.0 y scaleResponse=1.0 (frente) → layerScale=2.0 (doble)
    readonly property real layerScale: 1.0 + (cameraZoom - 1.0) * scaleResponse

    // ── Geometría: 1.6× el tamaño del padre, centrada ─────────────────────
    width:  parent.width  * 1.6
    height: parent.height * 1.6

    // ── Transformación de posición (paralaje) ─────────────────────────────
    // Centrar la capa en el padre y luego desplazar por paralaje.
    // Nota: cameraX positivo → la cámara se mueve a la derecha →
    //       el mundo se desplaza a la izquierda → offset negativo.
    x: (parent.width  - width)  / 2.0 - cameraX * parallaxFactor
    y: (parent.height - height) / 2.0 - cameraY * parallaxFactor

    // ── Transformación de escala (zoom) ───────────────────────────────────
    // El zoom se aplica desde el centro del item.
    // Sin paralaje, el centro del item coincide con el centro de la pantalla,
    // así que el zoom parece provenir del centro de la escena.
    scale:           layerScale
    transformOrigin: Item.Center
}
