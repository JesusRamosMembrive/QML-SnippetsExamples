// =============================================================================
// HudControlsPanel.qml — Panel de controles del HUD
// =============================================================================
// Panel compacto con 6 sliders organizados en un GridLayout de 6 columnas
// (2 filas x 3 pares label+slider). Expone las propiedades de vuelo como
// readonly properties para que Main.qml las conecte al HudCanvas.
//
// Patron de diseno:
//   Los sliders definen los valores, y las readonly properties los exponen
//   al exterior. Esto encapsula la implementacion (sliders) y permite que
//   el componente padre solo vea la interfaz publica (pitch, roll, etc.).
//   Si en el futuro se reemplazaran los sliders por entrada de teclado
//   o datos reales, la interfaz publica no cambiaria.
//
// Parametros de vuelo:
//   - Pitch: -20 a +20 grados (cabeceo)
//   - Roll: -45 a +45 grados (alabeo)
//   - Heading: 0 a 359 grados (rumbo)
//   - Speed: 100 a 600 nudos (velocidad)
//   - Altitude: 0 a 50000 pies (altitud)
//   - FPA: -10 a +10 grados (angulo de trayectoria de vuelo)
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    // -------------------------------------------------------------------------
    // Interfaz publica: readonly properties vinculadas a los sliders.
    // readonly asegura que solo este componente puede modificar los valores;
    // el padre solo puede leerlos. Es una forma de encapsulacion en QML.
    // -------------------------------------------------------------------------
    readonly property real pitch: pitchSlider.value
    readonly property real roll: rollSlider.value
    readonly property real heading: headingSlider.value
    readonly property real speed: speedSlider.value
    readonly property real altitude: altSlider.value
    readonly property real fpa: fpaSlider.value

    color: Style.cardColor
    radius: Style.resize(8)

    // -------------------------------------------------------------------------
    // GridLayout de 6 columnas: cada parametro ocupa 2 columnas (label + slider).
    // Esto permite organizar 6 parametros en 2 filas de forma compacta.
    // El unicode \u00B0 es el simbolo de grados (°).
    // -------------------------------------------------------------------------
    GridLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(10)
        columns: 6
        rowSpacing: Style.resize(4)
        columnSpacing: Style.resize(10)

        // Fila 1: Pitch, Roll, Heading
        Label {
            text: "Pitch"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: pitchSlider
                Layout.fillWidth: true
                from: -20; to: 20; value: 5
            }
            Label {
                text: pitchSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        Label {
            text: "Roll"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: rollSlider
                Layout.fillWidth: true
                from: -45; to: 45; value: 0
            }
            Label {
                text: rollSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        Label {
            text: "Heading"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: headingSlider
                Layout.fillWidth: true
                from: 0; to: 359; value: 0
            }
            Label {
                text: headingSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }

        // Fila 2: Speed, Altitude, FPA
        Label {
            text: "Speed"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from: 100; to: 600; value: 350
            }
            Label {
                text: speedSlider.value.toFixed(0) + " kt"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(45)
            }
        }

        Label {
            text: "Altitude"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: altSlider
                Layout.fillWidth: true
                from: 0; to: 50000; value: 25000
            }
            Label {
                text: altSlider.value.toFixed(0) + " ft"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(55)
            }
        }

        Label {
            text: "FPA"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
        RowLayout {
            Layout.fillWidth: true
            Slider {
                id: fpaSlider
                Layout.fillWidth: true
                from: -10; to: 10; value: 2
            }
            Label {
                text: fpaSlider.value.toFixed(0) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(30)
            }
        }
    }
}
