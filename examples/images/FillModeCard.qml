// =============================================================================
// FillModeCard.qml — Demostración de los 7 modos de relleno de Image
// =============================================================================
// Image.fillMode determina como se ajusta la imagen dentro de su contenedor.
// Este ejemplo permite cambiar entre los 7 modos disponibles en tiempo real
// usando un ComboBox, para que el usuario vea visualmente la diferencia entre
// Stretch, PreserveAspectFit, PreserveAspectCrop, Tile, etc.
//
// Patron aprendido: usar un array de objetos JS como modelo para mapear
// nombres legibles a valores enum de QML (Image.Stretch, Image.Tile, etc.).
// Esto evita un largo bloque if/else y mantiene la logica declarativa.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedMode: 0

    // -------------------------------------------------------------------------
    // Array de modos: cada entrada mapea un nombre descriptivo al enum real
    // de Image.FillMode. Esto permite iterar sobre ellos en el ComboBox
    // y acceder al modo activo con root.modes[root.selectedMode].mode.
    // -------------------------------------------------------------------------
    readonly property var modes: [
        { name: "Stretch",           mode: Image.Stretch },
        { name: "PreserveAspectFit", mode: Image.PreserveAspectFit },
        { name: "PreserveAspectCrop", mode: Image.PreserveAspectCrop },
        { name: "Tile",             mode: Image.Tile },
        { name: "TileVertically",   mode: Image.TileVertically },
        { name: "TileHorizontally", mode: Image.TileHorizontally },
        { name: "Pad",              mode: Image.Pad }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Image FillMode"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Area de previsualizacion de la imagen.
        // clip: true es esencial aqui porque ciertos modos (Tile, Pad)
        // pueden hacer que la imagen exceda los limites del contenedor.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Style.surfaceColor
                radius: Style.resize(8)
                border.color: "#3A3D45"
                border.width: 1

                // sourceSize limita el tamano del SVG decodificado en memoria.
                // Sin esto, un SVG se renderizaria al tamano del contenedor,
                // lo cual anula el efecto de Tile y Pad.
                Image {
                    anchors.fill: parent
                    anchors.margins: Style.resize(4)
                    source: "qrc:/assets/images/Qt_logo_2016.svg"
                    fillMode: root.modes[root.selectedMode].mode
                    sourceSize.width: Style.resize(100)
                    sourceSize.height: Style.resize(100)
                }
            }
        }

        // Selector de FillMode: el model se genera con .map() para extraer
        // solo los nombres del array de objetos.
        ComboBox {
            Layout.fillWidth: true
            model: root.modes.map(function(m) { return m.name })
            currentIndex: root.selectedMode
            onCurrentIndexChanged: root.selectedMode = currentIndex
            font.pixelSize: Style.resize(12)
        }

        // Etiqueta informativa que muestra el nombre completo del enum activo
        Label {
            text: "Image.FillMode." + root.modes[root.selectedMode].name
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
