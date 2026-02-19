// =============================================================================
// LabelsRangeSliderCard.qml — Tarjeta: Rangos con formato y unidades
// =============================================================================
// Demuestra como presentar RangeSliders con contexto significativo para el
// usuario: rangos de precio ($), edad (anios) y temperatura (°C). Cada slider
// tiene su propio rango (from/to), paso (stepSize) y formato de etiqueta.
//
// El ejemplo de temperatura va mas alla del formato: el color del label
// cambia dinamicamente segun el promedio del rango (azul < 10°C, teal 10-25,
// naranja > 25°C). Esto demuestra como usar bindings con logica condicional
// para crear feedback visual contextual.
//
// Patron de layout repetido: cada slider sigue la misma estructura:
//   ColumnLayout > RowLayout(titulo + valor) > Item > RangeSlider
// El RowLayout con un Item { fillWidth: true } en medio crea el efecto
// "titulo a la izquierda, valor a la derecha" (similar a space-between CSS).
//
// Aprendizaje clave: "from" no tiene que ser 0 — el slider de temperatura
// usa from: -20 y to: 50, mostrando que RangeSlider soporta rangos negativos.
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
            text: "Formatted Ranges"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Rango de precio: stepSize: 50 da incrementos de $50.
        // El formato "$200 -- $800" contextualiza los numeros crudos.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Price Range"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: "$" + priceRange.first.value.toFixed(0) + " — $" + priceRange.second.value.toFixed(0)
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: priceRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 1000
                    stepSize: 50
                    first.value: 200
                    second.value: 800
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // Rango de edad: from: 18 (mayoria de edad) a to: 65.
        // stepSize: 1 permite seleccion precisa anio por anio.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Age Range"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: ageRange.first.value.toFixed(0) + " — " + ageRange.second.value.toFixed(0) + " years"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: ageRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 18
                    to: 65
                    stepSize: 1
                    first.value: 25
                    second.value: 45
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // Rango de temperatura: usa valores negativos (from: -20).
        // El color del label cambia segun el promedio del rango:
        //   - Azul (#4FC3F7) para frio (< 10°C)
        //   - Teal (Style.mainColor) para templado (10-25°C)
        //   - Naranja (#FF7043) para calor (> 25°C)
        // Este patron de "color semantico" da informacion adicional
        // sin necesidad de texto extra.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Temperature"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: tempRange.first.value.toFixed(0) + " °C — " + tempRange.second.value.toFixed(0) + " °C"
                    font.pixelSize: Style.resize(14)
                    color: {
                        var avg = (tempRange.first.value + tempRange.second.value) / 2
                        if (avg < 10) return "#4FC3F7"
                        if (avg < 25) return Style.mainColor
                        return "#FF7043"
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: tempRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: -20
                    to: 50
                    stepSize: 1
                    first.value: 5
                    second.value: 30
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }
    }
}
