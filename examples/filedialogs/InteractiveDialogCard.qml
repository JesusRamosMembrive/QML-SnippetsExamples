// =============================================================================
// InteractiveDialogCard.qml — Log de acciones con multiples dialogos
// =============================================================================
// Combina los cuatro tipos de dialogo (Open, Save, Folder, OpenFiles) en una
// sola tarjeta con un registro de acciones (action log) que muestra el
// historial de operaciones realizadas.
//
// Cada dialogo tiene su propio FileDialog/FolderDialog declarado como
// componente no-visual. Al aceptar cualquier dialogo, se llama a addLog()
// que registra la accion con timestamp, tipo y ruta.
//
// Patrones aprendidos:
// - Funcion JS como helper: addLog() encapsula logica de manipulacion
//   de arrays que seria repetitiva en cada onAccepted.
// - Badges de color por tipo: cada accion tiene un color asociado
//   (Open=teal, Save=amber, Folder=azul, Multi=violeta), usando un
//   Rectangle con opacity:0.2 como fondo semitransparente y Label
//   con color solido encima para crear un "chip" visual.
// - unshift() + pop() mantiene un maximo de 8 entradas (FIFO invertido).
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

    property var actionLog: []

    // -------------------------------------------------------------------------
    // Helper JS: centraliza la logica de agregar entradas al log.
    // Reasignar root.actionLog (en vez de solo mutar el array) es necesario
    // para que QML detecte el cambio y actualice los bindings del Repeater.
    // -------------------------------------------------------------------------
    function addLog(action, path) {
        var log = root.actionLog
        var entry = {
            time: new Date().toLocaleTimeString(Qt.locale(), "HH:mm:ss"),
            action: action,
            path: path.toString().replace(/^file:\/\/\//, "")
        }
        log.unshift(entry)
        if (log.length > 8) log.pop()
        root.actionLog = log
    }

    // Cuatro dialogos declarados como componentes no-visuales.
    // Cada uno registra su resultado en el log al ser aceptado.
    FileDialog {
        id: openDlg
        title: "Open"
        fileMode: FileDialog.OpenFile
        onAccepted: root.addLog("Open", selectedFile)
    }

    FileDialog {
        id: saveDlg
        title: "Save"
        fileMode: FileDialog.SaveFile
        nameFilters: ["All files (*)"]
        onAccepted: root.addLog("Save", selectedFile)
    }

    FolderDialog {
        id: folderDlg
        title: "Folder"
        onAccepted: root.addLog("Folder", selectedFolder)
    }

    // OpenFiles: seleccion multiple. El bucle for registra cada archivo
    // como una entrada separada en el log.
    FileDialog {
        id: multiDlg
        title: "Open Multiple"
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            for (var i = 0; i < selectedFiles.length; i++) {
                root.addLog("Multi", selectedFiles[i])
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dialog Actions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Grid 2x2 de botones de accion, cada uno abre un dialogo diferente
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: Style.resize(6)
            columnSpacing: Style.resize(6)

            Button {
                text: "\u2759  Open File"
                Layout.fillWidth: true
                onClicked: openDlg.open()
            }
            Button {
                text: "\u2B73  Save File"
                Layout.fillWidth: true
                onClicked: saveDlg.open()
            }
            Button {
                text: "\u2750  Select Folder"
                Layout.fillWidth: true
                onClicked: folderDlg.open()
            }
            Button {
                text: "\u2630  Open Multiple"
                Layout.fillWidth: true
                onClicked: multiDlg.open()
            }
        }

        // -----------------------------------------------------------------
        // Log de acciones: lista scrolleable con timestamp, badge de tipo
        // y ruta del archivo/carpeta. El boton "Clear" vacia el log.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(2)

                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: "Action Log"
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true
                    }
                    Button {
                        text: "Clear"
                        font.pixelSize: Style.resize(10)
                        enabled: root.actionLog.length > 0
                        onClicked: root.actionLog = []
                    }
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentHeight: logCol.height

                    ColumnLayout {
                        id: logCol
                        width: parent.width
                        spacing: Style.resize(3)

                        Repeater {
                            model: root.actionLog

                            Rectangle {
                                required property var modelData
                                required property int index
                                Layout.fillWidth: true
                                height: Style.resize(36)
                                radius: Style.resize(4)
                                color: index % 2 === 0 ? "#2A2D35" : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    spacing: Style.resize(6)

                                    // Timestamp de la accion
                                    Label {
                                        text: modelData.time
                                        font.pixelSize: Style.resize(10)
                                        color: Style.inactiveColor
                                        Layout.preferredWidth: Style.resize(55)
                                    }

                                    // Badge de tipo: Rectangle con opacity 0.2
                                    // crea un fondo semitransparente del color
                                    // correspondiente, y el Label encima muestra
                                    // el texto con el color solido.
                                    Rectangle {
                                        width: Style.resize(50)
                                        height: Style.resize(18)
                                        radius: Style.resize(3)
                                        color: modelData.action === "Open" ? "#00D1A9"
                                             : modelData.action === "Save" ? "#FEA601"
                                             : modelData.action === "Folder" ? "#4FC3F7"
                                             : "#AB47BC"
                                        opacity: 0.2

                                        Label {
                                            anchors.centerIn: parent
                                            text: modelData.action
                                            font.pixelSize: Style.resize(9)
                                            font.bold: true
                                            color: modelData.action === "Open" ? "#00D1A9"
                                                 : modelData.action === "Save" ? "#FEA601"
                                                 : modelData.action === "Folder" ? "#4FC3F7"
                                                 : "#AB47BC"
                                        }
                                    }

                                    Label {
                                        text: modelData.path
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        elide: Text.ElideMiddle
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        Label {
                            text: "No actions yet"
                            font.pixelSize: Style.resize(12)
                            color: Style.inactiveColor
                            visible: root.actionLog.length === 0
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: Style.resize(20)
                        }
                    }
                }
            }
        }
    }
}
