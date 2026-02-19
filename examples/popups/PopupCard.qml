// =============================================================================
// PopupCard.qml — Ejemplos de Popup basico y modal
// =============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Popup en Qt Quick Controls:
//    - Popup es el componente base para contenido emergente (overlays).
//    - A diferencia de Dialog, no tiene titulo ni botones estandar — es una
//      "ventana flotante" generica que el desarrollador llena con lo que necesite.
//    - Se controla con open() y close().
//
// 2. Popup basico vs modal:
//    - modal: false (por defecto) — el popup aparece sin overlay y el usuario
//      puede interactuar con el resto de la UI. Se cierra con Esc o clic fuera.
//    - modal: true — oscurece el fondo (Overlay.modal) y BLOQUEA toda
//      interaccion con la UI subyacente hasta que se cierre.
//    - closePolicy define como se puede cerrar: CloseOnEscape, CloseOnPressOutside,
//      o combinaciones con el operador |.
//
// 3. parent: Overlay.overlay:
//    - IMPORTANTE: asignar Overlay.overlay como parent hace que el Popup se
//      renderice sobre TODA la ventana, no solo sobre su padre visual.
//    - Sin esto, el Popup quedaria limitado al area de su padre y podria
//      quedar cortado (clipped) o detras de otros elementos.
//
// 4. Transiciones enter/exit:
//    - enter y exit son Transition que animan la aparicion y desaparicion.
//    - Se animan multiples propiedades en paralelo (opacity + scale) para
//      crear un efecto natural de "zoom in" al aparecer.
//    - Easing.OutBack genera un ligero rebote al final, dando sensacion de
//      que el popup "se asoma".
//
// 5. background vs contentItem:
//    - background define el fondo visual del Popup (rectangulo, sombra, etc.)
//    - contentItem define el contenido interior. Ambos son personalizables.
//
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // --- Popup basico (no modal) ---
    // Aparece centrado sobre el overlay sin oscurecer el fondo.
    // El usuario puede cerrar haciendo clic fuera o pulsando Esc.
    Popup {
        id: basicPopup
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Style.resize(250)
        height: Style.resize(150)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        modal: false

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(8)
            border.color: Style.mainColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(10)

            Label {
                text: "Basic Popup"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "Click outside or press Esc to close"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Button {
                text: "Close"
                onClicked: basicPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        // Transicion de entrada: fade in + escala con rebote (OutBack).
        // Al combinar opacity y scale se logra un efecto de "brotar".
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        }

        // Transicion de salida: mas rapida que la entrada para sensacion responsiva.
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 100 }
        }
    }

    // --- Popup modal ---
    // Oscurece el fondo y bloquea la interaccion con la UI inferior.
    // Overlay.modal personaliza el rectangulo semitransparente del fondo.
    Popup {
        id: modalPopup
        anchors.centerIn: parent
        width: Style.resize(300)
        height: Style.resize(200)
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        parent: Overlay.overlay

        // Overlay.modal define el aspecto del fondo oscurecido.
        // Sin esto, Qt usa un overlay por defecto que puede no coincidir
        // con el tema oscuro de la app.
        Overlay.modal: Rectangle {
            color: Qt.rgba(0, 0, 0, 0.4)
        }

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(12)
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(15)

            Label {
                text: "Modal Popup"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "The background is dimmed.\nInteraction is blocked until this is closed."
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            Button {
                text: "Got it"
                onClicked: modalPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
        }
    }

    // --- Contenido visible de la card ---
    // Botones para abrir cada tipo de Popup y panel informativo que
    // resume las diferencias clave entre basico y modal.
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Popup"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Basic Popup"
            Layout.fillWidth: true
            onClicked: basicPopup.open()
        }

        Button {
            text: "Modal Popup"
            Layout.fillWidth: true
            onClicked: modalPopup.open()
        }

        Item { Layout.fillHeight: true }

        // Panel informativo: resumen visual de las diferencias entre ambos modos.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: infoColumn.implicitHeight + Style.resize(20)
            color: Style.bgColor
            radius: Style.resize(6)

            ColumnLayout {
                id: infoColumn
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Label {
                    text: "Basic vs Modal:"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Basic: no overlay, click outside to close"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "• Modal: dims background, blocks interaction"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }
            }
        }

        Label {
            text: "Popup shows overlay content with enter/exit transitions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
