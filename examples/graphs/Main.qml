// =============================================================================
// Main.qml — Página principal del módulo de gráficas
// =============================================================================
// Orquesta la disposición de TODOS los ejemplos de gráficas en dos zonas:
//
// 1. GridLayout superior (2x2): Tarjetas que usan QtGraphs (GraphsView,
//    LineSeries, BarSeries). Estas requieren el módulo QtGraphs de Qt 6.
//
// 2. Tarjeta inferior: Gráficas personalizadas dibujadas 100% con Canvas.
//    Demuestra que NO se necesita una librería de gráficas externa para crear
//    visualizaciones complejas (radar, velas, donut, scatter, heatmap).
//
// Patrón clave: La propiedad `active` se propaga a las tarjetas animadas
// para que los Timer/FrameAnimation solo corran cuando la página es visible,
// evitando consumo innecesario de CPU en segundo plano.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patrón de visibilidad compartido por todas las páginas del dashboard.
    // fullSize se controla desde Dashboard.qml según el estado de navegación.
    // La animación de opacidad da una transición suave al cambiar de página.
    // visible depende de opacity para que QML no renderice la página oculta.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView envuelve todo el contenido para permitir scroll vertical.
        // contentWidth: availableWidth asegura que el contenido se adapte al
        // ancho disponible sin generar scroll horizontal.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Título de la página
                Label {
                    text: "Graphs Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // =============================================================
                // Zona 1: Gráficas con QtGraphs (GraphsView)
                // Grid 2x2 con tarjetas interactivas que usan LineSeries y
                // BarSeries del módulo QtGraphs. Las tarjetas animadas reciben
                // `active: root.fullSize` para pausar animaciones cuando la
                // página no está visible.
                // =============================================================
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    VibrationSensorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    ScrollingWaveformCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    BarSeriesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    MultiSeriesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }
                }

                // =============================================================
                // Zona 2: Gráficas personalizadas con Canvas
                // Todas estas gráficas se dibujan manualmente usando la API
                // Canvas 2D de QML (equivalente a HTML5 Canvas). Esto permite
                // crear cualquier visualización sin dependencias externas.
                // Los separadores (Rectangle de 1px) dividen visualmente
                // cada ejemplo dentro de la tarjeta contenedora.
                // =============================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Graph Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Canvas-based charts: system monitor, radar, candlestick, donut, scatter, heatmap"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        SystemMonitor { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        RadarChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        CandlestickChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        DonutChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ScatterPlot { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        HeatmapChart { }
                    }
                }
            }
        }
    }
}
