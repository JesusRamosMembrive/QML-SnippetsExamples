// =============================================================================
// Main.qml — Pagina principal del modulo Toasts
// =============================================================================
// Presenta una pagina dedicada al patron de notificaciones temporales tipo
// React: un host central con API imperativa, cola de mensajes y posiciones
// configurables. La idea es mostrar un flujo parecido a librerias como
// react-hot-toast o sonner, pero implementado solo con QML.
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
                spacing: Style.resize(24)

                Label {
                    text: "Toasts Showcase"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Un patron muy de frontend web: host central, API imperativa y notificaciones efimeras con cola, accion y auto-dismiss."
                    wrapMode: Text.WordWrap
                    font.pixelSize: Style.resize(15)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: scrollView.availableWidth > Style.resize(1180) ? 2 : 1
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    ToastPlaygroundCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(520)
                    }

                    ToastQueueCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(520)
                    }
                }

                ToastApiCard {
                    Layout.fillWidth: true
                    Layout.minimumHeight: Style.resize(420)
                }
            }
        }
    }
}
