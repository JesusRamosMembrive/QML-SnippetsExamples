// =============================================================================
// SettingsInfoCard.qml — Inspector de QSettings: grupos, claves y ruta
// =============================================================================
// Herramienta de introspección que muestra la estructura interna de QSettings.
// Permite ver:
//   - La ruta física del archivo .ini / registro donde se guardan los settings
//   - Los grupos (childGroups) organizados jerárquicamente
//   - Las claves dentro de cada grupo con sus valores actuales
//
// Útil para debugging y para entender cómo QSettings organiza internamente
// los datos. En Windows usa el registro (HKEY_CURRENT_USER), en Linux usa
// archivos .conf en ~/.config/, y el método settingsPath() del wrapper C++
// expone esta ubicación.
//
// Patrón de Repeater anidado: un Repeater externo itera sobre los grupos,
// y dentro de cada grupo un Repeater interno itera sobre las claves. Esto
// crea una vista tipo árbol sin necesidad de un TreeView completo.
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

    // Array JS de objetos { group: string, items: [{key, val}] }.
    // Se reconstruye con refreshGroups() — mismo patrón que KeyValueCard.
    property var groupsList: []

    SettingsManager {
        id: settings
        onKeysChanged: root.refreshGroups()
    }

    Component.onCompleted: refreshGroups()

    // refreshGroups() construye la estructura jerárquica grupo → claves.
    // Usa childGroups() para obtener los nombres de grupo, luego
    // keysInGroup() para las claves de cada grupo. La clave completa
    // se reconstruye como "grupo/clave" para leer el valor con getValue().
    function refreshGroups() {
        var groups = settings.childGroups()
        var arr = []
        for (var i = 0; i < groups.length; i++) {
            var keys = settings.keysInGroup(groups[i])
            var items = []
            for (var j = 0; j < keys.length; j++) {
                var fullKey = groups[i] + "/" + keys[j]
                items.push({
                    key: keys[j],
                    val: settings.getValue(fullKey, "").toString()
                })
            }
            arr.push({ group: groups[i], items: items })
        }
        groupsList = arr
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Settings Inspector"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Browse groups, keys, and storage location"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // ---- Ruta de almacenamiento ----
        // Muestra dónde QSettings guarda los datos en el sistema de archivos.
        // elide: Text.ElideMiddle es ideal para rutas largas porque preserva
        // tanto el inicio como el final de la ruta.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(32)
            radius: Style.resize(4)
            color: Style.surfaceColor

            Label {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                text: settings.settingsPath()
                font.pixelSize: Style.resize(9)
                color: Style.fontSecondaryColor
                elide: Text.ElideMiddle
                verticalAlignment: Text.AlignVCenter
            }
        }

        // ---- Navegador de grupos ----
        // Flickable (en vez de ListView) porque el contenido usa Repeaters
        // anidados que generan un layout variable. ListView requiere delegates
        // de altura uniforme, mientras que Flickable + ColumnLayout se adapta
        // a contenido de altura variable.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                contentHeight: groupsCol.implicitHeight
                clip: true

                ColumnLayout {
                    id: groupsCol
                    width: parent.width
                    spacing: Style.resize(8)

                    // Repeater externo: un ColumnLayout por cada grupo
                    Repeater {
                        model: root.groupsList

                        ColumnLayout {
                            required property var modelData
                            required property int index
                            Layout.fillWidth: true
                            spacing: Style.resize(2)

                            // Encabezado de grupo con formato tipo INI: [NombreGrupo]
                            Label {
                                text: "[" + modelData.group + "]"
                                font.pixelSize: Style.resize(12)
                                font.bold: true
                                color: "#4FC3F7"
                            }

                            // Repeater interno: las claves dentro de este grupo,
                            // indentadas con leftMargin para comunicar la jerarquía
                            Repeater {
                                model: modelData.items

                                RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.leftMargin: Style.resize(12)
                                    spacing: Style.resize(8)

                                    Label {
                                        text: modelData.key + ":"
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        Layout.preferredWidth: Style.resize(90)
                                    }

                                    Label {
                                        text: modelData.val
                                        font.pixelSize: Style.resize(10)
                                        color: Style.mainColor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        text: "No settings groups found"
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF30"
                        visible: root.groupsList.length === 0
                    }
                }
            }
        }

        // ---- Barra de acciones ----
        // Refresh fuerza una recarga manual (útil si otro proceso modificó
        // el archivo de settings). Clear All borra TODO — acción destructiva
        // que en producción debería tener un diálogo de confirmación.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Refresh"
                implicitHeight: Style.resize(32)
                onClicked: root.refreshGroups()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: settings.allKeys().length + " total keys"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Button {
                text: "Clear All Settings"
                implicitHeight: Style.resize(32)
                onClicked: {
                    settings.clearAll()
                    root.refreshGroups()
                }
            }
        }
    }
}
