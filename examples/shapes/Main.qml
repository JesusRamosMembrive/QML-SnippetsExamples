// =============================================================================
// Main.qml — Pagina principal del modulo Shapes
// =============================================================================
// Punto de entrada de la seccion "Shapes" del dashboard. Organiza todas las
// tarjetas de ejemplo en un layout scrolleable con dos zonas:
//
//   1. GridLayout superior (2 columnas): tarjetas didacticas individuales que
//      ensenan conceptos fundamentales de QtQuick.Shapes — curvas Bezier,
//      arcos, SVG paths, fill rules, gradientes y animaciones de formas.
//
//   2. Tarjeta inferior de creaciones avanzadas: ejemplos complejos que
//      combinan Canvas 2D con matematicas (engranajes, ADN, osciloscopio,
//      curvas polares, mandalas, blobs liquidos).
//
// PATRON DE NAVEGACION: fullSize controla si esta pagina es la activa.
// Dashboard.qml asigna fullSize segun el estado del menu. La animacion de
// opacidad (200ms) crea una transicion suave al cambiar de seccion.
// visible se vincula a opacity > 0 para que las paginas inactivas no
// consuman recursos de renderizado.
//
// PATRON DE ACTIVACION SELECTIVA: los componentes con animaciones basadas
// en Timer (GearTrain, Oscilloscope, etc.) reciben active: root.fullSize
// para que sus Timers solo corran cuando la pagina es visible. Esto evita
// consumo de CPU innecesario cuando el usuario esta en otra seccion.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    // Patron de visibilidad animada comun a todas las paginas del proyecto.
    // opacity controla la transicion visual; visible evita renderizado en
    // segundo plano de paginas que no se estan mostrando.
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView envuelve todo el contenido porque la tarjeta de
        // creaciones avanzadas es muy alta (~3000px). contentWidth se fija
        // al ancho disponible para que solo haya scroll vertical.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(30)

                // Titulo de la seccion
                Label {
                    text: "Shape Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // =============================================================
                // Grid de tarjetas conceptuales (2 columnas)
                // Cada tarjeta es un componente autocontenido que ensena un
                // aspecto especifico del modulo QtQuick.Shapes. Se usa
                // GridLayout para que las tarjetas se distribuyan en pares.
                // =============================================================
                GridLayout {
                    columns: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BezierCurvesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    ArcsAnglesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    SvgPathsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    FillRulesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    GradientTypesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    AnimatedShapesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }
                }

                // =============================================================
                // Tarjeta de creaciones avanzadas
                // A diferencia de las tarjetas de arriba (que son componentes
                // independientes tipo Rectangle/BaseCard), esta seccion usa un
                // Rectangle contenedor unico con multiples sub-componentes
                // separados por lineas divisoras. Cada sub-componente demuestra
                // una tecnica diferente combinando Canvas con matematicas.
                // =============================================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3000)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Shape Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: gear systems, mathematical curves, scientific visualizations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // Los componentes con Timer reciben active: root.fullSize
                        // para pausar animaciones cuando la pagina no es visible
                        GearTrain { id: gearSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        RoseCurve { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        DnaDoubleHelix { id: dnaSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        Oscilloscope { id: scopeSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        GeometricMandala { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        LiquidBlob { id: blobSection; active: root.fullSize }
                    }
                }
            }
        }
    }
}
