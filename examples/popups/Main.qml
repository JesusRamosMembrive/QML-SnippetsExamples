// =============================================================================
// Main.qml — Pagina principal de ejemplos de Popups y Dialogs
// =============================================================================
//
// Esta pagina es el punto de entrada de la seccion "Popups & Dialogs" del
// proyecto. Organiza todos los ejemplos de componentes emergentes en un layout
// scrollable con dos zonas:
//
//   1. GridLayout superior (2x2): muestra los 4 tipos nativos de Qt Quick
//      Controls — Dialog, Popup, ToolTip y Menu — cada uno en su propia card.
//
//   2. Seccion inferior "Custom Popup Patterns": contiene patrones avanzados
//      que no son componentes nativos sino implementaciones manuales —
//      ToastNotifications, AlertCards, BottomSheet, Snackbar, FAB y
//      CommandPalette. Estos ensenan como construir comportamientos comunes
//      en apps modernas usando solo QML basico.
//
// PATRON DE NAVEGACION:
// - fullSize controla la visibilidad de la pagina. El Dashboard padre cambia
//   esta propiedad segun el estado del menu lateral.
// - La animacion de opacidad (200ms) suaviza la transicion entre paginas.
// - visible se vincula a opacity > 0 para evitar que el componente consuma
//   recursos de renderizado cuando esta oculto.
//
// LAYOUT:
// - ScrollView envuelve todo el contenido para permitir scroll vertical.
// - contentWidth: availableWidth asegura que el contenido se ajuste al ancho
//   disponible sin generar scroll horizontal.
// - Los separadores (Rectangle de 1px) entre sub-componentes crean division
//   visual dentro de la card grande de patrones personalizados.
//
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // --- Control de visibilidad por pagina ---
    // fullSize es asignado por Dashboard.qml segun el state activo.
    // Este patron permite tener multiples paginas cargadas pero solo una visible.
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

                // Titulo de la seccion
                Label {
                    text: "Popups & Dialogs Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 con los componentes nativos de Qt Quick Controls.
                // Cada card es un archivo QML independiente que demuestra un
                // tipo de componente emergente (Dialog, Popup, ToolTip, Menu).
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    DialogCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    PopupCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ToolTipCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    MenuCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }

                // ════════════════════════════════════════════════════════
                // Seccion de patrones personalizados
                // ════════════════════════════════════════════════════════
                // Esta card grande agrupa implementaciones manuales de patrones
                // de UI que no existen como componentes nativos en Qt Quick
                // Controls. Cada sub-componente es autosuficiente y demuestra
                // un patron comun en apps moviles/desktop modernas.
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3200)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Popup Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        ToastNotifications { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        AlertCards { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        BottomSheet { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        Snackbar { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        FloatingActionButton { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        CommandPalette { }
                    }
                }
            }
        }
    }
}
