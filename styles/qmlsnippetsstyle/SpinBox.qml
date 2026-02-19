// =============================================================================
// SpinBox.qml - Override de estilo para SpinBox (selector numerico +/-)
// =============================================================================
//
// SpinBox permite seleccionar un valor numerico con botones de incremento (+)
// y decremento (-). Es uno de los controles con mas "gotchas" sutiles.
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de SpinBox. Importar Controls causaria recursion infinita.
//   Templates provee solo la logica (valor, rango, pasos) sin apariencia.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - contentItem: el TextInput que muestra el valor numerico
//   - up.indicator: el boton "+" de incremento
//   - down.indicator: el boton "-" de decremento
//   - background: el rectangulo contenedor
//
// GOTCHA CRITICO — implicitWidth/implicitHeight en indicadores:
//   Los indicadores DEBEN tener implicitWidth e implicitHeight definidos.
//   Sin ellos, el area de clic tiene tamaño cero y los botones no responden
//   a clicks. Este es un error muy comun y dificil de diagnosticar.
//
// leftPadding / rightPadding:
//   Evitan que el TextInput del contentItem se superponga con los indicadores.
//   Sin padding, el texto se renderizaria debajo de los botones +/-.
//
// root.mirrored:
//   Soporta idiomas RTL (derecha a izquierda, como arabe o hebreo).
//   En modo RTL, el boton "+" va a la izquierda y "-" a la derecha.
//   La posicion X se invierte con el ternario: mirrored ? 0 : parent.width - width
//
// textFromValue:
//   Funcion que convierte el valor numerico a texto para mostrar.
//   Respeta el locale para separadores decimales (punto vs coma).
//
// validator + inputMethodHints:
//   Restringen la entrada del teclado a solo numeros.
//   Qt.ImhFormattedNumbersOnly indica al teclado virtual (movil) que
//   muestre solo el teclado numerico.
// =============================================================================

import QtQuick
import QtQuick.Templates as T

import utils

T.SpinBox {
    id: root

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS
    editable: false

    // Padding para que el TextInput no se superponga con los indicadores +/-
    leftPadding: Style.resize(40)
    rightPadding: Style.resize(40)

    // SLOT contentItem: muestra el valor numerico
    // textFromValue convierte numero a texto respetando el locale
    // validator restringe entrada a numeros validos
    contentItem: TextInput {
        text: root.textFromValue(root.value, root.locale)
        font: root.font
        color: Style.fontPrimaryColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !root.editable
        validator: root.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    // SLOT up.indicator: boton "+"
    // CRITICO: implicitWidth/implicitHeight DEBEN estar definidos o el area
    // de clic sera de tamaño cero y el boton no funcionara
    up.indicator: Rectangle {
        // mirrored: en RTL el boton + va a la izquierda
        x: root.mirrored ? 0 : parent.width - width
        implicitWidth: Style.resize(36)
        implicitHeight: Style.resize(40)
        height: parent.height
        width: Style.resize(36)
        radius: Style.resize(8)
        color: root.up.pressed ? Style.mainColor : "transparent"
        border.color: Style.inactiveColor
        border.width: Style.resize(1)

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Text {
            anchors.centerIn: parent
            text: "+"
            font.pixelSize: Style.fontSizeM
            font.bold: true
            color: root.up.pressed ? "white" : Style.mainColor
        }
    }

    // SLOT down.indicator: boton "-" (en decimo, Unicode \u2013)
    // Misma logica que up.indicator pero con posicion invertida
    down.indicator: Rectangle {
        // mirrored: en RTL el boton - va a la derecha
        x: root.mirrored ? parent.width - width : 0
        implicitWidth: Style.resize(36)
        implicitHeight: Style.resize(40)
        height: parent.height
        width: Style.resize(36)
        radius: Style.resize(8)
        color: root.down.pressed ? Style.mainColor : "transparent"
        border.color: Style.inactiveColor
        border.width: Style.resize(1)

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Text {
            anchors.centerIn: parent
            text: "\u2013"
            font.pixelSize: Style.fontSizeM
            font.bold: true
            color: root.down.pressed ? "white" : Style.mainColor
        }
    }

    // SLOT background: contenedor con borde que resalta al tener foco
    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        border.color: root.activeFocus ? Style.mainColor : Style.inactiveColor
    }
}
