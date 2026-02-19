// =============================================================================
// Main.qml — Pagina principal de ejemplos de Canvas y Shapes
// =============================================================================
// Punto de entrada de la seccion "Canvas" del dashboard. Organiza los ejemplos
// de dibujo en dos zonas:
//
// 1. GridLayout superior (2x2): cuatro tarjetas didacticas basicas:
//    - Canvas2DCard:      API imperativa de Context2D (primitivas de dibujo)
//    - ShapePathsCard:    Shape declarativo con PathLine, PathArc, PathQuad
//    - GradientsPieCard:  gradientes lineales/radiales + grafico circular
//    - DrawingPadCard:    canvas interactivo para dibujo libre con mouse
//
// 2. Card grande inferior: creaciones avanzadas con Canvas que usan Timer
//    para animaciones en tiempo real (reloj, espirografo, visualizador,
//    radar, arbol fractal, caleidoscopio).
//
// Patron de visibilidad de pagina:
//    fullSize controla si esta pagina esta activa en el Dashboard.
//    opacity + visible con Behavior es el patron estandar del proyecto:
//    se anima la opacidad y se vincula visible a opacity > 0 para que QML
//    no renderice esta pagina cuando no es visible.
//
// Los componentes animados reciben 'active: root.fullSize' para que sus
// Timers solo consuman CPU cuando la pagina esta en pantalla.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Item {
    id: root

    property bool fullSize: false

    // ── Patron de visibilidad animada ──────────────────────────────────────
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
                    text: "Canvas & Shapes Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ── Zona 1: Tarjetas conceptuales basicas ──────────────
                // Cada tarjeta es un componente autocontenido que ensenia un
                // aspecto distinto de Canvas o Shape en QML.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    Canvas2DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    ShapePathsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GradientsPieCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    DrawingPadCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                } // End of GridLayout

                // ═══════════════════════════════════════════════════════
                // Zona 2: Creaciones avanzadas con Canvas
                // ═══════════════════════════════════════════════════════
                // Animaciones en tiempo real que combinan Timer + Canvas.
                // Cada componente tiene su propio boton Start/Pause y
                // recibe 'active' para control de CPU desde el padre.
                // Los Rectangle finos entre secciones son separadores.
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
                            text: "Custom Canvas Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced Canvas techniques: real-time rendering, mathematical curves, simulations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        AnalogClock { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        SpirographGenerator { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        AudioVisualizer { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        RadarSweep { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        FractalTree { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        Kaleidoscope { active: root.fullSize }
                    }
                }
            }
        }
    }
}
