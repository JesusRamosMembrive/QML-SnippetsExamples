// =============================================================================
// FolderDialogCard.qml — FolderDialog con historial de carpetas
// =============================================================================
// Demuestra FolderDialog, el selector nativo de carpetas. A diferencia de
// FileDialog, solo permite elegir directorios, no archivos individuales.
//
// Caracteristicas de este ejemplo:
// - Muestra la carpeta seleccionada con feedback visual (borde verde
//   cuando hay seleccion, gris cuando no).
// - Mantiene un historial de las 5 carpetas mas recientes usando un array JS.
//   unshift() agrega al inicio; pop() elimina el ultimo si excede 5.
//
// Patron importante: las propiedades 'url' en QML almacenan rutas como
// "file:///C:/Users/...". Para mostrarlas al usuario, se limpia el prefijo
// con .toString().replace(/^file:\/\/\//, "").
//
// Nota: FolderDialog no tiene nameFilters porque los directorios no
// tienen extension. Solo se configura title y opcionalmente currentFolder.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property url selectedFolder: ""
    property var folderHistory: []

    // -------------------------------------------------------------------------
    // FolderDialog: similar a FileDialog pero para directorios.
    // onAccepted guarda la seleccion y actualiza el historial.
    // unshift() inserta al inicio del array (las mas recientes primero).
    // -------------------------------------------------------------------------
    FolderDialog {
        id: folderDialog
        title: "Select Folder"
        onAccepted: {
            root.selectedFolder = selectedFolder
            var history = root.folderHistory
            history.unshift(selectedFolder.toString().replace(/^file:\/\/\//, ""))
            if (history.length > 5) history.pop()
            root.folderHistory = history
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "FolderDialog"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Native folder picker"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Indicador de seleccion actual: cambia de color segun haya
        // o no una carpeta seleccionada. Usa expresiones ternarias
        // para alternar entre estados "seleccionado" y "vacio".
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(60)
            radius: Style.resize(8)
            color: root.selectedFolder.toString() ? "#1A3A35" : Style.surfaceColor
            border.color: root.selectedFolder.toString() ? "#00D1A9" : "#3A3D45"
            border.width: Style.resize(1)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(8)

                Label {
                    text: "\u2750"
                    font.pixelSize: Style.resize(24)
                    color: root.selectedFolder.toString() ? "#00D1A9" : Style.inactiveColor
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(2)
                    Label {
                        text: "Selected folder"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                    }
                    Label {
                        text: root.selectedFolder.toString()
                              ? root.selectedFolder.toString().replace(/^file:\/\/\//, "")
                              : "None"
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: root.selectedFolder.toString() ? Style.fontPrimaryColor : Style.inactiveColor
                        elide: Text.ElideMiddle
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Historial de carpetas recientes (maximo 5).
        // Patron: Repeater sobre un array JS que se actualiza cada vez
        // que el usuario selecciona una nueva carpeta.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Recent folders:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                Repeater {
                    model: root.folderHistory

                    Rectangle {
                        required property string modelData
                        required property int index
                        Layout.fillWidth: true
                        height: Style.resize(24)
                        radius: Style.resize(4)
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            spacing: Style.resize(6)
                            Label {
                                text: (index + 1) + "."
                                font.pixelSize: Style.resize(11)
                                color: Style.mainColor
                                Layout.preferredWidth: Style.resize(16)
                            }
                            Label {
                                text: modelData
                                font.pixelSize: Style.resize(11)
                                color: Style.fontSecondaryColor
                                elide: Text.ElideMiddle
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                Label {
                    text: "No history yet"
                    font.pixelSize: Style.resize(12)
                    color: Style.inactiveColor
                    visible: root.folderHistory.length === 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Style.resize(20)
                }

                Item { Layout.fillHeight: true }
            }
        }

        Button {
            text: "Select Folder"
            Layout.fillWidth: true
            onClicked: folderDialog.open()
        }
    }
}
