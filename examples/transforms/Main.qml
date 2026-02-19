// =============================================================================
// Main.qml — Pagina principal del modulo Transforms & Effects
// =============================================================================
// Pagina contenedora que organiza todos los ejemplos de transformaciones y
// efectos visuales. Usa el mismo patron de navegacion que las demas paginas
// del proyecto: fullSize controla la visibilidad con animacion de opacidad.
//
// ESTRUCTURA:
// - GridLayout 2x2 con las 4 tarjetas principales (2D, 3D, Effects, CardFlip)
// - Un bloque "Custom Transform Creations" con 6 demos avanzadas apiladas
//   verticalmente (carousel, parallax, spring, neon, shear, wave).
//
// PATRON DE RENDIMIENTO: Los componentes con animacion continua (Carousel3D,
// NeonGlow, WaveGrid) reciben la propiedad `active` ligada a root.fullSize,
// para que sus Timers solo corran cuando la pagina es visible. Esto evita
// consumir CPU/GPU cuando el usuario esta en otra seccion del dashboard.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // Patron de visibilidad del Dashboard: fullSize controla si esta pagina
    // se muestra. La animacion de opacidad (200ms) da una transicion suave
    // y visible: opacity > 0 evita que el motor renderice elementos ocultos.
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
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
                spacing: Style.resize(40)

                // Titulo de la pagina
                Label {
                    text: "Transforms & Effects Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 con las tarjetas principales — cada tarjeta es un
                // componente autocontenido que demuestra una categoria de
                // transformacion (2D basico, rotacion 3D, efectos graficos, card flip)
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    Transforms2DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    Rotation3DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GraphicalEffectsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    CardFlipCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ════════════════════════════════════════════════════════
                // Tarjeta 5: Creaciones avanzadas de transformaciones
                // Agrupa 6 demos en una sola tarjeta con separadores.
                // Cada demo es un componente independiente (Carousel3D, etc.)
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Transform Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: 3D carousel, parallax depth, spring physics, neon glow, matrix shear, wave grids"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // Cada demo animada recibe `active: root.fullSize` para
                        // pausar sus Timers cuando la pagina no esta visible.
                        // Los separadores (Rectangle de 1px) dan estructura visual.

                        Carousel3D { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ParallaxDepth { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ElasticSpring { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        NeonGlow { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        MatrixShear { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        WaveGrid { active: root.fullSize }
                    }
                }
            }
        }
    }
}
