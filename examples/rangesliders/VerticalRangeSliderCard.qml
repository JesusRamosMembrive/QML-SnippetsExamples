// =============================================================================
// VerticalRangeSliderCard.qml — Tarjeta: RangeSliders verticales
// =============================================================================
// Demuestra como usar orientation: Qt.Vertical en RangeSlider. Tres sliders
// se presentan uno al lado del otro en un RowLayout, cada uno con una
// configuracion diferente:
//   1. Continuo (rango amplio: 20-80)
//   2. Con pasos de 5 y snap (rango estrecho: 40-60)
//   3. Continuo (rango maximo: 10-90)
//
// A diferencia de Slider normal, en RangeSlider vertical el handle "first"
// esta abajo (valor minimo) y "second" arriba (valor maximo). Qt maneja
// automaticamente esta inversion cuando se cambia la orientacion.
//
// Aprendizaje clave: RowLayout + ColumnLayout anidados permiten colocar
// cada slider vertical con su label debajo, y luego alinearlos lado a lado.
// Layout.preferredHeight controla la altura del track del slider.
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
            text: "Vertical RangeSliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // RowLayout horizontal que contiene los tres sliders verticales
        // y un Label explicativo a la derecha.
        RowLayout {
            spacing: Style.resize(30)
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Slider 1: continuo, rango amplio
            ColumnLayout {
                spacing: Style.resize(10)

                RangeSlider {
                    id: vertRange1
                    from: 0
                    to: 100
                    first.value: 20
                    second.value: 80
                    orientation: Qt.Vertical
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: vertRange1.first.value.toFixed(0) + "-" + vertRange1.second.value.toFixed(0)
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Slider 2: con stepSize y snap, rango estrecho.
            // Notar como stepSize: 5 funciona igual en vertical que
            // en horizontal — la orientacion solo cambia la direccion
            // visual, no el comportamiento logico.
            ColumnLayout {
                spacing: Style.resize(10)

                RangeSlider {
                    id: vertRange2
                    from: 0
                    to: 100
                    first.value: 40
                    second.value: 60
                    orientation: Qt.Vertical
                    stepSize: 5
                    snapMode: RangeSlider.SnapAlways
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: vertRange2.first.value.toFixed(0) + "-" + vertRange2.second.value.toFixed(0)
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Slider 3: continuo, rango casi completo (10-90)
            ColumnLayout {
                spacing: Style.resize(10)

                RangeSlider {
                    id: vertRange3
                    from: 0
                    to: 100
                    first.value: 10
                    second.value: 90
                    orientation: Qt.Vertical
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: vertRange3.first.value.toFixed(0) + "-" + vertRange3.second.value.toFixed(0)
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Label {
                text: "Vertical range sliders using orientation: Qt.Vertical"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
