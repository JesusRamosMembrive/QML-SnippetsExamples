// =============================================================================
// Main.qml — Pagina principal de ejemplos de animaciones
// =============================================================================
// Punto de entrada de la seccion "Animations" del dashboard. Organiza todos los
// ejemplos de animacion en dos zonas:
//
// 1. GridLayout superior (2x2): cuatro tarjetas didacticas que ensenan los
//    conceptos fundamentales de animacion en QML:
//    - EasingCurvesCard:         curvas de aceleracion/desaceleracion
//    - SequentialParallelCard:   animaciones secuenciales vs paralelas
//    - BehaviorSpringCard:       Behavior + SpringAnimation reactiva
//    - StatesTransitionsCard:    sistema de estados y transiciones
//
// 2. Card grande inferior: animaciones avanzadas basadas en Canvas + Timer
//    (particulas, orbitas, ondas, Lissajous, pendulo, flip 3D, etc.)
//    Cada sub-seccion tiene controles Start/Stop individuales y un boton
//    global "Start All / Stop All" para activarlas todas a la vez.
//
// Patron de visibilidad de pagina:
//    fullSize controla si esta pagina esta activa en el Dashboard. La opacidad
//    se anima con Behavior, y visible se vincula a opacity > 0 para que QML
//    no renderice la pagina cuando esta completamente oculta.
//
// Patron de activacion de animaciones:
//    Cada sub-componente recibe 'active: root.fullSize' para que sus Timers
//    solo corran cuando la pagina es visible, evitando consumo de CPU en
//    segundo plano. Ademas, 'sectionActive' permite control individual.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Item {
    id: root

    property bool fullSize: false

    // ── Patron de visibilidad animada ──────────────────────────────────────
    // opacity + visible trabajan juntas: la opacidad se anima suavemente con
    // Behavior, y visible se desactiva cuando opacity llega a 0 para que el
    // motor de renderizado no procese este arbol de componentes cuando no
    // esta en pantalla. Esto es un patron comun en todas las paginas del app.
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

                // Header
                Label {
                    text: "Animations Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ── Zona 1: Tarjetas conceptuales basicas ──────────────
                // GridLayout 2x2 con las cuatro tarjetas didacticas. Cada
                // tarjeta es un componente autocontenido que demuestra un
                // concepto fundamental de animacion en QML.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    EasingCurvesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    SequentialParallelCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    BehaviorSpringCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    StatesTransitionsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Zona 2: Animaciones complejas con Canvas
                // ════════════════════════════════════════════════════════
                // Esta seccion contiene animaciones avanzadas que usan el
                // patron Timer + Canvas: un Timer dispara actualizaciones
                // periodicas del estado (posicion, fisica, tiempo) y llama
                // a requestPaint() para redibujar el Canvas. Este enfoque
                // es necesario cuando se animan muchos elementos a la vez
                // (particulas, trazados, etc.) donde crear Items QML
                // individuales seria demasiado costoso en rendimiento.
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        // ── Controles globales Start/Stop ──────────────
                        // Modifican sectionActive de cada sub-componente.
                        // sectionActive es independiente de 'active' (que
                        // depende de fullSize): ambos deben ser true para
                        // que la animacion corra (running: active && sectionActive).
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Label {
                                text: "Custom Complex Animations"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                                Layout.fillWidth: true
                            }

                            Button {
                                text: "\u25B6 Start All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = true
                                    orbitSection.sectionActive = true
                                    waveSection.sectionActive = true
                                    lissajousSection.sectionActive = true
                                    cradleSection.sectionActive = true
                                    breathSection.sectionActive = true
                                    matrixSection.sectionActive = true
                                }
                            }

                            Button {
                                text: "\u25A0 Stop All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = false
                                    orbitSection.sectionActive = false
                                    waveSection.sectionActive = false
                                    lissajousSection.sectionActive = false
                                    cradleSection.sectionActive = false
                                    breathSection.sectionActive = false
                                    matrixSection.sectionActive = false
                                }
                            }
                        }

                        // ── Sub-secciones de animaciones avanzadas ─────
                        // Cada componente recibe active: root.fullSize para
                        // que solo consuma CPU cuando la pagina esta visible.
                        // Los Rectangle delgados entre secciones actuan como
                        // separadores visuales.
                        ParticleFountain { id: particleSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        OrbitalSystem { id: orbitSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        SineWaveBars { id: waveSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        LissajousCurve { id: lissajousSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        NewtonsCradle { id: cradleSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        FlipCards3D { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        StaggeredList { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        BreathingCircles { id: breathSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        MatrixRain { id: matrixSection; active: root.fullSize }
                    }
                }
            }
        }
    }
}
