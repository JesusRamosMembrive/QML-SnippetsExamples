// =============================================================================
// Main.qml — Página de ejemplo: Cámara Multiplano 2.5D
// =============================================================================
// Demuestra el efecto de cámara multiplano inspirado en la técnica clásica
// de Disney: varias capas 2D apiladas que reaccionan de forma diferente al
// movimiento y zoom de la cámara, creando una ilusión convincente de profundidad.
//
// MODELO MATEMÁTICO (resumen):
//
//   Cada capa tiene:
//     depth          ∈ [0, 1]   profundidad (0=lejos, 1=cerca)
//     parallaxFactor = depth^γ  qué fracción del paneo aplica a esta capa
//     scaleResponse  = depth^γ  qué fracción del zoom aplica a esta capa
//
//   Traslación (paralaje):
//     layerOffsetX = -cameraX × parallaxFactor
//     → capas cercanas siguen la cámara; capas lejanas apenas se mueven
//
//   Escala (zoom):
//     layerScale = 1.0 + (cameraZoom − 1.0) × scaleResponse
//     → capas cercanas se agrandan mucho; el fondo permanece casi estático
//
//   Con γ=1.5 (curva no lineal) se consigue un contraste artístico mayor
//   entre las capas lejanas (casi estáticas) y las cercanas (muy dinámicas).
//
// CONTROLES:
//   Slider X / Y   — paneo de la cámara
//   Slider Zoom    — acercar / alejar
//   Reset          — vuelve a posición neutra
//   Auto / Stop    — anima la cámara en figura-8 (sin input del usuario)
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Item {
    id: root

    // ── Patrón estándar de visibilidad animada ─────────────────────────────
    property bool fullSize: false
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    // ── Estado de la cámara virtual (compartido con la escena) ────────────
    property real camX:    0.0
    property real camY:    0.0
    property real camZoom: 1.0

    // ── Animación automática ───────────────────────────────────────────────
    property bool autoPlay: false
    property real autoTime: 0.0   // segundos acumulados del timer

    // Timer de 60 fps que avanza el tiempo y calcula la trayectoria figura-8
    Timer {
        id: autoTimer
        interval: 16          // ~60 fps
        repeat:   true
        running:  root.autoPlay && root.fullSize

        onTriggered: {
            root.autoTime += 0.016
            var t = root.autoTime
            // Figura-8 en X/Y + oscilación del zoom
            root.camX    = Math.sin(t * 0.55) * 220
            root.camY    = Math.sin(t * 1.10) * 90
            root.camZoom = 1.0 + Math.sin(t * 0.38) * 0.48
            // Sincronizar sliders con los valores calculados
            sliderX.value    = root.camX
            sliderY.value    = root.camY
            sliderZoom.value = root.camZoom
        }
    }

    // Detener la animación si el usuario mueve los sliders manualmente
    function stopAuto() {
        if (root.autoPlay) {
            root.autoPlay = false
        }
    }

    // ── Layout principal ───────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(10)

        // ── Encabezado ─────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Label {
                text: "Cámara Multiplano 2.5D"
                font.pixelSize: Style.fontSizeL
                font.family:    Style.fontFamilyBold
                color:          Style.fontPrimaryColor
            }
            Label {
                text: "— efecto Disney con capas de paralaje"
                font.pixelSize: Style.fontSizeS
                color:          Style.inactiveColor
                Layout.alignment: Qt.AlignVCenter
            }
            Item { Layout.fillWidth: true }
        }

        // ── Panel de controles ─────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth:  true
            height: Style.resize(88)
            color:  Style.cardColor
            radius: Style.resize(8)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                spacing: Style.resize(16)

                // Paneo X
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Paneo X:  " + Math.round(root.camX)
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: sliderX
                        from:     -300
                        to:        300
                        value:     0
                        stepSize:  1
                        Layout.preferredWidth: Style.resize(200)
                        onMoved: { root.stopAuto(); root.camX = value }
                    }
                }

                // Paneo Y
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Paneo Y:  " + Math.round(root.camY)
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: sliderY
                        from:     -150
                        to:        150
                        value:     0
                        stepSize:  1
                        Layout.preferredWidth: Style.resize(180)
                        onMoved: { root.stopAuto(); root.camY = value }
                    }
                }

                // Zoom
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Zoom:  " + root.camZoom.toFixed(2) + "×"
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: sliderZoom
                        from:     0.5
                        to:       3.0
                        value:    1.0
                        stepSize: 0.01
                        Layout.preferredWidth: Style.resize(180)
                        onMoved: { root.stopAuto(); root.camZoom = value }
                    }
                }

                Item { Layout.fillWidth: true }

                // Botones de acción
                ColumnLayout {
                    spacing: Style.resize(6)

                    Button {
                        text: "Reset"
                        Layout.preferredWidth: Style.resize(80)
                        onClicked: {
                            root.stopAuto()
                            root.camX    = 0
                            root.camY    = 0
                            root.camZoom = 1.0
                            sliderX.value    = 0
                            sliderY.value    = 0
                            sliderZoom.value = 1.0
                        }
                    }
                    Button {
                        text: root.autoPlay ? "Stop" : "Auto"
                        highlighted: root.autoPlay
                        Layout.preferredWidth: Style.resize(80)
                        onClicked: {
                            if (root.autoPlay) {
                                root.autoPlay = false
                            } else {
                                root.autoTime = 0.0
                                root.autoPlay = true
                            }
                        }
                    }
                }
            }
        }

        // ── Escena multiplano (ocupa el espacio restante) ──────────────────
        MultiplaneScene {
            id: scene
            Layout.fillWidth:  true
            Layout.fillHeight: true
            Layout.minimumHeight: Style.resize(300)

            cameraX:    root.camX
            cameraY:    root.camY
            cameraZoom: root.camZoom
        }

        // ── Sección de explicación matemática ──────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height:  mathVisible ? mathContent.implicitHeight + Style.resize(24) : Style.resize(36)
            color:   Style.cardColor
            radius:  Style.resize(8)
            clip:    true

            property bool mathVisible: false

            Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            // Cabecera clickable para expandir/colapsar
            RowLayout {
                x: Style.resize(12)
                y: Style.resize(10)
                width: parent.width - Style.resize(24)
                spacing: Style.resize(8)

                Label {
                    text: parent.parent.mathVisible ? "▾" : "▸"
                    color: Style.mainColor
                    font.pixelSize: Style.fontSizeS
                }
                Label {
                    text: "Matemáticas del efecto"
                    color: Style.mainColor
                    font.pixelSize: Style.fontSizeS
                    font.family: Style.fontFamilyBold
                }
                Item { Layout.fillWidth: true }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: parent.mathVisible = !parent.mathVisible
                cursorShape: Qt.PointingHandCursor
            }

            // Contenido desplegable
            Column {
                id: mathContent
                x: Style.resize(12)
                y: Style.resize(36)
                width: parent.width - Style.resize(24)
                spacing: Style.resize(4)
                opacity: parent.mathVisible ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    text: "Cada capa tiene un parámetro <b>depth ∈ [0,1]</b> que determina su posición en el espacio 3D simulado."
                }
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    font.family: Style.fontFamilyBold
                    text: "Traslación (paralaje):   layerOffset = −cameraPos × depth^1.5"
                }
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    font.family: Style.fontFamilyBold
                    text: "Escala (zoom):           layerScale = 1 + (cameraZoom − 1) × depth^1.5"
                }
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    text: "Con <b>depth=0.0</b> (cielo): paralaje=0, escala=0 → fondo completamente estático, simula distancia infinita."
                }
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    text: "Con <b>depth=1.0</b> (primer plano): paralaje=1, escala=1 → máxima respuesta, sensación de extrema cercanía."
                }
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS
                    color: Style.fontSecondaryColor
                    text: "El exponente <b>γ=1.5</b> introduce no-linealidad: las capas intermedias se acercan más al comportamiento del fondo que al del primer plano, lo que resulta más natural visualmente que una interpolación lineal."
                }
                Item { height: Style.resize(8) }
            }
        }
    }
}
