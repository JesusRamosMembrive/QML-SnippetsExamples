// =============================================================================
// SpeedometerGauge.qml — Velocimetro analogico dibujado con Canvas
// =============================================================================
// Un velocimetro completo (0-240 km/h) con arco de colores, marcas de escala,
// etiquetas numericas, aguja y lectura digital central. Todo pintado con la
// API Canvas 2D de QML, similar a HTML5 Canvas.
//
// Patrones clave:
//   - Canvas como instrumento analogico: el Canvas se repinta cada vez que
//     cambia la velocidad (via Connections + requestPaint). No se usa
//     animacion de Canvas — se redibuja el frame completo en cada cambio.
//   - Gradiente de color por segmentos: como Canvas 2D no soporta
//     gradientes a lo largo de un arco, se divide en ~60 micro-segmentos
//     y se interpola el color RGB manualmente (verde→amarillo→rojo).
//   - Trigonometria para posicionamiento: todas las posiciones (marcas,
//     etiquetas, aguja) se calculan con cos/sin sobre angulos en radianes.
//     El arco abarca 240° (de 150° a 390°) dejando un hueco abajo.
//   - Connections vs onValueChanged: se usa Connections apuntando al
//     contenedor para detectar cambios en speed y repintar el Canvas.
//     Esto desacopla el Canvas del Slider.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Speedometer Gauge"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(30)
        Layout.alignment: Qt.AlignHCenter

        // ── Contenedor del velocimetro ──
        // Las propiedades speed y maxSpeed se definen aqui para que el
        // Canvas y la lectura digital puedan acceder a ellas por id.
        Item {
            id: speedoContainer
            Layout.preferredWidth: Style.resize(260)
            Layout.preferredHeight: Style.resize(260)

            property real speed: speedControl.value
            property real maxSpeed: 240

            Canvas {
                id: speedoCanvas
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var cx = width / 2
                    var cy = height / 2
                    var r = Math.min(cx, cy) - Style.resize(15)

                    // ── Geometria del arco ──
                    // 150° a 390° = arco de 240° con hueco en la parte inferior.
                    // Los angulos en Canvas se miden en radianes desde las 3h.
                    var startAngle = (150) * Math.PI / 180
                    var endAngle = (390) * Math.PI / 180

                    // Arco de fondo (riel completo semitransparente)
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, startAngle, endAngle, false)
                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.08)
                    ctx.lineWidth = Style.resize(18)
                    ctx.lineCap = "butt"
                    ctx.stroke()

                    // ── Arco de velocidad con gradiente por segmentos ──
                    // Se divide el arco activo en 60 partes. Cada una calcula
                    // su color RGB segun la fraccion total del rango:
                    //   0%-50%: verde→amarillo (R sube, G constante)
                    //   50%-100%: amarillo→rojo (G baja, B=0)
                    var speedFraction = speedoContainer.speed / speedoContainer.maxSpeed
                    var speedAngle = startAngle + speedFraction * (endAngle - startAngle)

                    var segments = 60
                    for (var i = 0; i < segments; i++) {
                        var frac = i / segments
                        var a0 = startAngle + frac * (speedAngle - startAngle)
                        var a1 = startAngle + (frac + 1.5 / segments) * (speedAngle - startAngle)
                        if (a1 > speedAngle) a1 = speedAngle
                        if (a0 >= speedAngle) break

                        var totalFrac = frac * speedFraction
                        var r_c, g_c, b_c
                        if (totalFrac < 0.5) {
                            r_c = totalFrac * 2
                            g_c = 0.82
                            b_c = 0.66 * (1 - totalFrac)
                        } else {
                            r_c = 1.0
                            g_c = 0.82 * (1 - (totalFrac - 0.5) * 2)
                            b_c = 0
                        }
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, a0, a1, false)
                        ctx.strokeStyle = Qt.rgba(r_c, g_c, b_c, 0.9)
                        ctx.lineWidth = Style.resize(18)
                        ctx.lineCap = "butt"
                        ctx.stroke()
                    }

                    // ── Marcas de escala (ticks) ──
                    // 13 marcas (0 a 12): las pares son mayores con etiqueta.
                    // Posicion = punto en la circunferencia a radio tickInner/Outer.
                    for (var t = 0; t <= 12; t++) {
                        var tickAngle = startAngle + (t / 12) * (endAngle - startAngle)
                        var isMajor = (t % 2 === 0)
                        var tickInner = r - Style.resize(isMajor ? 28 : 22)
                        var tickOuter = r - Style.resize(10)

                        ctx.beginPath()
                        ctx.moveTo(cx + tickOuter * Math.cos(tickAngle),
                                   cy + tickOuter * Math.sin(tickAngle))
                        ctx.lineTo(cx + tickInner * Math.cos(tickAngle),
                                   cy + tickInner * Math.sin(tickAngle))
                        ctx.strokeStyle = isMajor ? Style.fontPrimaryColor : Qt.rgba(1, 1, 1, 0.3)
                        ctx.lineWidth = isMajor ? Style.resize(2) : Style.resize(1)
                        ctx.stroke()

                        // Etiquetas numericas solo en marcas mayores
                        if (isMajor) {
                            var labelR = r - Style.resize(40)
                            var labelVal = Math.round(t / 12 * speedoContainer.maxSpeed)
                            ctx.font = Style.resize(11) + "px sans-serif"
                            ctx.fillStyle = Style.fontSecondaryColor
                            ctx.textAlign = "center"
                            ctx.textBaseline = "middle"
                            ctx.fillText(labelVal,
                                cx + labelR * Math.cos(tickAngle),
                                cy + labelR * Math.sin(tickAngle))
                        }
                    }

                    // ── Aguja ──
                    // Linea simple desde el centro hasta el punto del arco
                    // correspondiente a la velocidad actual. Color rojo fijo.
                    var needleAngle = startAngle + speedFraction * (endAngle - startAngle)
                    var needleLen = r - Style.resize(30)
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + needleLen * Math.cos(needleAngle),
                               cy + needleLen * Math.sin(needleAngle))
                    ctx.strokeStyle = "#FF3B30"
                    ctx.lineWidth = Style.resize(2.5)
                    ctx.lineCap = "round"
                    ctx.stroke()

                    // ── Eje central (hub) ──
                    // Dos circulos concentricos simulan un eje metalico.
                    ctx.beginPath()
                    ctx.arc(cx, cy, Style.resize(8), 0, 2 * Math.PI)
                    ctx.fillStyle = "#FF3B30"
                    ctx.fill()
                    ctx.beginPath()
                    ctx.arc(cx, cy, Style.resize(4), 0, 2 * Math.PI)
                    ctx.fillStyle = Style.cardColor
                    ctx.fill()
                }

                // Repintar el Canvas cada vez que cambia la velocidad.
                // Connections es preferible a un binding en onPaint porque
                // permite reaccionar a cambios de propiedades externas.
                Connections {
                    target: speedoContainer
                    function onSpeedChanged() { speedoCanvas.requestPaint() }
                }
                Component.onCompleted: requestPaint()
            }

            // ── Lectura digital superpuesta ──
            // Se posiciona sobre el Canvas con anchors, creando una capa
            // de texto encima del dibujo vectorial.
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(40)
                spacing: Style.resize(2)

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(speedoContainer.speed).toString()
                    font.pixelSize: Style.resize(36)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "km/h"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // ── Controles del velocimetro ──
        // El Slider controla la velocidad. La etiqueta cambia de color
        // con operador ternario encadenado segun umbrales de velocidad.
        ColumnLayout {
            Layout.fillHeight: true
            spacing: Style.resize(10)
            Layout.alignment: Qt.AlignVCenter

            Label {
                text: "Speed"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: speedControl
                Layout.preferredWidth: Style.resize(200)
                from: 0
                to: 240
                value: 85
                stepSize: 1
            }

            Label {
                text: Math.round(speedControl.value) + " km/h"
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: speedControl.value > 180 ? "#FF3B30"
                     : speedControl.value > 120 ? "#FFA500"
                     : Style.mainColor
            }
        }
    }
}
