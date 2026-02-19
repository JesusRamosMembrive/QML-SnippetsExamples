// =============================================================================
// Slider.qml - Override de estilo para Slider
// =============================================================================
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de Slider. Si importaramos Controls, se produciria recursion
//   infinita al intentar cargar el estilo dentro del propio estilo.
//   Templates provee solo la logica (valor, rango, arrastre) sin visual.
//
// SOPORTE DUAL DE ORIENTACION:
//   Este slider funciona tanto horizontal como vertical. Practicamente todos
//   los bindings usan ternarios: (orientation === Qt.Horizontal ? ... : ...)
//   Esto permite un unico archivo para ambas orientaciones.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - background: la pista (track) del slider — dos rectangulos superpuestos
//   - handle: el circulo arrastrable que el usuario mueve
//
// visualPosition:
//   Valor normalizado entre 0.0 y 1.0 que representa la posicion del handle.
//   Es diferente de "value" porque ya tiene en cuenta el rango del slider.
//   Ejemplo: si from=0, to=100, value=50 --> visualPosition=0.5
//   Esto simplifica los calculos de posicion visual.
//
// anchors.verticalCenter con "undefined":
//   En QML no se puede anclar condicionalmente con un if, pero se puede
//   asignar un anchor a "undefined" para desactivarlo. Asi el mismo codigo
//   funciona para ambas orientaciones: en horizontal se centra verticalmente,
//   en vertical se centra horizontalmente.
//
// calcDim en el handle:
//   Propiedad auxiliar que garantiza que el handle no sea ni demasiado pequeño
//   ni demasiado grande en proporcion al slider. Si la dimension disponible
//   es menor que 10 (escalado), usa todo el espacio; si no, usa la mitad.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.Slider {
    id: root

    // Tamaño implicito depende de la orientacion
    implicitWidth: root.orientation === Qt.Horizontal ? Style.resize(270) : Style.resize(20)
    implicitHeight: root.orientation === Qt.Horizontal ? Style.resize(20) : Style.resize(270)

    // SLOT background: dos rectangulos — la pista (inactiva) y el relleno (activo)
    background: Rectangle {
        // Pista exterior (track): color inactivo, ocupa 1/4 del grosor
        width: root.orientation === Qt.Horizontal ? parent.width : (parent.width / 4)
        height: root.orientation === Qt.Horizontal ? (parent.height / 4) : parent.height
        // Asignar anchor a undefined lo desactiva — truco para soporte dual
        anchors.verticalCenter: root.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.orientation === Qt.Vertical ? parent.horizontalCenter : undefined
        radius: Style.resize(20)
        color: Style.inactiveColor
        // Relleno interior: crece segun visualPosition (0.0 a 1.0)
        Rectangle {
            width: root.orientation === Qt.Horizontal ? (root.visualPosition * parent.width) : parent.width
            height: root.orientation === Qt.Horizontal ? parent.height : (root.visualPosition * parent.height)
            color: Style.mainColor
            radius: Style.resize(20)
            anchors.top: root.orientation === Qt.Vertical ? parent.top : undefined
        }
    }

    // SLOT handle: el circulo arrastrable
    handle: Rectangle {
        // calcDim: dimension adaptativa — evita que el handle sea
        // demasiado pequeño (< 10px) o demasiado grande (> mitad del slider)
        property int calcDim: root.orientation === Qt.Horizontal
                              ? ((root.height < Style.resize(10)) ? root.height : (root.height / 2))
                              : ((root.width < Style.resize(10)) ? root.width : (root.width / 2))
        width: calcDim
        height: calcDim
        anchors.verticalCenter: root.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.orientation === Qt.Vertical ? parent.horizontalCenter : undefined
        // Posicion X/Y: visualPosition * (espacio disponible)
        x: root.orientation === Qt.Horizontal ? (root.visualPosition * (root.width - calcDim)) : ((root.width - calcDim) / 2)
        y: root.orientation === Qt.Vertical ? (root.visualPosition * (root.height - calcDim)) : 0
        radius: (width / 2)
        color: Style.mainColor
    }
}
