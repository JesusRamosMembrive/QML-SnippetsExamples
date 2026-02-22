// =============================================================================
// FileDialogCard.qml — FileDialog para abrir archivos
// =============================================================================
// Demuestra FileDialog en modo apertura (OpenFile / OpenFiles).
// Caracteristicas principales:
// - nameFilters: lista de filtros que aparecen en el dropdown del dialogo nativo
// - fileMode: OpenFile (un archivo) o OpenFiles (seleccion multiple)
// - onAccepted: se dispara cuando el usuario confirma; selectedFiles contiene
//   la lista de URLs seleccionadas (siempre es lista, incluso con un solo archivo)
//
// Las URLs retornadas tienen formato "file:///ruta/al/archivo". Se usa
// .replace(/^file:\/\/\//, "") para mostrar la ruta legible sin el prefijo.
//
// Patron de UI: estado vacio ("No files selected") visible solo cuando
// la lista esta vacia, usando visible: root.selectedFiles.length === 0.
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

    property var selectedFiles: []
    property int filterIndex: 0

    // Filtros de archivo: el formato es "Descripcion (*.ext1 *.ext2)".
    // El dialogo nativo los muestra en un dropdown para que el usuario
    // filtre por tipo de archivo.
    readonly property list<string> filters: [
        "All files (*)",
        "Images (*.png *.jpg *.svg)",
        "Documents (*.pdf *.txt *.md)",
        "QML files (*.qml)",
        "C++ files (*.cpp *.h)"
    ]

    // -------------------------------------------------------------------------
    // FileDialog: componente no visual que invoca el dialogo nativo del SO.
    // Se declara fuera del layout porque no ocupa espacio visual.
    // fileMode cambia dinamicamente segun el Switch de multi-seleccion.
    // -------------------------------------------------------------------------
    FileDialog {
        id: openDialog
        title: "Open File"
        nameFilters: root.filters
        fileMode: multiCheck.checked ? FileDialog.OpenFiles : FileDialog.OpenFile
        onAccepted: {
            root.selectedFiles = selectedFiles
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "FileDialog (Open)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Native file picker with filters"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Lista de archivos seleccionados.
        // Flickable permite scroll cuando hay muchos archivos.
        // Cada fila alterna color de fondo para mejorar legibilidad.
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
                    text: "Selected files:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentHeight: fileCol.height

                    ColumnLayout {
                        id: fileCol
                        width: parent.width
                        spacing: Style.resize(4)

                        Repeater {
                            model: root.selectedFiles

                            Rectangle {
                                required property url modelData
                                required property int index
                                Layout.fillWidth: true
                                height: Style.resize(28)
                                radius: Style.resize(4)
                                color: index % 2 === 0 ? "#2A2D35" : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "\u2759"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.mainColor
                                    }
                                    // elide: Text.ElideMiddle trunca en el medio
                                    // de la ruta, mostrando inicio y final.
                                    // Ideal para rutas largas donde importan
                                    // tanto la carpeta como el nombre del archivo.
                                    Label {
                                        text: modelData.toString().replace(/^file:\/\/\//, "")
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        elide: Text.ElideMiddle
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Estado vacio: se muestra cuando no hay archivos
                        Label {
                            text: "No files selected"
                            font.pixelSize: Style.resize(13)
                            color: Style.inactiveColor
                            visible: root.selectedFiles.length === 0
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: Style.resize(30)
                        }
                    }
                }
            }
        }

        // Switch para alternar entre seleccion unica y multiple
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Switch {
                id: multiCheck
                text: "Multi-select"
                font.pixelSize: Style.resize(11)
            }

            Label {
                text: root.selectedFiles.length + " file(s)"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
            }
        }

        Button {
            text: "Open File Dialog"
            Layout.fillWidth: true
            onClicked: openDialog.open()
        }
    }
}
