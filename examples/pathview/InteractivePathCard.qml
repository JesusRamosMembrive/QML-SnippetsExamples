// =============================================================================
// InteractivePathCard.qml — PathView con parametros configurables en vivo
// =============================================================================
// Demuestra como los parametros de un Path se pueden vincular a controles
// de la UI (Sliders) para que el usuario modifique la forma del trazado
// en tiempo real. Esto enseña la reactividad de QML: al cambiar una
// propiedad que usa el Path, PathView redistribuye automaticamente los
// delegados sin codigo imperativo.
//
// Conceptos clave:
//   - Propiedades custom (itemCount, pathHeight): expuestas en el root
//     del componente para ser controladas por Sliders.
//   - model: itemCount: cuando el modelo es un entero, PathView genera
//     delegados numerados de 0 a N-1. Es la forma mas simple de modelo.
//   - Qt.hsla(): genera colores HSL programaticamente. Dividiendo el index
//     por el total de items se distribuyen colores uniformemente en el
//     espectro, creando un arcoiris automatico.
//   - pathItemCount: Math.min(itemCount, 7) limita los delegados visibles
//     para evitar solapamiento cuando hay muchos elementos.
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

    // -- Propiedades configurables externamente. Al estar en el root,
    //    los Sliders pueden hacer binding bidireccional con ellas.
    property int itemCount: 6
    property real pathHeight: 0.4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Configurable Path"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: configView
                anchors.fill: parent

                // -- Modelo entero: la forma mas simple. PathView crea
                //    delegados con index de 0 a itemCount-1.
                model: root.itemCount
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.StrictlyEnforceRange

                delegate: Rectangle {
                    required property int index
                    width: Style.resize(50)
                    height: Style.resize(50)
                    radius: Style.resize(25)

                    // -- Qt.hsla() distribuye colores uniformemente en el
                    //    espectro. El hue (0-1) se divide por el total para
                    //    que cada circulo tenga un color distinto.
                    color: Qt.hsla(index / root.itemCount, 0.7, 0.5, 1.0)
                    scale: PathView.isCurrentItem ? 1.3 : 0.8
                    opacity: PathView.isCurrentItem ? 1.0 : 0.6

                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    Label {
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                // -- PathQuad cuya curvatura depende de pathHeight. Cuando
                //    pathHeight = 0, la curva es plana (linea recta).
                //    Cuando pathHeight = 1, el punto de control esta en y=0
                //    creando el arco maximo.
                path: Path {
                    startX: Style.resize(20)
                    startY: configView.height / 2
                    PathQuad {
                        x: configView.width - Style.resize(20)
                        y: configView.height / 2
                        controlX: configView.width / 2
                        controlY: configView.height * (1.0 - root.pathHeight)
                    }
                }

                // -- Limitar delegados visibles para evitar solapamiento.
                pathItemCount: Math.min(root.itemCount, 7)
            }
        }

        // -- Panel de controles: Sliders vinculados a las propiedades
        //    del root. Al mover un Slider, pathHeight o itemCount cambian,
        //    QML re-evalua los bindings del Path y PathView redistribuye
        //    los delegados automaticamente (reactividad declarativa).
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Items: " + root.itemCount; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(70) }
                Slider {
                    Layout.fillWidth: true
                    from: 3; to: 12; value: root.itemCount; stepSize: 1
                    onMoved: root.itemCount = value
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Curve: " + (root.pathHeight * 100).toFixed(0) + "%"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(70) }
                Slider {
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: root.pathHeight
                    onMoved: root.pathHeight = value
                }
            }
        }
    }
}
