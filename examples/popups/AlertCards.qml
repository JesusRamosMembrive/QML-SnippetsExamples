// =============================================================================
// AlertCards.qml — Tarjetas de alerta con dismiss animado
// =============================================================================
// Implementa un conjunto de alertas de tipo banner (success, error, warning,
// info) con animacion de cierre. Cada alerta se puede descartar individualmente
// y restaurar con un boton "Reset".
//
// CONCEPTOS CLAVE:
//
// 1. Modelo declarativo con array de objetos JS:
//    - El Repeater usa un array literal como modelo. Cada objeto define tipo,
//      icono, titulo, mensaje, color de fondo y color de acento.
//    - Esto centraliza la configuracion visual de cada variante de alerta.
//
// 2. Animacion de dismiss con Behavior:
//    - "dismissed" es un bool que controla height y opacity simultaneamente.
//    - Behavior on height y Behavior on opacity animan ambas propiedades
//      automaticamente cuando "dismissed" cambia, creando un efecto de
//      colapso + fade-out combinado.
//    - clip: true evita que el contenido se dibuje fuera del area reducida.
//
// 3. Qt.color() para manipulacion de colores:
//    - Se usa Qt.color(string).r/g/b para extraer componentes RGB de un color
//      en formato string y combinarlo con Qt.rgba() para ajustar la opacidad.
//    - Esto permite crear variantes transparentes del color de acento sin
//      definir colores adicionales.
//
// 4. Reset iterando hijos del layout:
//    - El boton "Reset" recorre parent.children buscando elementos con la
//      propiedad "dismissed". Esto es un patron pragmatico pero fragil;
//      en produccion seria mejor usar un modelo ListModel.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Alert Cards"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.resize(8)

        // Repeater con modelo declarativo: cada objeto define la apariencia
        // y contenido de una alerta. El delegate genera una tarjeta por tipo.
        Repeater {
            model: [
                { type: "success", icon: "✓", title: "Success",
                  msg: "Your changes have been saved successfully.",
                  bg: "#1A3A2A", accent: "#34C759" },
                { type: "error", icon: "✕", title: "Error",
                  msg: "Unable to connect to the server. Check your network.",
                  bg: "#3A1A1A", accent: "#FF3B30" },
                { type: "warning", icon: "⚠", title: "Warning",
                  msg: "This action cannot be undone. Proceed with caution.",
                  bg: "#3A2E1A", accent: "#FF9500" },
                { type: "info", icon: "ℹ", title: "Information",
                  msg: "Scheduled maintenance window: Sunday 2:00-4:00 AM UTC.",
                  bg: "#1A2A3A", accent: "#5B8DEF" }
            ]

            // Delegate con animacion de dismiss: height colapsa a 0 y opacity
            // se desvanece. Los Behaviors aplican la transicion automaticamente.
            delegate: Rectangle {
                id: alertCard
                required property var modelData
                required property int index

                property bool dismissed: false

                Layout.fillWidth: true
                height: dismissed ? 0 : Style.resize(70)
                radius: Style.resize(8)
                color: alertCard.modelData.bg
                border.color: Qt.rgba(
                    Qt.color(alertCard.modelData.accent).r,
                    Qt.color(alertCard.modelData.accent).g,
                    Qt.color(alertCard.modelData.accent).b, 0.3)
                border.width: Style.resize(1)
                clip: true
                opacity: dismissed ? 0 : 1

                Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 200 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(14)
                    spacing: Style.resize(12)

                    // Circulo de icono con fondo semitransparente del color de acento.
                    // Qt.rgba() con alpha 0.2 crea un tono sutil que complementa el icono.
                    Rectangle {
                        width: Style.resize(34)
                        height: Style.resize(34)
                        radius: width / 2
                        color: Qt.rgba(
                            Qt.color(alertCard.modelData.accent).r,
                            Qt.color(alertCard.modelData.accent).g,
                            Qt.color(alertCard.modelData.accent).b, 0.2)

                        Label {
                            anchors.centerIn: parent
                            text: alertCard.modelData.icon
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: alertCard.modelData.accent
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(2)

                        Label {
                            text: alertCard.modelData.title
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: alertCard.modelData.accent
                        }
                        Label {
                            text: alertCard.modelData.msg
                            font.pixelSize: Style.resize(11)
                            color: Style.fontSecondaryColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    // Dismiss button
                    Rectangle {
                        width: Style.resize(24)
                        height: Style.resize(24)
                        radius: width / 2
                        color: alertDismissMa.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"

                        Label {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: Style.resize(12)
                            color: Style.inactiveColor
                        }

                        MouseArea {
                            id: alertDismissMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: alertCard.dismissed = true
                        }
                    }
                }
            }
        }

        Button {
            text: "Reset Alerts"
            flat: true
            font.pixelSize: Style.resize(11)
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                for (var i = 0; i < parent.children.length; i++) {
                    var child = parent.children[i]
                    if (child.dismissed !== undefined)
                        child.dismissed = false
                }
            }
        }
    }
}
