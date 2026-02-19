// =============================================================================
// RangeSlider.qml - Override de estilo para RangeSlider
// =============================================================================
//
// RangeSlider permite seleccionar un RANGO con dos handles (inicio y fin).
// A diferencia de Slider que tiene un solo handle, este tiene dos sub-objetos:
//   - root.first  (handle inferior / izquierdo)
//   - root.second (handle superior / derecho)
// Cada uno tiene su propio visualPosition, pressed, hovered, etc.
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de RangeSlider. Importar Controls causaria recursion infinita
//   al intentar cargar el estilo dentro del propio estilo.
//   Templates provee solo la logica base sin apariencia visual.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - background: la pista con el relleno entre los dos handles
//   - first.handle: el handle del valor inferior
//   - second.handle: el handle del valor superior
//
// RECTANGULO DE RELLENO (fill):
//   Se posiciona en first.visualPosition y su ancho es la DIFERENCIA entre
//   las dos posiciones: (second.visualPosition - first.visualPosition).
//   Esto crea la zona coloreada entre ambos handles que representa el rango
//   seleccionado.
//
// Qt.lighter EN PRESSED:
//   Cuando el usuario arrastra un handle (pressed=true), el color se aclara
//   con Qt.lighter(color, 1.3) = 30% mas claro. Esto da feedback visual
//   inmediato de cual handle esta siendo manipulado.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.RangeSlider {
    id: root

    implicitWidth: root.orientation === Qt.Horizontal ? Style.resize(270) : Style.resize(20)
    implicitHeight: root.orientation === Qt.Horizontal ? Style.resize(20) : Style.resize(270)

    // SLOT background: pista (track) con relleno de rango
    background: Rectangle {
        // Pista exterior: color inactivo, 1/4 del grosor
        width: root.orientation === Qt.Horizontal ? parent.width : (parent.width / 4)
        height: root.orientation === Qt.Horizontal ? (parent.height / 4) : parent.height
        anchors.verticalCenter: root.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.orientation === Qt.Vertical ? parent.horizontalCenter : undefined
        radius: Style.resize(20)
        color: Style.inactiveColor

        // Relleno del rango: posicionado en first, ancho = second - first
        // Esto colorea solo la zona entre los dos handles
        Rectangle {
            x: root.orientation === Qt.Horizontal ? (root.first.visualPosition * parent.width) : 0
            y: root.orientation === Qt.Vertical ? (root.first.visualPosition * parent.height) : 0
            width: root.orientation === Qt.Horizontal
                   ? ((root.second.visualPosition - root.first.visualPosition) * parent.width)
                   : parent.width
            height: root.orientation === Qt.Vertical
                    ? ((root.second.visualPosition - root.first.visualPosition) * parent.height)
                    : parent.height
            color: Style.mainColor
            radius: Style.resize(20)
        }
    }

    // SLOT first.handle: handle del valor inferior
    // Qt.lighter al presionar da feedback de cual handle se esta arrastrando
    first.handle: Rectangle {
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        x: root.orientation === Qt.Horizontal
           ? (root.first.visualPosition * (root.width - calcDim))
           : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical
           ? (root.first.visualPosition * (root.height - calcDim))
           : ((root.height - calcDim) / 2)
        radius: (width / 2)
        // pressed ? 30% mas claro : color normal
        color: root.first.pressed ? Qt.lighter(Style.mainColor, 1.3) : Style.mainColor
    }

    // SLOT second.handle: handle del valor superior (misma logica que first)
    second.handle: Rectangle {
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        x: root.orientation === Qt.Horizontal
           ? (root.second.visualPosition * (root.width - calcDim))
           : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical
           ? (root.second.visualPosition * (root.height - calcDim))
           : ((root.height - calcDim) / 2)
        radius: (width / 2)
        color: root.second.pressed ? Qt.lighter(Style.mainColor, 1.3) : Style.mainColor
    }
}
