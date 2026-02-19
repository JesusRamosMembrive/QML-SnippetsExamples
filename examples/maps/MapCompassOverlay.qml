// =============================================================================
// MapCompassOverlay.qml — Brujula miniatura como overlay del mapa
// =============================================================================
// Version compacta de la rosa de los vientos, posicionada en la esquina
// inferior izquierda del mapa. Muestra el heading actual del avion con
// la misma estetica de instrumentacion aeronautica que CompassRoseCard
// pero adaptada a un tamano reducido.
//
// Patrones y conceptos clave:
// - Reutilizacion de logica Canvas: mismo algoritmo de dibujo que
//   CompassRoseCard pero con dimensiones ajustadas al overlay.
//   En un proyecto real se podria extraer a un componente compartido.
// - Fondo circular semitransparente (Qt.rgba con alpha 0.65) para que
//   el mapa sea visible detras pero la brujula sea legible.
// - Repintado reactivo: solo se redibuja cuando cambia el heading,
//   no en cada frame.
// =============================================================================
import QtQuick
import QtQuick.Controls
import utils

Rectangle {
    id: root

    property real heading: 0

    // Posicionamiento como overlay circular en la esquina inferior izquierda.
    // bottomMargin extra para no solaparse con la MapControlsBar.
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: Style.resize(15)
    anchors.bottomMargin: Style.resize(65)
    width: Style.resize(140)
    height: width
    radius: width / 2
    color: Qt.rgba(0, 0, 0, 0.65)
    border.color: Qt.rgba(1, 1, 1, 0.25)
    border.width: 1

    // ── Canvas de la brujula ────────────────────────────────────
    // Dibuja los mismos elementos que CompassRoseCard:
    // 1. Anillo exterior fijo
    // 2. Tarjeta giratoria con marcas y etiquetas (rota con -heading)
    // 3. Flecha norte roja (gira con la tarjeta)
    // 4. Lubber line amarilla fija arriba
    // 5. Punto central
    // 6. Readout digital del heading
    Canvas {
        id: compassCanvas
        onAvailableChanged: if (available) requestPaint()
        anchors.fill: parent
        anchors.margins: Style.resize(5)

        property real hdg: root.heading

        onHdgChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height
            var cx = w / 2
            var cy = h / 2
            var r = Math.min(cx, cy) - 14

            ctx.clearRect(0, 0, w, h)

            var green = "#00FF00"
            var white = "#FFFFFF"

            // Anillo exterior fijo
            ctx.strokeStyle = "#666666"
            ctx.lineWidth = 1.5
            ctx.beginPath()
            ctx.arc(cx, cy, r + 4, 0, 2 * Math.PI)
            ctx.stroke()

            // Tarjeta giratoria: todo lo que esta entre save/restore
            // gira inversamente al heading del avion.
            ctx.save()
            ctx.translate(cx, cy)
            ctx.rotate(-hdg * Math.PI / 180)

            // Marcas cada 5 grados con jerarquia visual:
            // cardinales > mayores (cada 10) > menores
            for (var deg = 0; deg < 360; deg += 5) {
                var rad = (deg - 90) * Math.PI / 180
                var isCardinal = (deg % 90 === 0)
                var isMajor = (deg % 10 === 0)
                var innerR
                if (isCardinal) innerR = r - 16
                else if (isMajor) innerR = r - 9
                else innerR = r - 5

                ctx.strokeStyle = isCardinal ? white : "#888888"
                ctx.lineWidth = isCardinal ? 2 : 1
                ctx.beginPath()
                ctx.moveTo(Math.cos(rad) * innerR, Math.sin(rad) * innerR)
                ctx.lineTo(Math.cos(rad) * r, Math.sin(rad) * r)
                ctx.stroke()
            }

            // Etiquetas cada 30 grados (convencion aeronautica)
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.font = "bold " + (r * 0.13) + "px sans-serif"

            var labels = [
                { deg: 0, text: "N", color: white },
                { deg: 30, text: "3", color: green },
                { deg: 60, text: "6", color: green },
                { deg: 90, text: "E", color: white },
                { deg: 120, text: "12", color: green },
                { deg: 150, text: "15", color: green },
                { deg: 180, text: "S", color: white },
                { deg: 210, text: "21", color: green },
                { deg: 240, text: "24", color: green },
                { deg: 270, text: "W", color: white },
                { deg: 300, text: "30", color: green },
                { deg: 330, text: "33", color: green }
            ]

            for (var i = 0; i < labels.length; i++) {
                var l = labels[i]
                var lrad = (l.deg - 90) * Math.PI / 180
                var labelR = r - 26
                ctx.fillStyle = l.color
                ctx.fillText(l.text,
                    Math.cos(lrad) * labelR,
                    Math.sin(lrad) * labelR)
            }

            // Flecha norte (triangulo rojo, gira con la tarjeta)
            ctx.fillStyle = "#FF4444"
            var nRad = -Math.PI / 2
            var nR = r + 1
            ctx.beginPath()
            ctx.moveTo(Math.cos(nRad) * nR, Math.sin(nRad) * nR)
            ctx.lineTo(Math.cos(nRad - 0.08) * (nR - 12),
                       Math.sin(nRad - 0.08) * (nR - 12))
            ctx.lineTo(Math.cos(nRad + 0.08) * (nR - 12),
                       Math.sin(nRad + 0.08) * (nR - 12))
            ctx.closePath()
            ctx.fill()

            ctx.restore()

            // ── Elementos fijos (no rotan) ──────────────────────
            // Lubber line amarilla: marca la proa del avion
            ctx.fillStyle = "#FFFF00"
            ctx.beginPath()
            ctx.moveTo(cx, cy - r - 6)
            ctx.lineTo(cx - 6, cy - r + 4)
            ctx.lineTo(cx + 6, cy - r + 4)
            ctx.closePath()
            ctx.fill()

            // Punto central
            ctx.fillStyle = white
            ctx.beginPath()
            ctx.arc(cx, cy, 2.5, 0, 2 * Math.PI)
            ctx.fill()

            // Readout digital del heading (formato 3 digitos)
            var hdgStr = Math.round(hdg).toString().padStart(3, "0")
            ctx.fillStyle = "#000000"
            ctx.fillRect(cx - 20, 3, 40, 16)
            ctx.strokeStyle = green
            ctx.lineWidth = 1
            ctx.strokeRect(cx - 20, 3, 40, 16)
            ctx.fillStyle = green
            ctx.font = "bold " + (r * 0.10) + "px sans-serif"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            ctx.fillText(hdgStr + "\u00B0", cx, 11)
        }
    }
}
