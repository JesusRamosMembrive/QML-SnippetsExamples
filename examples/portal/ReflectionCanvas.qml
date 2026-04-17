// =============================================================================
// ReflectionCanvas.qml — Reflejo del portal usando ShaderEffectSource
// =============================================================================
// Captura el PortalCanvas completo (shader + animación), lo voltea
// verticalmente y aplica un degradado de desvanecimiento hacia el suelo.
//
// API pública:
//   portalSource (Item) — el item PortalCanvas de Main.qml
//   glowValue    (int)  — reservado para uso futuro
// =============================================================================
import QtQuick

Item {
    id: root

    property Item portalSource
    property int  glowValue: 30

    clip: true

    ShaderEffectSource {
        sourceItem: root.portalSource
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
