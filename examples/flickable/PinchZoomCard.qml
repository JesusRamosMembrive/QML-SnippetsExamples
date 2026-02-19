// =============================================================================
// PinchZoomCard.qml — Flickable con zoom (escala + desplazamiento)
// =============================================================================
// Combina Flickable con la propiedad scale para crear una experiencia de
// zoom + pan. El usuario puede hacer zoom con la rueda del raton o el slider,
// y desplazarse por el contenido ampliado arrastrando.
//
// Conceptos clave para el aprendiz:
//   - Relacion Flickable + scale: contentWidth/Height se multiplican por la
//     escala actual para que el Flickable sepa el tamano real del contenido
//     escalado y ajuste el rango de scroll correctamente.
//   - transformOrigin: TopLeft es fundamental — si se usa Center (el default),
//     la escala desplaza el contenido y el Flickable no puede rastrearlo.
//   - Canvas: API de dibujo imperativo (similar a HTML Canvas) para crear
//     graficos personalizados. Ideal para patrones, graficas, y diagramas.
//   - WheelHandler: captura eventos de rueda del raton y los convierte en
//     cambios de zoom, ofreciendo una alternativa al gesto de pinch.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Pinch to Zoom"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Use scroll wheel or slider to zoom"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // ---------------------------------------------------------------
            // El truco del zoom: contentWidth/Height incluyen la escala.
            // Cuando el contenido se amplifica (scale > 1), el Flickable
            // necesita saber el tamano visual real para habilitar el scroll
            // en las areas que ahora quedan fuera del viewport.
            // ---------------------------------------------------------------
            Flickable {
                id: zoomFlick
                anchors.fill: parent
                contentWidth: zoomContent.width * zoomContent.scale
                contentHeight: zoomContent.height * zoomContent.scale
                boundsBehavior: Flickable.StopAtBounds

                Item {
                    id: zoomContent
                    width: Style.resize(400)
                    height: Style.resize(400)
                    // transformOrigin en TopLeft es esencial: la escala se
                    // aplica desde la esquina superior izquierda para que
                    // (0,0) del contenido siempre coincida con el inicio
                    // del area del Flickable.
                    transformOrigin: Item.TopLeft
                    scale: zoomSlider.value

                    // -----------------------------------------------------------
                    // Canvas: dibujo imperativo con la API 2D de HTML Canvas.
                    // Se ejecuta una sola vez (onPaint) y genera una escena
                    // estatica con cuadricula, formas geometricas y texto.
                    // A diferencia de Items QML, el Canvas rasteriza todo en
                    // una textura, lo que es eficiente para graficos complejos
                    // pero no se adapta automaticamente a cambios de tamano
                    // (hay que llamar requestPaint() si cambia el tamano).
                    // -----------------------------------------------------------
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            // Fondo
                            ctx.fillStyle = Style.surfaceColor
                            ctx.fillRect(0, 0, width, height)

                            // Cuadricula: lineas cada 40px para dar contexto visual
                            // y que el usuario perciba el efecto del zoom
                            var step = 40
                            ctx.strokeStyle = "#3A3D45"
                            ctx.lineWidth = 1
                            for (var x = 0; x <= width; x += step) {
                                ctx.beginPath()
                                ctx.moveTo(x, 0)
                                ctx.lineTo(x, height)
                                ctx.stroke()
                            }
                            for (var y = 0; y <= height; y += step) {
                                ctx.beginPath()
                                ctx.moveTo(0, y)
                                ctx.lineTo(width, y)
                                ctx.stroke()
                            }

                            // Formas geometricas de colores para hacer el contenido
                            // visualmente interesante al hacer zoom
                            ctx.fillStyle = "#00D1A9"
                            ctx.fillRect(60, 60, 80, 80)

                            ctx.fillStyle = "#FEA601"
                            ctx.beginPath()
                            ctx.arc(260, 100, 50, 0, 2 * Math.PI)
                            ctx.fill()

                            ctx.fillStyle = "#FF7043"
                            ctx.beginPath()
                            ctx.moveTo(160, 240)
                            ctx.lineTo(220, 340)
                            ctx.lineTo(100, 340)
                            ctx.closePath()
                            ctx.fill()

                            ctx.fillStyle = "#AB47BC"
                            ctx.fillRect(260, 260, 100, 60)

                            // Texto sobre las formas
                            ctx.fillStyle = "#FFFFFF"
                            ctx.font = "bold 14px sans-serif"
                            ctx.textAlign = "center"
                            ctx.fillText("Rectangle", 100, 110)
                            ctx.fillText("Circle", 260, 105)
                            ctx.fillText("Triangle", 160, 300)
                            ctx.fillText("Box", 310, 295)
                        }
                    }
                }

                // WheelHandler captura la rueda del raton dentro del Flickable.
                // Divide angleDelta.y entre 120 (un "click" estandar de rueda)
                // y aplica un factor de 0.2 para que el zoom sea gradual.
                // Math.max/min mantiene el valor dentro del rango del slider.
                WheelHandler {
                    onWheel: function(event) {
                        var delta = event.angleDelta.y / 120
                        zoomSlider.value = Math.max(0.5, Math.min(3.0, zoomSlider.value + delta * 0.2))
                    }
                }
            }
        }

        // Controles de zoom: slider para control fino y boton Reset para
        // volver al estado inicial (zoom 1x, sin desplazamiento)
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Zoom: " + zoomSlider.value.toFixed(1) + "x"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: zoomSlider
                Layout.fillWidth: true
                from: 0.5; to: 3.0; value: 1.0
            }
            Button {
                text: "Reset"
                font.pixelSize: Style.resize(11)
                onClicked: {
                    zoomSlider.value = 1.0
                    zoomFlick.contentX = 0
                    zoomFlick.contentY = 0
                }
            }
        }
    }
}
