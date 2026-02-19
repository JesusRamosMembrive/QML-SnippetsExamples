// =============================================================================
// RecentFilesCard.qml — Lista de archivos recientes con QStringList en QSettings
// =============================================================================
// Demuestra cómo almacenar y gestionar una lista ordenada (QStringList) dentro
// de QSettings. El SettingsManager en C++ expone recentFiles como Q_PROPERTY
// de tipo QStringList, con lógica de negocio:
//   - Máximo 10 elementos (los más antiguos se descartan automáticamente)
//   - Orden LIFO (el más reciente primero)
//   - addRecentFile() mueve al inicio si ya existe (evita duplicados)
//
// Este patrón es muy común en aplicaciones reales para "Archivos Recientes",
// "Búsquedas Recientes", "Proyectos Recientes", etc.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import settingsmgr
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    SettingsManager { id: settings }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Recent Files"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QStringList stored in QSettings — max 10 items, newest first"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // ---- Entrada manual ----
        // El TextField soporta tanto clic en "Add" como presionar Enter
        // (onAccepted). Después de agregar, se limpia el campo para facilitar
        // agregar múltiples archivos seguidos.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: fileInput
                Layout.fillWidth: true
                placeholderText: "Enter file path..."
                font.pixelSize: Style.resize(11)
                onAccepted: {
                    if (text !== "") {
                        settings.addRecentFile(text)
                        text = ""
                    }
                }
            }

            Button {
                text: "Add"
                implicitHeight: Style.resize(34)
                onClicked: {
                    if (fileInput.text !== "") {
                        settings.addRecentFile(fileInput.text)
                        fileInput.text = ""
                    }
                }
            }
        }

        // ---- Botones de acceso rápido ----
        // Repeater con un array JS de nombres de archivo comunes. Permite
        // poblar la lista rápidamente para probar el comportamiento.
        // Cada botón construye una ruta ficticia "/home/user/<nombre>".
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: [
                    "project.qml", "main.cpp", "style.css",
                    "config.json", "readme.md"
                ]

                Button {
                    required property string modelData
                    text: modelData
                    implicitHeight: Style.resize(28)
                    font.pixelSize: Style.resize(10)
                    onClicked: settings.addRecentFile("/home/user/" + modelData)
                }
            }
        }

        // ---- Lista de archivos recientes ----
        // El modelo es directamente settings.recentFiles (QStringList expuesta
        // como Q_PROPERTY). QML convierte QStringList a un modelo válido para
        // ListView, donde cada elemento es accesible como modelData (string).
        // HoverHandler proporciona feedback visual sin necesidad de MouseArea.
        // elide: Text.ElideMiddle es ideal para rutas de archivo largas porque
        // preserva tanto el directorio raíz como el nombre del archivo.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            ListView {
                id: fileList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: settings.recentFiles
                spacing: Style.resize(3)

                delegate: Rectangle {
                    required property string modelData
                    required property int index
                    width: fileList.width
                    height: Style.resize(30)
                    radius: Style.resize(4)
                    color: fileHover.hovered ? "#1A00D1A9" : "transparent"

                    HoverHandler { id: fileHover }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(6)

                        Label {
                            text: (index + 1) + "."
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.preferredWidth: Style.resize(20)
                        }

                        Label {
                            text: modelData
                            font.pixelSize: Style.resize(11)
                            color: Style.mainColor
                            Layout.fillWidth: true
                            elide: Text.ElideMiddle
                        }
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: "No recent files"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: settings.recentFiles.length === 0
            }
        }

        // ---- Pie con contador y botón de limpiar ----
        // Item con Layout.fillWidth actúa como spacer flexible para empujar
        // el botón "Clear All" a la derecha.
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: settings.recentFiles.length + " files"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Clear All"
                implicitHeight: Style.resize(28)
                onClicked: settings.clearRecentFiles()
            }
        }
    }
}
