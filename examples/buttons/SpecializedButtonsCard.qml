// ============================================================================
// SpecializedButtonsCard.qml
// Concepto: Componentes de boton personalizados definidos en el modulo de estilo.
//
// Qt Quick Controls 2 permite crear componentes reutilizables que extienden
// o reemplazan los controles estandar. Los botones especializados aqui
// (GlowButton, GradientButton, PulseButton, NeumorphicButton) estan definidos
// en el modulo 'qmlsnippetsstyle' y pueden usarse en cualquier parte de la app.
//
// Cada uno expone propiedades custom (glowColor, startColor, pulseColor, etc.)
// que permiten configurar su apariencia sin modificar su implementacion interna.
// Este patron de "componente con API publica" es la base de la reutilizacion en QML.
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
// Importar el modulo de estilo hace disponibles los componentes custom
// (GlowButton, GradientButton, etc.) definidos en styles/qmlsnippetsstyle/.
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
            text: "Specialized Button Components"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Flow es un posicionador que distribuye sus hijos de izquierda a derecha
        // y salta a la siguiente fila cuando no caben. Ideal cuando no sabes
        // cuantos elementos habra o el ancho puede variar (responsive).
        Flow {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            // GlowButton: boton con efecto de resplandor (usa Qt5Compat.GraphicalEffects).
            // La propiedad 'glowColor' controla el color del halo luminoso.
            GlowButton {
                text: "Glow Effect"
                glowColor: "#00D1A8"
                width: Style.resize(150)
                height: Style.resize(40)
            }

            // GradientButton: fondo con degradado lineal entre dos colores.
            // startColor y endColor definen los extremos del gradiente.
            GradientButton {
                text: "Gradient"
                startColor: "#FF5900"
                endColor: "#FFE361"
                width: Style.resize(150)
                height: Style.resize(40)
            }

            // PulseButton: animacion de pulso continuo al hacer hover.
            // pulseColor define el color de la onda expansiva.
            PulseButton {
                text: "Pulse Animation"
                pulseColor: Style.mainColor
                width: Style.resize(150)
                height: Style.resize(40)
            }

            // NeumorphicButton: estilo neumorfismo con sombras internas/externas.
            // baseColor debe coincidir con el fondo para lograr el efecto 3D sutil.
            NeumorphicButton {
                text: "Neumorphic"
                baseColor: Style.bgColor
                width: Style.resize(150)
                height: Style.resize(40)
            }
        }

        Label {
            text: "These specialized components are reusable across all examples"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
