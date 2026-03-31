pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    // ── Controles tuning ──────────────────────────────────────────────────
    property real blurValue:    32
    property real tintValue:    0.10
    property real borderValue:  0.28

    // ─────────────────────────────────────────────────────────────────────
    // FONDO DE PÁGINA — base oscura + blobs suaves de ambiente
    // No se usa como fuente del blur; es solo el fondo decorativo de la página.
    // ─────────────────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#0d0d18"
    }

    // Blob ambiente superior-izquierda (no toca la tarjeta)
    Rectangle {
        x: -Style.resize(60)
        y: -Style.resize(40)
        width:  Style.resize(300)
        height: Style.resize(300)
        radius: width / 2
        color:  Qt.rgba(0.80, 0.10, 0.45, 0.30)
        layer.enabled: true
        layer.effect: MultiEffect { blurEnabled: true; blur: 1.0; blurMax: 80 }
    }

    // Blob ambiente inferior-derecha
    Rectangle {
        x: parent.width - Style.resize(180)
        y: parent.height - Style.resize(200)
        width:  Style.resize(340)
        height: Style.resize(300)
        radius: width / 2
        color:  Qt.rgba(0.40, 0.05, 0.80, 0.25)
        layer.enabled: true
        layer.effect: MultiEffect { blurEnabled: true; blur: 1.0; blurMax: 80 }
    }

    // ─────────────────────────────────────────────────────────────────────
    // CONTENIDO PRINCIPAL
    // ─────────────────────────────────────────────────────────────────────
    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: Style.resize(40)
        clip: true
        contentWidth: availableWidth

        ColumnLayout {
            width: scrollView.availableWidth
            spacing: Style.resize(32)

            // ── Cabecera ───────────────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(8)

                Text {
                    text: "Frost Glass"
                    font.family:    Style.fontFamilyBold
                    font.pixelSize: Style.resize(34)
                    font.bold:      true
                    color:          Style.mainColor
                }

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.pixelSize: Style.fontSizeS
                    color:          Style.fontSecondaryColor
                    text: "Glassmorphism: el cristal captura el fondo real en GPU, aplica desenfoque gaussiano y superpone tinte + borde luminoso. Los círculos de colores cruzan el borde de la tarjeta para que el efecto sea evidente."
                }
            }

            // ── Área de demostración ───────────────────────────────────────
            // demoArea es el contenedor fijo. demoBackground es el fondo real
            // que GlassCard captura y desenfoca. Los círculos están en
            // demoBackground, posicionados para cruzar el borde de la tarjeta.
            Item {
                id: demoArea
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(340)

                // ── Fondo capturado por GlassCard ────────────────────────
                Item {
                    id: demoBackground
                    anchors.fill: parent

                    // Base oscura
                    Rectangle {
                        anchors.fill: parent
                        color: "#0d0d18"
                    }

                    // ── Círculo magenta grande — cruza el borde izquierdo
                    // de la tarjeta. Nítido (blurMax bajo) para que el efecto
                    // glassmorphism sea claramente visible en el borde.
                    Rectangle {
                        // Centrado de forma que su borde derecho quede dentro
                        // de la tarjeta (~1/3 del círculo bajo el cristal).
                        x: demoArea.width / 2 - Style.resize(280)
                        y: demoArea.height  / 2 - Style.resize(130)
                        width:  Style.resize(260)
                        height: Style.resize(260)
                        radius: width / 2
                        color:  Qt.rgba(0.95, 0.15, 0.55, 1.0)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            blurEnabled: true; blur: 1.0; blurMax: 12
                        }
                    }

                    // ── Círculo violeta — cruza el borde derecho de la tarjeta
                    Rectangle {
                        x: demoArea.width / 2 + Style.resize(100)
                        y: demoArea.height  / 2 - Style.resize(100)
                        width:  Style.resize(220)
                        height: Style.resize(220)
                        radius: width / 2
                        color:  Qt.rgba(0.50, 0.08, 0.95, 1.0)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            blurEnabled: true; blur: 1.0; blurMax: 12
                        }
                    }

                    // ── Banda horizontal naranja — cruza el centro de la tarjeta
                    Rectangle {
                        x: demoArea.width * 0.10
                        y: demoArea.height / 2 + Style.resize(40)
                        width:  demoArea.width * 0.80
                        height: Style.resize(28)
                        radius: height / 2
                        color:  Qt.rgba(0.95, 0.50, 0.05, 0.85)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            blurEnabled: true; blur: 1.0; blurMax: 8
                        }
                    }
                }

                // ── Tarjeta de cristal esmerilado ─────────────────────────
                GlassCard {
                    id: memberCard
                    backgroundItem: demoBackground
                    width:   Style.resize(310)
                    height:  Style.resize(200)
                    anchors.centerIn: parent
                    blurRadius:    root.blurValue
                    tintOpacity:   root.tintValue
                    borderOpacity: root.borderValue

                    // Contenido de la tarjeta
                    Item {
                        anchors.fill: parent
                        anchors.margins: Style.resize(22)

                        RowLayout {
                            width: parent.width
                            anchors.top: parent.top

                            Text {
                                text: "MEMBERSHIP"
                                font.pixelSize:    Style.resize(11)
                                font.bold:         true
                                font.letterSpacing: 1.8
                                color: Qt.rgba(1, 1, 1, 0.65)
                            }

                            Item { Layout.fillWidth: true }

                            Rectangle {
                                width:  Style.resize(34)
                                height: Style.resize(34)
                                radius: width / 2
                                color:  "transparent"
                                border.color: Qt.rgba(1, 1, 1, 0.45)
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text:           "✦"
                                    font.pixelSize: Style.resize(14)
                                    color:          Qt.rgba(1, 1, 1, 0.70)
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            spacing: Style.resize(4)

                            Text {
                                text: "<b>JAMES</b> APPLESEED"
                                font.pixelSize:    Style.resize(20)
                                font.letterSpacing: 1.0
                                color: Qt.rgba(1, 1, 1, 0.92)
                                textFormat: Text.RichText
                            }

                            Text {
                                text:              "UXMISFIT.TOOLS"
                                font.pixelSize:    Style.resize(11)
                                font.letterSpacing: 1.4
                                color: Qt.rgba(1, 1, 1, 0.50)
                            }
                        }
                    }
                }
            }

            // ── Panel de tuning ────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight
                implicitHeight: tuningContent.implicitHeight + Style.resize(48)
                color:        Style.cardColor
                radius:       Style.resize(18)
                border.color: "#343842"
                border.width: 1

                ColumnLayout {
                    id: tuningContent
                    anchors.fill: parent
                    anchors.margins: Style.resize(24)
                    spacing: Style.resize(20)

                    Text {
                        text:           "Tuning Panel"
                        font.pixelSize: Style.resize(20)
                        font.bold:      true
                        color:          Style.fontPrimaryColor
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: Style.resize(24)
                        rowSpacing:    Style.resize(16)

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(6)
                            RowLayout {
                                Text { text: "Blur radius"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                Item { Layout.fillWidth: true }
                                Text { text: Math.round(root.blurValue); font.pixelSize: Style.resize(13); color: Style.mainColor }
                            }
                            Slider {
                                Layout.fillWidth: true
                                from: 0; to: 64; stepSize: 1
                                value: root.blurValue
                                onValueChanged: root.blurValue = value
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(6)
                            RowLayout {
                                Text { text: "Tint opacity"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                Item { Layout.fillWidth: true }
                                Text { text: root.tintValue.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                            }
                            Slider {
                                Layout.fillWidth: true
                                from: 0.0; to: 0.40; stepSize: 0.01
                                value: root.tintValue
                                onValueChanged: root.tintValue = value
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(6)
                            RowLayout {
                                Text { text: "Border glow"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                Item { Layout.fillWidth: true }
                                Text { text: root.borderValue.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                            }
                            Slider {
                                Layout.fillWidth: true
                                from: 0.0; to: 0.70; stepSize: 0.01
                                value: root.borderValue
                                onValueChanged: root.borderValue = value
                            }
                        }
                    }

                    Rectangle {
                        id: instructionsCard
                        Layout.fillWidth: true
                        Layout.preferredHeight: implicitHeight
                        implicitHeight: instructionsContent.implicitHeight + Style.resize(32)
                        color:        Style.surfaceColor
                        radius:       Style.resize(12)
                        border.color: "#323641"
                        border.width: 1

                        ColumnLayout {
                            id: instructionsContent
                            anchors.fill: parent
                            anchors.margins: Style.resize(16)
                            spacing: Style.resize(10)

                            Text {
                                text:           "Cómo funciona"
                                font.pixelSize: Style.resize(14)
                                font.bold:      true
                                color:          Style.fontPrimaryColor
                            }

                            Text {
                                Layout.fillWidth: true
                                wrapMode:       Text.WordWrap
                                font.pixelSize: Style.resize(13)
                                color:          Style.fontSecondaryColor
                                lineHeight:     1.5
                                text: "1. ShaderEffectSource dentro de GlassCard captura demoBackground (el fondo real).\n" +
                                      "2. Se posiciona en (-card.x, -card.y): el clip de la tarjeta recorta solo la región bajo ella.\n" +
                                      "3. MultiEffect aplica blur gaussiano sobre esa región.\n" +
                                      "4. Los círculos cruzan el borde de la tarjeta para que veas la diferencia con/sin blur."
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Style.resize(20) }
        }
    }
}
