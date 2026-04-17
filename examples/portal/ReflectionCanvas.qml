// =============================================================================
// ReflectionCanvas.qml — Reflejo del portal usando ShaderEffectSource
// =============================================================================
// Técnica:
//   1. ShaderEffectSource captura el frame actual del GIF (live: true)
//      y le aplica Scale(yScale: -1) para el volteo vertical.
//   2. Rectangle con Gradient cubre el reflejo de arriba (transparente)
//      a abajo (negro opaco) para el efecto de desvanecimiento en el suelo.
//
// API pública:
//   gifSource  (Item) — el AnimatedImage interno de PortalCanvas (alias gifItem)
//   glowValue  (int)  — reservado para uso futuro (opacidad del reflejo)
// =============================================================================
import QtQuick

Item {
    id: root

    property Item gifSource
    property int  glowValue: 30

    clip: true

    ShaderEffectSource {
        sourceItem: root.gifSource
        width:  parent.width
        height: parent.height
        transform: Scale { yScale: -1; origin.y: parent.height / 2 }
        live:    true
        opacity: 0.35
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#050505" }
        }
    }
}
