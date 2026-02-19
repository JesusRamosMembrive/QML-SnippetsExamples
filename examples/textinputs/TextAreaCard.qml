// =============================================================================
// TextAreaCard.qml — Ejemplo de TextArea con contador de caracteres
// =============================================================================
// Demuestra el uso de TextArea, el control de Qt Quick Controls 2 para
// entrada de texto multilinea. A diferencia de TextField (una sola linea),
// TextArea permite saltos de linea y ajuste de texto automatico (word wrap).
//
// Patrones educativos:
//   - Contador reactivo de caracteres con cambio de color al exceder el limite
//     (binding condicional: color cambia a rojo si length > 200)
//   - Uso de GradientButton (del estilo personalizado) para limpiar el campo
//   - Layout.preferredHeight para dar una altura fija al area de texto
//     sin impedir que el layout la ajuste si hay mas espacio disponible
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "TextArea"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Multi-line text input with word wrap:"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        // -----------------------------------------------------------------
        // TextArea: el control hereda su estilo del tema qmlsnippetsstyle.
        // A diferencia de construir un TextEdit manual (como en los
        // controles personalizados mas abajo), TextArea ya incluye
        // placeholder, scroll interno y estilo consistente.
        // -----------------------------------------------------------------
        TextArea {
            id: messageArea
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(150)
            placeholderText: "Type your message here..."
        }

        // -----------------------------------------------------------------
        // Barra de estado: muestra el conteo de caracteres con un binding
        // condicional para el color. Si supera 200 caracteres, el texto se
        // vuelve rojo como advertencia visual. El operador ternario en la
        // propiedad `color` es un patron muy comun en QML para feedback
        // visual basado en condiciones.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Characters: " + messageArea.text.length + " / 200"
                font.pixelSize: Style.resize(13)
                color: messageArea.text.length > 200 ? "#FF5900" : Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            GradientButton {
                text: "Clear"
                startColor: "#FF5900"
                endColor: "#FF8C00"
                width: Style.resize(80)
                height: Style.resize(32)
                onClicked: messageArea.text = ""
            }
        }

        // Separador visual
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: Style.bgColor
        }

        Label {
            text: "TextArea provides multi-line text editing with word wrap and scrolling"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
