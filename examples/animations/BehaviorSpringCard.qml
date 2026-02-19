// =============================================================================
// BehaviorSpringCard.qml — Demostrar Behavior y SpringAnimation interactiva
// =============================================================================
// Behavior es un tipo especial de QML que "intercepta" cambios en una propiedad
// y los anima automaticamente. En vez de definir una animacion standalone con
// target/property, simplemente envuelves la propiedad con Behavior on X { ... }
// y cualquier cambio en X se animara con la animacion que especifiques.
//
// SpringAnimation simula un resorte fisico con dos parametros clave:
//   - spring (rigidez): que tan fuerte "jala" hacia el destino. Valores altos
//     hacen el movimiento mas rapido y agresivo.
//   - damping (amortiguacion): que tan rapido se detiene la oscilacion. Valores
//     bajos causan mas rebotes; valores altos frenan rapidamente.
//
// La combinacion Behavior + SpringAnimation es ideal para UIs reactivas: el
// usuario mueve algo (click, drag) y el elemento "sigue" con fisica de resorte,
// sin necesidad de calcular trayectorias manualmente.
//
// Los Sliders permiten experimentar en tiempo real con los parametros del
// resorte, lo cual ayuda a entender intuitivamente como spring y damping
// afectan el movimiento.
// =============================================================================
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
            text: "Behavior & Spring"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Controles para ajustar los parametros del resorte en tiempo real.
        // Los valores del Slider se leen directamente en SpringAnimation,
        // aprovechando el sistema de bindings reactivos de QML.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Spring: " + springSlider.value.toFixed(1)
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: springSlider
                    anchors.fill: parent
                    from: 0.5
                    to: 5.0
                    value: 2.0
                    stepSize: 0.1
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Damping: " + dampingSlider.value.toFixed(2)
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: dampingSlider
                    anchors.fill: parent
                    from: 0.02
                    to: 0.4
                    value: 0.1
                    stepSize: 0.01
                }
            }
        }

        // Area de interaccion: al hacer clic, se actualiza la posicion x/y
        // de la bola. Behavior intercepta ese cambio y aplica SpringAnimation
        // automaticamente — no hace falta llamar start() ni restart().
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: springArea
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(8)
                border.color: Style.inactiveColor
                border.width: 1

                Label {
                    anchors.centerIn: parent
                    text: "Click anywhere"
                    font.pixelSize: Style.resize(13)
                    color: Style.inactiveColor
                    opacity: 0.5
                }

                // La bola tiene Behavior on x e y: cualquier asignacion directa
                // a x o y se convierte en una animacion de resorte. Esto demuestra
                // que Behavior funciona con CUALQUIER cambio de propiedad, ya sea
                // desde codigo (onClicked), desde bindings, o desde otros origenes.
                Rectangle {
                    id: springBall
                    x: springArea.width / 2 - width / 2
                    y: springArea.height / 2 - height / 2
                    width: Style.resize(30)
                    height: Style.resize(30)
                    radius: width / 2
                    color: Style.mainColor

                    Behavior on x {
                        SpringAnimation {
                            spring: springSlider.value
                            damping: dampingSlider.value
                        }
                    }

                    Behavior on y {
                        SpringAnimation {
                            spring: springSlider.value
                            damping: dampingSlider.value
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) {
                        springBall.x = mouse.x - springBall.width / 2
                        springBall.y = mouse.y - springBall.height / 2
                    }
                }
            }
        }

        Label {
            text: "Click to move. Adjust spring (stiffness) and damping (settling speed)"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
