// =============================================================================
// DialCard.qml — Tarjeta de ejemplo del control Dial de Qt Quick Controls
// =============================================================================
// Muestra tres variantes del Dial nativo:
//   1) Basico: rango libre de 0-100, el usuario gira sin restricciones.
//   2) Escalonado (Stepped): stepSize=10 con snapMode=SnapAlways, fuerza
//      que el valor se ajuste a multiplos de 10 al soltar.
//   3) Temperatura: rango personalizado (0-40°C) con sufijo "°C" que se
//      muestra en el estilo personalizado del proyecto (qmlsnippetsstyle).
//
// Conceptos clave para el aprendiz:
//   - stepSize + snapMode controlan la granularidad de la interaccion.
//   - La propiedad "suffix" es custom del estilo del proyecto, NO es nativa
//     de Qt Quick Controls — se implementa en styles/qmlsnippetsstyle/Dial.qml.
//   - Todas las dimensiones usan Style.resize() para escalado responsivo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dial"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ── Fila de tres Dials con variantes distintas ──
        // RowLayout distribuye los dials horizontalmente con espacio igual.
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(20)

            // ── Dial basico ──
            // Configuracion minima: from, to, value. Sin stepSize, el
            // usuario puede seleccionar cualquier valor continuo en el rango.
            ColumnLayout {
                spacing: Style.resize(8)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: basicDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: 35
                }

                Label {
                    text: "Basic (0-100)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Dial escalonado ──
            // stepSize: 10 define el incremento entre valores validos.
            // snapMode: Dial.SnapAlways hace que el dial "salte" al valor
            // mas cercano incluso durante el arrastre (no solo al soltar).
            ColumnLayout {
                spacing: Style.resize(8)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: steppedDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    stepSize: 10
                    snapMode: Dial.SnapAlways
                    value: 50
                }

                Label {
                    text: "Stepped (10)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Dial de temperatura ──
            // Demuestra un rango personalizado (0-40) con step=1 y un sufijo
            // visual "°C". El sufijo lo renderiza el estilo custom del proyecto.
            ColumnLayout {
                spacing: Style.resize(8)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: tempDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 40
                    stepSize: 1
                    snapMode: Dial.SnapAlways
                    value: 21
                    suffix: "°C"
                }

                Label {
                    text: "Temp (0-40°C)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Dial provides a rotary control for selecting values within a range"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
