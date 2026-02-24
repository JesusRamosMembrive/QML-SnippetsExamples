// =============================================================================
// GridViewCard.qml — Galeria de colores con GridView
// =============================================================================
// Demuestra GridView, el componente de Qt Quick para mostrar elementos en
// formato de grilla (filas y columnas). A diferencia de ListView (lineal),
// GridView organiza los delegates en una cuadricula definida por cellWidth
// y cellHeight.
//
// Conceptos clave:
//   - cellWidth/cellHeight: definen el tamanyo de cada celda de la grilla.
//     Los delegates se posicionan automaticamente dentro de esas celdas.
//   - currentIndex: indica el item seleccionado. GridView.isCurrentItem
//     dentro del delegate permite saber si ESE item es el seleccionado.
//   - ListModel: mismo modelo que se usa con ListView — GridView solo
//     cambia la disposicion visual, no la fuente de datos.
//
// Al hacer clic en un color, se actualiza currentIndex y la etiqueta
// superior muestra el nombre y hex del color seleccionado.
// =============================================================================

pragma ComponentBehavior: Bound

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
        spacing: Style.resize(10)

        Label {
            text: "GridView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            id: gridInfoLabel
            text: "Tap a color to select"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            // Modelo de colores: cada ListElement tiene nombre y valor hex.
            // Este mismo modelo podria alimentar un ListView o PathView.
            ListModel {
                id: colorModel
                ListElement { colorName: "Coral"; colorHex: "#FF6B6B" }
                ListElement { colorName: "Gold"; colorHex: "#FEA601" }
                ListElement { colorName: "Lime"; colorHex: "#A8E6CF" }
                ListElement { colorName: "Teal"; colorHex: "#00D1A9" }
                ListElement { colorName: "Sky"; colorHex: "#74B9FF" }
                ListElement { colorName: "Blue"; colorHex: "#4A90D9" }
                ListElement { colorName: "Purple"; colorHex: "#9B59B6" }
                ListElement { colorName: "Pink"; colorHex: "#FD79A8" }
                ListElement { colorName: "Orange"; colorHex: "#FF5900" }
                ListElement { colorName: "Mint"; colorHex: "#1ABC9C" }
                ListElement { colorName: "Slate"; colorHex: "#636E72" }
                ListElement { colorName: "Rose"; colorHex: "#E74C3C" }
            }

            // GridView: cellWidth y cellHeight definen el tamanyo de la celda,
            // no del delegate. El delegate puede ser mas pequenyo que la celda
            // (se centra) o mas grande (se corta si hay clip: true).
            // currentIndex: -1 significa que inicialmente no hay seleccion.
            GridView {
                id: colorGridView
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                cellWidth: Style.resize(80)
                cellHeight: Style.resize(90)
                model: colorModel
                clip: true
                currentIndex: -1

                delegate: Item {
                    id: colorDelegate

                    required property int index
                    required property string colorName
                    required property string colorHex

                    width: colorGridView.cellWidth
                    height: colorGridView.cellHeight

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)

                        Rectangle {
                            width: Style.resize(50)
                            height: Style.resize(50)
                            radius: Style.resize(8)
                            color: colorDelegate.colorHex
                            border.width: colorDelegate.GridView.isCurrentItem ? 3 : 0
                            border.color: Style.fontPrimaryColor
                            Layout.alignment: Qt.AlignHCenter

                            scale: colorDelegate.GridView.isCurrentItem ? 1.1 : 1.0
                            Behavior on scale {
                                NumberAnimation { duration: 150 }
                            }
                        }

                        Label {
                            text: colorDelegate.colorName
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            colorGridView.currentIndex = colorDelegate.index
                            gridInfoLabel.text = colorDelegate.colorName + ": " + colorDelegate.colorHex
                        }
                    }
                }
            }
        }

        Label {
            text: "GridView arranges delegates in a grid with cellWidth and cellHeight"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
