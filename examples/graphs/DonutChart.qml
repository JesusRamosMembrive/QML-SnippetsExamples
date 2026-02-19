// =============================================================================
// DonutChart.qml — Gráfica de dona (donut/pie chart con hueco central)
// =============================================================================
// Dibuja un gráfico circular con hueco central usando Canvas 2D, donde cada
// segmento representa una proporción del total. Incluye etiquetas externas
// con porcentaje y un valor total en el centro del hueco.
//
// Conceptos clave:
// - Donut vs Pie: La diferencia es solo el radio interior (innerR). Un pie
//   chart tendría innerR = 0. El hueco central se aprovecha para mostrar
//   información adicional (total, KPI, icono, etc.).
// - Arcos con ctx.arc(): Para crear la forma de "rebanada", se trazan dos
//   arcos — uno exterior (sentido horario) y uno interior (sentido antihorario,
//   parámetro `true`). Al cerrar el path, Canvas conecta los extremos
//   automáticamente, formando la forma de sector anular.
// - Separación visual entre segmentos: Se logra con un stroke del color del
//   fondo (Style.surfaceColor), creando líneas divisorias que parecen huecos.
// - Posicionamiento de etiquetas: Se calculan en coordenadas polares usando
//   el ángulo medio de cada segmento. La alineación de texto cambia según
//   si la etiqueta está a la izquierda o derecha del centro.
// - Ángulo inicial -PI/2: Hace que el primer segmento empiece arriba (12 en
//   punto) en lugar de a la derecha (3 en punto), que es la convención visual.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "4. Donut Chart"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "Randomize"
            onClicked: {
                var s = donutCanvas.segments
                for (var i = 0; i < s.length; i++)
                    s[i].value = Math.round(Math.random() * 40 + 5)
                donutCanvas.segments = s
                donutCanvas.requestPaint()
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(250)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Canvas {
            id: donutCanvas
            onAvailableChanged: if (available) requestPaint()
            anchors.centerIn: parent
            width: Math.min(parent.width - Style.resize(20), Style.resize(240))
            height: width

            // Modelo de datos: array de objetos con valor, color y etiqueta.
            // Este patrón es flexible — se puede alimentar desde C++ o JSON.
            property var segments: [
                { value: 35, color: "#00D1A9", label: "QML" },
                { value: 25, color: "#4A90D9", label: "C++" },
                { value: 20, color: "#FEA601", label: "Python" },
                { value: 12, color: "#9B59B6", label: "JS" },
                { value: 8, color: "#E74C3C", label: "Other" }
            ]

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var cx = w / 2, cy = h / 2
                var outerR = Math.min(cx, cy) - 8
                var innerR = outerR * 0.55
                var total = 0
                for (var i = 0; i < segments.length; i++) total += segments[i].value

                // -----------------------------------------------------------
                // Dibujado de segmentos: cada uno es un sector anular.
                // sweep = ángulo proporcional al valor del segmento.
                // Se trazan dos arcos (exterior e interior) para formar la
                // forma de "rebanada de dona". El segundo arc va en sentido
                // contrario (anticlockwise = true) para cerrar correctamente.
                // -----------------------------------------------------------
                var startAngle = -Math.PI / 2
                for (var i = 0; i < segments.length; i++) {
                    var sweep = segments[i].value / total * 2 * Math.PI
                    ctx.beginPath()
                    ctx.arc(cx, cy, outerR, startAngle, startAngle + sweep)
                    ctx.arc(cx, cy, innerR, startAngle + sweep, startAngle, true)
                    ctx.closePath()
                    ctx.fillStyle = segments[i].color
                    ctx.fill()

                    // Borde del mismo color que el fondo para simular separación
                    ctx.strokeStyle = Style.surfaceColor
                    ctx.lineWidth = 2
                    ctx.stroke()

                    // Etiqueta posicionada en el punto medio del arco exterior.
                    // textAlign cambia según el lado para que no se monte sobre la dona.
                    var midAngle = startAngle + sweep / 2
                    var labelR = outerR + 12
                    var lx = cx + labelR * Math.cos(midAngle)
                    var ly = cy + labelR * Math.sin(midAngle)
                    ctx.font = "10px sans-serif"
                    ctx.textAlign = midAngle > Math.PI / 2 || midAngle < -Math.PI / 2 ? "right" : "left"
                    ctx.textBaseline = "middle"
                    ctx.fillStyle = segments[i].color
                    ctx.fillText(segments[i].label + " " + Math.round(segments[i].value / total * 100) + "%", lx, ly)

                    startAngle += sweep
                }

                // Texto central: aprovecha el hueco de la dona para mostrar el total.
                // Este espacio es ideal para un KPI principal o dato destacado.
                ctx.font = "bold 22px sans-serif"
                ctx.fillStyle = "#E0E0E0"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(String(total).toString(), cx, cy - 6)
                ctx.font = "10px sans-serif"
                ctx.fillStyle = "#888"
                ctx.fillText("TOTAL", cx, cy + 12)
            }
        }
    }
}
