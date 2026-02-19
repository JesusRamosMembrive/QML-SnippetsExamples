// =============================================================================
// FormBuilderCard.qml — Formulario interactivo combinando multiples controles
// =============================================================================
// Este ejemplo integra todos los controles de entrada vistos en las tarjetas
// anteriores (TextField, ComboBox, SpinBox, TextArea) en un formulario
// practico con funcionalidad de envio y reinicio.
//
// Patrones educativos:
//   - Gestion de estado con propiedades: `submitted` y `summary` controlan
//     la visibilidad y contenido del resumen post-envio.
//   - Uso de botones del estilo personalizado: GlowButton para la accion
//     principal (submit) y PulseButton para la accion destructiva (reset).
//     Esto demuestra como los estilos personalizados permiten comunicar
//     jerarquia visual (accion primaria vs secundaria) con diferentes efectos.
//   - Reinicio manual de formulario: en QML no existe un "form reset" nativo;
//     hay que limpiar cada control individualmente. El handler de Reset
//     demuestra este patron.
//   - substring(0, 30) trunca el bio en el resumen para mantener el texto
//     compacto, un patron comun en interfaces de previsualizacion.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Estado del formulario: estas propiedades controlan la UI post-envio
    property bool submitted: false
    property string summary: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Interactive Demo - Form Builder"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Campo de nombre: TextField basico
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(3)

            Label {
                text: "Full Name:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: formName
                Layout.fillWidth: true
                placeholderText: "John Doe"
            }
        }

        // Selector de departamento: ComboBox con modelo de strings
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(3)

            Label {
                text: "Department:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: formDept
                Layout.fillWidth: true
                model: ["Engineering", "Design", "Marketing", "Sales"]
            }
        }

        // Anios de experiencia: SpinBox con rango 0-30
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Years of Experience:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            SpinBox {
                id: formYears
                from: 0
                to: 30
                value: 0
                stepSize: 1
            }
        }

        // Biografia: TextArea multilinea
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(3)

            Label {
                text: "Bio:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            TextArea {
                id: formBio
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(60)
                placeholderText: "Tell us about yourself..."
            }
        }

        // -----------------------------------------------------------------
        // Botones de accion: GlowButton (primario) y PulseButton (secundario).
        // Ambos son controles del estilo personalizado qmlsnippetsstyle.
        // El submit construye un resumen concatenando los valores de todos
        // los campos. El reset limpia cada campo manualmente — no hay un
        // mecanismo automatico de "form reset" en QML.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            GlowButton {
                text: "Submit"
                glowColor: "#00D1A8"
                width: Style.resize(100)
                height: Style.resize(35)
                onClicked: {
                    root.submitted = true;
                    root.summary =
                        formName.text + " | " + formDept.currentText
                        + " | " + formYears.value + " yrs | "
                        + (formBio.text.length > 0 ? formBio.text.substring(0, 30) + "..." : "No bio");
                }
            }

            PulseButton {
                text: "Reset"
                pulseColor: "#FF5900"
                width: Style.resize(100)
                height: Style.resize(35)
                onClicked: {
                    formName.text = "";
                    formDept.currentIndex = 0;
                    formYears.value = 0;
                    formBio.text = "";
                    root.submitted = false;
                    root.summary = "";
                }
            }
        }

        // -----------------------------------------------------------------
        // Resumen: solo visible despues de hacer submit. El binding
        // `visible: root.submitted` oculta este Label hasta que el usuario
        // presione Submit. En QML, `visible: false` evita el renderizado
        // y el calculo de layout del elemento.
        // -----------------------------------------------------------------
        Label {
            visible: root.submitted
            text: "Submitted: " + root.summary
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.mainColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "Combining all input controls into a practical form"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
