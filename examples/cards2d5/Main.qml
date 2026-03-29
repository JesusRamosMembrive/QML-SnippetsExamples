// =============================================================================
// Main.qml — Página: 2.5D Depth Cards
// =============================================================================
// Presenta cuatro tarjetas DepthCard con distintos colores de acento y
// parámetros de resorte. Cada tarjeta demuestra el mismo modelo de movimiento
// con variaciones que permiten comparar cómo el diferencial de spring afecta
// la profundidad percibida.
//
// COMPARATIVA DE TARJETAS:
//   Components (teal)   — parámetros por defecto: spring 5.0 / 2.0
//   Analytics  (azul)   — resortes más cercanos: spring 6.0 / 2.5 (menor separación)
//   Motion     (rosa)   — máximo lag: spring 5.0 / 1.5, offset 22px (mayor separación)
//   System     (naranja) — inclinación más pronunciada: tilt 14°, lift 10px
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
                              + "cursor simultáneamente, pero la siguen con constantes de resorte "
                              + "distintas. La tarjeta reacciona rápido (spring 5.0); el texto "
                              + "llega tarde (spring 2.0). Ese desfase temporal de ~180ms basta "
                              + "para que el ojo perciba los dos elementos en planos de profundidad "
                              + "separados — sin valores z, sin escena 3D."
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

                    // Tarjeta 2 — azul: texto cerca de la superficie
                    // textZDepth bajo = texto casi pegado al plano del card.
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "Analytics"
                        subtitle:    "Real-time metrics"
                        tagLabel:    "DATA"
                        accentColor: "#7B8FFF"
                        bgColor:     Style.cardColor
                        textZDepth:  30         // texto poco elevado
                        textSpring:  3.0        // respuesta rápida, poco lag
                    }

                    // Tarjeta 3 — rosa: máxima profundidad percibida
                    // textZDepth alto + spring muy suave = texto muy flotante.
                    DepthCard {
                        Layout.preferredWidth:  Style.resize(280)
                        Layout.preferredHeight: Style.resize(340)
                        title:       "Motion"
                        subtitle:    "Spring dynamics"
                        tagLabel:    "FX"
                        accentColor: "#FF6B9D"
                        bgColor:     Style.cardColor
                        textZDepth:  110        // texto muy elevado (Aceternity: 100px)
                        textSpring:  1.2        // lag máximo
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
                            text: "<b>Cuerpo de la tarjeta:</b>  SpringAnimation spring:5.0, "
                                  + "damping:0.65 — reactivo, ligero rebote. Llega al destino en ~120ms."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>Capa de texto:</b>  SpringAnimation spring:2.0, "
                                  + "damping:0.90 — suave, sin rebote. Llega al destino en ~300ms."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>La ilusión:</b>  Ambas capas reciben el mismo dato del cursor "
                                  + "en el mismo instante. El desfase de ~180ms entre sus llegadas "
                                  + "es interpretado por el sistema visual como separación espacial "
                                  + "— el objeto más lento parece estar más lejos del ojo."
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode:       Text.Wrap
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            text: "<b>Sin valores z.</b>  El efecto es puramente temporal: "
                                  + "mismo estímulo, velocidades de respuesta distintas "
                                  + "→ separación de profundidad percibida."
                        }
                        Item { height: Style.resize(8) }
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
