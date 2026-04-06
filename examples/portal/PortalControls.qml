// =============================================================================
// PortalControls.qml — Panel de controles del portal
// =============================================================================
// Expone dos propiedades de salida que Main.qml enlaza a PortalCanvas:
//   rotSpeed   — velocidad de rotación (incremento de angle por tick)
//   glowValue  — shadowBlur para el glow del Canvas
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    // ── Salidas ──────────────────────────────────────────────────────────────
    property real rotSpeed:  speedSlider.value
    property int  glowValue: glowSlider.value

    color:  Style.cardColor
    radius: Style.resize(8)
    implicitHeight: controlsLayout.implicitHeight + Style.resize(32)

    ColumnLayout {
        id: controlsLayout
        anchors {
            left:   parent.left
            right:  parent.right
            top:    parent.top
            margins: Style.resize(16)
        }
        spacing: Style.resize(12)

        // ── Velocidad ────────────────────────────────────────────────────────
        Label {
            text: "Velocidad de rotación"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from:  0.005    // muy lento
                to:    0.08     // rápido
                value: 0.025    // valor inicial
                stepSize: 0.001
            }

            Label {
                text: (speedSlider.value * 1000).toFixed(0) + " u/tick"
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.minimumWidth: Style.resize(70)
            }
        }

        // ── Glow ─────────────────────────────────────────────────────────────
        Label {
            text: "Intensidad del glow"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Slider {
                id: glowSlider
                Layout.fillWidth: true
                from:     0
                to:       60
                value:    30
                stepSize: 1
            }

            Label {
                text: glowSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.minimumWidth: Style.resize(70)
            }
        }
    }
}
