// =============================================================================
// CoverFlowCard.qml — Efecto CoverFlow con PathView y PathAttribute
// =============================================================================
// Reproduce el clasico efecto "CoverFlow" (popularizado por iTunes/Apple)
// donde las tarjetas se desplazan horizontalmente, con la tarjeta central
// al frente y las laterales reducidas en tamano y opacidad.
//
// Conceptos clave:
//   - PathLine: segmento de linea recta. Aqui se usan dos PathLines que
//     van de izquierda a centro y de centro a derecha, formando un
//     trazado horizontal simple.
//   - PathAttribute: interpola un valor numerico a lo largo del Path.
//     Aqui se usa para controlar "z" (profundidad). El z=10 en el centro
//     y z=1 en los extremos hace que la tarjeta central se dibuje
//     ENCIMA de las laterales (efecto de superposicion).
//   - z en el delegado: se asigna tanto con PathView.isCurrentItem como
//     con PathAttribute. La combinacion garantiza que el item activo
//     siempre este al frente.
//   - Behavior on color (ColorAnimation): la transicion de color del
//     label inferior se anima suavemente cuando cambia el item activo.
// =============================================================================
pragma ComponentBehavior: Bound

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
            text: "CoverFlow"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: coverFlow
                anchors.fill: parent

                // -- Modelo de "albums" musicales simulados con colores.
                model: ListModel {
                    id: albumModel
                    ListElement { name: "Teal Wave";     clr: "#00D1A9" }
                    ListElement { name: "Orange Sunset"; clr: "#FEA601" }
                    ListElement { name: "Blue Sky";      clr: "#4FC3F7" }
                    ListElement { name: "Red Fire";      clr: "#FF7043" }
                    ListElement { name: "Purple Night";  clr: "#AB47BC" }
                    ListElement { name: "Pink Dawn";     clr: "#EC407A" }
                    ListElement { name: "Green Forest";  clr: "#66BB6A" }
                }
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.StrictlyEnforceRange

                // -- Delegado: tarjeta de "album" con icono musical.
                //    z controla el orden de dibujo (profundidad). El item
                //    actual tiene z=10 para estar siempre al frente.
                delegate: Item {
                    id: coverDelegate
                    required property string name
                    required property string clr
                    required property int index
                    width: Style.resize(100)
                    height: Style.resize(120)
                    z: PathView.isCurrentItem ? 10 : 1
                    scale: PathView.isCurrentItem ? 1.0 : 0.7
                    opacity: PathView.isCurrentItem ? 1.0 : 0.5

                    Behavior on scale { NumberAnimation { duration: 250 } }
                    Behavior on opacity { NumberAnimation { duration: 250 } }

                    Rectangle {
                        anchors.fill: parent
                        radius: Style.resize(8)
                        color: coverDelegate.clr

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(4)

                            Label {
                                text: "\u266B"
                                font.pixelSize: Style.resize(32)
                                color: "#FFFFFF"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: coverDelegate.name
                                font.pixelSize: Style.resize(10)
                                font.bold: true
                                color: "#FFFFFF"
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                Layout.maximumWidth: Style.resize(80)
                            }
                        }
                    }
                }

                // -- Path horizontal con PathAttribute para profundidad (z).
                //    PathAttribute interpola el valor "z" a lo largo del path:
                //    z=1 al inicio -> z=10 en el centro -> z=1 al final.
                //    Esto crea el efecto de que las tarjetas laterales estan
                //    "detras" de la central, incluso aunque se solapen.
                path: Path {
                    startX: Style.resize(10)
                    startY: coverFlow.height / 2
                    PathAttribute { name: "z"; value: 1 }
                    PathLine {
                        x: coverFlow.width / 2
                        y: coverFlow.height / 2
                    }
                    PathAttribute { name: "z"; value: 10 }
                    PathLine {
                        x: coverFlow.width - Style.resize(10)
                        y: coverFlow.height / 2
                    }
                    PathAttribute { name: "z"; value: 1 }
                }

                pathItemCount: 5
            }
        }

        // -- Label que muestra el nombre del album actual. Behavior on color
        //    crea una transicion suave de color cuando el item cambia, porque
        //    cada album tiene un color diferente.
        Label {
            text: albumModel.get(coverFlow.currentIndex).name
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: albumModel.get(coverFlow.currentIndex).clr
            Layout.alignment: Qt.AlignHCenter

            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }
}
