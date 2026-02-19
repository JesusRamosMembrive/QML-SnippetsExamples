// =============================================================================
// CollapsibleSidebar.qml — Sidebar colapsable con animacion
// =============================================================================
// Implementa el patron clasico de barra lateral que se puede expandir o
// colapsar, muy comun en dashboards y aplicaciones de escritorio.
//
// Conceptos clave demostrados:
// 1. Anchoring manual vs Layouts: la barra lateral usa anchors (left, top,
//    bottom) con un width animado, en lugar de un Layout. Esto es
//    intencional porque el ancho cambia con animacion — los Layouts
//    recalculan posiciones sin animacion suave.
//
// 2. Behavior on width: anima el colapso/expansion con Easing.OutCubic
//    (desaceleracion natural). El contenido principal se adapta
//    automaticamente porque su anchor izquierdo esta vinculado al
//    borde derecho del sidebar (anchors.left: sidebarPanel.right).
//
// 3. Doble visibilidad del texto: cuando el sidebar se colapsa, el Label
//    usa TANTO visible: false (para no ocupar espacio en el layout)
//    COMO opacity animada (para un fade out suave). Sin el visible,
//    el texto seguiria ocupando espacio invisible.
//
// 4. Hover con MouseArea: cada item del menu cambia color al pasar el
//    raton (containsMouse), dando retroalimentacion visual inmediata.
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
        text: "Collapsible Sidebar"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: sidebarSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)

        property bool sidebarOpen: true

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            // -----------------------------------------------------------------
            // Panel lateral (sidebar)
            // Usa anchors manuales porque necesitamos animar el width.
            // Con un Layout, el cambio de tamano seria instantaneo.
            // Behavior on width da la transicion suave de 250ms.
            // -----------------------------------------------------------------
            Rectangle {
                id: sidebarPanel
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: sidebarSection.sidebarOpen ? Style.resize(180) : Style.resize(48)
                color: Style.surfaceColor

                Behavior on width {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    spacing: Style.resize(4)

                    // Boton toggle: alterna el estado abierto/cerrado
                    // El icono cambia entre flecha izquierda y derecha
                    Rectangle {
                        Layout.fillWidth: true
                        height: Style.resize(32)
                        radius: Style.resize(6)
                        color: sidebarToggleMa.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

                        Label {
                            anchors.centerIn: parent
                            text: sidebarSection.sidebarOpen ? "\u25C0" : "\u25B6"
                            font.pixelSize: Style.resize(14)
                            color: Style.mainColor
                        }

                        MouseArea {
                            id: sidebarToggleMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sidebarSection.sidebarOpen = !sidebarSection.sidebarOpen
                        }
                    }

                    // ---------------------------------------------------------
                    // Items del menu generados con Repeater + modelo JS
                    // Cada item tiene icono (siempre visible) + texto (se oculta
                    // al colapsar). El primer item (index === 0) tiene un fondo
                    // mas intenso para simular "seleccionado".
                    // ---------------------------------------------------------
                    Repeater {
                        model: [
                            { icon: "\uD83C\uDFE0", label: "Home" },
                            { icon: "\uD83D\uDCCA", label: "Analytics" },
                            { icon: "\uD83D\uDC64", label: "Profile" },
                            { icon: "\u2699", label: "Settings" },
                            { icon: "\uD83D\uDCC1", label: "Files" }
                        ]

                        delegate: Rectangle {
                            id: sidebarItem
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            height: Style.resize(34)
                            radius: Style.resize(6)
                            color: sidebarItemMa.containsMouse
                                   ? Qt.rgba(0, 0.82, 0.66, 0.1)
                                   : sidebarItem.index === 0
                                     ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                     : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                anchors.rightMargin: Style.resize(8)
                                spacing: Style.resize(10)

                                Label {
                                    text: sidebarItem.modelData.icon
                                    font.pixelSize: Style.resize(16)
                                }

                                // El texto se oculta con visible + opacity animada.
                                // visible: false evita que ocupe espacio;
                                // Behavior on opacity da el efecto de fade.
                                Label {
                                    text: sidebarItem.modelData.label
                                    font.pixelSize: Style.resize(12)
                                    color: sidebarItem.index === 0 ? Style.mainColor : Style.fontPrimaryColor
                                    visible: sidebarSection.sidebarOpen
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight

                                    opacity: sidebarSection.sidebarOpen ? 1 : 0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                }
                            }

                            MouseArea {
                                id: sidebarItemMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // -----------------------------------------------------------------
            // Contenido principal
            // Su borde izquierdo esta anclado al borde derecho del sidebar,
            // por lo que se expande automaticamente cuando el sidebar se
            // colapsa. Este es el beneficio de usar anchors: la relacion
            // espacial se mantiene sin codigo adicional.
            // -----------------------------------------------------------------
            Rectangle {
                anchors.left: sidebarPanel.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: Style.resize(8)
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Style.resize(8)

                    Label {
                        text: "Dashboard Content"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    // Tarjetas de estadisticas generadas con Repeater
                    // Cada tarjeta usa fillWidth para repartir el espacio
                    // equitativamente entre las 3
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(6)

                        Repeater {
                            model: [
                                { label: "Users", val: "1,247", clr: "#5B8DEF" },
                                { label: "Revenue", val: "$8.4k", clr: "#00D1A9" },
                                { label: "Orders", val: "384", clr: "#FF9500" }
                            ]

                            delegate: Rectangle {
                                id: statCard
                                required property var modelData
                                Layout.fillWidth: true
                                height: Style.resize(55)
                                radius: Style.resize(6)
                                color: Style.surfaceColor

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: Style.resize(2)

                                    Label {
                                        text: statCard.modelData.val
                                        font.pixelSize: Style.resize(16)
                                        font.bold: true
                                        color: statCard.modelData.clr
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Label {
                                        text: statCard.modelData.label
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }

                    // Area de contenido principal que crece para llenar
                    // todo el espacio vertical restante (fillHeight)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        Label {
                            anchors.centerIn: parent
                            text: "Main content area expands\nwhen sidebar collapses"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
