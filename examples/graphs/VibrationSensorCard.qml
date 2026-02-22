// =============================================================================
// VibrationSensorCard.qml — Simulación de sensor de vibración en tiempo real
// =============================================================================
// Demuestra cómo crear una visualización de datos en tiempo real de alto
// rendimiento usando QtGraphs (LineSeries) + FrameAnimation.
//
// Conceptos clave:
// - FrameAnimation: Se ejecuta en cada frame (~60fps), mucho más fluido que
//   Timer. Ideal para animaciones de datos continuas.
// - LineSeries.replace(): Modifica puntos existentes sin recrear la serie.
//   Esto es CRÍTICO para rendimiento — append/remove cada frame sería lento.
// - LineSeries.removeMultiple() / append(): Para cambiar la resolución
//   (cantidad de puntos) dinámicamente.
// - Sliders de control: Amplitud, frecuencia y resolución modifican la onda
//   en tiempo real gracias al binding declarativo de QML.
// - Patrón active: La animación solo corre cuando la página es visible
//   (root.active) Y el usuario ha pulsado Start (root.animRunning).
//
// La fórmula de vibración combina sin, cos y random para simular un sensor
// real con ruido y modulación de envolvente.
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
                text: "Vibration Sensor"
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

        // -------------------------------------------------------------------
        // Controles deslizantes: cada slider tiene su label con valor actual.
        // El patrón Item + Slider con anchors.fill es necesario porque Slider
        // dentro de un Layout no siempre respeta fillWidth correctamente.
        // -------------------------------------------------------------------

        // Slider de amplitud: controla la intensidad de la onda
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Amplitude: " + vibAmpSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibAmpSlider; anchors.fill: parent; from: 0.0; to: 1.0; value: 0.5; stepSize: 0.05 }
            }
        }

        // Slider de frecuencia: controla qué tan "apretada" es la onda
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Frequency: " + vibFreqSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibFreqSlider; anchors.fill: parent; from: 0.0; to: 1.0; value: 0.5; stepSize: 0.05 }
            }
        }

        // Slider de resolución: controla la cantidad de puntos de datos.
        // onMoved llama a vibLine.change() para agregar o quitar puntos.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Points: " + vibResSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: vibResSlider; anchors.fill: parent; from: 10; to: 500; value: 500; stepSize: 10;
                    onMoved: vibLine.change(value)
                }
            }
        }

        // -------------------------------------------------------------------
        // Área de la gráfica
        // Patrón: Rectangle oscuro como fondo + GraphsView con tema transparente.
        // clip: true evita que la línea se dibuje fuera del área cuando los
        // valores exceden el rango visible.
        // -------------------------------------------------------------------
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

                // Ejes ocultos: en este caso no necesitamos mostrar valores,
                // solo la forma de onda. max: 8 define el rango de coordenadas.
                axisX: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    max: 8
                }

                axisY: ValueAxis {
                    visible: false
                    lineVisible: false
                    gridVisible: false
                    subGridVisible: false
                    labelsVisible: false
                    max: 8
                }

                LineSeries {
                    id: vibLine
                    property int divisions: 500
                    property real amplitude: vibAmpSlider.value
                    property real resolution: vibFreqSlider.value

                    color: Style.mainColor
                    width: 2

                    // FrameAnimation reemplaza a Timer para animaciones fluidas.
                    // Se dispara cada frame de renderizado (~16ms a 60fps).
                    // La fórmula combina sin * cos * sin * random para simular
                    // vibración con modulación de envolvente y ruido.
                    FrameAnimation {
                        running: root.active && root.animRunning
                        onTriggered: {
                            for (let i = 0; i < vibLine.divisions; ++i) {
                                let y = Math.sin(vibLine.resolution * i)
                                y *= Math.cos(i)
                                y *= Math.sin(i / vibLine.divisions * 3.2) * 3 * vibLine.amplitude * Math.random()
                                vibLine.replace(i, (i / vibLine.divisions) * 8.0, y + 4)
                            }
                        }
                    }

                    // Inicialización: crea todos los puntos en la línea central (y=4).
                    Component.onCompleted: {
                        for (let i = 1; i <= divisions; ++i)
                            append((i / divisions) * 8.0, 4.0)
                    }

                    // Función para cambiar la resolución dinámicamente.
                    // Si se reduce, elimina puntos con removeMultiple().
                    // Si se aumenta, agrega nuevos puntos con append().
                    // Esto es más eficiente que recrear toda la serie.
                    function change(newDivs) {
                        let delta = newDivs - divisions
                        if (delta < 0) {
                            delta = Math.abs(delta)
                            removeMultiple(count - 1 - delta, delta)
                        } else {
                            for (let i = 0; i < delta; ++i)
                                append(((count + i) / divisions) * 8.0, 4.0)
                        }
                        divisions = newDivs
                    }
                }
            }
        }

        Label {
            text: "FrameAnimation + LineSeries.replace() for 60fps fluid updates"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
