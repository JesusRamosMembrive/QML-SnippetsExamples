// =============================================================================
// SystemMonitorCard.qml — Demo interactiva de monitor de sistema
// =============================================================================
// Combina varios controles nativos (Dial, ProgressBar, BusyIndicator) en un
// dashboard simulado de monitoreo de sistema con CPU, memoria y disco.
//
// Lo interesante de este componente es como integra multiples controles
// para crear una interfaz coherente y reactiva:
//   - CPU: un Dial de solo lectura (enabled: false) cuyo valor fluctua
//     automaticamente con un Timer. El color del progreso cambia a rojo
//     cuando supera 80% usando la propiedad custom "progressColor".
//   - Memoria: un ProgressBar controlado por un Slider manual.
//   - Disco: un ProgressBar estatico (valor fijo).
//   - BusyIndicator: se activa automaticamente cuando CPU > 80%.
//
// Patron de activacion: la propiedad "active" (pasada desde Main.qml)
// controla si el Timer corre. Esto evita que el Timer consuma CPU cuando
// la pagina de indicadores no esta visible — buena practica en apps con
// multiples paginas.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: monitorCard
    color: Style.cardColor
    radius: Style.resize(8)

    property bool active: false
    property real cpuValue: 25

    // ── Timer de simulacion de CPU ──
    // Cada 1.5s genera un valor aleatorio sumado al anterior, limitado
    // entre 0-100 con Math.min/max. Solo corre cuando active=true,
    // es decir, cuando la pagina de indicadores esta visible.
    Timer {
        running: monitorCard.active
        interval: 1500
        repeat: true
        onTriggered: {
            monitorCard.cpuValue = Math.min(100, Math.max(0,
                monitorCard.cpuValue + (Math.random() * 30 - 15)));
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Interactive Demo - System Monitor"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ── Seccion CPU: Dial + indicador de carga alta ──
        // El Dial muestra el uso de CPU con Behavior on value para
        // transiciones suaves. El BusyIndicator adyacente se activa
        // como alerta visual cuando el CPU supera el 80%.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(20)
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout {
                spacing: Style.resize(5)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: cpuDial
                    Layout.preferredWidth: Style.resize(130)
                    Layout.preferredHeight: Style.resize(130)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: monitorCard.cpuValue
                    enabled: false
                    suffix: "%"
                    progressColor: monitorCard.cpuValue > 80 ? "#FF5900" : Style.mainColor

                    // Behavior suaviza los saltos del Timer, creando una
                    // transicion fluida en vez de cambios abruptos.
                    Behavior on value {
                        NumberAnimation { duration: 500 }
                    }
                }

                Label {
                    text: "CPU Usage"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Indicador de advertencia de CPU alta ──
            // El BusyIndicator se activa/desactiva por umbral (80%).
            // La opacidad con Behavior crea una transicion suave entre
            // los estados visible (1.0) y atenuado (0.2).
            ColumnLayout {
                spacing: Style.resize(5)
                Layout.alignment: Qt.AlignHCenter

                BusyIndicator {
                    running: monitorCard.cpuValue > 80
                    opacity: monitorCard.cpuValue > 80 ? 1.0 : 0.2
                    Layout.alignment: Qt.AlignHCenter

                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }
                }

                Label {
                    text: monitorCard.cpuValue > 80 ? "High Load!" : "Normal"
                    font.pixelSize: Style.resize(12)
                    font.bold: monitorCard.cpuValue > 80
                    color: monitorCard.cpuValue > 80 ? "#FF5900" : Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ── Seccion Memoria: ProgressBar + Slider ──
        // El usuario puede ajustar el valor de memoria manualmente.
        // El binding progressSlider.value → ProgressBar.value es inmediato.
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(8)
                value: memorySlider.value
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: memorySlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 1
                    value: 0.62
                    stepSize: 0.01
                }
            }
        }

        // ── Seccion Disco: ProgressBar estatico ──
        // Valor fijo de 78%. Demuestra el caso mas simple de ProgressBar.
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "Disk: 78%"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(8)
                value: 0.78
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(1)
            color: Style.bgColor
        }

        // ── Resumen textual ──
        // Concatenacion de strings con valores reactivos. Todos los valores
        // se actualizan automaticamente cuando cambian sus fuentes.
        Label {
            text: "CPU: " + monitorCard.cpuValue.toFixed(0) + "%"
                  + "  |  Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                  + "  |  Disk: 78%"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
