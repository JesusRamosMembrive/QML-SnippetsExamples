// =============================================================================
// BusyIndicator.qml — Override de estilo para BusyIndicator (indicador de carga)
// =============================================================================
//
// Indicador de carga giratorio compuesto por 6 puntos dispuestos en circulo.
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.BusyIndicator con la logica (running, etc.) sin visual.
//
// ---- OPTIMIZACION visible/running ----
// visible: (opacity > 0.0) — solo visible cuando tiene opacidad.
// running: visible — solo gira cuando es visible.
// Esto ahorra CPU cuando el indicador esta oculto: si opacity es 0,
// visible se vuelve false, running se vuelve false, y la animacion se detiene.
//
// ---- RotationAnimator vs RotationAnimation ----
// RotationAnimator es un tipo especial que corre en el HILO DE RENDER
// (no en el hilo de UI). Mas eficiente para animaciones continuas.
// Solo las variantes "Animator" (RotationAnimator, OpacityAnimator, etc.)
// pueden ejecutarse en el hilo de render.
//
// ---- Repeater con model: 6 ----
// Crea 6 rectangulos (puntos) identicos. Cada uno se posiciona en circulo
// usando transformaciones.
//
// ---- transform: [Translate{}, Rotation{}] ----
// Las transformaciones se aplican en ORDEN INVERSO:
//   1. Primero Rotation: rota el punto alrededor del centro (angulo unico por index)
//   2. Luego Translate: desplaza el punto hacia afuera del centro
// Resultado: cada punto queda en angulos equidistantes sobre un circulo.
//
// ---- OpacityAnimator en el Behavior ----
// Usa OpacityAnimator (hilo de render) en vez de NumberAnimation para un
// desvanecimiento mas suave y eficiente.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.BusyIndicator {
    id: root

    implicitWidth: Style.resize(40)
    implicitHeight: Style.resize(40)
    // Optimizacion: solo visible si opacity > 0, solo gira si visible
    visible: (opacity > 0.0)
    running: visible

    contentItem: Item {
        id: contentItem
        anchors.fill: parent

        x: parent.width / 2 - Style.resize(32)
        y: parent.height / 2 - Style.resize(32)
        opacity: root.running ? 1 : 0

        // OpacityAnimator: corre en el hilo de render para suavidad
        Behavior on opacity {
            OpacityAnimator {
                duration: 250
            }
        }

        // RotationAnimator: animacion continua en el hilo de render
        // Mas eficiente que RotationAnimation para giros infinitos
        RotationAnimator {
            target: contentItem
            running: (root.visible && root.running)
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1250
        }

        // Repeater: crea 6 puntos identicos
        Repeater {
            id: repeater
            model: 6

            Rectangle {
                // Posicion base: centrado en el contenedor
                x: ((contentItem.width / 2) - (width / 2))
                y: ((contentItem.height / 2) - (height / 2))
                implicitWidth: Style.resize(10)
                implicitHeight: Style.resize(10)
                radius: Style.resize(5)
                color: Style.mainColor
                // Transformaciones: se aplican en ORDEN INVERSO
                // 1ro Rotation (rota alrededor del centro), 2do Translate (aleja del centro)
                // Resultado: puntos distribuidos en circulo a angulos iguales
                transform: [
                    Translate {
                        y: -((Math.min(contentItem.width, contentItem.height) * 0.5) + Style.resize(5))
                    },
                    Rotation {
                        angle: ((index / repeater.count) * 360)
                        origin.x: 5
                        origin.y: 5
                    }
                ]
            }
        }
    }
}
