// =============================================================================
// ArcPathCard.qml — PathView con arco curvado tipo carrusel
// =============================================================================
// Demuestra un carrusel donde los elementos siguen una curva de Bezier
// cuadratica (PathQuad). El resultado es un arco suave donde el elemento
// central esta en la parte mas alta y los laterales descienden.
//
// Conceptos clave:
//   - PathQuad: curva de Bezier cuadratica definida por un punto de control.
//     El controlX/controlY determina la "altura" de la curva. Aqui el punto
//     de control esta arriba (controlY bajo) creando un arco concavo.
//   - preferredHighlightBegin/End = 0.5: fuerza al elemento actual a estar
//     exactamente en el centro del path (posicion 50%).
//   - StrictlyEnforceRange: el PathView SIEMPRE centra un elemento en la
//     posicion de highlight. Sin esto, el scroll seria libre y el usuario
//     podria dejar el carrusel entre dos elementos.
//   - incrementCurrentIndex()/decrementCurrentIndex(): navegacion programatica
//     ademas del drag natural del PathView.
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
            text: "Arc Path (Carousel)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: arcView
                anchors.fill: parent

                // -- Modelo con iconos Unicode para representar categorias
                //    de componentes de manera visual sin necesidad de imagenes.
                model: ListModel {
                    ListElement { title: "Buttons"; icon: "\u25A3"; clr: "#00D1A9" }
                    ListElement { title: "Sliders"; icon: "\u2501"; clr: "#FEA601" }
                    ListElement { title: "Popups"; icon: "\u25A1"; clr: "#4FC3F7" }
                    ListElement { title: "Canvas"; icon: "\u25CB"; clr: "#FF7043" }
                    ListElement { title: "Graphs"; icon: "\u2587"; clr: "#AB47BC" }
                    ListElement { title: "Shapes"; icon: "\u25C6"; clr: "#EC407A" }
                }

                // -- Configuracion de highlight: el elemento actual siempre
                //    se posiciona en el punto 0.5 (centro) del path.
                //    StrictlyEnforceRange evita que el scroll deje el
                //    carrusel en una posicion intermedia.
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.StrictlyEnforceRange

                // -- Delegado: tarjeta rectangular con icono y titulo.
                //    La escala y opacidad reducidas en elementos no-actuales
                //    crean una sensacion de profundidad (efecto carrusel).
                delegate: Rectangle {
                    id: arcDelegate
                    required property string title
                    required property string icon
                    required property string clr
                    required property int index
                    width: Style.resize(90)
                    height: Style.resize(100)
                    radius: Style.resize(8)
                    color: Style.surfaceColor
                    opacity: PathView.isCurrentItem ? 1.0 : 0.5
                    scale: PathView.isCurrentItem ? 1.1 : 0.75

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200 } }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(6)

                        Label {
                            text: arcDelegate.icon
                            font.pixelSize: Style.resize(28)
                            color: arcDelegate.clr
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: arcDelegate.title
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // -- PathQuad: curva de Bezier cuadratica. Va de (0, 60%) a
                //    (width, 60%) con el punto de control en el centro-arriba.
                //    Esto crea el arco convexo del carrusel. Cuanto mas bajo
                //    sea controlY, mas pronunciada es la curva.
                path: Path {
                    startX: 0
                    startY: arcView.height * 0.6
                    PathQuad {
                        x: arcView.width
                        y: arcView.height * 0.6
                        controlX: arcView.width / 2
                        controlY: Style.resize(20)
                    }
                }

                pathItemCount: 5
            }
        }

        // -- Navegacion manual con botones: complementa el drag natural.
        //    decrementCurrentIndex/incrementCurrentIndex animan la transicion
        //    suavemente gracias al highlightMoveDuration interno de PathView.
        RowLayout {
            Layout.fillWidth: true

            Button { text: "\u25C0"; onClicked: arcView.decrementCurrentIndex() }
            Item { Layout.fillWidth: true }
            Label {
                text: arcView.model.get(arcView.currentIndex).title
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: Style.mainColor
            }
            Item { Layout.fillWidth: true }
            Button { text: "\u25B6"; onClicked: arcView.incrementCurrentIndex() }
        }
    }
}
