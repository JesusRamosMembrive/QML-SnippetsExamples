// =============================================================================
// ComponentLoaderCard.qml — Control de carga/descarga con Loader.active
// =============================================================================
// Demuestra la propiedad "active" del Loader, que controla si el componente
// está instanciado o no. Cuando active = false, el Loader destruye el item
// y libera toda la memoria asociada. Cuando active = true, lo re-crea.
//
// Esto es fundamental para la gestión de memoria en QML:
// - Loader.active = false → item se destruye, status pasa a Null
// - Loader.active = true  → item se recrea, status pasa a Ready
// - Loader.item es null cuando no hay componente cargado
//
// La barra de estado inferior muestra en tiempo real las propiedades del
// Loader (status, active, item) para que el estudiante observe cómo cambian.
// Los cuatro estados posibles del Loader son: Null, Loading, Ready, Error.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool loaded: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Loader State"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Load/unload component and observe status"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---- Loader con control de active ----
            // La propiedad active está vinculada a root.loaded. Cuando se
            // desactiva, el Loader destruye completamente el árbol de items
            // (el Rectangle + sus hijos). Esto es diferente de solo ocultar
            // con visible: false, que mantiene los objetos en memoria.
            Loader {
                id: stateLoader
                anchors.fill: parent
                active: root.loaded
                sourceComponent: Component {
                    Rectangle {
                        anchors.fill: parent
                        color: Style.surfaceColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(10)

                            Rectangle {
                                width: Style.resize(80)
                                height: Style.resize(80)
                                radius: Style.resize(40)
                                color: "#00D1A9"
                                Layout.alignment: Qt.AlignHCenter

                                Label {
                                    anchors.centerIn: parent
                                    text: "\u2713"
                                    font.pixelSize: Style.resize(36)
                                    color: "#FFFFFF"
                                }
                            }

                            Label {
                                text: "Component Loaded"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Label {
                                text: "Memory allocated for this tree"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            // ---- Estado descargado ----
            // Se muestra cuando el Loader está inactivo. Es un ColumnLayout
            // separado (no dentro del Loader) porque cuando active = false,
            // el contenido del Loader no existe. Este es el patrón típico
            // para mostrar un "placeholder" cuando el contenido real no
            // está cargado.
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(10)
                visible: !root.loaded

                Label {
                    text: "\u2715"
                    font.pixelSize: Style.resize(48)
                    color: Style.inactiveColor
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Component Unloaded"
                    font.pixelSize: Style.resize(16)
                    color: Style.inactiveColor
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Memory freed, no item tree"
                    font.pixelSize: Style.resize(12)
                    color: Style.inactiveColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ---- Barra de estado del Loader ----
        // Muestra las propiedades internas del Loader en tiempo real.
        // - status: Null (0), Ready (1), Loading (2), Error (3)
        // - active: si el Loader está activo
        // - item: si existe el objeto instanciado
        // Los colores refuerzan el significado: verde = Ready, naranja = Error.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(36)
            radius: Style.resize(4)
            color: Style.surfaceColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)

                Label {
                    text: "Status:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                Label {
                    text: stateLoader.status === Loader.Ready ? "Ready"
                        : stateLoader.status === Loader.Loading ? "Loading"
                        : stateLoader.status === Loader.Error ? "Error"
                        : "Null"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: stateLoader.status === Loader.Ready ? "#00D1A9"
                         : stateLoader.status === Loader.Error ? "#FF7043"
                         : Style.inactiveColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: "active: " + stateLoader.active
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                Label {
                    text: "item: " + (stateLoader.item ? "exists" : "null")
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // Botón toggle: el texto cambia según el estado actual
        Button {
            text: root.loaded ? "Unload" : "Load"
            Layout.fillWidth: true
            onClicked: root.loaded = !root.loaded
        }
    }
}
