// =============================================================================
// BottomSheet.qml — Panel deslizante inferior tipo Material Design
// =============================================================================
// Implementa un "bottom sheet" — un panel que se desliza desde la parte
// inferior, patron comun en apps moviles para menus de compartir, seleccion
// de opciones o configuracion rapida.
//
// CONCEPTOS CLAVE:
//
// 1. Animacion de deslizamiento con anchors + Behavior:
//    - El sheet se posiciona con "y" relativo al parent. Cuando esta cerrado,
//      y = parent.height (fuera de vista por abajo). Cuando se abre,
//      y = parent.height - height (visible en la parte inferior).
//    - Behavior on y con Easing.OutCubic da una desaceleracion suave.
//
// 2. Overlay de oscurecimiento (dim overlay):
//    - Un Rectangle semitransparente (rgba 0,0,0,0.4) cubre el fondo.
//    - Su opacity se anima con el estado open/close.
//    - visible: opacity > 0 evita capturar eventos cuando es invisible.
//    - Un MouseArea en el overlay permite cerrar al hacer clic fuera del sheet.
//
// 3. Drag handle visual:
//    - La barra horizontal gris en la parte superior del sheet es una convencion
//      visual que indica al usuario que el panel es arrastrable (aunque aqui
//      la interaccion es solo por clic, no por drag real).
//
// 4. Repeater con modelo de opciones:
//    - Las opciones de compartir se definen como array de objetos con nombre,
//      icono y color. Cada una se renderiza como boton circular con label.
//    - scale + Behavior on scale crea un efecto de hover sutil al pasar el mouse.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Bottom Sheet"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: bottomSheetSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(350)
        clip: true

        property bool sheetOpen: false

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Contenido de fondo: visible cuando el sheet esta cerrado.
        // Contiene el boton que abre el bottom sheet.
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(15)

            Label {
                text: "Main Content Area"
                font.pixelSize: Style.resize(16)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Open Bottom Sheet"
                Layout.alignment: Qt.AlignHCenter
                onClicked: bottomSheetSection.sheetOpen = true
            }
        }

        // Overlay de oscurecimiento: capa semitransparente que indica
        // que hay contenido modal activo. El clic en el overlay cierra el sheet.
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.4)
            opacity: bottomSheetSection.sheetOpen ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 200 } }

            MouseArea {
                anchors.fill: parent
                onClicked: bottomSheetSection.sheetOpen = false
            }
        }

        // Sheet deslizante: se posiciona fuera de la vista (y = parent.height)
        // cuando esta cerrado. Al abrirse, y se anima hasta quedar visible.
        // radius superior da la apariencia de panel redondeado tipo Material.
        Rectangle {
            id: bottomSheet
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Style.resize(240)
            radius: Style.resize(16)
            color: Style.cardColor
            y: bottomSheetSection.sheetOpen
               ? parent.height - height
               : parent.height

            Behavior on y {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(16)
                spacing: Style.resize(12)

                // Drag handle visual: convencion de UI movil que indica arrastre.
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: Style.resize(40)
                    height: Style.resize(4)
                    radius: Style.resize(2)
                    color: Qt.rgba(1, 1, 1, 0.2)
                }

                Label {
                    text: "Share with"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                // Opciones de compartir: Repeater genera un boton circular por cada
                // opcion. El modelo define nombre, icono Unicode y color de fondo.
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(15)
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: [
                            { name: "Email", icon: "✉", clr: "#5B8DEF" },
                            { name: "Link", icon: "🔗", clr: "#00D1A9" },
                            { name: "Twitter", icon: "𝕏", clr: "#1DA1F2" },
                            { name: "Slack", icon: "#", clr: "#E01E5A" },
                            { name: "Save", icon: "💾", clr: "#FF9500" }
                        ]

                        delegate: ColumnLayout {
                            id: shareDelegate
                            required property var modelData
                            spacing: Style.resize(6)

                            Rectangle {
                                Layout.preferredWidth: Style.resize(48)
                                Layout.preferredHeight: Style.resize(48)
                                Layout.alignment: Qt.AlignHCenter
                                radius: Style.resize(12)
                                color: Qt.rgba(
                                    Qt.color(shareDelegate.modelData.clr).r,
                                    Qt.color(shareDelegate.modelData.clr).g,
                                    Qt.color(shareDelegate.modelData.clr).b, 0.15)

                                scale: shareMa.containsMouse ? 1.15 : 1.0
                                Behavior on scale { NumberAnimation { duration: 100 } }

                                Label {
                                    anchors.centerIn: parent
                                    text: shareDelegate.modelData.icon
                                    font.pixelSize: Style.resize(20)
                                }

                                MouseArea {
                                    id: shareMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: bottomSheetSection.sheetOpen = false
                                }
                            }

                            Label {
                                text: shareDelegate.modelData.name
                                font.pixelSize: Style.resize(10)
                                color: Style.fontSecondaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }

                // Action buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Button {
                        text: "Copy Link"
                        Layout.fillWidth: true
                        onClicked: bottomSheetSection.sheetOpen = false
                    }

                    Button {
                        text: "Cancel"
                        flat: true
                        Layout.fillWidth: true
                        onClicked: bottomSheetSection.sheetOpen = false
                    }
                }
            }
        }
    }
}
