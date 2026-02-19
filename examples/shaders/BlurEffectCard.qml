// =============================================================================
// BlurEffectCard.qml — Desenfoque gaussiano interactivo
// =============================================================================
// Demuestra el efecto GaussianBlur de Qt5Compat.GraphicalEffects aplicado
// a una cuadricula de iconos coloridos. El usuario controla la intensidad
// del desenfoque con un slider.
//
// Conceptos clave para el aprendiz:
//   - Patron source/effect: los efectos graficos de Qt trabajan sobre un
//     "source" que debe tener visible: false. El efecto lee la textura del
//     source y genera una version procesada. Si el source fuera visible,
//     se verian ambos (original y efecto) superpuestos.
//   - GaussianBlur.radius: controla la intensidad del desenfoque. A mayor
//     radio, mas difuso se ve el contenido.
//   - GaussianBlur.samples: debe ser al menos radius*2 + 1 para calidad
//     optima. Menos samples = rendimiento mejor pero calidad peor.
//   - Costo de rendimiento: GaussianBlur realiza multiples pases de
//     renderizado. En contenido complejo o con radius alto, puede
//     afectar significativamente los FPS.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Gaussian Blur"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---------------------------------------------------------------
            // Escena fuente (source): contiene el contenido visual original.
            // visible: false es obligatorio — el source no se renderiza
            // directamente en pantalla; solo alimenta al efecto GaussianBlur.
            // Si lo dejamos visible, veriamos la imagen original debajo
            // del efecto desenfocado, arruinando el resultado.
            // ---------------------------------------------------------------
            Item {
                id: blurSource
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: Style.surfaceColor
                    radius: Style.resize(8)

                    // Cuadricula 3x3 de iconos Unicode con colores distintos
                    // — contenido visualmente rico para que el efecto de
                    // desenfoque sea claramente perceptible.
                    Grid {
                        anchors.centerIn: parent
                        columns: 3
                        spacing: Style.resize(10)

                        Repeater {
                            model: [
                                { icon: "\u2605", clr: "#00D1A9" },
                                { icon: "\u2665", clr: "#FF7043" },
                                { icon: "\u266B", clr: "#FEA601" },
                                { icon: "\u2600", clr: "#4FC3F7" },
                                { icon: "\u25C6", clr: "#AB47BC" },
                                { icon: "\u2708", clr: "#EC407A" },
                                { icon: "\u2699", clr: "#66BB6A" },
                                { icon: "\u26A1", clr: "#F7DF1E" },
                                { icon: "\u263A", clr: "#00599C" }
                            ]

                            Rectangle {
                                required property var modelData
                                width: Style.resize(55)
                                height: Style.resize(55)
                                radius: Style.resize(8)
                                color: modelData.clr

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.modelData.icon
                                    font.pixelSize: Style.resize(24)
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                }
            }

            // El efecto GaussianBlur: lee la textura de blurSource y la
            // renderiza con desenfoque. samples = radius*2+1 es la formula
            // recomendada por Qt para obtener calidad optima sin desperdiciar
            // ciclos de GPU en muestras innecesarias.
            GaussianBlur {
                anchors.fill: blurSource
                source: blurSource
                radius: blurSlider.value
                samples: Math.round(blurSlider.value) * 2 + 1
            }
        }

        // Control de intensidad: el slider va de 0 (sin desenfoque) a 16
        // (desenfoque maximo). El label muestra el valor actual para que
        // el aprendiz relacione el numero con el efecto visual.
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Radius: " + blurSlider.value.toFixed(1)
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: blurSlider
                Layout.fillWidth: true
                from: 0; to: 16; value: 0
            }
        }
    }
}
