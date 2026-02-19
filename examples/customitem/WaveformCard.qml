// =============================================================================
// WaveformCard.qml — Visualizador de onda sinusoidal (QQuickPaintedItem)
// =============================================================================
// Demuestra el uso de WaveformItem, un QQuickPaintedItem que dibuja una
// onda seno parametrizable con cuadricula tipo osciloscopio usando QPainter
// y QPainterPath en C++.
//
// Integracion C++ <-> QML:
//   - WaveformItem expone Q_PROPERTYs: frequency, amplitude, phase,
//     lineWidth, showGrid. QML controla estas propiedades con Sliders
//     y Switch, y cada cambio dispara un repintado en C++.
//   - La animacion se logra incrementando "phase" con un Timer QML.
//     Cada 50ms phase += 0.15, lo que desplaza la onda horizontalmente.
//     El setter de phase en C++ llama update() -> repintado continuo.
//
// Patron Timer para animacion:
//   En vez de usar NumberAnimation (que es declarativa y no permite
//   incrementos infinitos), se usa un Timer imperativo que modifica
//   la propiedad phase repetidamente. Esto es apropiado para animaciones
//   ciclicas que no tienen un "destino" fijo.
//
// La propiedad "animating" del root controla si el Timer esta running,
// permitiendo pausar/reanudar la animacion con un boton.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool animating: false

    // -- Timer de animacion: incrementa la fase de la onda cada 50ms.
    //    running esta vinculado a root.animating, asi que se activa/
    //    desactiva con el boton "Animate"/"Stop".
    Timer {
        interval: 50
        running: root.animating
        repeat: true
        onTriggered: waveform.phase += 0.15
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Waveform Display"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem — sine wave with QPainterPath"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Area de visualizacion: WaveformItem es el componente C++ que
        //    dibuja la onda con QPainter. Se envuelve en un Rectangle con
        //    clip: true para que la onda no se dibuje fuera de los limites.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            WaveformItem {
                id: waveform
                anchors.fill: parent
                anchors.margins: Style.resize(8)

                // -- Bindings directos a Q_PROPERTYs de C++.
                //    Cuando freqSlider.value cambia, frequency se actualiza
                //    automaticamente -> el setter en C++ llama update() ->
                //    paint() redibuja la onda con la nueva frecuencia.
                frequency: freqSlider.value
                amplitude: ampSlider.value
                lineWidth: 2
            }
        }

        // -- Control de frecuencia: cuantos ciclos de la onda se muestran.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Freq:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                id: freqSlider
                Layout.fillWidth: true
                from: 0.5; to: 8.0; value: 2.0
            }

            Label {
                text: freqSlider.value.toFixed(1) + " Hz"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // -- Control de amplitud: altura de la onda (0-100%).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Amp:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                id: ampSlider
                Layout.fillWidth: true
                from: 0.1; to: 1.0; value: 0.8
            }

            Label {
                text: (ampSlider.value * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // -- Controles de animacion y cuadricula.
        //    El boton "Reset" restaura todos los parametros a sus valores
        //    iniciales, demostrando asignacion imperativa de Q_PROPERTYs.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: root.animating ? "Stop" : "Animate"
                implicitHeight: Style.resize(34)
                onClicked: root.animating = !root.animating
            }

            Button {
                text: "Reset"
                implicitHeight: Style.resize(34)
                onClicked: {
                    waveform.phase = 0
                    freqSlider.value = 2.0
                    ampSlider.value = 0.8
                    root.animating = false
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Grid:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            // -- Switch vinculado a waveform.showGrid (Q_PROPERTY bool).
            //    Demuestra binding bidireccional con propiedad booleana de C++.
            Switch {
                checked: waveform.showGrid
                onCheckedChanged: waveform.showGrid = checked
            }
        }
    }
}
