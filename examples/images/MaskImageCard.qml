// =============================================================================
// MaskImageCard.qml — Mascaras de imagen con OpacityMask
// =============================================================================
// Demuestra como recortar una imagen usando formas arbitrarias mediante
// OpacityMask de Qt5Compat.GraphicalEffects. La mascara funciona asi:
// donde la mascara es blanca, la imagen se muestra; donde es transparente,
// la imagen se oculta.
//
// Se ofrecen 4 formas de mascara: circulo (Rectangle con radius=50%),
// rectangulo redondeado, diamante (Canvas) y estrella (Canvas).
// La imagen fuente es un paisaje generado con Canvas para no depender
// de archivos externos.
//
// Nota importante: tanto el source como el maskSource deben tener
// visible: false. OpacityMask los renderiza internamente; si fueran
// visibles, se verian duplicados.
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

    // Indice de la forma de mascara activa (0=circulo, 1=redondeado, 2=diamante, 3=estrella)
    property int maskShape: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Image Masking"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // -----------------------------------------------------------------
            // Imagen fuente: paisaje generado con Canvas.
            // visible: false porque OpacityMask la consume como textura interna.
            // Canvas permite crear graficos procedurales sin archivos de imagen,
            // ideal para demos y prototipos.
            // -----------------------------------------------------------------
            Canvas {
                id: landscape
                anchors.centerIn: parent
                width: Style.resize(180)
                height: Style.resize(180)
                visible: false
                onPaint: {
                    var ctx = getContext("2d")
                    // Sky gradient
                    var sky = ctx.createLinearGradient(0, 0, 0, height * 0.6)
                    sky.addColorStop(0, "#1a237e")
                    sky.addColorStop(1, "#4FC3F7")
                    ctx.fillStyle = sky
                    ctx.fillRect(0, 0, width, height * 0.6)

                    // Sun
                    ctx.beginPath()
                    ctx.arc(width * 0.7, height * 0.25, 25, 0, Math.PI * 2)
                    ctx.fillStyle = "#FEA601"
                    ctx.fill()

                    // Mountains
                    ctx.beginPath()
                    ctx.moveTo(0, height * 0.6)
                    ctx.lineTo(width * 0.25, height * 0.3)
                    ctx.lineTo(width * 0.45, height * 0.55)
                    ctx.lineTo(width * 0.65, height * 0.25)
                    ctx.lineTo(width * 0.85, height * 0.5)
                    ctx.lineTo(width, height * 0.4)
                    ctx.lineTo(width, height * 0.6)
                    ctx.fillStyle = "#2E7D32"
                    ctx.fill()

                    // Ground
                    var ground = ctx.createLinearGradient(0, height * 0.6, 0, height)
                    ground.addColorStop(0, "#33691E")
                    ground.addColorStop(1, "#1B5E20")
                    ctx.fillStyle = ground
                    ctx.fillRect(0, height * 0.6, width, height * 0.4)

                    // Stars
                    ctx.fillStyle = "#FFFFFF"
                    for (var i = 0; i < 15; i++) {
                        var sx = Math.random() * width
                        var sy = Math.random() * height * 0.4
                        ctx.fillRect(sx, sy, 2, 2)
                    }
                }
                Component.onCompleted: requestPaint()
            }

            // -----------------------------------------------------------------
            // Contenedor de mascaras: tambien visible: false.
            // Contiene multiples formas; solo la activa (segun maskShape)
            // se muestra internamente. Las formas simples (circulo, redondeado)
            // usan Rectangle con radius; las complejas (diamante, estrella)
            // usan Canvas para dibujar paths arbitrarios.
            // -----------------------------------------------------------------
            Item {
                id: maskItem
                anchors.fill: landscape
                visible: false

                // Circulo (radius = 50%) o rectangulo redondeado
                Rectangle {
                    anchors.fill: parent
                    radius: root.maskShape === 0 ? width / 2
                          : root.maskShape === 1 ? Style.resize(16)
                          : 0
                    color: "#FFFFFF"
                    visible: root.maskShape <= 1
                }

                // Mascara de diamante: 4 vertices en forma de rombo
                Canvas {
                    anchors.fill: parent
                    visible: root.maskShape === 2
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#FFFFFF"
                        ctx.beginPath()
                        ctx.moveTo(width / 2, 0)
                        ctx.lineTo(width, height / 2)
                        ctx.lineTo(width / 2, height)
                        ctx.lineTo(0, height / 2)
                        ctx.closePath()
                        ctx.fill()
                    }
                }

                // Mascara de estrella: alterna entre radio exterior e interior
                // para crear 5 puntas. La formula trigonometrica genera los
                // 10 vertices (5 exteriores + 5 interiores) del poligono.
                Canvas {
                    anchors.fill: parent
                    visible: root.maskShape === 3
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#FFFFFF"
                        ctx.beginPath()
                        var cx = width / 2, cy = height / 2
                        var outerR = Math.min(width, height) / 2
                        var innerR = outerR * 0.4
                        for (var i = 0; i < 10; i++) {
                            var angle = (i * Math.PI / 5) - Math.PI / 2
                            var r = (i % 2 === 0) ? outerR : innerR
                            if (i === 0) ctx.moveTo(cx + r * Math.cos(angle), cy + r * Math.sin(angle))
                            else ctx.lineTo(cx + r * Math.cos(angle), cy + r * Math.sin(angle))
                        }
                        ctx.closePath()
                        ctx.fill()
                    }
                }
            }

            // OpacityMask combina source y maskSource: muestra los pixeles
            // del source donde el maskSource tiene opacidad (blanco).
            OpacityMask {
                anchors.fill: landscape
                source: landscape
                maskSource: maskItem
            }
        }

        // Selector de forma: al cambiar, se fuerza requestPaint() en los
        // Canvas hijos para que redibujen la mascara correspondiente.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: ["Circle", "Rounded", "Diamond", "Star"]

                Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    font.pixelSize: Style.resize(11)
                    highlighted: root.maskShape === index
                    onClicked: {
                        root.maskShape = index
                        // Repaint Canvas masks
                        for (var i = 0; i < maskItem.children.length; i++) {
                            var child = maskItem.children[i]
                            if (child.requestPaint) child.requestPaint()
                        }
                    }
                }
            }
        }
    }
}
