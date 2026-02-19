// ============================================================================
// GraphicalEffectsCard.qml
// Demuestra efectos graficos de post-procesado usando Qt5Compat.GraphicalEffects.
//
// CONCEPTO CLAVE: GraphicalEffects aplica shaders GPU sobre elementos QML
// existentes. Funcionan como "filtros" que toman un item fuente ('source')
// y producen una version modificada (con sombra, desenfoque, colorizado, etc.).
//
// PATRON SOURCE/EFFECT:
//   1. Crear el item fuente con 'visible: false' (para que no se dibuje dos veces).
//   2. Crear el efecto con 'source: itemFuente' y 'anchors.fill: itemFuente'.
//   El efecto reemplaza visualmente al item original.
//
// NOTA IMPORTANTE: En Qt 6, estos efectos se movieron al modulo de
// compatibilidad 'Qt5Compat.GraphicalEffects'. Para usarlos hay que agregar
// el modulo Qt5Compat en CMake: find_package(Qt6 COMPONENTS Qt5Compat).
// En Qt 6.5+ se recomienda usar MultiEffect como alternativa mas eficiente.
//
// EFECTOS MOSTRADOS:
//   - DropShadow: sombra proyectada con desenfoque gaussiano.
//   - GaussianBlur: desenfoque gaussiano (efecto "frosted glass").
//   - Colorize: cambia el tono/saturacion/luminosidad del item fuente.
// ============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "GraphicalEffects"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Controles interactivos ---
        // Cada slider controla un parametro de un efecto diferente,
        // permitiendo ver en tiempo real como cambia el resultado.

        // Radio de sombra: valores mas altos = sombra mas difusa y extendida
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Shadow: " + shadowSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: shadowSlider; anchors.fill: parent; from: 0; to: 30; value: 12; stepSize: 1 }
            }
        }

        // Radio de desenfoque: 0 = nitido, valores altos = muy borroso
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Blur: " + blurSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: blurSlider; anchors.fill: parent; from: 0; to: 20; value: 0; stepSize: 1 }
            }
        }

        // Tono (hue): 0.0-1.0 recorre todo el espectro de colores (rojo->amarillo->verde->azul->violeta->rojo)
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Hue: " + hueSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: hueSlider; anchors.fill: parent; from: 0; to: 1.0; value: 0; stepSize: 0.01 }
            }
        }

        // --- Vista previa de efectos ---
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // =============================================
            // DropShadow: sombra proyectada
            // - horizontalOffset/verticalOffset: desplazamiento de la sombra.
            // - radius: desenfoque de la sombra (mayor = mas suave).
            // - samples: calidad del desenfoque. Regla: samples >= radius * 2 + 1
            //   para evitar artefactos. Mas samples = mejor calidad pero mas lento.
            // - color: color de la sombra (tipicamente negro semitransparente).
            // PATRON: el source debe tener visible:false para evitar doble dibujo.
            // =============================================
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    // Item fuente: visible:false porque DropShadow lo renderiza
                    Rectangle {
                        id: shadowSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: Style.mainColor
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "A"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    // DropShadow dibuja el item original + su sombra
                    DropShadow {
                        anchors.fill: shadowSource
                        source: shadowSource
                        horizontalOffset: Style.resize(3)
                        verticalOffset: Style.resize(3)
                        radius: shadowSlider.value
                        samples: 25
                        color: Qt.rgba(0, 0, 0, 0.4)
                    }
                }

                Label {
                    text: "DropShadow"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // =============================================
            // GaussianBlur: desenfoque gaussiano
            // - radius: intensidad del desenfoque (0 = sin efecto).
            // - samples: debe ser al menos radius*2+1 para buena calidad.
            //   Aqui se calcula dinamicamente con la formula: valor * 2 + 1.
            //
            // USO COMUN: efecto "frosted glass" (vidrio esmerilado), fondos
            // difusos detras de menus/popups, transiciones de enfoque.
            // =============================================
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: blurSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: "#4A90D9"
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "B"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    GaussianBlur {
                        anchors.fill: blurSource
                        source: blurSource
                        radius: blurSlider.value
                        // Formula: samples = radius * 2 + 1 garantiza calidad optima
                        samples: blurSlider.value * 2 + 1
                    }
                }

                Label {
                    text: "GaussianBlur"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // =============================================
            // Colorize: cambia el color del item fuente
            // - hue: tono (0.0-1.0, recorre el espectro completo).
            // - saturation: intensidad del color (0 = gris, 1 = puro).
            // - lightness: luminosidad (-1 a 1, 0 = sin cambio).
            //
            // Trabaja en espacio de color HSL. Util para temas dinamicos,
            // indicadores de estado (verde=ok, rojo=error), o efectos
            // de seleccion/hover sin crear multiples assets.
            // =============================================
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: colorizeSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: "#FEA601"
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "C"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    Colorize {
                        anchors.fill: colorizeSource
                        source: colorizeSource
                        hue: hueSlider.value
                        saturation: 0.8
                        lightness: 0.0
                    }
                }

                Label {
                    text: "Colorize"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Qt5Compat.GraphicalEffects: shadow, blur, and color manipulation"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
