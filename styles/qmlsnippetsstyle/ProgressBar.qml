// =============================================================================
// ProgressBar.qml - Override de estilo para ProgressBar
// =============================================================================
//
// ProgressBar tiene DOS modos de funcionamiento:
//   1. DETERMINADO: progreso conocido (0.0 a 1.0). La barra crece de izquierda
//      a derecha segun la propiedad "position".
//   2. INDETERMINADO: progreso desconocido. Una barra mas pequeña se mueve
//      de un lado a otro en bucle infinito (efecto "rebote").
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de ProgressBar. Importar Controls causaria recursion infinita.
//   Templates provee solo la logica (valor, rango, indeterminate) sin visual.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - background: la pista de fondo (track completo)
//   - contentItem: la barra de relleno que indica el progreso
//
// position:
//   Valor normalizado entre 0.0 y 1.0 (similar a Slider.visualPosition).
//   Independiente del rango from/to del ProgressBar.
//
// clip: true en contentItem:
//   ESENCIAL para que el rectangulo de relleno no se dibuje fuera de los
//   limites durante la animacion indeterminada (cuando se mueve fuera de vista).
//
// Behavior on width con "enabled: !root.indeterminate":
//   Solo anima cambios de ancho en modo determinado (transiciones suaves al
//   actualizar el progreso). En modo indeterminado, el ancho es fijo y la
//   SequentialAnimation controla el movimiento directamente via "x".
//
// ANIMACION INDETERMINADA:
//   SequentialAnimation mueve el rectangulo desde fuera del borde izquierdo
//   (x = -ancho) hasta fuera del borde derecho (x = ancho total).
//   Easing.InOutQuad hace que acelere al inicio y desacelere al final,
//   creando un movimiento mas natural que el lineal.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.ProgressBar {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(8)

    // SLOT background: pista completa de fondo
    background: Rectangle {
        width: root.width
        height: root.height
        radius: height / 2
        color: Style.bgColor
    }

    // SLOT contentItem: barra de relleno (progreso visible)
    // clip: true impide que el relleno se dibuje fuera de los limites
    contentItem: Item {
        clip: true

        Rectangle {
            id: fillRect
            // Modo determinado: ancho = position (0.0-1.0) * ancho total
            // Modo indeterminado: ancho fijo del 30% (se mueve via "x")
            width: root.indeterminate ? parent.width * 0.3 : parent.width * root.position
            height: parent.height
            radius: height / 2
            color: Style.mainColor

            // Solo anima cambios de ancho en modo determinado.
            // En indeterminado, la SequentialAnimation controla "x" directamente.
            Behavior on width {
                enabled: !root.indeterminate
                NumberAnimation { duration: 150 }
            }
        }

        // Animacion indeterminada: mueve fillRect de izquierda a derecha en bucle
        // from: -fillRect.width (fuera por la izquierda)
        // to: root.width (fuera por la derecha)
        SequentialAnimation {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite

            NumberAnimation {
                target: fillRect
                property: "x"
                from: -fillRect.width
                to: root.width
                duration: 1200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
