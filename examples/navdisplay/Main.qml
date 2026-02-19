// =============================================================================
// Main.qml — Pagina principal del Navigation Display
// =============================================================================
// Simula un Navigation Display (ND) de aviacion real con cuatro paneles
// interconectados: mapa movil, plan de vuelo, rosa de los vientos y controles
// de modo/rango. Demuestra como gestionar estado compartido entre multiples
// componentes hijos usando properties en el nivel raiz.
//
// Patrones clave:
// - Estado centralizado: flightPlan y selectedWp viven en root y se pasan
//   como properties a cada tarjeta, garantizando sincronizacion.
// - GridLayout 2x2 para distribuir los cuatro paneles de forma responsiva.
// - Cada tarjeta es un componente independiente y reutilizable.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // Patron de visibilidad del dashboard: fullSize controla si esta pagina
    // esta activa. La animacion de opacidad da una transicion suave al
    // cambiar entre paginas del menu lateral.
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // ── Estado compartido ───────────────────────────────────────
    // selectedWp es el indice del waypoint seleccionado. Al ser -1 indica
    // que no hay seleccion. Todos los paneles leen este valor para resaltar
    // el waypoint activo de forma coordinada.
    property int selectedWp: -1

    // Plan de vuelo simulado con datos tipicos de aviacion: nombre del fix,
    // rumbo (bearing), distancia en millas nauticas, nivel de vuelo y ETA.
    // Se define aqui para que todos los paneles accedan a la misma fuente de datos.
    property var flightPlan: [
        { name: "DEPART", brg: 0,   dist: 0,   alt: "----",  eta: "--:--" },
        { name: "MOPAR",  brg: 25,  dist: 12,  alt: "FL120", eta: "00:04" },
        { name: "OKRIX",  brg: 40,  dist: 28,  alt: "FL240", eta: "00:09" },
        { name: "VESAN",  brg: 15,  dist: 52,  alt: "FL350", eta: "00:18" },
        { name: "LARAN",  brg: 355, dist: 85,  alt: "FL370", eta: "00:28" },
        { name: "ASTER",  brg: 340, dist: 120, alt: "FL370", eta: "00:35" },
        { name: "ARRIV",  brg: 330, dist: 160, alt: "FL180", eta: "00:45" }
    ]

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "Navigation Display"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ── Grid de 4 paneles ───────────────────────────────
                // GridLayout 2x2 organiza los paneles como en un cockpit real:
                // [Mapa Movil]    [Plan de Vuelo]
                // [Compas]        [Modo y Rango]
                // Cada panel se comunica con los demas via bindings declarativos.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // Mapa movil: lee rango y modo desde ModeRangeCard.
                    // Su heading (calculado desde el slider interno) se
                    // propaga a CompassRoseCard y ModeRangeCard.
                    MovingMapCard {
                        id: movingMap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        currentRange: modeRange.currentRange
                        ndMode: modeRange.ndMode
                        selectedWp: root.selectedWp
                        flightPlan: root.flightPlan
                    }

                    // Plan de vuelo: emite waypointSelected cuando el
                    // usuario hace clic, lo que actualiza root.selectedWp
                    // y resalta el waypoint en el mapa.
                    FlightPlanCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        flightPlan: root.flightPlan
                        selectedWp: root.selectedWp
                        onWaypointSelected: (index) => root.selectedWp = index
                    }

                    // Rosa de los vientos: visualiza el heading actual
                    // como una brujula giratoria dibujada con Canvas.
                    CompassRoseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        heading: movingMap.heading
                    }

                    // Panel de modo y rango: controla ROSE/ARC/PLAN/VOR
                    // y la escala del mapa. Tambien muestra un resumen de estado.
                    ModeRangeCard {
                        id: modeRange
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        heading: movingMap.heading
                        flightPlan: root.flightPlan
                    }
                }
            }
        }
    }
}
