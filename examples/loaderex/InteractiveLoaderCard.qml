// =============================================================================
// InteractiveLoaderCard.qml — View Switcher tipo tabs con Loader
// =============================================================================
// Implementa un patrón de navegación por pestañas donde cada pestaña carga
// un componente diferente a través de un Loader. Es el patrón más común
// para interfaces con múltiples vistas donde solo una está activa a la vez.
//
// Diferencia con BasicLoaderCard: aquí se permite estado "vacío" (ningún
// componente cargado, sourceComponent = null), lo cual es útil para
// interfaces donde el usuario puede cerrar la vista activa.
//
// Patrón toggle: al hacer clic en la pestaña activa, se deselecciona
// (currentView vuelve a -1). Esto permite al usuario "cerrar" la vista
// sin necesidad de un botón de cierre explícito.
//
// Cada componente simula una vista real (Profile, Settings, Stats)
// demostrando que el Loader puede cargar contenido arbitrariamente complejo.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -1 = ninguna vista seleccionada → sourceComponent será null
    property int currentView: -1

    // ---- Componentes de vista ----
    // Tres componentes que simulan paneles de una app real.
    // Están definidos como Component {} inline para mantener todo
    // autocontenido en este archivo de ejemplo.

    // Vista de perfil de usuario
    Component {
        id: profileComp
        Rectangle {
            color: Style.surfaceColor
            radius: Style.resize(8)
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)
                Rectangle {
                    width: Style.resize(60); height: Style.resize(60)
                    radius: Style.resize(30)
                    color: "#00D1A9"
                    Layout.alignment: Qt.AlignHCenter
                    Label { anchors.centerIn: parent; text: "\u263A"; font.pixelSize: Style.resize(28); color: "#FFFFFF" }
                }
                Label { text: "User Profile"; font.pixelSize: Style.resize(14); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                Label { text: "john@example.com"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
            }
        }
    }

    // Vista de configuración con Switches
    Component {
        id: settingsComp
        Rectangle {
            color: Style.surfaceColor
            radius: Style.resize(8)
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)
                Label { text: "\u2699"; font.pixelSize: Style.resize(40); color: "#FEA601"; Layout.alignment: Qt.AlignHCenter }
                Label { text: "Settings Panel"; font.pixelSize: Style.resize(14); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                Repeater {
                    model: ["Notifications", "Dark Mode", "Auto-save"]
                    RowLayout {
                        required property string modelData
                        Layout.alignment: Qt.AlignHCenter
                        Switch { checked: true; scale: 0.7 }
                        Label { text: modelData; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                    }
                }
            }
        }
    }

    // Vista de estadísticas con Grid 2×2
    Component {
        id: statsComp
        Rectangle {
            color: Style.surfaceColor
            radius: Style.resize(8)
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)
                Label { text: "\u2587"; font.pixelSize: Style.resize(40); color: "#AB47BC"; Layout.alignment: Qt.AlignHCenter }
                Label { text: "Statistics"; font.pixelSize: Style.resize(14); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                Grid {
                    columns: 2; spacing: Style.resize(10); Layout.alignment: Qt.AlignHCenter
                    Repeater {
                        model: [
                            { lbl: "Views", val: "1,234" },
                            { lbl: "Clicks", val: "567" },
                            { lbl: "Users", val: "89" },
                            { lbl: "Rating", val: "4.8" }
                        ]
                        ColumnLayout {
                            required property var modelData
                            spacing: Style.resize(2)
                            Label { text: modelData.val; font.pixelSize: Style.resize(16); font.bold: true; color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                            Label { text: modelData.lbl; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "View Switcher"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---- Barra de pestañas ----
        // ListModel con label e idx. El onClick implementa toggle: si la
        // pestaña ya está seleccionada, la deselecciona (idx → -1).
        // highlighted marca visualmente la pestaña activa.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: ListModel {
                    ListElement { label: "\u263A Profile"; idx: 0 }
                    ListElement { label: "\u2699 Settings"; idx: 1 }
                    ListElement { label: "\u2587 Stats"; idx: 2 }
                }

                Button {
                    required property string label
                    required property int idx
                    text: label
                    font.pixelSize: Style.resize(11)
                    highlighted: root.currentView === idx
                    Layout.fillWidth: true
                    onClicked: root.currentView = (root.currentView === idx) ? -1 : idx
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---- Loader principal ----
            // sourceComponent puede ser null (cuando currentView === -1),
            // lo cual descarga el componente actual. El operador ternario
            // encadenado mapea cada índice a su componente correspondiente.
            Loader {
                id: viewLoader
                anchors.fill: parent
                sourceComponent: root.currentView === 0 ? profileComp
                               : root.currentView === 1 ? settingsComp
                               : root.currentView === 2 ? statsComp
                               : null
            }

            // ---- Estado vacío ----
            // Placeholder visible solo cuando no hay ninguna vista cargada.
            // Está fuera del Loader porque cuando sourceComponent = null,
            // el Loader no tiene contenido que mostrar.
            ColumnLayout {
                anchors.centerIn: parent
                visible: root.currentView === -1
                spacing: Style.resize(8)
                Label { text: "\u25CB"; font.pixelSize: Style.resize(40); color: Style.inactiveColor; Layout.alignment: Qt.AlignHCenter }
                Label { text: "Select a view above"; font.pixelSize: Style.resize(14); color: Style.inactiveColor; Layout.alignment: Qt.AlignHCenter }
                Label { text: "No component loaded"; font.pixelSize: Style.resize(11); color: Style.inactiveColor; Layout.alignment: Qt.AlignHCenter }
            }
        }

        // ---- Barra de estado ----
        // Muestra si el Loader tiene un item cargado. El color cambia
        // dinámicamente según el estado (verde si hay item, gris si no).
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(28)
            radius: Style.resize(4)
            color: Style.surfaceColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                Label {
                    text: "Loader.active: " + viewLoader.active
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: viewLoader.item ? "item loaded" : "item: null"
                    font.pixelSize: Style.resize(11)
                    color: viewLoader.item ? "#00D1A9" : Style.inactiveColor
                }
            }
        }
    }
}
