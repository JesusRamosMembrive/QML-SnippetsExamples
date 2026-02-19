// =============================================================================
// HeadingIndicatorCard.qml — Indicador de Rumbo (HSI / Brujula)
// =============================================================================
// Simula el indicador de rumbo tipo Navigation Display (ND) de un avion.
// La rosa de los vientos rota en sentido contrario al rumbo del avion,
// de modo que el rumbo actual siempre queda alineado con la marca fija
// superior (lubber line). Incluye un heading bug (marcador de rumbo deseado).
//
// Tecnicas Canvas 2D utilizadas:
//   - Rotacion del contexto para girar toda la rosa de los vientos
//   - Coordenadas polares para posicionar marcas y etiquetas en el perimetro
//   - save/restore anidados: se salva el contexto para cada etiqueta
//     y se contra-rota para que el texto permanezca legible
//   - Elementos fijos (lubber line, readout) se dibujan DESPUES de restore()
//
// Trigonometria clave:
//   - Cada grado se convierte a radianes: (deg - 90) * PI / 180
//     (se resta 90 porque en Canvas el angulo 0 es a la derecha, no arriba)
//   - Posicion en circulo: x = cos(a) * r, y = sin(a) * r
//   - Las etiquetas se contra-rotan con ctx.rotate(deg * PI/180) para
//     que el texto no quede al reves al girar la rosa
// =============================================================================
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
            text: "Heading Indicator"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: headingCanvas
                onAvailableChanged: if (available) requestPaint()
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - Style.resize(10)
                height: width

                property real heading: headingSlider.value
                property real headingBug: bugSlider.value

                onHeadingChanged: requestPaint()
                onHeadingBugChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    var w = width;
                    var h = height;
                    var cx = w / 2;
                    var cy = h / 2;
                    var r = Math.min(cx, cy) - 8;

                    ctx.clearRect(0, 0, w, h);
                    ctx.save();

                    // Fondo circular oscuro del instrumento
                    ctx.fillStyle = "#1a1a1a";
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                    ctx.fill();

                    // ---------------------------------------------------------
                    // Rotacion de la rosa de los vientos:
                    // Se rota en sentido contrario al heading (-heading)
                    // para que el rumbo actual quede arriba. Si el avion
                    // apunta a 090 (Este), la rosa gira -90 grados y la "E"
                    // queda alineada con la marca fija superior.
                    // ---------------------------------------------------------
                    ctx.translate(cx, cy);
                    ctx.rotate(-heading * Math.PI / 180);

                    // ---------------------------------------------------------
                    // Marcas de la rosa cada 5 grados:
                    // - Cada 30 grados: marca larga + etiqueta (N, E, S, W o numero)
                    // - Cada 10 grados: marca mediana
                    // - Cada 5 grados: marca corta
                    // La conversion a radianes resta 90 para que 0 grados = arriba.
                    // ---------------------------------------------------------
                    ctx.strokeStyle = "#FFFFFF";
                    ctx.fillStyle = "#FFFFFF";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";

                    for (var deg = 0; deg < 360; deg += 5) {
                        var angle = (deg - 90) * Math.PI / 180;
                        var innerR;

                        if (deg % 30 === 0) {
                            innerR = r * 0.78;
                            ctx.lineWidth = 2;
                        } else if (deg % 10 === 0) {
                            innerR = r * 0.83;
                            ctx.lineWidth = 1.5;
                        } else {
                            innerR = r * 0.87;
                            ctx.lineWidth = 1;
                        }

                        ctx.beginPath();
                        ctx.moveTo(Math.cos(angle) * innerR, Math.sin(angle) * innerR);
                        ctx.lineTo(Math.cos(angle) * r * 0.92, Math.sin(angle) * r * 0.92);
                        ctx.stroke();

                        // ---------------------------------------------------------
                        // Etiquetas cada 30 grados con contra-rotacion:
                        // Se usa save/translate/rotate/fillText/restore para que
                        // el texto siempre se lea de forma vertical. Sin la
                        // contra-rotacion, las letras quedarian giradas con la rosa.
                        // Los puntos cardinales (N rojo, E/S/W blanco) usan texto
                        // literal; los intermedios muestran el rumbo/10 (ej: 12 = 120).
                        // ---------------------------------------------------------
                        if (deg % 30 === 0) {
                            ctx.save();
                            var labelR = r * 0.7;
                            var lx = Math.cos(angle) * labelR;
                            var ly = Math.sin(angle) * labelR;
                            ctx.translate(lx, ly);
                            ctx.rotate(deg * Math.PI / 180);

                            ctx.font = "bold " + (r * 0.12) + "px sans-serif";

                            var label;
                            switch (deg) {
                                case 0: label = "N"; ctx.fillStyle = "#FF0000"; break;
                                case 90: label = "E"; ctx.fillStyle = "#FFFFFF"; break;
                                case 180: label = "S"; ctx.fillStyle = "#FFFFFF"; break;
                                case 270: label = "W"; ctx.fillStyle = "#FFFFFF"; break;
                                default: label = (deg / 10).toString(); ctx.fillStyle = "#CCCCCC"; break;
                            }
                            ctx.fillText(label, 0, 0);
                            ctx.restore();
                        }
                    }

                    // ---------------------------------------------------------
                    // Heading bug (marcador de rumbo deseado):
                    // Triangulo cyan en el borde exterior de la rosa, en la
                    // posicion angular del rumbo seleccionado. Como la rosa
                    // ya esta rotada, el bug se posiciona en coordenadas
                    // polares relativas al heading bug absoluto.
                    // ---------------------------------------------------------
                    var bugAngle = (headingBug - 90) * Math.PI / 180;
                    ctx.fillStyle = "#00FFFF";
                    ctx.beginPath();
                    var bugR = r * 0.94;
                    var bugW = 0.04;
                    ctx.moveTo(Math.cos(bugAngle) * bugR, Math.sin(bugAngle) * bugR);
                    ctx.lineTo(Math.cos(bugAngle - bugW) * (r * 1.0), Math.sin(bugAngle - bugW) * (r * 1.0));
                    ctx.lineTo(Math.cos(bugAngle + bugW) * (r * 1.0), Math.sin(bugAngle + bugW) * (r * 1.0));
                    ctx.closePath();
                    ctx.fill();

                    ctx.restore();

                    // ---------------------------------------------------------
                    // Elementos fijos (no rotan con la rosa):
                    // - Lubber line: linea amarilla desde el borde superior
                    //   hacia el centro. Indica la direccion actual del avion.
                    // - Triangulo puntero: refuerzo visual sobre la lubber line.
                    // - Readout digital: caja negra con el rumbo en grados,
                    //   formateado a 3 digitos con padStart (ej: "045").
                    // ---------------------------------------------------------

                    // Lubber line (linea de referencia fija arriba)
                    ctx.strokeStyle = "#FFD600";
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    ctx.moveTo(cx, cy - r + 2);
                    ctx.lineTo(cx, cy - r * 0.6);
                    ctx.stroke();

                    // Triangulo puntero fijo arriba
                    ctx.fillStyle = "#FFD600";
                    ctx.beginPath();
                    ctx.moveTo(cx, cy - r - 4);
                    ctx.lineTo(cx - r * 0.05, cy - r + 4);
                    ctx.lineTo(cx + r * 0.05, cy - r + 4);
                    ctx.closePath();
                    ctx.fill();

                    // Lectura digital del rumbo
                    ctx.fillStyle = "#000000";
                    ctx.fillRect(cx - r * 0.2, cy + r * 0.35, r * 0.4, r * 0.18);
                    ctx.strokeStyle = "#FFD600";
                    ctx.lineWidth = 1;
                    ctx.strokeRect(cx - r * 0.2, cy + r * 0.35, r * 0.4, r * 0.18);

                    ctx.fillStyle = "#00FF00";
                    ctx.font = "bold " + (r * 0.12) + "px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    var hdgStr = Math.round(heading).toString().padStart(3, '0') + "°";
                    ctx.fillText(hdgStr, cx, cy + r * 0.44);

                    // Anillo exterior
                    ctx.strokeStyle = "#555";
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                    ctx.stroke();
                }
            }
        }

        // ---------------------------------------------------------------------
        // Controles: heading (rumbo actual) y heading bug (rumbo deseado).
        // El heading bug es independiente del heading — en un avion real,
        // el piloto lo ajusta para marcar el rumbo objetivo.
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Heading"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: headingSlider
                Layout.fillWidth: true
                from: 0
                to: 359
                value: 0
            }
            Label {
                text: headingSlider.value.toFixed(0) + "°"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "HDG Bug"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: bugSlider
                Layout.fillWidth: true
                from: 0
                to: 359
                value: 45
            }
            Label {
                text: bugSlider.value.toFixed(0) + "°"
                font.pixelSize: Style.resize(12)
                color: "#00CCCC"
                Layout.preferredWidth: Style.resize(35)
            }
        }

        Label {
            text: "Rotating compass card with N/E/S/W, heading bug (cyan), lubber line. Classic ND pattern."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
