// =============================================================================
// DialCard.qml — Control rotatorio Dial con propiedades custom del estilo
// =============================================================================
// Presenta el componente Dial de Qt Quick Controls con las propiedades custom
// definidas en el estilo del proyecto (qmlsnippetsstyle). Tres diales con
// diferentes configuraciones demuestran la versatilidad del componente.
//
// CONCEPTOS CLAVE:
//
// 1. Dial como alternativa al Slider:
//    - Dial permite seleccionar valores girando un control circular, ideal
//      para representar magnitudes rotatorias (temperatura, volumen, velocidad).
//    - Soporta interaccion por drag, rueda del mouse y teclas de flecha.
//
// 2. Propiedades custom del estilo:
//    - progressColor: color del arco de progreso (no es nativo de Dial,
//      lo implementa el estilo qmlsnippetsstyle).
//    - trackWidth: grosor del arco.
//    - showTicks/tickCount: marcas de division.
//    - suffix: unidad mostrada junto al valor ("°C", "%", "km/h").
//    - valueDecimals: precision decimal del valor mostrado.
//    - Estas propiedades existen porque el Dial.qml del estilo las define
//      como "property" adicionales.
//
// 3. Color dinamico basado en posicion:
//    - El dial de temperatura usa un binding que calcula progressColor
//      segun la posicion (0-1): azul para frio, verde para medio, naranja
//      para caliente. Esto demuestra como los colores pueden ser reactivos.
//
// 4. Comparacion de configuraciones:
//    - Tres diales con diferentes trackWidth, colores y precision muestran
//      como un mismo componente se adapta a distintos contextos de uso.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
            text: "Dial — Styled Qt Controls"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(30)

            // Dial de temperatura: progressColor dinamico segun la posicion.
            // Azul (< 35%) -> verde (35-65%) -> naranja (> 65%).
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    id: tempDial
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 16
                    to: 32
                    value: 22
                    stepSize: 0.5
                    valueDecimals: 1
                    suffix: "°C"
                    progressColor: {
                        var ratio = tempDial.position
                        if (ratio < 0.35) return "#4FC3F7"
                        if (ratio < 0.65) return Style.mainColor
                        return "#FF7043"
                    }
                }

                Label {
                    text: "Temperature"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Dial de volumen: trackWidth grueso y color fijo purpura.
            // Demuestra una configuracion tipica de control de audio.
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: 65
                    stepSize: 1
                    suffix: "%"
                    progressColor: "#7C4DFF"
                    trackWidth: Style.resize(12)
                }

                Label {
                    text: "Volume"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Dial de velocidad: track fino (6px), sin ticks.
            // showTicks: false da un aspecto minimalista y limpio.
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 200
                    value: 80
                    stepSize: 5
                    suffix: "km/h"
                    showTicks: false
                    trackWidth: Style.resize(6)
                    progressColor: "#FF5900"
                }

                Label {
                    text: "Speed"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Panel informativo: lista las propiedades custom disponibles.
            // Sirve como referencia rapida para el desarrollador.
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: Style.resize(10)

                Label {
                    text: "Custom Properties"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• progressColor — arc color\n• trackWidth — arc thickness\n• showTicks / tickCount\n• suffix — unit label\n• valueDecimals — precision\n• showValue — center display"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    lineHeight: 1.4
                }

                Label {
                    text: "Native Dial interaction:\ndrag, mouse wheel, arrow keys"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.mainColor
                }
            }
        }
    }
}
