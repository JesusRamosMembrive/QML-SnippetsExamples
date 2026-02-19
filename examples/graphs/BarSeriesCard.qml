// =============================================================================
// BarSeriesCard.qml — Gráfica de barras con QtGraphs
// =============================================================================
// Ejemplo básico de gráfica de barras usando los componentes declarativos de
// QtGraphs: GraphsView, BarSeries y BarSet.
//
// Conceptos clave:
// - BarCategoryAxis: Eje X con categorías de texto (días de la semana).
// - BarSet.replace(): Actualiza valores individuales sin recrear la serie.
// - GraphsTheme: Personalización visual del fondo y área de dibujo.
// - Qt.darker(): Función de Qt para oscurecer un color (útil para bordes).
//
// El botón "Randomize" demuestra cómo modificar datos dinámicamente usando
// BarSet.replace(index, newValue), que es más eficiente que recrear el BarSet.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Bar Series"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Botón para regenerar datos aleatorios.
        // replace(index, value) modifica un valor individual del BarSet
        // sin necesidad de destruir y recrear la serie completa.
        Button {
            text: "Randomize"
            onClicked: {
                for (let i = 0; i < 6; i++)
                    barSet.replace(i, Math.random() * 80 + 10)
            }
        }

        // Área de la gráfica: un Rectangle oscuro como fondo + GraphsView encima.
        // Este patrón de "fondo manual + tema transparente" da más control visual
        // que usar solo el tema de GraphsView.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            GraphsView {
                anchors.fill: parent
                anchors.margins: Style.resize(8)

                // Tema transparente: desactivamos el fondo de GraphsView para
                // que se vea nuestro Rectangle oscuro personalizado debajo.
                theme: GraphsTheme {
                    backgroundVisible: false
                    plotAreaBackgroundColor: "transparent"
                }

                // BarCategoryAxis usa strings como categorías en lugar de números.
                // Ideal para datos discretos como días, meses o productos.
                axisX: BarCategoryAxis {
                    categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    lineVisible: false
                    gridVisible: false
                }

                axisY: ValueAxis {
                    min: 0
                    max: 100
                    tickInterval: 25
                    lineVisible: false
                    subGridVisible: false
                }

                // BarSeries contiene uno o más BarSets. Cada BarSet es un
                // grupo de datos (una "serie" en el gráfico de barras).
                BarSeries {
                    BarSet {
                        id: barSet
                        label: "Activity"
                        values: [65, 45, 80, 55, 70, 90]
                        color: Style.mainColor
                        borderColor: Qt.darker(Style.mainColor, 1.2)
                        borderWidth: 1
                    }
                }
            }
        }

        Label {
            text: "BarSeries with BarCategoryAxis. Click Randomize to update values"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
