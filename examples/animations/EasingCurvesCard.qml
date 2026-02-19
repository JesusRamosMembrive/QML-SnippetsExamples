// ============================================================================
// EasingCurvesCard.qml
// Concepto: Curvas de easing — como controlar la aceleracion de animaciones.
//
// Las curvas de easing definen la velocidad de una animacion a lo largo del
// tiempo. En lugar de moverse a velocidad constante, se puede hacer que un
// objeto acelere, desacelere, rebote o se comporte elasticamente.
//
// Qt ofrece mas de 40 tipos de easing a traves de Easing.Type. Aqui se
// comparan cuatro de los mas representativos:
//   - Linear:     velocidad constante, sin aceleracion (movimiento robotico)
//   - InOutQuad:  acelera al inicio, desacelera al final (movimiento natural)
//   - OutBounce:  rebota al llegar al destino (efecto fisico)
//   - InElastic:  oscila elasticamente al arrancar (efecto de resorte)
//
// La convencion de nombres In/Out indica donde se aplica el efecto:
//   - In = al inicio de la animacion
//   - Out = al final de la animacion
//   - InOut = en ambos extremos
//
// PropertyAnimation es el tipo de animacion mas comun en QML. Anima una
// propiedad especifica de un target entre los valores 'from' y 'to'.
// ============================================================================

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
            text: "Easing Curves"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // restart() reinicia la animacion desde el principio, incluso si ya
        // estaba en ejecucion. Esto permite reproducir la comparacion repetidamente.
        Button {
            text: "Play"
            onClicked: {
                easingAnim1.restart()
                easingAnim2.restart()
                easingAnim3.restart()
                easingAnim4.restart()
            }
        }

        // Contenedor de las barras de easing
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: Style.resize(8)

                // Linear: velocidad constante. El movimiento se siente mecanico
                // y predecible. Util para barras de progreso o indicadores.
                ColumnLayout {
                    spacing: Style.resize(2)
                    Layout.fillWidth: true

                    Label {
                        text: "Linear"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(24)

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            radius: height / 2
                            color: Style.bgColor
                        }

                        Rectangle {
                            id: bar1
                            x: 0
                            width: Style.resize(24)
                            height: parent.height
                            radius: height / 2
                            color: "#4A90D9"

                            // PropertyAnimation: anima la propiedad 'x' del rectangulo.
                            // target + property definen QUE se anima.
                            // from/to definen el rango. duration es en milisegundos.
                            PropertyAnimation {
                                id: easingAnim1
                                target: bar1
                                property: "x"
                                from: 0
                                to: bar1.parent.width - bar1.width
                                duration: 1500
                                easing.type: Easing.Linear
                            }
                        }
                    }
                }

                // InOutQuad: acelera suavemente al inicio y desacelera al final.
                // Es la curva mas usada para movimientos naturales en UI.
                ColumnLayout {
                    spacing: Style.resize(2)
                    Layout.fillWidth: true

                    Label {
                        text: "InOutQuad"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(24)

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            radius: height / 2
                            color: Style.bgColor
                        }

                        Rectangle {
                            id: bar2
                            x: 0
                            width: Style.resize(24)
                            height: parent.height
                            radius: height / 2
                            color: Style.mainColor

                            PropertyAnimation {
                                id: easingAnim2
                                target: bar2
                                property: "x"
                                from: 0
                                to: bar2.parent.width - bar2.width
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                // OutBounce: rebota varias veces al llegar al destino.
                // Simula la fisica de un objeto cayendo y rebotando.
                ColumnLayout {
                    spacing: Style.resize(2)
                    Layout.fillWidth: true

                    Label {
                        text: "OutBounce"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(24)

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            radius: height / 2
                            color: Style.bgColor
                        }

                        Rectangle {
                            id: bar3
                            x: 0
                            width: Style.resize(24)
                            height: parent.height
                            radius: height / 2
                            color: "#FEA601"

                            PropertyAnimation {
                                id: easingAnim3
                                target: bar3
                                property: "x"
                                from: 0
                                to: bar3.parent.width - bar3.width
                                duration: 1500
                                easing.type: Easing.OutBounce
                            }
                        }
                    }
                }

                // InElastic: oscilacion elastica al inicio de la animacion.
                // El objeto "se estira" antes de lanzarse, como un resorte.
                ColumnLayout {
                    spacing: Style.resize(2)
                    Layout.fillWidth: true

                    Label {
                        text: "InElastic"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(24)

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            radius: height / 2
                            color: Style.bgColor
                        }

                        Rectangle {
                            id: bar4
                            x: 0
                            width: Style.resize(24)
                            height: parent.height
                            radius: height / 2
                            color: "#FF5900"

                            PropertyAnimation {
                                id: easingAnim4
                                target: bar4
                                property: "x"
                                from: 0
                                to: bar4.parent.width - bar4.width
                                duration: 1500
                                easing.type: Easing.InElastic
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: "Compare how different easing curves affect animation feel"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
