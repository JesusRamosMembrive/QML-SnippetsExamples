// =============================================================================
// Main.qml — Página: 2.5D Depth Cards
// =============================================================================
// Presenta cuatro tarjetas DepthCard con distintos colores de acento y
// profundidades virtuales. La rotación sigue el puntero en tiempo real y
// el hover eleva el contenido para replicar el patrón 3D de Aceternity.
//
// COMPARATIVA DE TARJETAS:
//   Components (teal)   — profundidad equilibrada: Z 60px
//   Analytics  (azul)   — contenido más cercano al plano: Z 30px
//   Motion     (rosa)   — contenido muy flotante: Z 110px
//   System     (naranja) — inclinación más pronunciada y lift mayor
// =============================================================================

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import utils

Item {
    id: root

    // Patrón estándar de visibilidad del Dashboard
    property bool fullSize: false
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
            anchors.fill:   parent
            anchors.margins: Style.resize(40)
            clip:            true
            contentWidth:    availableWidth

            ColumnLayout {
                width:   scrollView.availableWidth
                spacing: Style.resize(32)

                // ── Encabezado ────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Text {
                        text:           "2.5D Depth Cards"
                        font.pixelSize: Style.resize(32)
                        font.bold:      true
                        color:          Style.mainColor
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "El cuerpo de cada tarjeta y su texto reciben la misma posición del "
                              + "cursor simultáneamente. La rotación sigue el movimiento del ratón "
                              + "en tiempo real y el hover eleva visualmente el contenido con un "
                              + "despegue animado para crear la sensación de profundidad del efecto "
                              + "3D Card de Aceternity."
                        font.pixelSize: Style.fontSizeS
                        color:          Style.fontSecondaryColor
                        wrapMode:       Text.WordWrap
                        Layout.fillWidth: true
                    }
                }

                // ── Grid de tarjetas (2×2) ────────────────────────────────────
                GridLayout {
                    Layout.fillWidth: true
                    columns:       2
                    rowSpacing:    Style.resize(24)
                    columnSpacing: Style.resize(24)

                    // Tarjeta 1 — teal: valores de referencia
                    // textZDepth:60 reproduce CSS translateZ(60px) en preserve-3d.
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "Components"
                        subtitle:    "Reusable UI system"
                        tagLabel:    "UI"
                        accentColor: Style.mainColor
                        bgColor:     Style.cardColor
                        // defaults: tilt 18°, textZDepth 60, textSpring 2.0
                    }

                    // Tarjeta 2 — azul: contenido cerca de la superficie
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "Analytics"
                        subtitle:    "Real-time metrics"
                        tagLabel:    "DATA"
                        accentColor: "#7B8FFF"
                        bgColor:     Style.cardColor
                        textZDepth:  30         // texto poco elevado
                        textSpring:  3.0        // retorno algo más rápido al reposo
                    }

                    // Tarjeta 3 — rosa: máxima profundidad percibida
                    // textZDepth alto = contenido muy flotante.
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "Motion"
                        subtitle:    "Spring dynamics"
                        tagLabel:    "FX"
                        accentColor: "#FF6B9D"
                        bgColor:     Style.cardColor
                        textZDepth:  110        // texto muy elevado (Aceternity: 100px)
                        textSpring:  1.2        // retorno más elástico
                        textDamping: 0.92
                    }

                    // Tarjeta 4 — naranja: inclinación pronunciada, sombra intensa
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "System"
                        subtitle:    "Runtime diagnostics"
                        tagLabel:    "SYS"
                        accentColor: "#FEA601"
                        bgColor:     Style.cardColor
                        cardTiltStrength: 22    // inclinación más agresiva
                        cardLiftStrength: 12
                        shadowIntensity:  0.45
                        textZDepth:       80
                    }
                }

                // ── Indicación de interacción ─────────────────────────────────
                Text {
                    text:           "Pasa el cursor sobre una tarjeta — el texto flota sobre la superficie"
                    font.pixelSize: Style.resize(13)
                    font.italic:    true
                    color:          Style.inactiveColor
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                // ── Panel explicativo colapsable ──────────────────────────────
                Rectangle {
                    id: explanationBox
                    Layout.fillWidth: true
                    height: explanationVisible
                            ? explanationContent.implicitHeight + Style.resize(24)
                            : Style.resize(36)
                    color:  Style.cardColor
                    radius: Style.resize(8)
                    clip:   true

                    property bool explanationVisible: false

                    Behavior on height {
                        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                    }

                    RowLayout {
                        x:     Style.resize(12)
                        y:     Style.resize(10)
                        width: explanationBox.width - Style.resize(24)
                        spacing: Style.resize(8)

                        Text {
                            text:           explanationBox.explanationVisible ? "▾" : "▸"
                            color:          Style.mainColor
                            font.pixelSize: Style.fontSizeS
                        }
                        Text {
                            text:           "¿Cómo funciona la ilusión de profundidad?"
                            color:          Style.mainColor
                            font.pixelSize: Style.fontSizeS
                            font.bold:      true
                        }
                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        onClicked:    explanationBox.explanationVisible = !explanationBox.explanationVisible
                    }

                    ColumnLayout {
                        id: explanationContent
                        x:       Style.resize(12)
                        y:       Style.resize(36)
                        width:   explanationBox.width - Style.resize(24)
                        spacing: Style.resize(6)
                        opacity: explanationBox.explanationVisible ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }

                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>Cuerpo de la tarjeta:</b>  La rotación se calcula directamente "
                                  + "desde la posición actual del puntero, sin esperar a que el ratón "
                                  + "se detenga. El resorte spring:5.0 / damping:0.65 solo actúa al salir."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>Capa de texto:</b>  Comparte el mismo tilt de la tarjeta y añade "
                                  + "un desplazamiento perspectivo basado en Z. Al entrar en hover se "
                                  + "despega con una animación un poco más larga y luego sigue al puntero "
                                  + "en tiempo real."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>La ilusión:</b>  El plano base rota con el cursor y el contenido "
                                  + "se proyecta como si estuviera más cerca del espectador. Esa diferencia "
                                  + "de profundidad aparente produce el efecto 2.5D."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>Sin escena 3D completa.</b>  El efecto se construye con rotación "
                                  + "3D, perspectiva simulada y desplazamientos proyectados, manteniendo "
                                  + "la interacción ligera y continua."
                        }
                        Item { height: Style.resize(8) }
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
