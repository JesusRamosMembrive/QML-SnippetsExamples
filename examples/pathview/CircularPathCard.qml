// =============================================================================
// CircularPathCard.qml — PathView con trazado circular (elipse completa)
// =============================================================================
// Demuestra como crear un PathView circular usando dos PathArc que juntos
// forman una elipse completa. Los delegados (circulos con texto) se
// distribuyen uniformemente a lo largo de la elipse.
//
// Conceptos clave:
//   - PathArc: segmento de arco eliptico. Se necesitan DOS arcos para
//     formar un circulo completo porque un solo PathArc no puede cubrir
//     360 grados (limitacion del formato SVG arc que Qt usa internamente).
//   - PathView.isCurrentItem: propiedad attached que indica si un
//     delegado es el elemento actualmente seleccionado. Se usa para
//     destacarlo con mayor opacidad y escala.
//   - pathItemCount: cuantos delegados se muestran simultaneamente.
//     Los demas existen en el modelo pero no se renderizan (optimizacion).
//
// El usuario puede arrastrar (drag) para rotar los elementos por la
// elipse. PathView maneja el gesto internamente sin codigo adicional.
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
            text: "Circular PathView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Drag to rotate the circle"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // -- Contenedor del PathView. Se usa un Item intermedio porque
        //    PathView necesita un padre con dimensiones definidas (fillWidth/
        //    fillHeight) para calcular las coordenadas del Path correctamente.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: circularView
                anchors.fill: parent

                // -- ListModel inline con las tecnologias del stack Qt.
                //    Cada elemento tiene un label (texto) y clr (color).
                model: ListModel {
                    ListElement { label: "Qt"; clr: "#41CD52" }
                    ListElement { label: "C++"; clr: "#00599C" }
                    ListElement { label: "QML"; clr: "#00D1A9" }
                    ListElement { label: "JS"; clr: "#F7DF1E" }
                    ListElement { label: "CMake"; clr: "#064F8C" }
                    ListElement { label: "SQL"; clr: "#FF7043" }
                    ListElement { label: "Git"; clr: "#F05032" }
                    ListElement { label: "CSS"; clr: "#264DE4" }
                }

                // -- Delegado: cada circulo de color con el nombre de la tecnologia.
                //    "required property" es el patron moderno (Qt 6) para acceder
                //    a roles del modelo — reemplaza al antiguo model.label/model.clr.
                delegate: Rectangle {
                    id: circDelegate
                    required property string label
                    required property string clr
                    required property int index
                    width: Style.resize(60)
                    height: Style.resize(60)
                    radius: Style.resize(30)
                    color: clr

                    // -- PathView.isCurrentItem es una propiedad "attached" que
                    //    PathView inyecta en cada delegado. El elemento actual
                    //    se destaca con opacidad completa y escala mayor.
                    opacity: PathView.isCurrentItem ? 1.0 : 0.6
                    scale: PathView.isCurrentItem ? 1.2 : 0.85

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200 } }

                    Label {
                        anchors.centerIn: parent
                        text: circDelegate.label
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                // -- Path circular: dos PathArc clockwise que van del punto
                //    superior al inferior y de vuelta. Juntos forman una
                //    elipse completa. radiusX/radiusY definen la forma
                //    (si son iguales es un circulo; si difieren, una elipse).
                path: Path {
                    startX: circularView.width / 2
                    startY: Style.resize(30)
                    PathArc {
                        x: circularView.width / 2
                        y: circularView.height - Style.resize(30)
                        radiusX: circularView.width / 2 - Style.resize(40)
                        radiusY: circularView.height / 2 - Style.resize(30)
                        direction: PathArc.Clockwise
                    }
                    PathArc {
                        x: circularView.width / 2
                        y: Style.resize(30)
                        radiusX: circularView.width / 2 - Style.resize(40)
                        radiusY: circularView.height / 2 - Style.resize(30)
                        direction: PathArc.Clockwise
                    }
                }

                // -- Mostrar los 8 elementos del modelo simultaneamente.
                pathItemCount: 8
            }
        }

        // -- Indicador del elemento seleccionado. model.get() accede
        //    directamente al ListModel por indice para obtener el label.
        Label {
            text: "Current: " + circularView.model.get(circularView.currentIndex).label
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
