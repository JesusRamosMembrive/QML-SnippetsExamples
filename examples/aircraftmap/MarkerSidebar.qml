// =============================================================================
// MarkerSidebar.qml — Panel lateral con filtros y lista de marcadores
// =============================================================================
// Sidebar que combina filtros por categoria (CheckBox) con una lista
// desplazable de todos los marcadores. Al hacer clic en un marcador,
// emite una signal para que el visor centre la vista en el.
//
// Patrones y conceptos clave:
// - pragma ComponentBehavior: Bound — exige que cada delegate declare
//   explicitamente las propiedades del modelo que usa (required property).
//   Esto mejora la seguridad de tipos y el rendimiento en Qt 6.
// - Filtrado visual: los delegates se ocultan (visible: false) segun la
//   categoria, pero siguen en el modelo. implicitHeight: 0 cuando no
//   es visible evita que dejen espacio en blanco en la lista.
// - CheckBox con palette.highlight: personaliza el color del indicador
//   para que coincida con el color de la categoria que controla.
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

    property var markerModel
    property int selectedMarker: -1

    // Flags de visibilidad por categoria. Cada uno controla si los marcadores
    // de esa categoria se muestran en la lista y en el visor.
    // Se exponen como properties publicas para que el padre las pase al visor.
    property bool showExits:     true
    property bool showHydraulic: true
    property bool showEmergency: true
    property bool showFuel:      true
    property bool showAvionics:  true


    signal markerClicked(int index)

    // Funcion helper que traduce el nombre de categoria a su flag de visibilidad.
    // Centraliza la logica en un solo lugar en vez de repetir ifs en cada delegate.
    function isCategoryVisible(cat) {
        if (cat === "exits")     return showExits
        if (cat === "hydraulic") return showHydraulic
        if (cat === "emergency") return showEmergency
        if (cat === "fuel")      return showFuel
        if (cat === "avionics")  return showAvionics
        return true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(12)
        spacing: Style.resize(10)

        // ── Seccion de filtros ──────────────────────────────────
        // Cada CheckBox usa palette.highlight para colorear su indicador
        // con el color de la categoria correspondiente, creando una
        // asociacion visual inmediata entre filtro y marcadores.
        Label {
            text: "Filters"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        CheckBox { text: "Exits";     checked: root.showExits;     onToggled: root.showExits = checked
            palette.highlight: "#4CAF50" }
        CheckBox { text: "Hydraulic"; checked: root.showHydraulic; onToggled: root.showHydraulic = checked
            palette.highlight: "#2196F3" }
        CheckBox { text: "Emergency"; checked: root.showEmergency; onToggled: root.showEmergency = checked
            palette.highlight: "#F44336" }
        CheckBox { text: "Fuel";      checked: root.showFuel;      onToggled: root.showFuel = checked
            palette.highlight: "#FF9800" }
        CheckBox { text: "Avionics";  checked: root.showAvionics;  onToggled: root.showAvionics = checked
            palette.highlight: "#9C27B0" }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Style.bgColor
        }

        // ── Lista de marcadores ─────────────────────────────────
        // ListView con delegate que usa required properties (Bound mode).
        // El delegate se oculta si su categoria no esta activa, y usa
        // implicitHeight: 0 para colapsar el espacio del item oculto.
        Label {
            text: "Markers"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        ListView {
            id: markerListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.markerModel
            spacing: Style.resize(2)
            currentIndex: root.selectedMarker

            delegate: Rectangle {
                id: listDelegate

                required property int index
                required property var model

                width: markerListView.width
                height: Style.resize(30)
                radius: Style.resize(4)
                visible: root.isCategoryVisible(listDelegate.model.category)
                color: listDelegate.index === root.selectedMarker
                       ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                implicitHeight: visible ? Style.resize(30) : 0

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(6)
                    anchors.rightMargin: Style.resize(6)
                    spacing: Style.resize(6)
                    visible: listDelegate.visible

                    // Circulo de color que identifica la categoria visualmente
                    Rectangle {
                        Layout.preferredWidth: Style.resize(10)
                        Layout.preferredHeight: width
                        radius: width / 2
                        color: listDelegate.model.color
                    }

                    Label {
                        text: listDelegate.model.name
                        font.pixelSize: Style.resize(12)
                        color: Style.fontPrimaryColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    visible: listDelegate.visible
                    onClicked: root.markerClicked(listDelegate.index)
                }
            }
        }
    }
}
