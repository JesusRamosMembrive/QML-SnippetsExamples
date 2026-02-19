// =============================================================================
// GaugeCard.qml — Medidores circulares tipo velocimetro (QQuickPaintedItem)
// =============================================================================
// Demuestra el uso de GaugeItem, un QQuickPaintedItem que dibuja un medidor
// semicircular con arco de progreso, marcas de graduacion (ticks), aguja
// indicadora y valor numerico, todo renderizado con QPainter en C++.
//
// Integracion C++ <-> QML:
//   - GaugeItem expone Q_PROPERTYs: value, minValue, maxValue, label,
//     gaugeColor, backgroundColor.
//   - value se vincula directamente al Slider: rpmGauge.value = rpmSlider.value.
//     Cada movimiento del Slider actualiza la propiedad en C++, que repinta
//     el arco y reposiciona la aguja instantaneamente.
//   - gaugeColor acepta un string de color que Qt convierte a QColor en C++.
//
// Patron de dos instancias con configuracion diferente:
//   Se crean dos GaugeItem con el mismo componente C++ pero parametros
//   distintos (RPM vs km/h), demostrando la reutilizacion de componentes
//   C++ personalizados. Cada uno mantiene su estado independiente porque
//   son instancias separadas del QObject.
//
// Dimensionamiento cuadrado:
//   Math.min(parent.width, parent.height) asegura que el gauge sea siempre
//   un cuadrado perfecto, necesario para que los arcos de QPainter se
//   dibujen proporcionalmente.
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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Circular Gauge"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem — arc gauge with needle"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Dos medidores lado a lado: cada GaugeItem es una instancia
        //    independiente del mismo componente C++, configurada con
        //    diferentes rangos, etiquetas y colores.
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(10)

            // -- Medidor de RPM (tacometro)
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                GaugeItem {
                    id: rpmGauge
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) - Style.resize(10)
                    height: width
                    value: rpmSlider.value
                    minValue: 0
                    maxValue: 8000
                    label: "RPM"
                    gaugeColor: "#00D1A9"
                }
            }

            // -- Medidor de velocidad (velocimetro)
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                GaugeItem {
                    id: speedGauge
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) - Style.resize(10)
                    height: width
                    value: speedSlider.value
                    minValue: 0
                    maxValue: 260
                    label: "km/h"
                    gaugeColor: "#FF6B6B"
                }
            }
        }

        // -- Slider de RPM vinculado a rpmGauge.value via binding directo.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "RPM:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(50)
            }

            Slider {
                id: rpmSlider
                Layout.fillWidth: true
                from: 0; to: 8000; value: 3500
            }

            Label {
                text: rpmSlider.value.toFixed(0)
                font.pixelSize: Style.resize(11)
                color: "#00D1A9"
                Layout.preferredWidth: Style.resize(45)
            }
        }

        // -- Slider de velocidad vinculado a speedGauge.value.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Speed:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(50)
            }

            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from: 0; to: 260; value: 120
            }

            Label {
                text: speedSlider.value.toFixed(0)
                font.pixelSize: Style.resize(11)
                color: "#FF6B6B"
                Layout.preferredWidth: Style.resize(45)
            }
        }
    }
}
