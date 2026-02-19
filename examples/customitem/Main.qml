// =============================================================================
// Main.qml — Pagina principal del ejemplo Custom Painted Items (C++ / QML)
// =============================================================================
// Pagina contenedora que organiza cuatro tarjetas que demuestran el uso de
// QQuickPaintedItem: la clase de Qt que permite dibujar graficos 2D con
// QPainter dentro de una escena QML.
//
// Integracion C++ <-> QML:
//   Los tipos AnalogClock, WaveformItem, GaugeItem y DrawCanvas estan
//   definidos en C++ (imports/customitem/) y registrados con QML_ELEMENT.
//   QML los usa como cualquier otro componente nativo, pero internamente
//   el dibujo lo hace QPainter en C++ — mucho mas eficiente que Canvas QML
//   para graficos complejos y renderizado continuo.
//
// Cada tarjeta muestra un caso de uso diferente de QQuickPaintedItem:
//   - PaintedClockCard: reloj analogico (dibujo ciclico + Q_PROPERTY)
//   - WaveformCard: onda sinusoidal animada (QPainterPath)
//   - GaugeCard: medidor circular (drawArc + transformaciones)
//   - InteractiveDrawCard: lienzo de dibujo libre (eventos del mouse)
//
// Patron de navegacion: misma estructura que las demas paginas del proyecto
// (fullSize + opacidad animada + ScrollView con GridLayout 2x2).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patron de visibilidad del proyecto: Dashboard.qml controla
    //    fullSize segun el estado de navegacion actual.
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
                    text: "Custom Painted Items"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- Grid 2x2 con altura minima mayor (480px) porque los
                //    items pintados con QPainter necesitan mas espacio
                //    para ser visualmente claros (reloj, medidores, etc.).
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    PaintedClockCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    WaveformCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    GaugeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    InteractiveDrawCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
