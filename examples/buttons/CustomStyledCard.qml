// =============================================================================
// CustomStyledCard.qml — Personalizacion de color con palette
// =============================================================================
// Demuestra como cambiar los colores de Button SIN crear un componente custom,
// usando la propiedad "palette" de Qt Quick Controls 2. Este es el mecanismo
// oficial de Qt para personalizar colores de controles individuales.
//
// CONCEPTOS CLAVE:
//
// 1. palette.button y palette.buttonText:
//    - palette.button: color de fondo del boton.
//    - palette.buttonText: color del texto del boton.
//    - Estos valores sobreescriben los colores del estilo activo solo para
//      esa instancia, sin afectar a otros botones.
//
// 2. Variantes solidas vs flat:
//    - Los mismos colores de palette funcionan tanto en botones solidos
//      como en flat. En flat, palette.button se usa como color de texto
//      (ya que no hay fondo), creando una familia visual coherente.
//    - Esto permite crear botones "Success", "Warning", "Danger" que
//      funcionan en ambos contextos sin codigo adicional.
//
// 3. Patron de colores semanticos:
//    - Verde (#00D1A8) para exito, amarillo (#FFE361) para advertencia,
//      naranja (#FF5900) para peligro. Estos colores son convenciones
//      universales de UI que los usuarios reconocen intuitivamente.
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
        spacing: Style.resize(15)

        Label {
            text: "Custom Styled Buttons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Fila de botones solidos con colores semanticos.
        // palette.buttonText se ajusta al contraste del fondo.
        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                text: "Success"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#00D1A8"
                palette.buttonText: "white"
            }

            Button {
                text: "Warning"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FFE361"
                palette.buttonText: "#333"
            }

            Button {
                text: "Danger"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FF5900"
                palette.buttonText: "white"
            }
        }

        // Mismos colores pero en variante flat: el estilo usa palette.button
        // como color de texto e interacciones hover, en lugar de fondo.
        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                text: "Success Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#00D1A8"
            }

            Button {
                text: "Warning Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FFE361"
            }

            Button {
                text: "Danger Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FF5900"
            }
        }

        Label {
            text: "palette.button changes color for both solid and flat variants"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
