// =============================================================================
// Main.qml — Pagina principal de ejemplos de Dials & Indicators
// =============================================================================
// Esta pagina es el punto de entrada para todos los ejemplos de indicadores.
// Organiza los componentes en dos secciones:
//   1) Un GridLayout 2x2 con controles nativos de Qt (Dial, ProgressBar,
//      BusyIndicator) y una demo interactiva de monitor de sistema.
//   2) Un bloque grande con indicadores personalizados dibujados con Canvas
//      y tecnicas avanzadas (velocimetro, tacometro, bateria, termometro, etc.)
//
// Patron clave: cada sub-componente es un archivo QML independiente, lo que
// permite reutilizarlos y mantenerlos por separado. La propiedad "fullSize"
// controla la visibilidad con animacion de opacidad — patron estandar del
// proyecto para las transiciones de pagina del Dashboard.
//
// Algunos componentes reciben "active: root.fullSize" para que sus Timers
// y animaciones solo corran cuando la pagina esta visible, ahorrando CPU.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    // ── Patron de visibilidad animada ──
    // Cuando fullSize cambia, la opacidad transiciona suavemente en 200ms.
    // visible se vincula a opacity > 0 para que el Item no consuma eventos
    // de raton ni recursos de renderizado cuando esta completamente oculto.
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

        // ── ScrollView con contenido vertical ──
        // contentWidth: availableWidth asegura que el contenido ocupe todo
        // el ancho disponible sin scroll horizontal, solo vertical.
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
                    text: "Dials & Indicators Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ── Seccion 1: Controles nativos de Qt Quick Controls ──
                // GridLayout 2x2 con tarjetas individuales. Cada tarjeta
                // demuestra un control nativo (Dial, ProgressBar, BusyIndicator)
                // con variantes y configuraciones distintas.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    DialCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ProgressBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    BusyIndicatorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    // SystemMonitorCard recibe "active" para que su Timer
                    // de simulacion de CPU solo corra cuando la pagina es visible.
                    SystemMonitorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        active: root.fullSize
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Seccion 2: Indicadores personalizados (Canvas y QML puro)
                // ════════════════════════════════════════════════════════
                // Esta tarjeta grande agrupa todos los indicadores custom.
                // Cada uno es un componente independiente separado por
                // lineas divisorias (Rectangles de 1px de alto).
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Indicators & Gauges"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        SpeedometerGauge { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        CircularProgressRings { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        BatteryIndicator { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        SignalStrength { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        Thermometer { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        VuLevelMeter { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        RpmTachometer { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        StepProgress { }
                    }
                }
            }
        }
    }
}
