// =============================================================================
// InteractiveFlickableCard.qml — Laboratorio de propiedades de Flickable
// =============================================================================
// Permite experimentar en tiempo real con tres propiedades fundamentales de
// Flickable: boundsBehavior, maximumFlickVelocity y flickDeceleration.
// El objetivo es que el aprendiz "sienta" el efecto de cada parametro
// al interactuar con el tablero de ajedrez arrastrandolo.
//
// Conceptos clave para el aprendiz:
//   - boundsBehavior controla que pasa al llegar al borde del contenido:
//       * StopAtBounds: se detiene inmediatamente (lo mas comun)
//       * DragOverBounds: permite arrastrar un poco mas alla, con rebote
//       * OvershootBounds: la inercia del flick puede sobrepasar el borde
//   - maximumFlickVelocity: tope maximo de velocidad del flick (px/s).
//     Valores altos hacen el scroll muy rapido e impreciso.
//   - flickDeceleration: que tan rapido frena el scroll despues de soltar.
//     Valores bajos = scroll largo y suave; altos = frenado brusco.
//   - Indicadores duales (vertical + horizontal): el contenido es mas grande
//     que el viewport en ambos ejes, asi que se necesitan dos scrollbars.
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
        spacing: Style.resize(12)

        Label {
            text: "Interactive Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // ---------------------------------------------------------------
            // Flickable bidireccional: el contenido (500x500) es mayor que
            // el viewport en ambos ejes. Las propiedades se enlazan
            // directamente a los controles de abajo para experimentacion
            // interactiva. Nota el uso de ternarios encadenados para mapear
            // el indice del ComboBox al enum correspondiente.
            // ---------------------------------------------------------------
            Flickable {
                id: interFlick
                anchors.fill: parent
                contentWidth: interContent.width
                contentHeight: interContent.height
                boundsBehavior: boundsCombo.currentIndex === 0 ? Flickable.StopAtBounds
                              : boundsCombo.currentIndex === 1 ? Flickable.DragOverBounds
                              : Flickable.OvershootBounds
                maximumFlickVelocity: velocitySlider.value
                flickDeceleration: decelSlider.value

                Rectangle {
                    id: interContent
                    width: Style.resize(500)
                    height: Style.resize(500)
                    color: Style.surfaceColor
                    radius: Style.resize(8)

                    // Tablero de ajedrez 8x8 con colores HSL. La alternancia
                    // de saturacion/luminosidad entre celdas pares e impares
                    // crea el patron del tablero, mientras que el hue varia
                    // con el index para agregar interes visual.
                    Grid {
                        anchors.fill: parent
                        anchors.margins: Style.resize(10)
                        columns: 8
                        rows: 8
                        spacing: Style.resize(2)

                        Repeater {
                            model: 64

                            Rectangle {
                                required property int index
                                width: (interContent.width - Style.resize(20) - 7 * Style.resize(2)) / 8
                                height: width
                                radius: Style.resize(3)
                                color: {
                                    var row = Math.floor(index / 8)
                                    var col = index % 8
                                    if ((row + col) % 2 === 0)
                                        return Qt.hsla(index / 64.0, 0.5, 0.35, 1.0)
                                    else
                                        return Qt.hsla(index / 64.0, 0.3, 0.25, 1.0)
                                }

                                Label {
                                    anchors.centerIn: parent
                                    text: (index + 1).toString()
                                    font.pixelSize: Style.resize(9)
                                    color: "#FFFFFF"
                                    opacity: 0.7
                                }
                            }
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // Indicadores de scroll duales: uno vertical (derecha) y uno
            // horizontal (abajo). Usan movingVertically/movingHorizontally
            // para mayor precision — estas propiedades solo son true cuando
            // hay movimiento en el eje correspondiente, a diferencia de
            // "moving" que es true para cualquier eje.
            // ---------------------------------------------------------------
            Rectangle {
                anchors.right: parent.right
                y: interFlick.visibleArea.yPosition * parent.height
                width: Style.resize(3)
                height: interFlick.visibleArea.heightRatio * parent.height
                radius: Style.resize(1.5)
                color: Style.mainColor
                opacity: interFlick.movingVertically ? 0.8 : 0.2
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
            Rectangle {
                anchors.bottom: parent.bottom
                x: interFlick.visibleArea.xPosition * parent.width
                width: interFlick.visibleArea.widthRatio * parent.width
                height: Style.resize(3)
                radius: Style.resize(1.5)
                color: Style.mainColor
                opacity: interFlick.movingHorizontally ? 0.8 : 0.2
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        // -------------------------------------------------------------------
        // Panel de controles: cada propiedad del Flickable se puede ajustar
        // en tiempo real. El ComboBox para boundsBehavior y los Sliders para
        // velocity/deceleration estan enlazados directamente al Flickable.
        // -------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Bounds:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(60)
                }
                ComboBox {
                    id: boundsCombo
                    Layout.fillWidth: true
                    model: ["StopAtBounds", "DragOverBounds", "OvershootBounds"]
                    currentIndex: 0
                    font.pixelSize: Style.resize(11)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Velocity: " + velocitySlider.value.toFixed(0)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    id: velocitySlider
                    Layout.fillWidth: true
                    from: 500; to: 5000; value: 2500
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Decel: " + decelSlider.value.toFixed(0)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    id: decelSlider
                    Layout.fillWidth: true
                    from: 500; to: 5000; value: 1500
                }
            }
        }
    }
}
