// =============================================================================
// Main.qml — Pagina principal del modulo de Switches, CheckBoxes y RadioButtons
// =============================================================================
// Esta pagina es el punto de entrada del ejemplo "Switches". Organiza todas las
// tarjetas de demostración en un layout scrollable con dos secciones:
//
// 1. Un GridLayout 2x2 con los controles nativos de Qt Quick Controls:
//    BasicSwitchCard, CheckBoxCard, RadioButtonCard y SmartHomeCard.
// 2. Una tarjeta grande con switches custom construidos desde cero usando
//    Rectangle + MouseArea + animaciones (sin componentes Switch de Qt).
//
// Patron clave: cada componente hijo es autocontenido — tiene su propia logica
// de estado, colores y animaciones. Main.qml solo se encarga del layout.
//
// La propiedad fullSize controla la visibilidad con animacion de opacidad,
// patron estandar de navegacion en este proyecto (ver Dashboard.qml).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de navegacion: fullSize es controlado por Dashboard.qml.
    // Cuando la pagina esta activa, fullSize = true y la opacidad anima a 1.0.
    // visible depende de opacity para evitar renderizar elementos invisibles.
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
        // contentWidth: availableWidth asegura que el contenido ocupe todo el
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

                Label {
                    text: "Switch, CheckBox & RadioButton Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -------------------------------------------------------------
                // Seccion 1: Controles nativos de Qt Quick Controls 2
                // GridLayout 2x2 donde cada tarjeta muestra un tipo de control
                // diferente. Layout.fillWidth + fillHeight permite que las
                // tarjetas se distribuyan equitativamente en el espacio.
                // -------------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicSwitchCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    CheckBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    RadioButtonCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    SmartHomeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }
                }

                // -------------------------------------------------------------
                // Seccion 2: Switches custom — construidos desde cero
                // Esta tarjeta grande contiene 6 sub-componentes separados por
                // lineas divisoras (Rectangle de 1px). Cada uno demuestra una
                // tecnica diferente para crear toggles personalizados:
                // - IconToggles: tarjetas con icono que cambian color de fondo
                // - ColoredTrackSwitches: track + knob animado con colores custom
                // - PillToggles: botones pill con texto ON/OFF
                // - DayNightSwitch: switch tematico con estrellas, sol y luna
                // - LargeKnobToggles: botones circulares grandes con hover/press
                // - SegmentedToggle: selector segmentado tipo iOS
                // -------------------------------------------------------------
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customSwitchesCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customSwitchesCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Styled Switches"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted toggles built from scratch with Rectangle, MouseArea, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // Cada sub-componente esta separado por una linea divisora sutil.
                        // Los Rectangle de 1px con opacity 0.3 crean separacion visual
                        // sin ser demasiado prominentes sobre el fondo oscuro.
                        IconToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        ColoredTrackSwitches {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        PillToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        DayNightSwitch {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        LargeKnobToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        SegmentedToggle {}
                    }
                }
            }
        }
    }
}
