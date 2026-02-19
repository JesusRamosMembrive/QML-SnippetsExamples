// =============================================================================
// KeyValueCard.qml — CRUD genérico de claves con QSettings
// =============================================================================
// Demuestra la API más fundamental de QSettings: setValue(), value() y remove().
// El usuario escribe una clave (con ruta tipo "Group/subkey") y un valor,
// luego puede guardarlo, cargarlo o eliminarlo. Todas las claves existentes
// se muestran en un ListView.
//
// Patrón importante: las claves usan "/" como separador de grupo, igual que
// QSettings nativo (ej. "Custom/myKey" → grupo "Custom", clave "myKey").
//
// pragma ComponentBehavior: Bound refuerza que las propiedades `required` del
// delegate se resuelvan en tiempo de compilación, mejorando la seguridad de
// tipos y el rendimiento.
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

    // keysList almacena un array JS de objetos {key, val}. Se usa un array
    // JS en vez de ListModel porque se reconstruye completamente en cada
    // refresco — más simple y sin problemas de sincronización.
    property var keysList: []

    // ---- Integración C++ ----
    // SettingsManager es un QObject registrado desde C++ que envuelve QSettings.
    // La señal onKeysChanged notifica cuando cualquier clave cambia, lo que
    // permite actualizar la UI de forma reactiva sin polling.
    SettingsManager {
        id: settings
        onKeysChanged: root.refreshKeys()
    }

    Component.onCompleted: refreshKeys()

    // refreshKeys() reconstruye la lista completa de claves.
    // Se itera allKeys() y se crea un array plano — este enfoque es adecuado
    // para un número moderado de claves. Para miles de claves, sería mejor
    // usar un QAbstractListModel desde C++.
    function refreshKeys() {
        var all = settings.allKeys()
        var arr = []
        for (var i = 0; i < all.length; i++) {
            arr.push({
                key: all[i],
                val: settings.getValue(all[i], "").toString()
            })
        }
        keysList = arr
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Key-Value Store"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Generic QSettings setValue / value / remove"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // ---- Campos de entrada ----
        // Dos TextFields lado a lado: clave y valor. El formato de clave
        // soporta notación con "/" para organizar en grupos de QSettings.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: keyField
                Layout.fillWidth: true
                placeholderText: "Key (e.g. Custom/myKey)"
                font.pixelSize: Style.resize(11)
            }

            TextField {
                id: valueField
                Layout.fillWidth: true
                placeholderText: "Value"
                font.pixelSize: Style.resize(11)
            }
        }

        // ---- Botones de acción ----
        // Save → setValue, Load → getValue, Remove → removeKey.
        // Todos deshabilitados si el campo de clave está vacío (enabled binding).
        // Después de Save/Remove se refresca la lista para reflejar el cambio.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Button {
                text: "Save"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    settings.setValue(keyField.text, valueField.text)
                    root.refreshKeys()
                }
            }

            Button {
                text: "Load"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    valueField.text = settings.getValue(keyField.text, "").toString()
                }
            }

            Button {
                text: "Remove"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    settings.removeKey(keyField.text)
                    root.refreshKeys()
                }
            }
        }

        // ---- Lista de claves almacenadas ----
        // ListView con modelo JS array. El delegate usa filas alternadas
        // (index % 2) con un blanco semitransparente para mejorar la
        // legibilidad — un patrón clásico de tablas tipo "zebra striping".
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            ListView {
                id: keyList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: root.keysList
                spacing: Style.resize(2)

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: keyList.width
                    height: Style.resize(26)
                    radius: Style.resize(3)
                    color: index % 2 === 0 ? "#0AFFFFFF" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(8)

                        Label {
                            text: modelData.key
                            font.pixelSize: Style.resize(10)
                            color: Style.mainColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Label {
                            text: modelData.val
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }

            // Estado vacío: mensaje visible solo cuando no hay claves.
            // Este patrón de "empty state" mejora la experiencia del usuario
            // al indicar claramente que la lista está vacía, no rota.
            Label {
                anchors.centerIn: parent
                text: "No settings stored yet"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: root.keysList.length === 0
            }
        }

        Label {
            text: root.keysList.length + " keys stored"
            font.pixelSize: Style.resize(10)
            color: Style.fontSecondaryColor
        }
    }
}
