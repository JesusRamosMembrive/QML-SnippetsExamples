// =============================================================================
// ScrollingWaveformCard.qml — Forma de onda desplazable en tiempo real
// =============================================================================
// Simula un osciloscopio con tres tipos de onda seleccionables: seno,
// latido cardíaco y ruido filtrado. La onda se desplaza continuamente
// gracias a un acumulador de tiempo (scrollLine.time).
//
// Conceptos clave:
// - FrameAnimation + acumulador de tiempo: En cada frame, `time` avanza
//   proporcionalmente a la velocidad seleccionada. La posición Y de cada
//   punto se recalcula como f(time + offset_espacial), creando el efecto
//   de desplazamiento horizontal sin mover puntos de lugar.
// - Selección de tipo de onda con botones: `highlighted` da feedback visual
//   del botón activo. La propiedad waveType se lee en el FrameAnimation.
// - Señal de latido (heartbeat): Construida con segmentos de seno en fases
//   específicas, imitando un electrocardiograma (P, QRS, T).
// - Ruido filtrado: Suma de senos con frecuencias irracionales entre sí,
//   lo que produce un patrón pseudo-aleatorio pero determinista y suave.
// =============================================================================

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
                text: "Scrolling Waveform"
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

        // Control de velocidad: multiplica el incremento de `time` por frame.
        // Un valor mayor = onda se desplaza más rápido.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Speed: " + scrollSpeedSlider.value.toFixed(1) + "x"; font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: scrollSpeedSlider; anchors.fill: parent; from: 0.2; to: 5.0; value: 1.0; stepSize: 0.1 }
            }
        }

        // -------------------------------------------------------------------
        // Selector de tipo de onda con botones mutuamente exclusivos.
        // `highlighted` es una propiedad nativa de Button en Qt Quick Controls
        // que cambia su apariencia visual (definida por el estilo activo).
        // -------------------------------------------------------------------
        RowLayout {
            id: waveSelector
            Layout.fillWidth: true
            spacing: Style.resize(6)

            property int waveType: 0

            Button {
                text: "Sine"
                highlighted: waveSelector.waveType === 0
                onClicked: waveSelector.waveType = 0
            }
            Button {
                text: "Heartbeat"
                highlighted: waveSelector.waveType === 1
                onClicked: waveSelector.waveType = 1
            }
            Button {
                text: "Noise"
                highlighted: waveSelector.waveType === 2
                onClicked: waveSelector.waveType = 2
            }
        }

        // Área de la gráfica
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
                    max: 200
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

                LineSeries {
                    id: scrollLine
                    property int pointCount: 200
                    property real time: 0

                    color: "#4A90D9"
                    width: 2

                    // En cada frame, avanzamos el tiempo y recalculamos TODOS
                    // los puntos. El truco del desplazamiento: cada punto i
                    // calcula su Y como f(time + i/total * 6), así el patrón
                    // parece moverse hacia la izquierda aunque los puntos X
                    // permanecen fijos en su lugar.
                    FrameAnimation {
                        running: root.active && root.animRunning
                        onTriggered: {
                            scrollLine.time += 0.04 * scrollSpeedSlider.value
                            var waveType = waveSelector.waveType

                            for (let i = 0; i < scrollLine.pointCount; ++i) {
                                let t = scrollLine.time + (i / scrollLine.pointCount) * 6.0
                                let y = 4.0

                                if (waveType === 0) {
                                    // Onda seno con armónicos: frecuencia base + segundo armónico
                                    y = Math.sin(t * 3.0) * 2.0 + Math.sin(t * 7.1) * 0.5 + 4.0
                                } else if (waveType === 1) {
                                    // Latido cardíaco: segmentos de seno en fases específicas
                                    // simulando las ondas P (0-0.3), QRS (1.0-1.3), S (1.3-1.8)
                                    // y T (2.2-2.7) de un ECG real.
                                    let phase = (t * 1.5) % (Math.PI * 2)
                                    y = 4.0
                                    if (phase < 0.3)
                                        y += Math.sin(phase / 0.3 * Math.PI) * 0.5
                                    else if (phase > 1.0 && phase < 1.3)
                                        y += Math.sin((phase - 1.0) / 0.3 * Math.PI) * 3.0
                                    else if (phase > 1.3 && phase < 1.8)
                                        y -= Math.sin((phase - 1.3) / 0.5 * Math.PI) * 1.0
                                    else if (phase > 2.2 && phase < 2.7)
                                        y += Math.sin((phase - 2.2) / 0.5 * Math.PI) * 0.8
                                } else {
                                    // Ruido filtrado: suma de senos con frecuencias irracionales
                                    // (5.0, 13.7, 23.1) que nunca se repiten exactamente.
                                    y = Math.sin(t * 5.0) * 1.5 + Math.sin(t * 13.7) * 0.8 + Math.sin(t * 23.1) * 0.4 + 4.0
                                }

                                scrollLine.replace(i, i, y)
                            }
                        }
                    }

                    // Inicialización: todos los puntos en la línea central (y=4)
                    Component.onCompleted: {
                        for (let i = 0; i < pointCount; ++i)
                            append(i, 4.0)
                    }
                }
            }
        }

        Label {
            text: "Real-time scrolling line chart, updated every frame"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
