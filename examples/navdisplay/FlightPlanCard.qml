// =============================================================================
// FlightPlanCard.qml — Tabla interactiva de waypoints del plan de vuelo
// =============================================================================
// Muestra el plan de vuelo en formato tabular con cabecera fija y lista
// desplazable. Permite seleccionar un waypoint con clic para resaltarlo
// en el mapa movil. Demuestra:
// - ListView con delegate personalizado (tabla con columnas alineadas).
// - Comunicacion hijo->padre via signal (waypointSelected).
// - Resaltado condicional: el waypoint seleccionado cambia a cyan,
//   el hover muestra un fondo diferente, y filas alternas usan zebra striping.
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

    // La tarjeta recibe el plan de vuelo y el indice seleccionado desde
    // el padre, y emite una signal cuando el usuario hace clic en un waypoint.
    // Este patron de "datos hacia abajo, eventos hacia arriba" es fundamental
    // en QML para mantener un flujo de datos predecible.
    property var flightPlan: []
    property int selectedWp: -1
    signal waypointSelected(int index)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Flight Plan"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ── Cabecera de la tabla ────────────────────────────────
        // Fila fija con los nombres de columna. Usa RowLayout con
        // preferredWidth para que las columnas se alineen con los datos
        // del delegate. En aviacion: WPT=waypoint, BRG=bearing (rumbo),
        // DIST=distancia, ALT=altitud, ETA=hora estimada de llegada.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(30)
            color: "#2a2a2a"
            radius: Style.resize(4)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(10)
                anchors.rightMargin: Style.resize(10)
                spacing: Style.resize(5)

                Label { text: "WPT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(55) }
                Label { text: "BRG"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(35); horizontalAlignment: Text.AlignRight }
                Label { text: "DIST"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(45); horizontalAlignment: Text.AlignRight }
                Label { text: "ALT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(50); horizontalAlignment: Text.AlignRight }
                Label { text: "ETA"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
            }
        }

        // ── Lista de waypoints ──────────────────────────────────
        // Usa model: flightPlan.length (entero) en lugar de un ListModel
        // porque el plan de vuelo es un array JS. El delegate accede
        // a los datos via root.flightPlan[index].
        ListView {
            id: wpListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.flightPlan.length

            delegate: Rectangle {
                required property int index

                width: wpListView.width
                height: Style.resize(36)

                // Resaltado condicional con tres estados: seleccionado (cyan-oscuro),
                // hover (azul-oscuro), o zebra striping para mejor legibilidad.
                color: {
                    if (index === root.selectedWp) return "#1a3a3a";
                    if (wpMa.containsMouse) return "#1a1a2a";
                    return (index % 2 === 0) ? "#1a1a1a" : "#222222";
                }
                radius: Style.resize(2)

                property var wp: root.flightPlan[index]

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    spacing: Style.resize(5)

                    Label {
                        text: wp.name
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: index === root.selectedWp ? "#00FFFF" : "#00FF00"
                        Layout.preferredWidth: Style.resize(55)
                    }
                    Label {
                        text: wp.brg + "\u00B0"
                        font.pixelSize: Style.resize(12)
                        color: "#AAAAAA"
                        Layout.preferredWidth: Style.resize(35)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.dist + " NM"
                        font.pixelSize: Style.resize(12)
                        color: "#AAAAAA"
                        Layout.preferredWidth: Style.resize(45)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.alt
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF"
                        Layout.preferredWidth: Style.resize(50)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.eta
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                // MouseArea con hoverEnabled para mostrar feedback visual
                // al pasar el raton. El clic emite la signal para que el
                // padre actualice selectedWp globalmente.
                MouseArea {
                    id: wpMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.waypointSelected(index)
                }
            }
        }

        Label {
            text: "Click a waypoint to highlight it on the map (cyan). Shows bearing, distance, altitude, and ETA."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
