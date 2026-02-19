// =============================================================================
// BasicTableCard.qml — TableView basico con modelo 100% QML (sin C++)
// =============================================================================
// Demuestra que TableView de Qt 6 puede funcionar con un TableModel
// declarativo (Qt.labs.qmlmodels) sin necesidad de escribir C++. Ideal para
// prototipos rapidos o tablas con datos estaticos.
//
// Componentes usados:
//   - TableModel (Qt.labs.qmlmodels): modelo tabular declarativo. Se definen
//     columnas con TableModelColumn { display: "key" } y filas como array
//     de objetos JS en la propiedad "rows".
//   - HorizontalHeaderView: cabecera sincronizada con el TableView via
//     syncView. Se mueve horizontalmente en sincronía con el scroll de la tabla.
//   - TableView: el componente central de Qt 6 para datos tabulares. Solo
//     crea delegates para las celdas visibles (virtualizacion), haciendolo
//     eficiente incluso con miles de filas.
//   - ItemSelectionModel: modelo de seleccion que permite seleccionar filas.
//     selectionBehavior: TableView.SelectRows activa seleccion por fila completa.
//
// Patrones clave:
//   - columnWidthProvider: funcion JS que retorna el ancho de cada columna.
//     Es mas flexible que un ancho fijo porque permite anchos diferentes por
//     columna y se puede hacer responsivo.
//   - Alternancia de colores: row % 2 === 0 alterna entre dos colores de
//     fondo para mejorar la legibilidad (patron "zebra striping").
//   - selected property en delegate: propiedad inyectada por TableView cuando
//     se configura selectionModel. Cambia el color de la fila seleccionada.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
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
            text: "Basic Table (QML-only)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Uses Qt.labs.qmlmodels TableModel — zero C++ required"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TableModel {
                id: basicModel
                TableModelColumn { display: "name" }
                TableModelColumn { display: "language" }
                TableModelColumn { display: "year" }
                TableModelColumn { display: "type" }

                rows: [
                    { name: "Qt",        language: "C++",        year: "1995", type: "Framework" },
                    { name: "React",     language: "JavaScript", year: "2013", type: "Library" },
                    { name: "Angular",   language: "TypeScript", year: "2016", type: "Framework" },
                    { name: "Vue",       language: "JavaScript", year: "2014", type: "Framework" },
                    { name: "Flutter",   language: "Dart",       year: "2017", type: "SDK" },
                    { name: "SwiftUI",   language: "Swift",      year: "2019", type: "Framework" },
                    { name: "Compose",   language: "Kotlin",     year: "2021", type: "Toolkit" },
                    { name: "Svelte",    language: "JavaScript", year: "2016", type: "Compiler" },
                    { name: "WPF",       language: "C#",         year: "2006", type: "Framework" },
                    { name: "GTK",       language: "C",          year: "1998", type: "Toolkit" }
                ]
            }

            HorizontalHeaderView {
                id: basicHeader
                anchors.top: parent.top
                anchors.left: basicTable.left
                anchors.right: basicTable.right
                syncView: basicTable
                clip: true

                delegate: Rectangle {
                    implicitWidth: Style.resize(150)
                    implicitHeight: Style.resize(32)
                    color: Style.bgColor

                    Label {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(10)
                        verticalAlignment: Text.AlignVCenter
                        text: model.display
                        color: Style.mainColor
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#3A3D45"
                    }
                }
            }

            TableView {
                id: basicTable
                anchors.top: basicHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: basicModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows

                selectionModel: ItemSelectionModel {
                    id: basicSelModel
                    model: basicModel
                }

                columnWidthProvider: function(col) {
                    var widths = [160, 160, 100, 140]
                    return Style.resize(widths[col] || 120)
                }

                delegate: Rectangle {
                    required property bool selected
                    required property bool current
                    implicitWidth: Style.resize(120)
                    implicitHeight: Style.resize(34)
                    color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                         : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                    Label {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(10)
                        verticalAlignment: Text.AlignVCenter
                        text: model.display
                        color: selected ? Style.mainColor : Style.fontPrimaryColor
                        font.pixelSize: Style.resize(12)
                    }
                }
            }
        }

        Label {
            text: "TableModel + HorizontalHeaderView + row selection + alternating colors"
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
