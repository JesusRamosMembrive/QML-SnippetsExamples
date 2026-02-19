// =============================================================================
// BasicGridCard.qml — GridView básico con selección y highlight
// =============================================================================
// Demuestra las propiedades fundamentales de GridView:
// - cellWidth / cellHeight: tamaño fijo de cada celda
// - model: puede ser un número entero (genera 0..N-1 automáticamente)
// - highlight: componente visual que se dibuja detrás del item seleccionado
// - highlightFollowsCurrentItem: el highlight se mueve automáticamente
// - currentIndex: índice del item seleccionado
//
// El color de cada celda se genera con Qt.hsla() distribuyendo el hue
// uniformemente (index / 24.0), creando un arcoíris de colores sin
// necesidad de definir colores manualmente para cada celda.
//
// Behavior on scale en el delegate da un efecto de "zoom" sutil al
// seleccionar, proporcionando feedback visual inmediato al usuario.
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
            text: "Basic GridView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Click cells to select"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: gridView
                anchors.fill: parent
                clip: true
                cellWidth: Style.resize(70)
                cellHeight: Style.resize(70)
                // modelo entero: GridView genera automáticamente
                // items con index 0, 1, 2, ..., 23
                model: 24

                // ---- Highlight ----
                // Componente que se dibuja DETRÁS del item seleccionado.
                // highlightFollowsCurrentItem hace que el highlight se
                // mueva suavemente al cambiar currentIndex. Es un patrón
                // nativo de GridView/ListView — no requiere lógica manual.
                highlight: Rectangle {
                    color: Style.mainColor
                    opacity: 0.3
                    radius: Style.resize(6)
                }
                highlightFollowsCurrentItem: true

                // ---- Delegate ----
                // Cada celda tiene tamaño exacto cellWidth×cellHeight.
                // El Item exterior actúa como "slot" del grid, y el Rectangle
                // interior tiene margins para crear separación visual entre celdas.
                delegate: Item {
                    id: gridDelegate
                    required property int index
                    width: gridView.cellWidth
                    height: gridView.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(6)
                        color: Qt.hsla(gridDelegate.index / 24.0, 0.6, 0.45, 1.0)
                        scale: gridView.currentIndex === gridDelegate.index ? 1.05 : 1.0

                        Behavior on scale { NumberAnimation { duration: 150 } }

                        Label {
                            anchors.centerIn: parent
                            text: (gridDelegate.index + 1).toString()
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: gridView.currentIndex = gridDelegate.index
                        }
                    }
                }
            }
        }

        Label {
            text: "Selected: cell " + (gridView.currentIndex + 1)
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
