// =============================================================================
// InteractiveEffectsCard.qml — Combinador de efectos en cadena
// =============================================================================
// Demuestra como encadenar multiples efectos graficos en un pipeline
// secuencial: Source -> DropShadow -> GaussianBlur -> Glow. Cada efecto
// se puede activar/desactivar independientemente con switches.
//
// Conceptos clave para el aprendiz:
//   - Pipeline de efectos: cada efecto toma como source la salida del
//     anterior, formando una cadena. El orden importa — por ejemplo, aplicar
//     blur despues de shadow difumina tambien la sombra. Cambiar el orden
//     produce resultados diferentes.
//   - visible: false en capas intermedias: solo la ultima capa del pipeline
//     (Glow) es visible. Las demas estan ocultas porque son pasos intermedios.
//   - Radius 0 = efecto desactivado: cuando un efecto tiene radius 0,
//     efectivamente "pasa" la imagen sin modificarla. Esto permite mantener
//     el pipeline intacto sin crear/destruir componentes.
//   - Behavior on radius: anima la transicion al activar/desactivar cada
//     efecto, dando un resultado visual suave en lugar de un cambio abrupto.
//   - Costo acumulativo: cada efecto adicional es un pase de renderizado
//     extra. Tres efectos encadenados = 3 texturas offscreen adicionales.
//     En una app real, hay que ser consciente del impacto en rendimiento.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Propiedades booleanas que controlan la activacion de cada efecto.
    // Estan a nivel de root para que tanto los switches como los efectos
    // puedan acceder a ellas sin acoplamiento directo.
    property bool enableBlur: false
    property bool enableGlow: false
    property bool enableShadow: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Effect Combiner"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---------------------------------------------------------------
            // Escena fuente: rectangulo con gradiente y un icono centrado.
            // El gradiente (teal a azul) hace que los efectos de color
            // sean mas apreciables que con un color solido.
            // ---------------------------------------------------------------
            Item {
                id: comboSource
                anchors.centerIn: parent
                width: Style.resize(140)
                height: Style.resize(140)
                visible: false

                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(20)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00D1A9" }
                        GradientStop { position: 1.0; color: "#4FC3F7" }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)

                        Label {
                            text: "\u2726"
                            font.pixelSize: Style.resize(40)
                            color: "#FFFFFF"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Effects"
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // Pipeline de efectos encadenados:
            //   comboSource -> DropShadow -> GaussianBlur -> Glow
            //
            // Cuando un efecto tiene radius 0, simplemente pasa la imagen
            // a la siguiente capa sin modificarla. Esto evita tener que
            // reconectar la cadena al activar/desactivar efectos.
            // ---------------------------------------------------------------

            // Capa 1: DropShadow — agrega sombra proyectada si esta activa
            DropShadow {
                id: shadowLayer
                anchors.fill: comboSource
                source: comboSource
                radius: root.enableShadow ? 16 : 0
                samples: 33
                color: "#80000000"
                horizontalOffset: Style.resize(8)
                verticalOffset: Style.resize(8)
                visible: false

                Behavior on radius { NumberAnimation { duration: 300 } }
            }

            // Capa 2: GaussianBlur — difumina todo lo que viene de la capa
            // anterior (incluyendo la sombra si esta activa)
            GaussianBlur {
                id: blurLayer
                anchors.fill: shadowLayer
                source: shadowLayer
                radius: root.enableBlur ? blurAmount.value : 0
                samples: Math.round(radius) * 2 + 1
                visible: false

                Behavior on radius { NumberAnimation { duration: 300 } }
            }

            // Capa 3: Glow — la capa final (unica visible). Agrega brillo
            // al resultado acumulado de las capas anteriores.
            Glow {
                anchors.fill: blurLayer
                source: blurLayer
                radius: root.enableGlow ? 12 : 0
                samples: 25
                color: "#00D1A9"
                spread: 0.2

                Behavior on radius { NumberAnimation { duration: 300 } }
            }
        }

        // -------------------------------------------------------------------
        // Panel de control: switches para activar/desactivar cada capa
        // del pipeline, y un slider para ajustar la intensidad del blur.
        // El slider solo aparece cuando el blur esta activo (visible binding).
        // -------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(15)

                Switch {
                    id: blurSwitch
                    text: "Blur"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableBlur
                    onToggled: root.enableBlur = checked
                }
                Switch {
                    text: "Glow"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableGlow
                    onToggled: root.enableGlow = checked
                }
                Switch {
                    text: "Shadow"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableShadow
                    onToggled: root.enableShadow = checked
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.enableBlur
                Label {
                    text: "Blur: " + blurAmount.value.toFixed(0)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(60)
                }
                Slider {
                    id: blurAmount
                    Layout.fillWidth: true
                    from: 0; to: 16; value: 8
                }
            }
        }

        // Etiqueta resumen: muestra que efectos estan activos actualmente.
        // La propiedad computada "active" construye la lista dinaminamente
        // y join(" + ") la formatea como "Blur + Glow + Shadow".
        Label {
            property var active: {
                var list = []
                if (root.enableBlur) list.push("Blur")
                if (root.enableGlow) list.push("Glow")
                if (root.enableShadow) list.push("Shadow")
                return list
            }
            text: active.length > 0 ? active.join(" + ") : "No effects active"
            font.pixelSize: Style.resize(12)
            color: active.length > 0 ? Style.mainColor : Style.inactiveColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
