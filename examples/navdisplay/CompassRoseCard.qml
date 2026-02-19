// =============================================================================
// CompassRoseCard.qml — Rosa de los vientos con Canvas 2D
// =============================================================================
// Dibuja una brujula giratoria completa de 360 grados usando Canvas (API 2D
// de HTML5). La tarjeta de brujula rota segun el heading del avion, mientras
// la linea de referencia (lubber line) permanece fija arriba.
//
// Demuestra:
// - Canvas para graficos vectoriales dinamicos en QML.
// - Transformaciones 2D: translate + rotate para girar la brujula.
// - Repintado reactivo: onHdgChanged llama requestPaint() para que el
//   Canvas se redibuje solo cuando cambia el heading.
// - Elementos clasicos de instrumentacion: tick marks, etiquetas cardinales,
//   flecha norte (roja), lubber line (amarilla) y readout digital.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property real heading: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Compass Rose"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a1a"
                radius: Style.resize(6)

                // ── Canvas de la brujula ────────────────────────────
                // Canvas usa la API 2D del contexto HTML5. Se redibuja
                // completamente en cada frame porque los graficos vectoriales
                // necesitan recalcularse con cada cambio de heading.
                // onAvailableChanged asegura el primer pintado cuando
                // el Canvas esta listo en el scene graph.
                Canvas {
                    id: compassCanvas
                    onAvailableChanged: if (available) requestPaint()
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)

                    property real hdg: root.heading

                    onHdgChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d");
                        var w = width;
                        var h = height;
                        var cx = w / 2;
                        var cy = h / 2;
                        var r = Math.min(cx, cy) - 20;

                        ctx.clearRect(0, 0, w, h);

                        var green = "#00FF00";
                        var white = "#FFFFFF";

                        // Anillo exterior: marco fijo de referencia
                        ctx.strokeStyle = "#444444";
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.arc(cx, cy, r + 5, 0, 2 * Math.PI);
                        ctx.stroke();

                        // ── Tarjeta giratoria de la brujula ─────────
                        // Se traslada al centro y se rota con el heading negativo
                        // porque la brujula gira en sentido contrario al avion:
                        // si el avion gira a la derecha, la brujula gira a la izquierda.
                        ctx.save();
                        ctx.translate(cx, cy);
                        ctx.rotate(-hdg * Math.PI / 180);

                        // Marcas cada 5 grados: cardinales (largas), mayores (medianas),
                        // menores (cortas). El offset de -90 convierte la convencion
                        // matematica (0=este) a la aeronautica (0=norte).
                        for (var deg = 0; deg < 360; deg += 5) {
                            var rad = (deg - 90) * Math.PI / 180;
                            var isCardinal = (deg % 90 === 0);
                            var isMajor = (deg % 10 === 0);
                            var innerR;
                            if (isCardinal) innerR = r - 20;
                            else if (isMajor) innerR = r - 12;
                            else innerR = r - 6;

                            ctx.strokeStyle = isCardinal ? white : "#888888";
                            ctx.lineWidth = isCardinal ? 2 : 1;
                            ctx.beginPath();
                            ctx.moveTo(Math.cos(rad) * innerR, Math.sin(rad) * innerR);
                            ctx.lineTo(Math.cos(rad) * r, Math.sin(rad) * r);
                            ctx.stroke();
                        }

                        // Etiquetas cada 30 grados. Convencion aeronautica:
                        // los numeros son decenas (3=030, 12=120, etc.).
                        // Los puntos cardinales (N,E,S,W) se muestran en blanco
                        // y los demas en verde para diferenciarse visualmente.
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";
                        ctx.font = "bold " + (r * 0.11) + "px sans-serif";

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
                        ];

                        for (var i = 0; i < labels.length; i++) {
                            var l = labels[i];
                            var rad = (l.deg - 90) * Math.PI / 180;
                            var labelR = r - 32;
                            ctx.fillStyle = l.color;
                            ctx.fillText(l.text, Math.cos(rad) * labelR, Math.sin(rad) * labelR);
                        }

                        // Flecha norte: triangulo rojo que gira con la brujula
                        // para indicar siempre donde esta el norte magnetico.
                        ctx.fillStyle = "#FF4444";
                        var nRad = -Math.PI / 2;
                        var nR = r + 2;
                        ctx.beginPath();
                        ctx.moveTo(Math.cos(nRad) * nR, Math.sin(nRad) * nR);
                        ctx.lineTo(Math.cos(nRad - 0.06) * (nR - 14), Math.sin(nRad - 0.06) * (nR - 14));
                        ctx.lineTo(Math.cos(nRad + 0.06) * (nR - 14), Math.sin(nRad + 0.06) * (nR - 14));
                        ctx.closePath();
                        ctx.fill();

                        ctx.restore();

                        // ── Elementos fijos (no rotan) ──────────────
                        // Lubber line: triangulo amarillo fijo en la parte superior.
                        // En un instrumento real, marca la proa del avion.
                        ctx.fillStyle = "#FFFF00";
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r - 8);
                        ctx.lineTo(cx - 7, cy - r + 5);
                        ctx.lineTo(cx + 7, cy - r + 5);
                        ctx.closePath();
                        ctx.fill();

                        // Punto central de referencia
                        ctx.fillStyle = white;
                        ctx.beginPath();
                        ctx.arc(cx, cy, 3, 0, 2 * Math.PI);
                        ctx.fill();

                        // Readout digital del heading: caja negra con borde verde
                        // y texto en formato de 3 digitos (ej: 045, 270, 000).
                        var hdgStr = Math.round(hdg).toString().padStart(3, "0");
                        ctx.fillStyle = "#000000";
                        ctx.fillRect(cx - 25, 5, 50, 20);
                        ctx.strokeStyle = green;
                        ctx.lineWidth = 1;
                        ctx.strokeRect(cx - 25, 5, 50, 20);
                        ctx.fillStyle = green;
                        ctx.font = "bold " + (r * 0.09) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";
                        ctx.fillText(hdgStr + "\u00B0", cx, 15);
                    }
                }
            }
        }

        Label {
            text: "Full 360\u00B0 rotating compass card. Yellow lubber line at top, red north arrow. Heading slider drives rotation."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
