// =============================================================================
// Dial.qml — Override de estilo para Dial
// =============================================================================
//
// Este es el override de estilo mas complejo del proyecto. Dibuja un dial
// circular personalizado usando Canvas (API de HTML5 Canvas) para el arco
// de fondo, el progreso, las marcas (ticks) y el efecto de resplandor (glow).
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.Dial con toda la logica (value, position, pressed, etc.)
// pero SIN ningun visual. Nosotros definimos el visual aqui.
//
// ---- GEOMETRIA DEL ARCO ----
// El rango por defecto del Dial es -140 a +140 grados desde las 12 en punto.
// Canvas usa un sistema de coordenadas diferente: 0 grados = 3 en punto,
// sentido horario. Las propiedades _arcStart/_arcSweep/_arcEnd convierten
// entre ambos sistemas. Resultado: inicio=130, barrido=280, fin=410(=50).
//
// ---- PROPIEDADES PERSONALIZABLES ----
// Las propiedades custom (progressColor, trackWidth, showTicks, etc.) permiten
// personalizar cada instancia sin crear un componente nuevo:
//   Dial { progressColor: "red"; showTicks: false }
//
// ---- CANVAS.onPaint: DIBUJO IMPERATIVO ----
// A diferencia del QML declarativo, Canvas dibuja paso a paso con comandos ctx
// (como HTML Canvas). Se pintan 4 capas en orden:
//   1. Glow (semitransparente detras del progreso)
//   2. Marcas de tick (mayores cada 5, menores entre ellas)
//   3. Pista de fondo (track completo)
//   4. Arco de progreso
//
// ---- HANDLE (MANIJA) ----
// Se posiciona con trigonometria cos/sin sobre el arco. Tiene sombra + cuerpo
// + punto interior para dar sensacion de profundidad.
//
// ---- requestPaint() ----
// Canvas NO se repinta automaticamente cuando cambian propiedades (a diferencia
// de Rectangle). Se debe llamar requestPaint() explicitamente por cada
// propiedad que afecte el dibujo. Component.onCompleted hace el pintado
// inicial cuando el componente se crea por primera vez.
//
// ---- inputMode: Dial.Circular ----
// El usuario arrastra en movimiento circular para cambiar el valor
// (vs. Dial.Vertical donde se arrastra arriba/abajo).
// =============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Dial {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(200)

    // inputMode: Circular — el usuario arrastra en circulo para cambiar valor
    inputMode: T.Dial.Circular

    // --- Propiedades personalizables por instancia ---
    // Permiten configurar el Dial sin necesidad de crear un componente derivado
    property color progressColor: Style.mainColor
    property color trackColor: Qt.rgba(0.66, 0.66, 0.66, 0.3)
    property real trackWidth: Style.resize(10)
    property bool showTicks: true
    property int tickCount: 10
    property bool showValue: true
    property string suffix: ""
    property int valueDecimals: 0

    // --- Geometria del arco ---
    // El Dial barre de -140 a +140 grados desde las 12 en punto.
    // Canvas usa: 0 rad = 3 en punto, sentido horario.
    // Conversion: inicio en 130 grados (desde las 3), barrido total de 280 grados.
    // _arcEnd = _arcStart + _arcSweep = 410 grados = 50 grados (equivalente).
    readonly property real _arcStart:  130 * Math.PI / 180
    readonly property real _arcSweep:  280 * Math.PI / 180
    readonly property real _arcEnd:    _arcStart + _arcSweep
    readonly property real _dialSize:  Math.min(width, height)
    readonly property real _arcRadius: _dialSize / 2 - _dialSize * 0.09  // Radio con margen interior
    readonly property real _progressAngle: _arcStart + root.position * _arcSweep  // Angulo actual segun posicion (0..1)

    background: Item {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight

        // Canvas: usa la API de HTML5 Canvas para dibujo imperativo.
        // A diferencia de elementos declarativos (Rectangle, etc.), aqui
        // dibujamos paso a paso con comandos del contexto 2D (ctx).
        Canvas {
            id: dialCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.clearRect(0, 0, width, height)  // Limpiar todo antes de redibujar

                var cx = width / 2
                var cy = height / 2
                var r  = root._arcRadius

                // -- Capa 1: Glow (resplandor detras del progreso) --
                // Se dibuja mas ancho y semitransparente para crear un halo
                if (root.position > 0.01) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, root._arcStart, root._progressAngle, false)
                    ctx.strokeStyle = root.progressColor
                    ctx.lineWidth = root.trackWidth + root._dialSize * 0.03
                    ctx.lineCap = "round"
                    ctx.globalAlpha = 0.2
                    ctx.stroke()
                    ctx.globalAlpha = 1.0
                }

                // -- Capa 2: Marcas de tick --
                // Lineas radiales: mayores (cada 5) mas largas y visibles
                if (root.showTicks) {
                    var s = root._dialSize
                    for (var i = 0; i <= root.tickCount; i++) {
                        var ta  = root._arcStart + (i / root.tickCount) * root._arcSweep
                        var maj = (i % 5 === 0)
                        var ri  = r - root.trackWidth / 2 - s * (maj ? 0.07 : 0.04)
                        var ro  = r - root.trackWidth / 2 - s * 0.01

                        ctx.beginPath()
                        ctx.moveTo(cx + ri * Math.cos(ta), cy + ri * Math.sin(ta))
                        ctx.lineTo(cx + ro * Math.cos(ta), cy + ro * Math.sin(ta))
                        ctx.strokeStyle = Qt.rgba(1, 1, 1, maj ? 0.3 : 0.12)
                        ctx.lineWidth = maj ? Math.max(1.5, s * 0.01) : 1
                        ctx.stroke()
                    }
                }

                // -- Capa 3: Pista de fondo (track completo) --
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._arcStart, root._arcEnd, false)
                ctx.strokeStyle = root.trackColor
                ctx.lineWidth = root.trackWidth
                ctx.lineCap = "round"
                ctx.stroke()

                // -- Capa 4: Arco de progreso (sobre la pista) --
                if (root.position > 0.005) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, root._arcStart, root._progressAngle, false)
                    ctx.strokeStyle = root.progressColor
                    ctx.lineWidth = root.trackWidth
                    ctx.lineCap = "round"
                    ctx.stroke()
                }
            }
        }

        // Texto central: muestra el valor numerico y sufijo opcional
        Column {
            visible: root.showValue
            anchors.centerIn: parent
            spacing: Style.resize(2)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.value.toFixed(root.valueDecimals)
                font.pixelSize: root._arcRadius * 0.38
                font.bold: true
                font.family: Style.fontFamilyBold
                color: Style.fontPrimaryColor
            }

            Text {
                visible: root.suffix !== ""
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.suffix
                font.pixelSize: root._arcRadius * 0.15
                font.family: Style.fontFamilyRegular
                color: Style.inactiveColor
            }
        }
    }

    // --- Handle (manija) ---
    // Se posiciona con trigonometria: x = centro + radio * cos(angulo),
    // y = centro + radio * sin(angulo). Esto lo coloca sobre el arco
    // en la posicion exacta del progreso actual.
    handle: Item {
        id: handleItem
        width: root._dialSize * 0.14
        height: width

        // Posicion calculada con cos/sin para colocar el handle sobre el arco
        x: root.background.x + root.background.width / 2 - width / 2
           + root._arcRadius * Math.cos(root._progressAngle)
        y: root.background.y + root.background.height / 2 - height / 2
           + root._arcRadius * Math.sin(root._progressAngle)

        // Sombra desplazada hacia abajo para dar profundidad
        Rectangle {
            width: parent.width
            height: width
            radius: width / 2
            y: root._dialSize * 0.01
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        // Cuerpo del handle: circulo con borde de color y punto central
        Rectangle {
            id: handleBody
            width: parent.width
            height: width
            radius: width / 2
            color: Style.cardColor
            border.color: root.progressColor
            border.width: Math.max(2, root._dialSize * 0.015)
            scale: root.pressed ? 1.15 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }

            // Punto interior: refuerza la sensacion de profundidad
            Rectangle {
                width: root._dialSize * 0.04
                height: width
                radius: width / 2
                color: root.progressColor
                anchors.centerIn: parent
            }
        }
    }

    // --- requestPaint() por cada propiedad que afecte el dibujo ---
    // Canvas NO se repinta automaticamente cuando cambian propiedades
    // (a diferencia de Rectangle, que se actualiza solo). Debemos llamar
    // requestPaint() explicitamente para cada cambio relevante.
    onPositionChanged:     dialCanvas.requestPaint()
    onPressedChanged:      dialCanvas.requestPaint()
    onProgressColorChanged: dialCanvas.requestPaint()
    onTrackColorChanged:   dialCanvas.requestPaint()
    onWidthChanged:        dialCanvas.requestPaint()
    onHeightChanged:       dialCanvas.requestPaint()
    // Component.onCompleted: pintado inicial cuando el componente se crea
    Component.onCompleted: dialCanvas.requestPaint()
}
