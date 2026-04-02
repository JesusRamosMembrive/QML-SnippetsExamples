// =============================================================================
// Main.qml — Página principal del módulo Charts 3D
// =============================================================================
// Muestra tres tipos de gráficos 3D de QtGraphs apilados verticalmente:
//
//   1. Bars3DCard  — Gráfico de barras 3D con datos trimestrales por región.
//      Demuestra CategoryAxis3D (filas y columnas) + ValueAxis3D + Bar3DSeries
//      con ItemModelBarDataProxy para conectar un ListModel a Bars3D.
//
//   2. Scatter3DCard — Scatter plot 3D con dos series superpuestas:
//      nube gaussiana y hélice paramétrica. Usa tres ValueAxis3D independientes
//      (X, Y, Z) y dataArray para carga eficiente de puntos.
//
//   3. Surface3DCard — Superficie matemática interactiva (función f(x,z)).
//      El usuario elige entre 4 funciones, cambia el modo de dibujado
//      (superficie/malla) y ajusta la resolución de la rejilla.
//
// Patrón de visibilidad: igual que todos los módulos del dashboard.
// La propiedad `fullSize` se activa desde Dashboard.qml al navegar a esta página.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

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
                spacing: Style.resize(32)

                // --- Título ---
                Label {
                    text: "Charts 3D"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Gráficos tridimensionales con QtGraphs: barras, scatter y superficie. " +
                          "Todos los gráficos admiten interacción directa (orbitar, zoom, rotar) con ratón o touch."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // --- Barras 3D ---
                Bars3DCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)
                }

                // --- Scatter 3D ---
                Scatter3DCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)
                }

                // --- Superficie 3D ---
                Surface3DCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(520)
                }

                // Espaciador inferior
                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
