// =============================================================================
// Main.qml — Pagina principal del Aircraft Blueprint (plano del avion)
// =============================================================================
// Visor interactivo de un plano tecnico de avion con marcadores de sistemas.
// Permite explorar la ubicacion de salidas de emergencia, sistemas hidraulicos,
// equipamiento de emergencia, tanques de combustible y avionica.
//
// Patrones clave:
// - ListModel como fuente de datos centralizada con multiples campos
//   (nombre, categoria, color, posicion normalizada, descripcion).
// - Arquitectura sidebar + visor: la sidebar filtra y lista marcadores,
//   el visor los muestra sobre la imagen del plano.
// - Comunicacion bidireccional: clic en sidebar centra el visor en el
//   marcador; clic en visor actualiza selectedMarker globalmente.
// - Posiciones normalizadas (0.0-1.0) para que los marcadores se adapten
//   a cualquier tamano de imagen sin coordenadas absolutas.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // Patron de visibilidad del dashboard
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // ── Estado compartido ───────────────────────────────────────
    // Un unico indice de seleccion centralizado. Tanto la sidebar como
    // el visor leen y escriben este valor para mantenerse sincronizados.
    property int selectedMarker: -1

    // ── Modelo de datos de marcadores ───────────────────────────
    // ListModel permite acceso por indice y roles tipados, ideal para
    // ListView y Repeater. Cada marcador tiene:
    // - posX/posY: posicion normalizada (0-1) sobre la imagen del plano.
    // - category: para filtrado por grupo (usada por los CheckBox).
    // - color: cada categoria tiene su propio color Material Design.
    ListModel {
        id: markerModel

        // Salidas de emergencia (verde)
        ListElement { name: "Exit L1";         category: "exits";     color: "#4CAF50"; posX: 0.42; posY: 0.295; description: "Forward left passenger door. Type I exit." }
        ListElement { name: "Exit R1";         category: "exits";     color: "#4CAF50"; posX: 0.58; posY: 0.295; description: "Forward right passenger door. Type I exit." }
        ListElement { name: "Exit L2";         category: "exits";     color: "#4CAF50"; posX: 0.38; posY: 0.46;  description: "Over-wing left exit. Type III exit." }
        ListElement { name: "Exit R2";         category: "exits";     color: "#4CAF50"; posX: 0.62; posY: 0.46;  description: "Over-wing right exit. Type III exit." }
        ListElement { name: "Rear Exit";       category: "exits";     color: "#4CAF50"; posX: 0.50; posY: 0.62;  description: "Aft ventral airstair exit." }

        // Sistemas hidraulicos (azul)
        ListElement { name: "Hydraulic Sys A"; category: "hydraulic"; color: "#2196F3"; posX: 0.45; posY: 0.52;  description: "Primary hydraulic system. Powers flight controls and landing gear." }
        ListElement { name: "Hydraulic Sys B"; category: "hydraulic"; color: "#2196F3"; posX: 0.55; posY: 0.52;  description: "Secondary hydraulic system. Backup for flight controls." }
        ListElement { name: "Standby Hyd";     category: "hydraulic"; color: "#2196F3"; posX: 0.50; posY: 0.55;  description: "Standby hydraulic system. Emergency power for rudder and thrust reversers." }

        // Equipamiento de emergencia (rojo)
        ListElement { name: "First Aid Fwd";   category: "emergency"; color: "#F44336"; posX: 0.46; posY: 0.32;  description: "Forward first aid kit. Located in overhead bin near L1 door." }
        ListElement { name: "Fire Ext Fwd";    category: "emergency"; color: "#F44336"; posX: 0.54; posY: 0.32;  description: "Forward fire extinguisher. Halon 1211 type, 2.5 lb." }
        ListElement { name: "First Aid Aft";   category: "emergency"; color: "#F44336"; posX: 0.46; posY: 0.58;  description: "Aft first aid kit. Located near rear galley area." }
        ListElement { name: "Fire Ext Aft";    category: "emergency"; color: "#F44336"; posX: 0.54; posY: 0.58;  description: "Aft fire extinguisher. Halon 1211 type, 2.5 lb." }
        ListElement { name: "ELT";             category: "emergency"; color: "#F44336"; posX: 0.50; posY: 0.60;  description: "Emergency Locator Transmitter. Activates on impact or manually." }

        // Tanques de combustible (naranja)
        ListElement { name: "Center Tank";     category: "fuel";      color: "#FF9800"; posX: 0.50; posY: 0.42;  description: "Center fuel tank. Capacity: 4,720 gallons. Used first in flight." }
        ListElement { name: "Left Wing Tank";  category: "fuel";      color: "#FF9800"; posX: 0.28; posY: 0.44;  description: "Left wing fuel tank. Capacity: 1,800 gallons." }
        ListElement { name: "Right Wing Tank"; category: "fuel";      color: "#FF9800"; posX: 0.72; posY: 0.44;  description: "Right wing fuel tank. Capacity: 1,800 gallons." }

        // Avionica (morado)
        ListElement { name: "FMC";             category: "avionics";  color: "#9C27B0"; posX: 0.48; posY: 0.27;  description: "Flight Management Computer. Navigation, performance, and route management." }
        ListElement { name: "Weather Radar";   category: "avionics";  color: "#9C27B0"; posX: 0.50; posY: 0.24;  description: "Weather radar antenna in nose cone. Range up to 320 NM." }
        ListElement { name: "Radio Stack";     category: "avionics";  color: "#9C27B0"; posX: 0.52; posY: 0.27;  description: "VHF comm, VHF nav, ADF, transponder, and DME equipment." }
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(15)

            Label {
                text: "Aircraft Blueprint"
                font.pixelSize: Style.resize(32)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            // ── Layout principal: sidebar + visor ───────────────
            // RowLayout divide el espacio horizontal: la sidebar tiene
            // ancho fijo (preferredWidth), el visor ocupa el resto (fillWidth).
            // Ambos comparten el mismo markerModel y selectedMarker.
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(15)

                // Sidebar: filtros por categoria y lista de marcadores.
                // Cuando el usuario hace clic en un marcador de la lista,
                // se invoca viewer.centerOnMarker() para centrar la vista.
                MarkerSidebar {
                    id: sidebar
                    Layout.preferredWidth: Style.resize(230)
                    Layout.fillHeight: true
                    markerModel: markerModel
                    selectedMarker: root.selectedMarker
                    onMarkerClicked: (index) => viewer.centerOnMarker(index)
                }

                // Visor del plano: imagen con zoom/pan y marcadores superpuestos.
                // Los filtros de visibilidad vienen de la sidebar (showExits, etc.).
                // Las signals markerSelected/deselected fluyen hacia arriba para
                // actualizar root.selectedMarker.
                BlueprintViewer {
                    id: viewer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    markerModel: markerModel
                    selectedMarker: root.selectedMarker
                    showExits: sidebar.showExits
                    showHydraulic: sidebar.showHydraulic
                    showEmergency: sidebar.showEmergency
                    showFuel: sidebar.showFuel
                    showAvionics: sidebar.showAvionics
                    onMarkerSelected: (index) => root.selectedMarker = index
                    onDeselected: root.selectedMarker = -1
                }
            }
        }
    }
}
