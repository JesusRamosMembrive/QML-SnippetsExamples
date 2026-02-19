// =============================================================================
// MapInfoPanel.qml — Panel de informacion de vuelo (overlay HUD)
// =============================================================================
// Panel semitransparente posicionado en la esquina superior derecha del mapa.
// Muestra datos de vuelo en tiempo real: heading, coordenadas, waypoint
// actual, segmento y velocidad de simulacion.
//
// Patrones y conceptos clave:
// - Overlay con fondo semitransparente: Qt.rgba(0,0,0,0.7) sobre el mapa.
// - Fuente monoespaciada (font.family: "monospace") para que los datos
//   numericos se alineen correctamente en columnas.
// - implicitHeight basado en el contenido: el panel se autoajusta segun
//   cuantas filas de datos tiene, sin necesidad de altura fija.
// - Todas las properties son de solo lectura (recibidas del padre),
//   haciendo este componente puramente presentacional.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    property real aircraftHeading: 0
    property real aircraftLat: 0
    property real aircraftLon: 0
    property int currentSegment: 0
    property var waypoints: []
    property real simSpeed: 1.0

    // Posicionamiento como overlay en la esquina superior derecha.
    // Usa anchors al parent (mapContainer) para mantenerse en su lugar
    // independientemente del tamano del mapa.
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: Style.resize(12)
    width: Style.resize(190)
    implicitHeight: infoColumn.implicitHeight + Style.resize(20)
    color: Qt.rgba(0, 0, 0, 0.7)
    radius: Style.resize(8)

    // ── Datos de vuelo ──────────────────────────────────────────
    // Formato estilo cockpit: etiqueta de 3-4 caracteres + valor alineado.
    // padStart(3, "0") formatea el heading como 001, 045, 270 (estandar aeronautico).
    // toFixed(4) para coordenadas muestra precision de ~11 metros.
    ColumnLayout {
        id: infoColumn
        anchors.fill: parent
        anchors.margins: Style.resize(10)
        spacing: Style.resize(3)

        Label {
            text: "Flight Info"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "HDG  " + Math.round(root.aircraftHeading).toString().padStart(3, "0") + "\u00B0"
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "#00FF00"
        }

        Label {
            text: "LAT  " + root.aircraftLat.toFixed(4)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "LON  " + root.aircraftLon.toFixed(4)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "WPT  " + (root.currentSegment < root.waypoints.length
                ? root.waypoints[root.currentSegment].name : "---")
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "#00FF00"
        }

        Label {
            text: "SEG  " + (root.currentSegment + 1) + "/" + (root.waypoints.length - 1)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "SPD  " + root.simSpeed.toFixed(0) + "x"
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }
    }
}
