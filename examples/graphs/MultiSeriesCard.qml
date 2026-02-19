// =============================================================================
// MultiSeriesCard.qml — Múltiples series de líneas animadas simultáneamente
// =============================================================================
// Muestra tres funciones matemáticas (seno, coseno y diente de sierra)
// superpuestas en un mismo GraphsView, animadas en tiempo real.
//
// Conceptos clave:
// - Múltiples LineSeries en un GraphsView: Se pueden superponer tantas series
//   como se necesite. Cada una tiene su propio color y datos independientes.
// - FrameAnimation centralizado: Un solo FrameAnimation (en sawSeries) actualiza
//   las tres series. Esto es intencional — no se necesitan tres timers separados
//   ya que todas comparten el mismo ciclo de actualización.
// - pragma ComponentBehavior: Bound: Requerido en Qt 6.x cuando un Repeater
//   usa `required property` para acceder a modelData de forma type-safe.
// - Diente de sierra (sawtooth): Se genera con módulo — ((t) % (2*PI)) / (2*PI)
//   produce una rampa lineal de 0 a 1 que se repite periódicamente.
// - Desfase (phase): El slider de fase mueve la curva coseno respecto al seno,
//   permitiendo visualizar la relación cos(x) = sin(x + PI/2).
// =============================================================================

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool active: false
    property bool animRunning: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Multi-Series"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Button {
                text: root.animRunning ? "Stop" : "Start"
                onClicked: root.animRunning = !root.animRunning
            }
        }

        // Slider de frecuencia: afecta las tres series por igual.
        // Multiplica la velocidad temporal de la animación.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Freq: " + multiFreqSlider.value.toFixed(1); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: multiFreqSlider; anchors.fill: parent; from: 0.5; to: 5.0; value: 2.0; stepSize: 0.1 }
            }
        }

        // Slider de fase: desplaza la curva coseno respecto al seno.
        // Rango 0 a 2*PI (6.28) para cubrir un ciclo completo.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Phase: " + multiPhaseSlider.value.toFixed(1); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: multiPhaseSlider; anchors.fill: parent; from: 0.0; to: 6.28; value: 1.0; stepSize: 0.1 }
            }
        }

        // -------------------------------------------------------------------
        // Leyenda con Repeater: genera un indicador color + texto por cada
        // serie. El modelo es un array de objetos JS inline.
        // `required property var modelData` es la forma type-safe de Qt 6
        // para acceder a datos del modelo dentro de un delegate.
        // -------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)
            Repeater {
                model: [
                    { label: "Sin", clr: "#00D1A9" },
                    { label: "Cos", clr: "#4A90D9" },
                    { label: "Sawtooth", clr: "#FEA601" }
                ]
                RowLayout {
                    required property var modelData
                    spacing: Style.resize(4)
                    Rectangle { width: Style.resize(12); height: Style.resize(3); color: modelData.clr; radius: 1 }
                    Label { text: modelData.label; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                }
            }
        }

        // Área de la gráfica con tres LineSeries superpuestas
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            GraphsView {
                anchors.fill: parent
                anchors.margins: Style.resize(4)

                theme: GraphsTheme {
                    backgroundVisible: false
                    plotAreaBackgroundColor: "transparent"
                }

                axisX: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    max: 100
                }

                axisY: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    min: 0
                    max: 8
                }

                // Serie seno: la función trigonométrica base
                LineSeries {
                    id: sinSeries
                    color: "#00D1A9"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }
                }

                // Serie coseno: igual que seno pero desfasada por `phase`
                LineSeries {
                    id: cosSeries
                    color: "#4A90D9"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }
                }

                // Serie diente de sierra: onda lineal periódica.
                // Contiene el FrameAnimation que actualiza las TRES series.
                LineSeries {
                    id: sawSeries
                    color: "#FEA601"
                    width: 2

                    Component.onCompleted: {
                        for (let i = 0; i < 100; ++i)
                            append(i, 4.0)
                    }

                    property real time: 0

                    // Un solo FrameAnimation controla las tres series.
                    // En cada frame recorre los 100 puntos y calcula:
                    // - sin(t): onda sinusoidal pura
                    // - cos(t + phase): seno desfasado por el slider
                    // - sawtooth: rampa lineal usando operador módulo
                    // Todas centradas en y=4 con amplitud escalada a +-2.5
                    FrameAnimation {
                        running: root.active && root.animRunning
                        onTriggered: {
                            sawSeries.time += 0.03
                            let freq = multiFreqSlider.value
                            let phase = multiPhaseSlider.value

                            for (let i = 0; i < 100; ++i) {
                                let x = i / 100.0 * Math.PI * 4.0
                                let t = x + sawSeries.time * freq

                                // Sin series
                                let ys = Math.sin(t) * 2.5 + 4.0
                                sinSeries.replace(i, i, ys)

                                // Cos series (phase offset)
                                let yc = Math.cos(t + phase) * 2.5 + 4.0
                                cosSeries.replace(i, i, yc)

                                // Sawtooth: módulo normalizado a [0,1], luego escalado
                                let sawVal = ((t + phase * 2) % (Math.PI * 2)) / (Math.PI * 2)
                                let ysaw = (sawVal * 2.0 - 1.0) * 2.0 + 4.0
                                sawSeries.replace(i, i, ysaw)
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: "3 LineSeries overlaid with real-time FrameAnimation updates"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
