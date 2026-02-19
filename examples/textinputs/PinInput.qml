// =============================================================================
// PinInput.qml — Entrada de codigo PIN/verificacion con cajas individuales
// =============================================================================
// Implementa un campo de entrada de PIN de 6 digitos al estilo de las
// pantallas de verificacion de aplicaciones modernas. Cada digito se muestra
// en su propia caja con animaciones de foco, color y escala.
//
// Patron arquitectonico clave: "TextInput oculto"
//   El truco central es usar un TextInput invisible (opacity: 0, 1x1 px) que
//   captura toda la entrada de teclado, mientras que la UI visible es un
//   Repeater de Rectangles decorativos. El MouseArea sobre todo el contenedor
//   redirige el foco al TextInput oculto cuando el usuario hace clic.
//   Este patron es necesario porque QML no tiene un componente nativo de
//   "input segmentado" — hay que construirlo combinando primitivas.
//
// Otros patrones educativos:
//   - Repeater con index: cada caja sabe su posicion y la compara con la
//     longitud actual del PIN para determinar su estado visual.
//   - SequentialAnimation on opacity: crea el efecto de cursor parpadeante
//     que solo aparece en la caja activa (la siguiente a llenar).
//   - RegularExpressionValidator + Qt.ImhDigitsOnly: doble capa de validacion
//     para asegurar que solo se acepten digitos.
//   - `scale: 1.05` con Behavior: efecto sutil de "zoom" en la caja activa.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "PIN / Verification Code"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: pinContainer
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(70)

        // Estado del PIN: la cadena se llena caracter a caracter
        property string pinValue: ""
        property int pinLength: 6
        property bool completed: pinValue.length === pinLength

        RowLayout {
            anchors.centerIn: parent
            spacing: Style.resize(10)

            // -----------------------------------------------------------------
            // Repeater genera 6 cajas. Cada caja cambia su apariencia segun
            // tres estados: "llena" (ya tiene digito), "activa" (la siguiente
            // a llenar), o "vacia" (aun no alcanzada). Los colores de borde
            // y la escala se determinan comparando el `index` de cada caja
            // con la longitud actual del texto del PIN.
            // -----------------------------------------------------------------
            Repeater {
                model: pinContainer.pinLength

                Rectangle {
                    id: pinBox
                    required property int index

                    width: Style.resize(48)
                    height: Style.resize(56)
                    radius: Style.resize(10)
                    color: Style.surfaceColor
                    border.color: {
                        if (pinContainer.completed) return Style.mainColor
                        if (index === pinContainer.pinValue.length) return Style.mainColor
                        if (index < pinContainer.pinValue.length) return "#4FC3F7"
                        return "#3A3D45"
                    }
                    border.width: index === pinContainer.pinValue.length ? 2 : 1

                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    // Efecto sutil de zoom en la caja activa
                    scale: index === pinContainer.pinValue.length ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }

                    // Digito visible dentro de la caja
                    Label {
                        anchors.centerIn: parent
                        text: index < pinContainer.pinValue.length
                              ? pinContainer.pinValue.charAt(index) : ""
                        font.pixelSize: Style.resize(22)
                        font.bold: true
                        color: pinContainer.completed ? Style.mainColor : "white"

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    // ---------------------------------------------------------
                    // Cursor parpadeante: un rectangulo delgado que pulsa su
                    // opacidad de 1 a 0 en loop infinito. Solo es visible en
                    // la caja activa Y cuando el TextInput oculto tiene foco.
                    // SequentialAnimation on <prop> es la forma mas limpia
                    // de crear animaciones en bucle sobre una propiedad.
                    // ---------------------------------------------------------
                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(2)
                        height: Style.resize(24)
                        color: Style.mainColor
                        visible: index === pinContainer.pinValue.length
                                 && pinHiddenInput.activeFocus

                        SequentialAnimation on opacity {
                            running: visible
                            loops: Animation.Infinite
                            NumberAnimation { from: 1; to: 0; duration: 500 }
                            NumberAnimation { from: 0; to: 1; duration: 500 }
                        }
                    }
                }
            }

            // Indicador de completado
            Label {
                text: pinContainer.completed ? "\u2705" : ""
                font.pixelSize: Style.resize(24)
                Layout.leftMargin: Style.resize(10)
            }
        }

        // -----------------------------------------------------------------
        // TextInput oculto: este es el corazon del patron. Tiene opacity: 0
        // y tamano 1x1 para ser invisible, pero captura toda la entrada
        // de teclado. maximumLength limita a 6 digitos y el validator
        // rechaza cualquier caracter que no sea numerico.
        // onTextChanged sincroniza el texto con pinValue, que a su vez
        // actualiza toda la UI visual via bindings.
        // -----------------------------------------------------------------
        TextInput {
            id: pinHiddenInput
            width: 1; height: 1
            opacity: 0
            maximumLength: pinContainer.pinLength
            validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }
            inputMethodHints: Qt.ImhDigitsOnly
            onTextChanged: pinContainer.pinValue = text
        }

        // MouseArea captura clics en toda el area y redirige el foco al input oculto
        MouseArea {
            anchors.fill: parent
            onClicked: pinHiddenInput.forceActiveFocus()
        }

        // Enlace de reinicio
        Label {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Reset"
            font.pixelSize: Style.resize(12)
            color: pinResetMa.containsMouse ? Style.mainColor : Style.fontSecondaryColor

            MouseArea {
                id: pinResetMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: { pinHiddenInput.text = ""; pinHiddenInput.forceActiveFocus() }
            }
        }
    }
}
