// =============================================================================
// HolyGrailLayout.qml — El clasico "Holy Grail" de diseno web en QML
// =============================================================================
// El "Holy Grail Layout" es un patron de diseno web clasico que fue
// notoriamente dificil de implementar en CSS durante anos. Consiste en:
//
//   +-------------------------------------------+
//   |              Header / Navbar              |
//   +--------+-----------------+--------+
//   |  Nav   |   Main Content  | Aside  |
//   | (fijo) |   (flexible)    | (fijo) |
//   +--------+-----------------+--------+
//   |               Footer                      |
//   +-------------------------------------------+
//
// En QML, este layout es trivial gracias a ColumnLayout + RowLayout:
// 1. ColumnLayout exterior: apila header, cuerpo y footer verticalmente.
// 2. RowLayout interior: coloca sidebar, contenido y aside en fila.
// 3. El contenido central usa fillWidth + fillHeight para ocupar TODO
//    el espacio sobrante despues de reservar los anchos fijos de los
//    paneles laterales y las alturas fijas de header/footer.
//
// Leccion para el aprendiz: este es el patron mas importante para
// aplicaciones de escritorio — header fijo, footer fijo, sidebar(s)
// de ancho fijo, y contenido que llena el resto.
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
        text: "Holy Grail Layout"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(240)

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                spacing: Style.resize(4)

                // -------------------------------------------------------------
                // Header: altura fija, ancho completo
                // Contiene logo/titulo a la izquierda y navegacion a la derecha.
                // Item { fillWidth } actua como "spacer" para empujar los
                // links de navegacion hacia la derecha.
                // -------------------------------------------------------------
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(36)
                    radius: Style.resize(4)
                    color: "#5B8DEF"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(12)

                        Label {
                            text: "\u26A1 Header / Navbar"
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: "#FFF"
                        }

                        Item { Layout.fillWidth: true }

                        Repeater {
                            model: ["Home", "About", "Contact"]
                            Label {
                                required property string modelData
                                text: modelData
                                font.pixelSize: Style.resize(10)
                                color: Qt.rgba(1, 1, 1, 0.8)
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // Fila central: la clave del Holy Grail
                // - Sidebar izquierdo: preferredWidth fijo (100px)
                // - Contenido central: fillWidth + fillHeight (expansible)
                // - Aside derecho: preferredWidth fijo (90px)
                // El contenido central se expande automaticamente para
                // llenar todo el espacio que los paneles laterales no usan.
                // -------------------------------------------------------------
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    // Sidebar de navegacion (ancho fijo)
                    Rectangle {
                        Layout.preferredWidth: Style.resize(100)
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: "#2D3436"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: "Nav"
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: "#00D1A9"
                            }

                            Repeater {
                                model: ["Dashboard", "Users", "Reports", "Settings"]
                                Label {
                                    required property string modelData
                                    required property int index
                                    text: "\u2022 " + modelData
                                    font.pixelSize: Style.resize(10)
                                    color: index === 0 ? Style.mainColor : Style.fontSecondaryColor
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // Contenido principal (expansion total)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: Style.surfaceColor

                        Label {
                            anchors.centerIn: parent
                            text: "Main Content\n(fills remaining space)"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // Panel lateral derecho (ancho fijo)
                    Rectangle {
                        Layout.preferredWidth: Style.resize(90)
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: "#2D3436"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: "Aside"
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: "#FF9500"
                            }

                            Label {
                                text: "Related\nlinks and\nwidgets"
                                font.pixelSize: Style.resize(10)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }
                }

                // Footer: altura fija, ancho completo
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: "#636E72"

                    Label {
                        anchors.centerIn: parent
                        text: "Footer \u2014 \u00A9 2026 QML Snippets"
                        font.pixelSize: Style.resize(10)
                        color: Qt.rgba(1, 1, 1, 0.6)
                    }
                }
            }
        }
    }
}
