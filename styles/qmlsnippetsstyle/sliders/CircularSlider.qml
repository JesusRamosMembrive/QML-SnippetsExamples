// ============================================================================
// CircularSlider.qml — Slider circular/arco dibujado con Canvas
// ============================================================================
//
// NOTA: Este es un componente personalizado construido desde cero usando Item.
// NO es un override de estilo Qt (no hereda de T.Slider) porque el Slider
// nativo de Qt no soporta interaccion circular — solo lineal.
//
// ARQUITECTURA — Dos elementos Canvas:
//   1. glowCanvas: resplandor suave detras del arco de progreso (efecto neon)
//   2. canvas:     dibujo principal — pista, progreso, marcas, tirador (handle)
//
// GEOMETRIA DEL ARCO:
//   _startAngle = 135° (abajo-izquierda del circulo)
//   _sweepAngle = 270° (recorre la mayor parte del circulo)
//   Esto deja un hueco de 90° en la parte inferior — disposicion clasica de
//   velocimetro/indicador de nivel.
//
//        225° (arriba-izq)  ···  315° (arriba-der)
//       /                                        \
//     180° (izquierda)                    0°/360° (derecha)
//       \                                        /
//        135° (INICIO) ··· GAP 90° ··· 45° (FIN)
//
// API CANVAS:
//   Usa la misma API que HTML5 Canvas (ctx.beginPath, ctx.arc, ctx.stroke, etc.)
//   QML Canvas es compatible con el estandar web, asi que la documentacion
//   de MDN Canvas API aplica directamente.
//
// INTERACCION DEL MOUSE (angleToValue):
//   Convierte la posicion del mouse a un angulo usando Math.atan2(dy, dx),
//   y luego ese angulo a un valor dentro del rango from-to.
//   Incluye una "zona muerta" en el hueco inferior (45°-135°) donde los
//   clicks se ajustan automaticamente al minimo o maximo segun el lado.
//
// stepSize:
//   Cuando es > 0, ajusta (snap) el valor al paso mas cercano usando
//   Math.round(v / stepSize) * stepSize.
//
// signal moved():
//   Senal personalizada emitida al arrastrar, permitiendo que el componente
//   padre reaccione a los cambios de valor.
//
// REPINTADO MANUAL (onXxxChanged -> requestPaint):
//   A diferencia de Rectangle y otros items declarativos que se actualizan
//   automaticamente con los bindings, Canvas debe repintarse manualmente
//   llamando a requestPaint() cada vez que cambia una propiedad visual.
// ============================================================================

import QtQuick
import Qt5Compat.GraphicalEffects

import utils

Item {
    id: root

    // --- Propiedades del rango de valores ---
    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 0       // 0 = continuo, >0 = ajuste a pasos discretos

    // --- Propiedades visuales ---
    property color trackColor: Qt.rgba(0.66, 0.66, 0.66, 0.3)
    property color progressColor: Style.mainColor
    property color handleColor: "white"
    property color textColor: Style.fontPrimaryColor

    property real trackWidth: Style.resize(10)
    property real handleRadius: Style.resize(14)
    property bool showValue: true
    property string suffix: ""
    property int decimals: 0
    property bool showTicks: true
    property int tickCount: 10

    // Senal personalizada: emitida cada vez que el usuario arrastra el tirador
    signal moved()

    // --- Geometria interna del arco ---
    // Angulos en radianes. 135° = inicio abajo-izquierda, 270° de recorrido.
    readonly property real _startAngle: 135 * Math.PI / 180
    readonly property real _sweepAngle: 270 * Math.PI / 180
    readonly property real _endAngle: _startAngle + _sweepAngle
    readonly property real _centerX: width / 2
    readonly property real _centerY: height / 2
    // Radio del arco: la mitad del lado menor, menos margen para el tirador
    readonly property real _radius: Math.min(width, height) / 2 - handleRadius - Style.resize(4)
    // Ratio 0.0-1.0 que indica cuanto del arco esta "lleno" segun el valor actual
    readonly property real _valueRatio: (to > from) ? (value - from) / (to - from) : 0
    // Angulo hasta donde llega el arco de progreso
    readonly property real _valueAngle: _startAngle + _valueRatio * _sweepAngle

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(200)

    // Canvas de resplandor: dibuja un arco mas grueso y semitransparente
    // detras del arco de progreso para crear un efecto de brillo suave (glow).
    Canvas {
        id: glowCanvas
        anchors.fill: parent
        visible: root._valueRatio > 0.01

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            if (root._valueRatio <= 0.01)
                return

            // Arco de resplandor: mismo recorrido que el progreso pero mas grueso
            // y con globalAlpha bajo para dar efecto de halo difuminado
            ctx.beginPath()
            ctx.arc(root._centerX, root._centerY, root._radius,
                    root._startAngle, root._valueAngle, false)
            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = root.trackWidth + Style.resize(6)
            ctx.lineCap = "round"
            ctx.globalAlpha = 0.25
            ctx.stroke()
        }
    }

    // Canvas principal: dibuja la pista de fondo, el arco de progreso,
    // las marcas de graduacion (ticks) y el tirador circular (handle).
    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var cx = root._centerX
            var cy = root._centerY
            var r  = root._radius

            // -- Marcas de graduacion (ticks) --
            // Se dibujan como lineas radiales. Las marcas "mayores" (cada 5)
            // son mas largas y gruesas para facilitar la lectura.
            if (root.showTicks) {
                for (var i = 0; i <= root.tickCount; i++) {
                    var tickAngle = root._startAngle + (i / root.tickCount) * root._sweepAngle
                    var major = (i % 5 === 0)
                    var innerR = r - root.trackWidth / 2 - Style.resize(major ? 14 : 8)
                    var outerR = r - root.trackWidth / 2 - Style.resize(2)

                    // Cada tick es una linea desde innerR hasta outerR en la direccion del angulo
                    ctx.beginPath()
                    ctx.moveTo(cx + innerR * Math.cos(tickAngle),
                               cy + innerR * Math.sin(tickAngle))
                    ctx.lineTo(cx + outerR * Math.cos(tickAngle),
                               cy + outerR * Math.sin(tickAngle))
                    ctx.strokeStyle = Qt.rgba(0, 0, 0, major ? 0.3 : 0.12)
                    ctx.lineWidth = major ? Style.resize(2) : 1
                    ctx.stroke()
                }
            }

            // -- Pista de fondo (track) --
            // Arco completo de 270° en color tenue — representa el rango total
            ctx.beginPath()
            ctx.arc(cx, cy, r, root._startAngle, root._endAngle, false)
            ctx.strokeStyle = root.trackColor
            ctx.lineWidth = root.trackWidth
            ctx.lineCap = "round"
            ctx.stroke()

            // -- Arco de progreso --
            // Arco parcial desde el inicio hasta _valueAngle — representa el valor actual
            if (root._valueRatio > 0.005) {
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._startAngle, root._valueAngle, false)
                ctx.strokeStyle = root.progressColor
                ctx.lineWidth = root.trackWidth
                ctx.lineCap = "round"
                ctx.stroke()
            }

            // -- Tirador (handle) --
            // Posicion: punto sobre el arco en el angulo del valor actual
            var hx = cx + r * Math.cos(root._valueAngle)
            var hy = cy + r * Math.sin(root._valueAngle)

            // Sombra del tirador (circulo desplazado hacia abajo, semitransparente)
            ctx.beginPath()
            ctx.arc(hx, hy + Style.resize(2), root.handleRadius, 0, 2 * Math.PI)
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.2)
            ctx.fill()

            // Cuerpo del tirador (circulo blanco con borde de color)
            ctx.beginPath()
            ctx.arc(hx, hy, root.handleRadius, 0, 2 * Math.PI)
            ctx.fillStyle = root.handleColor
            ctx.fill()
            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = Style.resize(3)
            ctx.stroke()

            // Punto central del tirador (pequeno circulo de color)
            ctx.beginPath()
            ctx.arc(hx, hy, Style.resize(4), 0, 2 * Math.PI)
            ctx.fillStyle = root.progressColor
            ctx.fill()
        }
    }

    // Texto central: muestra el valor numerico actual y el sufijo opcional
    Column {
        visible: root.showValue
        anchors.centerIn: parent
        spacing: Style.resize(2)

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.value.toFixed(root.decimals)
            font.pixelSize: root._radius * 0.38
            font.bold: true
            font.family: Style.fontFamilyBold
            color: root.textColor
        }

        Text {
            visible: root.suffix !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.suffix
            font.pixelSize: root._radius * 0.15
            font.family: Style.fontFamilyRegular
            color: Style.inactiveColor
        }
    }

    // --- Interaccion con el mouse ---
    // Convierte la posicion del click/arrastre a un valor dentro del rango.
    MouseArea {
        anchors.fill: parent

        // angleToValue: convierte posicion (x,y) del mouse a valor del slider.
        // 1. Calcula el angulo desde el centro usando Math.atan2 (trigonometria)
        // 2. Maneja la "zona muerta" (hueco inferior del arco)
        // 3. Convierte el angulo relativo a un ratio 0-1 y luego al valor final
        // 4. Aplica stepSize si esta configurado (snap a pasos discretos)
        function angleToValue(mx, my) {
            var dx = mx - root._centerX
            var dy = my - root._centerY
            // Math.atan2: devuelve el angulo en radianes entre el eje X+ y el punto (dx,dy)
            var angle = Math.atan2(dy, dx)
            if (angle < 0) angle += 2 * Math.PI

            var deg = angle * 180 / Math.PI

            // Zona muerta: 45°-135° (el hueco de 90° en la parte inferior del arco).
            // Si el click cae aqui, se ajusta al extremo mas cercano:
            //   - Lado izquierdo del hueco (deg < 90°) -> snap al maximo
            //   - Lado derecho del hueco (deg >= 90°) -> snap al minimo
            if (deg > 45 && deg < 135) {
                angle = (deg < 90)
                        ? (root._endAngle - 2 * Math.PI)   // snap to max
                        : root._startAngle                  // snap to min
            }

            // Convertir angulo absoluto a posicion relativa dentro del arco
            var rel = angle - root._startAngle
            if (rel < 0) rel += 2 * Math.PI

            // Ratio 0-1 y conversion a valor en el rango from-to
            var ratio = Math.max(0, Math.min(1, rel / root._sweepAngle))
            var v = root.from + ratio * (root.to - root.from)

            // stepSize: ajuste a pasos discretos (ej: stepSize=5 -> 0, 5, 10, 15...)
            if (root.stepSize > 0)
                v = Math.round(v / root.stepSize) * root.stepSize

            root.value = Math.max(root.from, Math.min(root.to, v))
            root.moved()
        }

        onPressed: function(mouse) { angleToValue(mouse.x, mouse.y) }
        onPositionChanged: function(mouse) {
            if (pressed) angleToValue(mouse.x, mouse.y)
        }
    }

    // --- Disparadores de repintado ---
    // Canvas NO se actualiza automaticamente con bindings (a diferencia de
    // Rectangle, Text, etc.). Cada vez que cambia una propiedad visual,
    // debemos llamar requestPaint() manualmente para forzar el redibujado.
    onValueChanged:         { canvas.requestPaint(); glowCanvas.requestPaint() }
    on_ValueRatioChanged:   { canvas.requestPaint(); glowCanvas.requestPaint() }
    onWidthChanged:         { canvas.requestPaint(); glowCanvas.requestPaint() }
    onHeightChanged:        { canvas.requestPaint(); glowCanvas.requestPaint() }
    onTrackColorChanged:    { canvas.requestPaint(); glowCanvas.requestPaint() }
    onProgressColorChanged: { canvas.requestPaint(); glowCanvas.requestPaint() }
    Component.onCompleted:  { canvas.requestPaint(); glowCanvas.requestPaint() }
}
