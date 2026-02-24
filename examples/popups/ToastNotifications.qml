// =============================================================================
// ToastNotifications.qml — Sistema de notificaciones toast con auto-dismiss
// =============================================================================
// Implementa un patron de notificaciones temporales ("toasts") similar al de
// Android o apps web modernas. Las notificaciones aparecen apiladas, se
// auto-eliminan tras 4 segundos, y tienen una barra de progreso visual que
// muestra el tiempo restante.
//
// CONCEPTOS CLAVE:
//
// 1. Modelo de datos reactivo con arrays JS:
//    - "toasts" es un property var (array JS) que actua como modelo del Repeater.
//    - QML NO detecta cambios internos en arrays (push/pop). Para notificar
//      cambios, se reasigna el array completo con slice() + push/shift.
//    - Se limita a 5 toasts maximo con shift() (elimina el mas antiguo).
//
// 2. Timer para countdown de vida:
//    - Un Timer global decrementa "life" en cada toast cada 100ms.
//    - Cuando life llega a 0, el toast se filtra del array.
//    - Este patron es mas eficiente que un Timer por toast, ya que un solo
//      Timer maneja todas las notificaciones.
//
// 3. Opacidad vinculada a vida restante:
//    - opacity: Math.min(1, life * 2) crea un fade-out suave en el ultimo
//      medio segundo de vida (life < 0.5 -> opacity < 1).
//
// 4. Tipos semanticos con diccionario de colores:
//    - Cada tipo (success, error, warning, info) tiene colores de fondo y
//      borde predefinidos, siguiendo convenciones de diseno estandar.
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
        text: "Toast Notifications"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: toastSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)

        property var toasts: []
        property int nextId: 0

        // Crea un nuevo toast con tipo y mensaje. El diccionario "colors"
        // asocia cada tipo semantico con su esquema visual (fondo, borde, icono).
        // slice() + push + reasignacion garantiza que QML detecte el cambio.
        function addToast(type, message) {
            var colors = {
                success: { bg: "#1A3A2A", border: "#34C759", icon: "✓" },
                error:   { bg: "#3A1A1A", border: "#FF3B30", icon: "✕" },
                warning: { bg: "#3A2E1A", border: "#FF9500", icon: "⚠" },
                info:    { bg: "#1A2A3A", border: "#5B8DEF", icon: "ℹ" }
            }
            var c = colors[type]
            var t = toastSection.toasts.slice()
            t.push({ id: toastSection.nextId++, type: type, msg: message,
                     bg: c.bg, border: c.border, icon: c.icon, life: 4.0 })
            if (t.length > 5) t.shift()
            toastSection.toasts = t
        }

        // Timer global de countdown: decrementa la vida de todos los toasts
        // cada 100ms. Solo corre cuando hay toasts activos (running vinculado).
        // Los toasts con life <= 0 se filtran automaticamente.
        Timer {
            running: toastSection.toasts.length > 0
            interval: 100
            repeat: true
            onTriggered: {
                var t = toastSection.toasts.slice()
                var alive = []
                for (var i = 0; i < t.length; i++) {
                    t[i].life -= 0.1
                    if (t[i].life > 0) alive.push(t[i])
                }
                toastSection.toasts = alive
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Botones de disparo: cada uno invoca addToast() con un tipo distinto.
        // Posicionados en la parte inferior del area de demostracion.
        Row {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Style.resize(15)
            spacing: Style.resize(10)
            z: 1

            Button {
                text: "✓ Success"
                flat: true
                font.pixelSize: Style.resize(11)
                onClicked: toastSection.addToast("success", "Operation completed successfully!")
            }
            Button {
                text: "✕ Error"
                flat: true
                font.pixelSize: Style.resize(11)
                onClicked: toastSection.addToast("error", "Connection failed. Please try again.")
            }
            Button {
                text: "⚠ Warning"
                flat: true
                font.pixelSize: Style.resize(11)
                onClicked: toastSection.addToast("warning", "Storage is almost full (92%)")
            }
            Button {
                text: "ℹ Info"
                flat: true
                font.pixelSize: Style.resize(11)
                onClicked: toastSection.addToast("info", "New version available: v2.4.1")
            }
        }

        // Pila de toasts: Column apila las notificaciones de arriba a abajo.
        // El Repeater genera un delegate por cada elemento del array "toasts".
        // Cada delegate es un Rectangle con icono, mensaje y barra de progreso.
        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.resize(10)
            spacing: Style.resize(6)
            width: parent.width * 0.85

            Repeater {
                model: toastSection.toasts.length

                delegate: Rectangle {
                    id: toastItem
                    required property int index

                    // Acceso seguro al objeto toast: el || {} evita errores si el
                    // indice queda fuera de rango durante la animacion de salida.
                    readonly property var toast: toastSection.toasts[toastItem.index] || {}
                    readonly property real life: toast.life || 0

                    width: parent.width
                    height: Style.resize(46)
                    radius: Style.resize(8)
                    color: toast.bg || "transparent"
                    border.color: toast.border || "transparent"
                    border.width: Style.resize(1)
                    opacity: Math.min(1, life * 2)

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(12)
                        spacing: Style.resize(10)

                        Label {
                            text: toastItem.toast.icon || ""
                            font.pixelSize: Style.resize(16)
                            color: toastItem.toast.border || "#FFF"
                        }

                        Label {
                            text: toastItem.toast.msg || ""
                            font.pixelSize: Style.resize(12)
                            color: Style.fontPrimaryColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        // Progress bar showing remaining time
                        Rectangle {
                            Layout.preferredWidth: Style.resize(40)
                            Layout.preferredHeight: Style.resize(3)
                            radius: Style.resize(1)
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Rectangle {
                                width: parent.width * Math.max(0, (toastItem.life / 4.0))
                                height: parent.height
                                radius: parent.radius
                                color: toastItem.toast.border || "#FFF"
                            }
                        }
                    }
                }
            }
        }
    }
}
