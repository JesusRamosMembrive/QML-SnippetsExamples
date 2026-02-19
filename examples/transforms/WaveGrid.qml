// =============================================================================
// WaveGrid.qml — Grilla de cuadrados con onda propagandose (wave effect)
// =============================================================================
// 60 cuadrados (6x10) se deforman como una onda que se propaga en diagonal.
// Cada cuadrado cambia de escala, color y posicion Y segun una funcion
// sinusoidal que depende de su posicion en la grilla (col + row).
//
// COMO SE CREA LA ONDA:
//   wave = sin(phase + (col + row) * 0.4)
//   - 'phase' avanza con el Timer, creando movimiento temporal.
//   - '(col + row) * 0.4' desfasa cada celda segun su posicion, creando
//     la propagacion espacial de la onda en diagonal.
//   - 't = (wave + 1) / 2' normaliza wave de [-1,1] a [0,1] para usar
//     como factor de interpolacion en scale y color.
//
// TRANSFORM: TRANSLATE:
//   'transform: Translate { y: wave * 12 }' desplaza cada cuadrado
//   verticalmente. A diferencia de modificar 'y' directamente, Translate
//   se aplica DESPUES del layout, asi que no afecta el calculo de
//   posiciones del Grid. Si modificaramos 'y', el Grid recalcularia
//   las posiciones de todos los elementos en cada frame (costoso).
//
// COLOR DINAMICO: Qt.rgba() con expresiones crea una transicion suave
// de color rojo-calido (t=0) a verde-azulado (t=1), sincronizada con
// la onda. Esto refuerza visualmente el patron ondulatorio.
//
// REPEATER + GRID: Grid posiciona los items en filas/columnas automaticamente.
// Repeater genera los 60 items. col/row se calculan a partir del index
// usando aritmetica modular (% y Math.floor).
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool waveActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "6. Wave Grid"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.waveActive ? "Pause" : "Start"
            onClicked: root.waveActive = !root.waveActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(230)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: waveSection
            anchors.fill: parent
            property real wavePhase: 0

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.waveActive
                onTriggered: waveSection.wavePhase += 0.08
            }

            Grid {
                anchors.centerIn: parent
                rows: 6
                columns: 10
                spacing: Style.resize(4)

                Repeater {
                    model: 60

                    Rectangle {
                        property int col: index % 10
                        property int row: Math.floor(index / 10)
                        property real wave: Math.sin(waveSection.wavePhase + (col + row) * 0.4)
                        property real t: (wave + 1) / 2

                        width: Style.resize(22)
                        height: Style.resize(22)
                        radius: Style.resize(4)
                        scale: 0.55 + 0.45 * t
                        color: Qt.rgba(1 - t * 0.75, t * 0.6 + 0.3, t * 0.5 + 0.2, 1)

                        transform: Translate { y: wave * Style.resize(12) }
                    }
                }
            }
        }
    }
}
