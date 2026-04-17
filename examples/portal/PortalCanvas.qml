// =============================================================================
// PortalCanvas.qml — Portal Rick & Morty con ShaderEffect procedural
// =============================================================================
import QtQuick

Item {
    id: root

    property bool active:    false
    property bool open:      true
    property int  glowValue: 30
    property bool hovered:   false

    // ── Wrapper visual: scale aquí, NO en el root ────────────────────────────
    // El root siempre ocupa el espacio completo para que el MouseArea funcione
    // aunque el portal esté cerrado (scale=0 en el root inhabilita los clicks).
    Item {
        id: visualItem
        anchors.fill: parent

        scale: root.open ? 1.0 : 0.0
        Behavior on scale {
            NumberAnimation { duration: 600; easing.type: Easing.OutBack }
        }

        ShaderEffect {
            id: portalEffect
            anchors.fill: parent

            property real time:         0.0
            property real aspectRatio:  width / height
            property real glowIntensity: root.hovered
                ? Math.min(root.glowValue / 60.0 * 1.5, 1.0)
                : root.glowValue / 60.0

            Behavior on glowIntensity {
                NumberAnimation { duration: 200 }
            }

            fragmentShader: "qrc:/qt/qml/portal/shaders/portal.frag.qsb"
            vertexShader:   "qrc:/qt/qml/portal/shaders/portal.vert.qsb"
        }
    }

    // ── Reloj de animación ───────────────────────────────────────────────────
    FrameAnimation {
        running: root.active
        onTriggered: portalEffect.time += Math.min(frameTime, 0.05)
    }

    // ── MouseArea en el root: siempre a tamaño completo ──────────────────────
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked:              root.open    = !root.open
        onContainsMouseChanged: root.hovered = containsMouse
    }
}
