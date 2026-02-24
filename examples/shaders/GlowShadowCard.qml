// =============================================================================
// GlowShadowCard.qml — Efectos de brillo y sombra: Glow, DropShadow,
// InnerShadow
// =============================================================================
// Muestra los tres efectos de iluminacion/sombra de Qt5Compat.GraphicalEffects
// aplicados a una misma forma fuente. Solo uno esta visible a la vez, controlado
// por botones de seleccion.
//
// Conceptos clave para el aprendiz:
//   - Glow: emite luz desde los bordes del source hacia afuera. El color
//     del glow y el spread controlan la apariencia. Ideal para botones
//     "neon" o indicadores activos.
//   - DropShadow: sombra proyectada detras del source, con offset horizontal/
//     vertical que simula una fuente de luz. Es el efecto mas usado en UI
//     para dar profundidad y jerarquia visual.
//   - InnerShadow: sombra interna que simula que el contenido esta hundido
//     o en relieve. Se usa para campos de texto, contenedores inset, etc.
//   - Los tres efectos comparten radius y samples — radius controla la
//     difusion y samples la calidad del muestreo.
//   - visible para alternar: en lugar de crear/destruir efectos, se usan
//     los tres simultaneamente pero solo uno es visible. Esto es mas
//     eficiente que Loader para pocos elementos.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Indice del efecto activo (0=Glow, 1=DropShadow, 2=InnerShadow)
    property int effectIndex: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Glow & Shadow"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Selector de efecto: tres botones generados con Repeater.
        // highlighted marca visualmente el boton activo usando el estilo
        // personalizado del proyecto (qmlsnippetsstyle).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: ["Glow", "DropShadow", "InnerShadow"]

                Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    font.pixelSize: Style.resize(11)
                    highlighted: root.effectIndex === index
                    onClicked: root.effectIndex = index
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---------------------------------------------------------------
            // Forma fuente: un rectangulo redondeado con un icono de estrella.
            // visible: false porque los tres efectos lo usan como source.
            // Cada efecto incluye la forma original en su renderizado,
            // asi que no es necesario dibujarla aparte.
            // ---------------------------------------------------------------
            Rectangle {
                id: shadowSource
                anchors.centerIn: parent
                width: Style.resize(120)
                height: Style.resize(120)
                radius: Style.resize(16)
                color: "#00D1A9"
                visible: false

                Label {
                    anchors.centerIn: parent
                    text: "\u2605"
                    font.pixelSize: Style.resize(48)
                    color: "#FFFFFF"
                }
            }

            // Glow: emision de luz hacia afuera. spread controla que tan
            // concentrada esta la luz (0.0 = difusa, 1.0 = concentrada).
            // El color del glow coincide con el source para un efecto neon.
            Glow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#00D1A9"
                spread: 0.3
                visible: root.effectIndex === 0
            }

            // DropShadow: sombra exterior con desplazamiento. El color
            // "#80000000" es negro al 50% de opacidad. Los offsets simulan
            // una fuente de luz desde la esquina superior izquierda.
            DropShadow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#80000000"
                horizontalOffset: Style.resize(6)
                verticalOffset: Style.resize(6)
                visible: root.effectIndex === 1
            }

            // InnerShadow: sombra interior que da efecto de profundidad.
            // Offsets menores que DropShadow porque el efecto es mas sutil
            // al estar confinado dentro de la forma.
            InnerShadow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#80000000"
                horizontalOffset: Style.resize(4)
                verticalOffset: Style.resize(4)
                visible: root.effectIndex === 2
            }
        }

        // Slider compartido por los tres efectos — ajusta el radius que
        // controla la difusion del efecto activo
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Radius: " + glowRadius.value.toFixed(0)
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: glowRadius
                Layout.fillWidth: true
                from: 0; to: 16; value: 10
            }
        }
    }
}
