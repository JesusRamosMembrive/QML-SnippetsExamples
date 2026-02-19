// =============================================================================
// Main.qml — Pagina principal del modulo File Dialogs
// =============================================================================
// Punto de entrada para los ejemplos de dialogos de archivos nativos.
// Qt 6 provee FileDialog y FolderDialog en el modulo QtQuick.Dialogs,
// que invocan el selector nativo del sistema operativo (Windows Explorer,
// Nautilus, Finder, etc.).
//
// Cuatro tarjetas en grid 2x2:
//   - FileDialogCard: abrir archivos con filtros y seleccion multiple
//   - FolderDialogCard: seleccionar carpetas con historial
//   - SaveDialogCard: guardar archivos con seleccion de formato
//   - InteractiveDialogCard: log de acciones combinando todos los dialogos
//
// Nota: estos dialogos son nativos del SO, no se pueden personalizar
// visualmente desde QML. Lo que se controla es el titulo, filtros,
// modo (abrir/guardar), y la respuesta (onAccepted/onRejected).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: fullSize controla la animacion
    // de entrada/salida de la pagina desde Dashboard.qml.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "File Dialog Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 con las cuatro tarjetas de ejemplo de dialogos
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    FileDialogCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    FolderDialogCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    SaveDialogCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveDialogCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
