// =============================================================================
// VolumeActionsCard.qml — Slider con botones de accion preestablecidos
// =============================================================================
// Combina un Slider con botones especializados (GradientButton, PulseButton,
// GlowButton) que establecen valores predefinidos. Demuestra la interaccion
// entre controles: los botones modifican el valor del slider programaticamente.
//
// CONCEPTOS CLAVE:
//
// 1. Modificacion programatica del valor:
//    - onClicked: volumeSlider.value = 0/50/100 establece el valor del
//      slider desde codigo. El handle se mueve automaticamente a la nueva
//      posicion y el label se actualiza via binding.
//    - Esto es bidireccional: el usuario puede mover el slider manualmente
//      O usar los botones de acceso rapido.
//
// 2. Reutilizacion de componentes custom en contexto:
//    - GradientButton, PulseButton y GlowButton se usan como botones de
//      accion real, no solo como demo visual. Esto refuerza que los
//      componentes custom del proyecto son verdaderamente reutilizables.
//
// 3. Patron de preset + ajuste fino:
//    - Los botones dan acceso rapido a valores comunes (0%, 50%, 100%)
//      mientras el slider permite ajuste fino entre esos valores.
//    - Es un patron de UX comun en controles de volumen y brillo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Custom Slider with Actions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Slider de volumen con label que muestra el porcentaje actual.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Volume: " + volumeSlider.value.toFixed(0) + "%"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    id: volumeSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    value: 50
                }
            }
        }

        // Botones de presets: cada uno establece un valor fijo en el slider.
        // Usan tres componentes custom diferentes para variedad visual.
        RowLayout {
            spacing: Style.resize(10)
            Layout.fillWidth: true

            GradientButton {
                text: "Mute"
                startColor: "#FF5900"
                endColor: "#FF8C00"
                width: Style.resize(100)
                height: Style.resize(35)
                onClicked: volumeSlider.value = 0
            }

            PulseButton {
                text: "50%"
                pulseColor: Style.mainColor
                width: Style.resize(100)
                height: Style.resize(35)
                onClicked: volumeSlider.value = 50
            }

            GlowButton {
                text: "Max"
                glowColor: "#00D1A8"
                width: Style.resize(100)
                height: Style.resize(35)
                onClicked: volumeSlider.value = 100
            }
        }

        Label {
            text: "Using GradientButton, PulseButton, and GlowButton - all reusable components!"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
