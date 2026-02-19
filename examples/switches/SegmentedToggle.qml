// =============================================================================
// SegmentedToggle.qml — Selector segmentado tipo iOS / Material Tabs
// =============================================================================
// Implementa un control segmentado donde un grupo de opciones mutuamente
// excluyentes se presenta en una barra horizontal, con un indicador visual
// que resalta el segmento seleccionado.
//
// Diferencia con RadioButton: aqui la seleccion es visual — un rectangulo
// coloreado se mueve al segmento activo con ColorAnimation. No se usa
// ButtonGroup; en su lugar, un entero 'selectedSegment' identifica la
// opcion activa y cada segmento compara su idx con ese valor.
//
// Patron clave — Repeater con RowLayout + Layout.fillWidth:
// Al usar fillWidth en cada delegate del Repeater, los segmentos se
// distribuyen equitativamente en el espacio disponible, sin importar
// cuantos haya. Esto crea un control que se adapta al contenido.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Segmented Toggle"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: segmentedItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(50)

        // selectedSegment: indice del segmento activo. Cada segmento
        // del Repeater compara su modelData.idx con este valor para
        // decidir si mostrarse coloreado o transparente.
        property int selectedSegment: 1

        Rectangle {
            anchors.centerIn: parent
            width: Style.resize(400)
            height: Style.resize(42)
            radius: Style.resize(8)
            color: Style.surfaceColor
            border.color: "#3A3D45"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(3)
                spacing: Style.resize(3)

                Repeater {
                    model: [
                        { text: "\u2600  Light",   idx: 0 },
                        { text: "\uD83C\uDF19  Dark",    idx: 1 },
                        { text: "\u2699  System",  idx: 2 }
                    ]

                    Rectangle {
                        id: segItem
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: segmentedItem.selectedSegment === modelData.idx
                               ? Style.mainColor : "transparent"

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Label {
                            anchors.centerIn: parent
                            text: segItem.modelData.text
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: segmentedItem.selectedSegment === segItem.modelData.idx
                                   ? "#1A1D23" : Style.fontSecondaryColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: segmentedItem.selectedSegment = segItem.modelData.idx
                        }
                    }
                }
            }
        }
    }
}
