// =============================================================================
// BasicSlidersCard.qml — Variantes fundamentales del componente Slider
// =============================================================================
// Presenta tres configuraciones basicas del Slider de Qt Quick Controls:
// continuo, escalonado (stepped) y deshabilitado. Cubre las propiedades
// esenciales que todo desarrollador debe conocer para controles de rango.
//
// CONCEPTOS CLAVE:
//
// 1. Propiedades basicas de Slider:
//    - from/to: rango de valores (minimo y maximo).
//    - value: valor actual (bidireccional si se vincula con un binding).
//    - El valor se muestra con toFixed(N) para controlar los decimales.
//
// 2. stepSize y snapMode (slider escalonado):
//    - stepSize: 10 hace que el slider solo se detenga en multiplos de 10.
//    - snapMode: Slider.SnapAlways fuerza a que el handle "salte" al paso
//      mas cercano, en lugar de permitir posiciones intermedias.
//    - Sin snapMode, el handle se mueve libremente aunque stepSize este
//      definido (solo afecta al valor reportado).
//
// 3. Slider deshabilitado (enabled: false):
//    - El estilo automaticamente atenua el slider y desactiva la interaccion.
//    - Util para mostrar un valor de referencia que no se puede modificar.
//
// 4. Patron de wrapping en Item:
//    - Los Sliders estan envueltos en un Item con anchors.fill + margenes.
//    - Esto evita que el handle del slider se corte en los extremos, ya que
//      el handle se extiende ligeramente mas alla del track.
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
            text: "Basic Sliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Slider continuo: se mueve libremente entre from y to.
        // toFixed(2) muestra dos decimales para evidenciar la continuidad.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Horizontal Slider: " + horizontalSlider.value.toFixed(2)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)
                Layout.preferredWidth: root.width - 10

                Slider {
                    id: horizontalSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    value: 50
                }
            }
        }

        // Slider escalonado: stepSize + snapMode restringen los valores
        // a multiplos de 10, simulando un selector discreto.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Stepped Slider (step: 10): " + steppedSlider.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    id: steppedSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    stepSize: 10
                    value: 50
                    snapMode: Slider.SnapAlways
                }
            }
        }

        // Slider deshabilitado: muestra un valor fijo sin interaccion.
        // El estilo qmlsnippetsstyle lo renderiza con opacidad reducida.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Disabled Slider"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    value: 75
                    enabled: false
                }
            }
        }
    }
}
