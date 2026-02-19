// =============================================================================
// TextFieldCard.qml — Ejemplos de TextField con diferentes modos de entrada
// =============================================================================
// Demuestra las tres variantes mas comunes de TextField (control nativo de
// Qt Quick Controls 2):
//
//   1. Texto basico: sin restricciones, el caso mas simple.
//   2. Contrasena: usa `echoMode: TextInput.Password` para ocultar caracteres.
//   3. Solo numeros: combina `RegularExpressionValidator` con `inputMethodHints`
//      para restringir la entrada exclusivamente a digitos.
//
// Patron educativo clave: la validacion en QML ocurre en dos niveles:
//   - `validator` rechaza caracteres en tiempo real (no permite escribirlos)
//   - `inputMethodHints` sugiere al teclado virtual que tipo de entrada esperar
//     (importante en dispositivos moviles, pero no bloquea en desktop)
//
// Al final de la tarjeta se muestra un resumen reactivo que refleja en tiempo
// real los valores de los tres campos, gracias al binding declarativo de QML.
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
        spacing: Style.resize(15)

        Label {
            text: "TextField"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Campo basico: sin validacion ni restricciones. El TextField hereda
        // su estilo visual del tema personalizado (qmlsnippetsstyle).
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            Label {
                text: "Basic text input:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: nameField
                Layout.fillWidth: true
                placeholderText: "Enter your name"
            }
        }

        // -----------------------------------------------------------------
        // Campo de contrasena: echoMode oculta los caracteres escritos.
        // Los modos disponibles son: Normal, Password, NoEcho y
        // PasswordEchoOnEdit (muestra el ultimo caracter brevemente).
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            Label {
                text: "Password (echoMode: Password):"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: "Enter password"
                echoMode: TextInput.Password
            }
        }

        // -----------------------------------------------------------------
        // Campo numerico: RegularExpressionValidator con regex /[0-9]*/
        // impide escribir letras. La regex valida toda la cadena, no solo
        // caracteres individuales. Qt.ImhDigitsOnly le indica al sistema
        // operativo que muestre un teclado numerico (relevante en movil).
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            Label {
                text: "Numbers only (with validator):"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: numberField
                Layout.fillWidth: true
                placeholderText: "Numbers only"
                validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        // Separador visual
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: Style.bgColor
        }

        // -----------------------------------------------------------------
        // Resumen reactivo: este Label se actualiza automaticamente gracias
        // a los bindings declarativos de QML. Cada vez que el usuario escribe
        // en cualquier campo, el texto se recalcula sin necesidad de senales
        // ni callbacks explicitos. Este es el poder del paradigma reactivo.
        // -----------------------------------------------------------------
        Label {
            text: "Name: " + (nameField.text || "-")
                  + "  |  Password: " + (passwordField.text.length > 0 ? passwordField.text.length + " chars" : "-")
                  + "  |  Number: " + (numberField.text || "-")
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "TextField provides single-line text input with validation and echo modes"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
