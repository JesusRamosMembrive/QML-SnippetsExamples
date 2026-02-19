// =============================================================================
// Snackbar.qml — Notificacion inferior con accion (patron Material Design)
// =============================================================================
// Implementa un "snackbar" — una barra de notificacion temporal que aparece
// en la parte inferior con un mensaje y opcionalmente un boton de accion
// (como "UNDO" o "VIEW"). Es el patron estandar de feedback en Material Design.
//
// CONCEPTOS CLAVE:
//
// 1. Animacion de entrada/salida por anchors.bottomMargin:
//    - Cuando el snackbar esta oculto, bottomMargin es negativo (-height),
//      posicionandolo fuera de vista por debajo.
//    - Cuando se muestra, bottomMargin es positivo, deslizandolo hacia arriba.
//    - Behavior on anchors.bottomMargin con OutCubic anima el movimiento.
//
// 2. Timer de auto-dismiss:
//    - El snackbar se oculta automaticamente tras 4 segundos.
//    - Timer.restart() reinicia el conteo si se muestra un nuevo snackbar
//      antes de que el anterior desaparezca.
//
// 3. Accion contextual:
//    - El boton de accion (ej: "UNDO") es visible solo si snackAction != "".
//    - En el caso de "UNDO", revierte el deletedCount, demostrando como
//      el snackbar puede deshacer operaciones.
//
// 4. Ancho responsivo con Math.min:
//    - width: Math.min(parent.width - 30, 400) asegura que el snackbar
//      no exceda un maximo pero se adapte a pantallas pequenas.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Snackbar with Action"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: snackbarSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        clip: true

        property bool snackVisible: false
        property string snackMessage: ""
        property string snackAction: ""
        property int deletedCount: 0

        // Muestra el snackbar con un mensaje y una accion opcional.
        // restart() reinicia el timer para que el auto-dismiss cuente
        // desde el momento de la ultima invocacion.
        function showSnack(msg, action) {
            snackMessage = msg
            snackAction = action
            snackVisible = true
            snackTimer.restart()
        }

        Timer {
            id: snackTimer
            interval: 4000
            onTriggered: snackbarSection.snackVisible = false
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Contenido de demostracion: botones que disparan el snackbar con
        // diferentes mensajes y acciones. El contador de "deleted items"
        // demuestra como la accion UNDO puede revertir una operacion.
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(12)

            Label {
                text: "Deleted items: " + snackbarSection.deletedCount
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(10)

                Button {
                    text: "Delete Item"
                    onClicked: {
                        snackbarSection.deletedCount++
                        snackbarSection.showSnack(
                            "Item deleted", "UNDO")
                    }
                }

                Button {
                    text: "Archive"
                    flat: true
                    onClicked: {
                        snackbarSection.showSnack(
                            "Conversation archived", "VIEW")
                    }
                }

                Button {
                    text: "Send"
                    flat: true
                    onClicked: {
                        snackbarSection.showSnack(
                            "Message sent to 3 recipients", "")
                    }
                }
            }
        }

        // Snackbar visual: barra oscura con texto y boton de accion.
        // Se desliza desde abajo con animacion OutCubic.
        // El color #323232 sigue la especificacion Material Design para snackbars.
        Rectangle {
            id: snackbar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: snackbarSection.snackVisible ? Style.resize(12) : -height
            width: Math.min(parent.width - Style.resize(30), Style.resize(400))
            height: Style.resize(46)
            radius: Style.resize(8)
            color: "#323232"

            Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(16)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(10)

                Label {
                    text: snackbarSection.snackMessage
                    font.pixelSize: Style.resize(13)
                    color: "#E0E0E0"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Button {
                    visible: snackbarSection.snackAction !== ""
                    text: snackbarSection.snackAction
                    flat: true
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    onClicked: {
                        if (snackbarSection.snackAction === "UNDO")
                            snackbarSection.deletedCount = Math.max(0, snackbarSection.deletedCount - 1)
                        snackbarSection.snackVisible = false
                    }
                }
            }
        }
    }
}
