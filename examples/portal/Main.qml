// =============================================================================
// Main.qml — Página "Portal Rick & Morty"
// =============================================================================
// Ensambla:
//   - PortalCanvas: AnimatedImage del GIF + Glow (Qt5Compat) + interacción
//   - ReflectionCanvas: reflejo via ShaderEffectSource + degradado
//   - PortalControls: slider de intensidad del halo
//
// Patrón de visibilidad estándar del proyecto:
//   fullSize controla la reproducción del GIF (playing: root.fullSize).
//   opacity + visible con Behavior es el patrón animado del dashboard.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
                    text: "Click en el portal para abrirlo o cerrarlo. Pasa el ratón por encima para intensificar el halo verde."
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

                    // ── Portal ───────────────────────────────────────────────
                    // El halo exterior se dibuja dentro del Canvas (portal_draw.js)
                    // con shadowBlur de doble pasada. Esto evita MultiEffect, que
                    // era demasiado costoso combinado con Canvas animado a 30ms.
                    PortalCanvas {
                        id: portalCanvas
                        width:  Style.resize(320)
                        height: Style.resize(380)
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:   parent.verticalCenter
                            verticalCenterOffset: Style.resize(-40)
                        }
                        active:    root.fullSize
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
                        gifSource:  portalCanvas.gifItem
                        glowValue:  controls.glowValue
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
