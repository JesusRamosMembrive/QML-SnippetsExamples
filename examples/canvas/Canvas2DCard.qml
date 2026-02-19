// ============================================================================
// Canvas2DCard.qml
// Demuestra el elemento Canvas de QML con la API de dibujo 2D (Context2D).
//
// CONCEPTO CLAVE: Canvas proporciona una superficie de dibujo imperativo,
// similar al <canvas> de HTML5. A diferencia del resto de QML (que es
// declarativo), aqui se dibuja paso a paso con codigo JavaScript.
//
// CUANDO USAR CANVAS vs SHAPE:
//   - Canvas: ideal para graficos dinamicos, visualizaciones de datos,
//     dibujo libre, o cuando necesitas la API completa de Context2D.
//   - Shape (QtQuick.Shapes): mejor para formas vectoriales estaticas o
//     animadas declarativamente, con mejor rendimiento en GPU.
//
// API Context2D: es casi identica a la de HTML5 Canvas. Los metodos
// principales son: beginPath(), moveTo(), lineTo(), arc(), bezierCurveTo(),
// fill(), stroke(), fillText(), createLinearGradient(), etc.
//
// IMPORTANTE: Canvas se redibuja SOLO cuando se llama requestPaint().
// El handler onPaint contiene todo el codigo de dibujo.
// ============================================================================
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
        spacing: Style.resize(10)

        Label {
            text: "Canvas 2D"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Area del Canvas ---
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            Canvas {
                id: primitiveCanvas
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                // onAvailableChanged: se dispara cuando el contexto de renderizado
                // esta listo. Es necesario esperar a que 'available' sea true antes
                // de llamar requestPaint(), porque el contexto OpenGL/software
                // puede no estar inicializado inmediatamente.
                onAvailableChanged: if (available) requestPaint()

                // onPaint: se ejecuta cada vez que se necesita redibujar.
                // Recibe implicitamente el contexto a traves de getContext("2d").
                // PATRON: siempre limpiar con clearRect() al inicio para evitar
                // que los dibujos anteriores se acumulen.
                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height

                    ctx.clearRect(0, 0, w, h)

                    // 1. Rectangulo con gradiente lineal
                    // createLinearGradient(x0, y0, x1, y1) define la direccion
                    // del gradiente. addColorStop(posicion, color) agrega colores
                    // en posiciones de 0.0 a 1.0.
                    var grad = ctx.createLinearGradient(10, 10, 140, 70)
                    grad.addColorStop(0, "#00D1A9")
                    grad.addColorStop(1, "#4A90D9")
                    ctx.fillStyle = grad
                    ctx.beginPath()
                    ctx.roundedRect(10, 10, 130, 60, 8, 8)
                    ctx.fill()

                    // 2. Circulo con borde (stroke) y relleno semitransparente
                    // arc(cx, cy, radio, anguloInicio, anguloFin) dibuja un arco.
                    // Un circulo completo va de 0 a 2*PI radianes.
                    // El color "#FEA60140" usa notacion hex con alfa (40 = ~25%).
                    ctx.beginPath()
                    ctx.arc(200, 40, 28, 0, 2 * Math.PI)
                    ctx.fillStyle = "#FEA60140"
                    ctx.fill()
                    ctx.strokeStyle = "#FEA601"
                    ctx.lineWidth = 3
                    ctx.stroke()

                    // 3. Circulo solido sin borde
                    ctx.beginPath()
                    ctx.arc(270, 40, 20, 0, 2 * Math.PI)
                    ctx.fillStyle = "#FF5900"
                    ctx.fill()

                    // 4. Lineas conectadas (polyline)
                    // moveTo() posiciona el "lapiz", lineTo() traza lineas.
                    // stroke() dibuja el trazo; sin fill() no hay relleno.
                    ctx.strokeStyle = "#9B59B6"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(10, 90)
                    ctx.lineTo(60, 120)
                    ctx.lineTo(110, 85)
                    ctx.lineTo(160, 130)
                    ctx.stroke()

                    // 5. Rectangulo con linea discontinua
                    // setLineDash([trazo, espacio]) define el patron de guiones.
                    // IMPORTANTE: restaurar con setLineDash([]) despues, o todas
                    // las lineas siguientes tambien seran discontinuas.
                    ctx.strokeStyle = "#E74C3C"
                    ctx.lineWidth = 2
                    ctx.setLineDash([6, 4])
                    ctx.strokeRect(180, 80, 80, 55)
                    ctx.setLineDash([])

                    // 6. Texto con sombra
                    // Las propiedades shadow* afectan a TODO lo que se dibuje
                    // mientras esten activas. Hay que resetearlas despues.
                    ctx.shadowColor = "#00D1A9"
                    ctx.shadowBlur = 8
                    ctx.shadowOffsetX = 2
                    ctx.shadowOffsetY = 2
                    ctx.font = "bold 22px sans-serif"
                    ctx.fillStyle = "#E0E0E0"
                    ctx.fillText("Canvas!", 10, 170)
                    ctx.shadowBlur = 0
                    ctx.shadowOffsetX = 0
                    ctx.shadowOffsetY = 0

                    // 7. Curva Bezier cubica
                    // bezierCurveTo(cp1x, cp1y, cp2x, cp2y, endX, endY) traza una
                    // curva suave con 2 puntos de control. Util para formas
                    // organicas, graficos y animaciones de trayectoria.
                    ctx.strokeStyle = "#00D1A9"
                    ctx.lineWidth = 3
                    ctx.beginPath()
                    ctx.moveTo(150, 160)
                    ctx.bezierCurveTo(180, 110, 240, 200, 290, 150)
                    ctx.stroke()
                }
            }
        }

        Label {
            text: "Imperative drawing with context2D: gradients, arcs, text, bezier curves"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
