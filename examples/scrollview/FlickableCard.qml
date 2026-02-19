// =============================================================================
// FlickableCard.qml — Flickable bidireccional (2D)
// =============================================================================
// Demuestra un Flickable con scroll en ambos ejes (horizontal y vertical).
// El contenido es una cuadrícula 8x8 de celdas de colores que excede el área
// visible, permitiendo al usuario arrastrar en cualquier dirección.
//
// A diferencia de ScrollView (que envuelve un Flickable), aquí usamos
// Flickable directamente con ScrollBar.vertical y ScrollBar.horizontal
// como propiedades adjuntas (attached properties).
//
// Aprendizaje clave:
// - Flickable necesita contentWidth y contentHeight explícitos para saber el
//   tamaño total del contenido y calcular los límites del scroll
// - Qt.hsla() genera colores HSL: útil para crear paletas automáticas
//   distribuyendo el hue uniformemente
// - ScrollBar.AsNeeded solo muestra la barra cuando el contenido excede el
//   área visible en ese eje
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
            text: "2D Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Scroll horizontally and vertically"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // Flickable bidireccional: tanto contentWidth como contentHeight
            // están vinculados al tamaño real del Grid, permitiendo scroll
            // en ambas direcciones cuando el Grid excede el área visible.
            Flickable {
                id: gridFlickable
                anchors.fill: parent
                contentWidth: gridContent.width
                contentHeight: gridContent.height
                clip: true

                // Grid posiciona los hijos en una cuadrícula automática.
                // A diferencia de GridLayout, Grid no participa en layouts
                // y los hijos deben tener tamaño fijo (width/height explícitos).
                Grid {
                    id: gridContent
                    columns: 8
                    spacing: Style.resize(4)
                    padding: Style.resize(8)

                    // 64 celdas (8x8) con color basado en el índice.
                    // Qt.hsla(hue, sat, light, alpha): al dividir index/64
                    // se distribuye el espectro de color uniformemente.
                    Repeater {
                        model: 64
                        Rectangle {
                            required property int index
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: Style.resize(6)
                            color: Qt.hsla(index / 64.0, 0.6, 0.4, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                font.pixelSize: Style.resize(12)
                                color: "#FFFFFF"
                            }
                        }
                    }
                }

                // Barras de scroll adjuntas: AsNeeded las muestra solo si el
                // contenido excede el viewport en ese eje.
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }
            }
        }

        // Muestra el desplazamiento actual en píxeles (contentX, contentY)
        // para que el usuario vea cómo cambian al hacer scroll.
        Label {
            text: "Offset: " + Math.round(gridFlickable.contentX) + ", " + Math.round(gridFlickable.contentY)
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
        }
    }
}
