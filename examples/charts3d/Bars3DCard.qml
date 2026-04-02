// =============================================================================
// Bars3DCard.qml — Gráfico de barras 3D multi-eje con QtGraphs
// =============================================================================
// Muestra un Bars3D con datos trimestrales por región. Los tres ejes son:
//   - Eje de filas (rowAxis): trimestres Q1–Q4
//   - Eje de columnas (columnAxis): regiones (Norte, Sur, Este, Oeste)
//   - Eje de valor (valueAxis): ventas en millones
//
// Conceptos clave:
// - Bar3DSeries contiene la geometría y aspecto visual de las barras.
// - ItemModelBarDataProxy conecta un ListModel QML con el motor 3D.
//   Los roles "row", "col" y "value" mapean las columnas del modelo a los ejes.
// - GraphsTheme: personalización del tema visual. En Qt 6.8+ reemplaza a Theme3D.
// - Los ejes se configuran con propiedades inline (rowAxis.title, valueAxis.min…)
//   porque CategoryAxis3D / ValueAxis3D ya no son tipos QML en Qt 6.8+.
// - La cámara se controla con cameraPreset; el usuario puede orbitar arrastrando.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Modelo de datos: ventas trimestrales por región.
    ListModel {
        id: salesModel

        // Q1
        ListElement { quarter: "Q1"; region: "Norte"; sales: 42 }
        ListElement { quarter: "Q1"; region: "Sur";   sales: 58 }
        ListElement { quarter: "Q1"; region: "Este";  sales: 35 }
        ListElement { quarter: "Q1"; region: "Oeste"; sales: 67 }

        // Q2
        ListElement { quarter: "Q2"; region: "Norte"; sales: 75 }
        ListElement { quarter: "Q2"; region: "Sur";   sales: 48 }
        ListElement { quarter: "Q2"; region: "Este";  sales: 82 }
        ListElement { quarter: "Q2"; region: "Oeste"; sales: 55 }

        // Q3
        ListElement { quarter: "Q3"; region: "Norte"; sales: 63 }
        ListElement { quarter: "Q3"; region: "Sur";   sales: 91 }
        ListElement { quarter: "Q3"; region: "Este";  sales: 44 }
        ListElement { quarter: "Q3"; region: "Oeste"; sales: 78 }

        // Q4
        ListElement { quarter: "Q4"; region: "Norte"; sales: 88 }
        ListElement { quarter: "Q4"; region: "Sur";   sales: 72 }
        ListElement { quarter: "Q4"; region: "Este";  sales: 95 }
        ListElement { quarter: "Q4"; region: "Oeste"; sales: 60 }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(10)

        // --- Cabecera ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(2)

                Label {
                    text: "Bars 3D — Ventas por Región y Trimestre"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.mainColor
                }
                Label {
                    text: "Arrastra para orbitar · Rueda para zoom"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            Button {
                text: "Aleatorizar"
                onClicked: {
                    for (let i = 0; i < salesModel.count; i++)
                        salesModel.setProperty(i, "sales", Math.floor(Math.random() * 80 + 15))
                }
            }
        }

        // --- Gráfico 3D ---
        // Los ejes se configuran con propiedades inline (Qt 6.8+ elimina CategoryAxis3D/ValueAxis3D).
        // rowAxis.labels se extrae automáticamente del role "quarter" del proxy.
        // columnAxis.labels se extrae del role "region".
        Bars3D {
            id: bars3d
            Layout.fillWidth: true
            Layout.fillHeight: true

            cameraPreset: Graphs3D.CameraPreset.IsometricLeftHigh
            shadowQuality: Graphs3D.ShadowQuality.Low
            msaaSamples: 4

            rowAxis.title: "Trimestre"
            rowAxis.titleVisible: true

            columnAxis.title: "Región"
            columnAxis.titleVisible: true

            valueAxis.title: "Ventas (M€)"
            valueAxis.titleVisible: true
            valueAxis.min: 0
            valueAxis.max: 100
            valueAxis.segmentCount: 4
            valueAxis.subSegmentCount: 2
            valueAxis.labelFormat: "%d"

            // GraphsTheme reemplaza a Theme3D en Qt 6.8+.
            theme: GraphsTheme {
                plotAreaBackgroundVisible: false
                backgroundVisible: false
                colorScheme: GraphsTheme.ColorScheme.Dark
                theme: GraphsTheme.Theme.BlueSeries
                labelTextColor: "#cccccc"
                grid.mainColor: Qt.rgba(1, 1, 1, 0.1)
            }

            Bar3DSeries {
                id: barSeries
                baseColor: Style.mainColor
                singleHighlightColor: Qt.lighter(Style.mainColor, 1.4)
                multiHighlightColor: Qt.lighter(Style.mainColor, 1.6)

                // ItemModelBarDataProxy conecta el ListModel con Bars3D.
                dataProxy: ItemModelBarDataProxy {
                    itemModel: salesModel
                    rowRole: "quarter"
                    columnRole: "region"
                    valueRole: "sales"
                }
            }
        }

        Label {
            text: "Bar3DSeries + ItemModelBarDataProxy · 4 trimestres × 4 regiones · rowAxis / columnAxis / valueAxis"
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }
}
