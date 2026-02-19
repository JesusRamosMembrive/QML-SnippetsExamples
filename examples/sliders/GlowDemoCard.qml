// =============================================================================
// GlowDemoCard.qml — Demo interactiva de reutilizacion de componentes
// =============================================================================
// Demuestra un principio clave del desarrollo en QML: la reutilizacion de
// componentes entre modulos. El GlowButton (definido en qmlsnippetsstyle)
// se controla en tiempo real con sliders, mostrando como las propiedades
// publicas de un componente custom permiten personalizacion flexible.
//
// CONCEPTOS CLAVE:
//
// 1. Reutilizacion cross-module:
//    - GlowButton esta definido en styles/qmlsnippetsstyle/ pero se usa
//      aqui en examples/sliders/. import qmlsnippetsstyle lo hace disponible.
//    - Esto demuestra que los componentes QML son verdaderamente portables
//      entre modulos del proyecto.
//
// 2. Propiedades publicas como API:
//    - GlowButton expone glowIntensity y glowRadius como property.
//    - Los sliders controlan estas propiedades via bindings directos:
//      glowIntensity: glowIntensitySlider.value
//    - Este patron de "control externo via propiedades" es la base del
//      diseno de componentes reutilizables en QML.
//
// 3. Feedback visual en tiempo real:
//    - Cada cambio en los sliders se refleja instantaneamente en el
//      GlowButton gracias al sistema de bindings reactivos de QML.
//    - No hay handlers ni callbacks — solo declaraciones de dependencia.
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
        spacing: Style.resize(20)

        Label {
            text: "Interactive Demo - Reusable Components"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Control the GlowButton intensity with the slider below"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // GlowButton controlado por sliders: glowIntensity y glowRadius
        // se vinculan directamente a los valores de los sliders.
        GlowButton {
            id: demoGlowButton
            text: "Glow Button"
            glowColor: "#00D1A8"
            glowIntensity: glowIntensitySlider.value
            glowRadius: glowRadiusSlider.value
            Layout.alignment: Qt.AlignHCenter
            width: Style.resize(180)
            height: Style.resize(50)
        }

        // Control de intensidad del glow: rango 0-1 con pasos de 0.1.
        // El binding glowIntensity: glowIntensitySlider.value conecta
        // este slider directamente con la propiedad del GlowButton.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Glow Intensity: " + glowIntensitySlider.value.toFixed(2)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    id: glowIntensitySlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 1
                    value: 0.6
                    stepSize: 0.1
                }
            }
        }

        // Control del radio del glow: define el tamano del halo luminoso.
        // Valores altos crean un resplandor amplio y difuso.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Glow Radius: " + glowRadiusSlider.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                Slider {
                    id: glowRadiusSlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 5
                    to: 50
                    value: 20
                    stepSize: 5
                }
            }
        }

        Label {
            text: "✓ This demonstrates component reusability - GlowButton from the Buttons example is used here!"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
            font.bold: true
        }
    }
}
