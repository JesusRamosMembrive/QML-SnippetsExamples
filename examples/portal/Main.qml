// =============================================================================
// Main.qml — Página "Portal Rick & Morty"
// =============================================================================
// Ensambla:
//   - PortalCanvas: espiral animada + destellos + glow interno (Canvas 2D)
//   - MultiEffect:  halo verde exterior (QtQuick.Effects, Qt 6.5+, nativo)
//   - ReflectionCanvas: reflejo invertido del portal
//   - PortalControls: sliders de velocidad y glow
//
// Patrón de visibilidad estándar del proyecto:
//   fullSize controla si el Timer del portal consume CPU.
//   opacity + visible con Behavior es el patrón animado del dashboard.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import utils

Item {
    id: root

    property bool fullSize: false

    // ── Patrón de visibilidad animada ────────────────────────────────────────
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(24)

                // ── Título ───────────────────────────────────────────────────
                Label {
                    text: "Portal Rick & Morty"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Click en el portal para abrirlo o cerrarlo. Pasa el ratón por encima para intensificar el halo."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // ── Zona visual: portal + reflejo ────────────────────────────
                // Item contenedor de altura fija. El portal está en la mitad
                // superior y el reflejo en la mitad inferior.
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)

                    // Fondo negro para que el portal destaque
                    Rectangle {
                        anchors.fill: parent
                        color: "#050505"
                        radius: Style.resize(8)
                    }

                    // ── Halo exterior (MultiEffect detrás del portal) ─────────
                    // Se posiciona ligeramente más grande que el portal para
                    // que el blur "se derrame" fuera del borde del óvalo.
                    MultiEffect {
                        id: glowHalo
                        source: portalCanvas
                        anchors.centerIn: portalCanvas
                        width:  portalCanvas.width  + (controls.glowValue * 1.2)
                        height: portalCanvas.height + (controls.glowValue * 1.2)
                        blurEnabled: true
                        blurMax: controls.glowValue + (portalCanvas.hovered ? 16 : 0)
                        Behavior on blurMax {
                            NumberAnimation { duration: 200 }
                        }
                        opacity: 0.75
                        z: 0
                    }

                    // ── Portal (encima del halo) ─────────────────────────────
                    PortalCanvas {
                        id: portalCanvas
                        width:  Style.resize(260)
                        height: Style.resize(320)
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:   parent.verticalCenter
                            verticalCenterOffset: Style.resize(-40)
                        }
                        active:    root.fullSize
                        rotSpeed:  controls.rotSpeed
                        glowValue: controls.glowValue
                        z: 1
                    }

                    // ── Reflejo (debajo del portal) ──────────────────────────
                    ReflectionCanvas {
                        id: reflectionCanvas
                        width:  portalCanvas.width
                        height: Style.resize(120)
                        anchors {
                            horizontalCenter: portalCanvas.horizontalCenter
                            top: portalCanvas.bottom
                        }
                        angle:     portalCanvas.angle
                        glowValue: controls.glowValue
                        z: 1
                    }
                }

                // ── Panel de controles ───────────────────────────────────────
                PortalControls {
                    id: controls
                    Layout.fillWidth: true
                }

                // Espaciado final
                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
