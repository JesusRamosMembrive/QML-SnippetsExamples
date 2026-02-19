// =============================================================================
// BasicRangeSliderCard.qml — Tarjeta: RangeSliders basicos
// =============================================================================
// Muestra tres variaciones fundamentales del RangeSlider horizontal:
//   1. Continuo (sin restriccion de paso)
//   2. Con pasos (stepSize + snapMode)
//   3. Deshabilitado (enabled: false)
//
// El RangeSlider tiene dos sub-objetos "first" y "second", cada uno con
// su propio value, pressed, hovered, etc. En el Label se accede como
// basicRange.first.value y basicRange.second.value.
//
// Nota tecnica: los RangeSlider estan dentro de Items contenedores con
// margenes laterales. Esto evita que los handles se corten en los bordes
// de la tarjeta, ya que el thumb del slider puede sobresalir ligeramente
// de su area logica.
//
// Aprendizaje clave: snapMode: RangeSlider.SnapAlways fuerza que los
// handles se "peguen" a los valores definidos por stepSize, dando una
// sensacion de clicks discretos al arrastrar.
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
        spacing: Style.resize(20)

        Label {
            text: "Basic RangeSliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // RangeSlider continuo: el usuario puede colocar los handles
        // en cualquier posicion entre 0 y 100. El label muestra los
        // valores redondeados con toFixed(0).
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Horizontal: " + basicRange.first.value.toFixed(0) + " — " + basicRange.second.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: basicRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 20
                    second.value: 80
                }
            }
        }

        // RangeSlider con pasos: stepSize: 10 restringe los valores
        // posibles a multiplos de 10. SnapAlways hace que el handle
        // salte al valor mas cercano tanto al arrastrar como al soltar.
        // Otras opciones: SnapOnRelease (solo al soltar) y NoSnap.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Stepped (step: 10): " + steppedRange.first.value.toFixed(0) + " — " + steppedRange.second.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: steppedRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    stepSize: 10
                    first.value: 30
                    second.value: 70
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // RangeSlider deshabilitado: muestra como luce el control cuando
        // enabled: false. El estilo personalizado (qmlsnippetsstyle)
        // automaticamente aplica colores atenuados y desactiva la interaccion.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Disabled RangeSlider"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 25
                    second.value: 75
                    enabled: false
                }
            }
        }
    }
}
