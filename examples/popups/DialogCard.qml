// ============================================================================
// DialogCard - Ejemplos de Dialog de Qt Quick Controls
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Dialog en Qt Quick Controls:
//    - Dialog es un Popup especializado que proporciona ventanas modales
//      con titulo, contenido y botones estandar.
//    - Es modal por defecto: bloquea la interaccion con el resto de la UI
//      hasta que el usuario responda.
//    - Se abre con open() y se cierra automaticamente al pulsar un boton
//      estandar, o manualmente con close().
//
// 2. standardButtons (botones predefinidos):
//    - Qt proporciona botones estandar: Ok, Cancel, Yes, No, Apply, etc.
//    - Se combinan con el operador | (OR): Dialog.Yes | Dialog.No
//    - Cada boton dispara una senal especifica:
//      * Ok/Yes -> onAccepted
//      * Cancel/No -> onRejected
//    - Esto separa la logica de respuesta del boton pulsado.
//
// 3. Tres patrones comunes de Dialog:
//    a) Info Dialog: solo boton Ok. Para mensajes informativos.
//    b) Confirm Dialog: Yes + No. Para confirmacion de acciones.
//       onAccepted/onRejected manejan la decision del usuario.
//    c) Input Dialog: Ok + Cancel + TextField. Para capturar entrada.
//       onOpened limpia el campo y le da foco automaticamente.
//
// 4. Ubicacion de los Dialog:
//    - Los Dialog se definen como hijos del componente contenedor (no del
//      layout). Esto es IMPORTANTE porque Dialog necesita acceso al overlay
//      de la ventana para mostrarse correctamente sobre toda la UI.
//    - Si se define dentro de un ColumnLayout, el Dialog puede no
//      posicionarse correctamente o tener problemas de z-order.
//
// 5. forceActiveFocus():
//    - En onOpened se usa forceActiveFocus() para que el TextField reciba
//      el foco del teclado automaticamente al abrirse el dialog.
//    - Sin esto, el usuario tendria que hacer clic en el campo antes de escribir.
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // --- Dialogs ---
    // Se definen aqui (hijos directos del Rectangle) para que el overlay
    // funcione correctamente. Cada uno demuestra un patron distinto.

    // Patron 1: Dialog informativo (solo Ok).
    // Caso de uso: mostrar mensajes, avisos, resultado de operaciones.
    Dialog {
        id: infoDialog
        title: "Information"
        standardButtons: Dialog.Ok

        Label {
            text: "This is a simple informational dialog.\nIt displays a message to the user."
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
        }
    }

    // Patron 2: Dialog de confirmacion (Yes/No).
    // Caso de uso: confirmar acciones destructivas o irreversibles.
    // onAccepted se dispara con Yes, onRejected con No.
    Dialog {
        id: confirmDialog
        title: "Confirm Action"
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: "Are you sure you want to proceed?\nThis action can be reversed."
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
        }

        onAccepted: confirmResultLabel.text = "Result: Accepted"
        onRejected: confirmResultLabel.text = "Result: Rejected"
    }

    // Patron 3: Dialog con entrada de texto (Ok/Cancel + TextField).
    // Caso de uso: pedir datos al usuario (nombre, valor, busqueda).
    // onOpened limpia el campo y asigna foco para mejor UX.
    Dialog {
        id: inputDialog
        title: "Enter Text"
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            anchors.fill: parent
            spacing: Style.resize(10)

            Label {
                text: "Please enter your name:"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: inputDialogField
                Layout.fillWidth: true
                placeholderText: "Type here..."
            }
        }

        onAccepted: inputResultLabel.text = "Entered: " + inputDialogField.text
        onRejected: inputResultLabel.text = "Cancelled"
        onOpened: {
            inputDialogField.text = ""
            inputDialogField.forceActiveFocus()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dialog"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Info Dialog"
            Layout.fillWidth: true
            onClicked: infoDialog.open()
        }

        Button {
            text: "Confirm Dialog"
            Layout.fillWidth: true
            onClicked: confirmDialog.open()
        }

        // Labels de resultado: muestran la respuesta del usuario.
        // Demuestran como capturar la decision del dialog y reflejarla en la UI.
        Label {
            id: confirmResultLabel
            text: "Result: —"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        Button {
            text: "Input Dialog"
            Layout.fillWidth: true
            onClicked: inputDialog.open()
        }

        Label {
            id: inputResultLabel
            text: "Entered: —"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        Item { Layout.fillHeight: true }

        Label {
            text: "Dialog provides modal windows for user interaction with standard buttons"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
