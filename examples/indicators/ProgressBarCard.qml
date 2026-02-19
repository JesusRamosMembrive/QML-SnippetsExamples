// =============================================================================
// ProgressBarCard.qml — Tarjeta de ejemplo del control ProgressBar
// =============================================================================
// Demuestra las dos modalidades del ProgressBar nativo de Qt Quick Controls:
//   1) Determinado: el valor se controla con un Slider (binding directo).
//      Ideal para operaciones donde se conoce el progreso (descarga, copia).
//   2) Indeterminado: propiedad "indeterminate: true" muestra una animacion
//      ciclica sin porcentaje. Ideal para esperas de duracion desconocida.
//
// Conceptos clave:
//   - El ProgressBar usa rango 0-1 por defecto (from/to). El label muestra
//     el valor multiplicado por 100 con toFixed(0) para formatear como %.
//   - El Switch controla indeterminate de forma reactiva — cambiar el
//     binding es todo lo necesario, Qt gestiona la animacion automaticamente.
//   - El Slider esta envuelto en un Item para controlar margenes sin
//     afectar el layout, un patron comun cuando anchors y Layout colisionan.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ProgressBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ── ProgressBar determinado ──
        // El valor se vincula directamente al Slider. Cada movimiento
        // del slider actualiza la barra y la etiqueta de porcentaje
        // gracias al sistema de bindings reactivos de QML.
        Label {
            text: "Determinate: " + (progressSlider.value * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        ProgressBar {
            id: determinateBar
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(8)
            from: 0
            to: 1
            value: progressSlider.value
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(40)

            Slider {
                id: progressSlider
                anchors.fill: parent
                anchors.leftMargin: Style.resize(10)
                anchors.rightMargin: Style.resize(10)
                from: 0
                to: 1
                value: 0.65
                stepSize: 0.01
            }
        }

        Rectangle {
            Layout.fillWidth: true
            color: Style.bgColor
        }

        // ── ProgressBar indeterminado ──
        // Cuando indeterminate=true, Qt muestra una animacion ciclica
        // integrada en el estilo. El Switch permite activar/desactivar
        // el modo en tiempo real para ver la diferencia visualmente.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Indeterminate:"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
                Layout.fillWidth: true
            }

            Switch {
                id: indeterminateSwitch
                text: indeterminateSwitch.checked ? "ON" : "OFF"
                checked: true
            }
        }

        ProgressBar {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(8)
            indeterminate: indeterminateSwitch.checked
        }

        Item { Layout.fillHeight: true }

        Label {
            text: "ProgressBar shows task completion. Indeterminate mode indicates unknown duration"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
