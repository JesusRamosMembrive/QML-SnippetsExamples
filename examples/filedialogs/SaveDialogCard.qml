// =============================================================================
// SaveDialogCard.qml — FileDialog en modo guardado con seleccion de formato
// =============================================================================
// FileDialog con fileMode: FileDialog.SaveFile muestra el dialogo nativo
// de "Guardar como...", permitiendo al usuario elegir ubicacion y nombre.
//
// Este ejemplo agrega un selector de formato (txt, json, csv, qml) que
// ajusta dinamicamente los nameFilters del dialogo. Tambien incluye un
// TextField para escribir el nombre del archivo y una previsualizacion
// que muestra el nombre completo (nombre + extension).
//
// Conceptos clave:
// - FileDialog.SaveFile: el dialogo permite escribir un nombre nuevo,
//   no solo seleccionar archivos existentes.
// - nameFilters se actualiza dinamicamente al cambiar formatIndex,
//   gracias al binding sobre root.formats[root.formatIndex].filter.
// - selectedFile (singular, no plural) retorna la URL del archivo guardado.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property url savedFile: ""
    property string fileName: "untitled"
    property int formatIndex: 0

    // Array de formatos disponibles: cada uno tiene extension, filtro
    // para el dialogo nativo, y un icono unicode representativo.
    readonly property var formats: [
        { ext: ".txt",  filter: "Text files (*.txt)",     icon: "\u2759" },
        { ext: ".json", filter: "JSON files (*.json)",    icon: "\u007B" },
        { ext: ".csv",  filter: "CSV files (*.csv)",      icon: "\u2637" },
        { ext: ".qml",  filter: "QML files (*.qml)",      icon: "\u25C8" }
    ]

    // FileDialog en modo SaveFile: el primer filtro es el formato
    // seleccionado, el segundo es "All files" como fallback.
    FileDialog {
        id: saveDialog
        title: "Save File As"
        fileMode: FileDialog.SaveFile
        nameFilters: [root.formats[root.formatIndex].filter, "All files (*)"]
        onAccepted: {
            root.savedFile = selectedFile
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "FileDialog (Save)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Save file dialog with format selection"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Campo de texto para el nombre del archivo.
        // onTextChanged actualiza root.fileName en tiempo real,
        // lo que se refleja inmediatamente en la previsualizacion.
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "File name:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            TextField {
                Layout.fillWidth: true
                text: root.fileName
                font.pixelSize: Style.resize(13)
                placeholderText: "Enter file name..."
                onTextEdited: root.fileName = text
            }
        }

        // Selector de formato: botones con highlighted para indicar
        // el formato activo. Cada boton muestra icono + extension.
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Format:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(6)

                Repeater {
                    model: root.formats

                    Button {
                        required property var modelData
                        required property int index
                        text: modelData.icon + " " + modelData.ext
                        font.pixelSize: Style.resize(11)
                        highlighted: root.formatIndex === index
                        onClicked: root.formatIndex = index
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Previsualizacion: muestra el nombre completo del archivo
        // y la ruta de guardado (si ya se guardo).
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)

                Label {
                    text: root.formats[root.formatIndex].icon
                    font.pixelSize: Style.resize(40)
                    color: Style.mainColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: root.fileName + root.formats[root.formatIndex].ext
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                // wrapMode: Text.WrapAnywhere permite que rutas largas
                // se partan en cualquier caracter, no solo en espacios.
                Label {
                    text: root.savedFile.toString()
                          ? "Saved to: " + root.savedFile.toString().replace(/^file:\/\/\//, "")
                          : "Not saved yet"
                    font.pixelSize: Style.resize(11)
                    color: root.savedFile.toString() ? "#00D1A9" : Style.inactiveColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: Style.resize(250)
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Button {
            text: "Save As..."
            Layout.fillWidth: true
            onClicked: saveDialog.open()
        }
    }
}
