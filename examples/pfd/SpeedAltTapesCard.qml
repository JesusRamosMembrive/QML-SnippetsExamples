// =============================================================================
// SpeedAltTapesCard.qml — Cintas de Velocidad y Altitud
// =============================================================================
// Las cintas (tapes) son indicadores lineales verticales que muestran velocidad
// (izquierda) y altitud (derecha). Desplazan verticalmente una escala numerica
// mientras el valor actual queda fijo en el centro con una caja resaltada.
//
// Este es el formato estandar de los PFD modernos (Airbus, Boeing) que
// reemplazo a los instrumentos analogicos de aguja circulares.
//
// Tecnicas Canvas 2D utilizadas:
//   - Clipping rectangular: ctx.rect() + ctx.clip() para limitar el area
//     visible de la cinta y evitar que las marcas se dibujen fuera
//   - Scroll virtual: las marcas se posicionan en funcion del valor actual,
//     creando la ilusion de una cinta infinita que se desplaza
//   - Bandas de color (speed tape): franjas verde/ambar/rojo en el borde
//     que indican rangos operativos (VNE, rango normal, baja velocidad)
//   - Caja de valor actual: rectangulo con borde amarillo sobre fondo negro
//
// Matematica del scroll:
//   ppk = pixeles por unidad (knot o foot): define cuantos pixeles
//         equivalen a una unidad de la magnitud
//   y = cy - (marca - valorActual) * ppk
//   Esto centra el valor actual en cy y desplaza todas las marcas
//   proporcionalmente. Marcas con valor mayor quedan arriba (y menor).
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
            text: "Speed & Altitude Tapes"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: Style.resize(30)

                // =============================================================
                // CINTA DE VELOCIDAD (izquierda)
                // Muestra velocidad en nudos (knots) con scroll vertical.
                // Las marcas cada 10 kt con subdivisiones cada 5 kt.
                // Bandas de color en el borde derecho:
                //   - Rojo (VNE): por encima de 340 kt (velocidad maxima)
                //   - Verde: 180-340 kt (rango operativo normal)
                //   - Ambar: por debajo de 180 kt (velocidad baja)
                // =============================================================
                Item {
                    Layout.preferredWidth: parent.width * 0.35
                    Layout.fillHeight: true

                    Canvas {
                        id: speedTape
                        onAvailableChanged: if (available) requestPaint()
                        anchors.fill: parent

                        property real speed: speedSlider.value

                        onSpeedChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d");
                            var w = width;
                            var h = height;
                            var tapeW = w * 0.6;
                            var tapeX = w * 0.2;
                            var cy = h / 2;
                            var ppk = h / 80; // pixels por nudo (80 kt visibles)

                            ctx.clearRect(0, 0, w, h);

                            // Fondo de la cinta
                            ctx.fillStyle = "#1a1a1a";
                            ctx.fillRect(tapeX, 0, tapeW, h);

                            // -------------------------------------------------
                            // Clipping: limita el dibujo al area de la cinta
                            // para que las marcas no se dibujen fuera.
                            // -------------------------------------------------
                            ctx.save();
                            ctx.beginPath();
                            ctx.rect(tapeX, 0, tapeW, h);
                            ctx.clip();

                            // -------------------------------------------------
                            // Marcas de velocidad:
                            // Se calcula el rango visible (speed +-60 kt) y se
                            // dibujan marcas cada 10 kt. La posicion Y se obtiene
                            // con: cy - (marca - speed) * ppk
                            // Esto hace que la velocidad actual siempre este en cy.
                            // -------------------------------------------------
                            ctx.fillStyle = "#FFFFFF";
                            ctx.strokeStyle = "#FFFFFF";
                            ctx.lineWidth = 1;
                            ctx.textAlign = "right";
                            ctx.textBaseline = "middle";
                            ctx.font = (h * 0.04) + "px sans-serif";

                            var startSpd = Math.floor(speed / 10) * 10 - 60;
                            var endSpd = startSpd + 120;

                            for (var s = startSpd; s <= endSpd; s += 10) {
                                var y = cy - (s - speed) * ppk;
                                if (y < -10 || y > h + 10) continue;

                                ctx.beginPath();
                                ctx.moveTo(tapeX + tapeW - 1, y);
                                ctx.lineTo(tapeX + tapeW - tapeW * 0.15, y);
                                ctx.stroke();

                                if (s >= 0) {
                                    ctx.fillText(s.toString(), tapeX + tapeW - tapeW * 0.2, y);
                                }
                            }

                            // Subdivisiones cada 5 kt (marcas menores)
                            for (var s2 = startSpd + 5; s2 <= endSpd; s2 += 10) {
                                var y2 = cy - (s2 - speed) * ppk;
                                if (y2 < 0 || y2 > h) continue;
                                ctx.beginPath();
                                ctx.moveTo(tapeX + tapeW - 1, y2);
                                ctx.lineTo(tapeX + tapeW - tapeW * 0.08, y2);
                                ctx.stroke();
                            }

                            ctx.restore();

                            // -------------------------------------------------
                            // Bandas de color (borde derecho de la cinta):
                            // Indican los limites operativos de velocidad.
                            // La posicion Y de cada limite se calcula igual que
                            // las marcas, convirtiendo kt a pixeles.
                            // -------------------------------------------------
                            // VNE (rojo) por encima de 340 kt
                            var vneY = cy - (340 - speed) * ppk;
                            if (vneY > 0) {
                                ctx.fillStyle = "#FF0000";
                                ctx.fillRect(tapeX + tapeW, 0, 4, Math.max(0, vneY));
                            }

                            // Rango verde: 180-340 kt
                            var greenTop = cy - (340 - speed) * ppk;
                            var greenBot = cy - (180 - speed) * ppk;
                            ctx.fillStyle = "#00E676";
                            ctx.fillRect(tapeX + tapeW, Math.max(0, greenTop), 4,
                                Math.min(h, greenBot) - Math.max(0, greenTop));

                            // Rango ambar: por debajo de 180 kt
                            var amberTop = cy - (180 - speed) * ppk;
                            if (amberTop < h) {
                                ctx.fillStyle = "#FF9800";
                                ctx.fillRect(tapeX + tapeW, Math.max(0, amberTop), 4, h - Math.max(0, amberTop));
                            }

                            // Caja del valor actual
                            var boxH = h * 0.08;
                            ctx.fillStyle = "#000000";
                            ctx.strokeStyle = "#FFD600";
                            ctx.lineWidth = 2;
                            ctx.fillRect(tapeX - 2, cy - boxH / 2, tapeW + 6, boxH);
                            ctx.strokeRect(tapeX - 2, cy - boxH / 2, tapeW + 6, boxH);

                            ctx.fillStyle = "#00FF00";
                            ctx.font = "bold " + (h * 0.055) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.textBaseline = "middle";
                            ctx.fillText(Math.round(speed).toString(), tapeX + tapeW / 2, cy);

                            // Etiquetas de unidad
                            ctx.fillStyle = "#AAAAAA";
                            ctx.font = (h * 0.035) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.fillText("SPD", tapeX + tapeW / 2, h - h * 0.03);
                            ctx.fillText("KTS", tapeX + tapeW / 2, h * 0.03);
                        }
                    }
                }

                // =============================================================
                // CINTA DE ALTITUD (derecha)
                // Misma mecanica que la cinta de velocidad pero para altitud
                // en pies (feet). Marcas cada 100 ft, etiquetas cada 200 ft.
                // ppf (pixels per foot) = h / 1000 — muestra 1000 ft de rango.
                //
                // A diferencia de la cinta de velocidad, no tiene bandas de
                // color porque los limites de altitud dependen del tipo de
                // aeronave y la fase de vuelo.
                // =============================================================
                Item {
                    Layout.preferredWidth: parent.width * 0.35
                    Layout.fillHeight: true

                    Canvas {
                        id: altTape
                        onAvailableChanged: if (available) requestPaint()
                        anchors.fill: parent

                        property real altitude: altSlider.value

                        onAltitudeChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d");
                            var w = width;
                            var h = height;
                            var tapeW = w * 0.6;
                            var tapeX = w * 0.2;
                            var cy = h / 2;
                            var ppf = h / 1000; // pixels por pie (1000 ft visibles)

                            ctx.clearRect(0, 0, w, h);

                            // Fondo
                            ctx.fillStyle = "#1a1a1a";
                            ctx.fillRect(tapeX, 0, tapeW, h);

                            ctx.save();
                            ctx.beginPath();
                            ctx.rect(tapeX, 0, tapeW, h);
                            ctx.clip();

                            // Marcas de altitud cada 100 ft
                            ctx.fillStyle = "#FFFFFF";
                            ctx.strokeStyle = "#FFFFFF";
                            ctx.lineWidth = 1;
                            ctx.textAlign = "left";
                            ctx.textBaseline = "middle";
                            ctx.font = (h * 0.035) + "px sans-serif";

                            var startAlt = Math.floor(altitude / 100) * 100 - 600;
                            var endAlt = startAlt + 1200;

                            for (var a = startAlt; a <= endAlt; a += 100) {
                                var y = cy - (a - altitude) * ppf;
                                if (y < -10 || y > h + 10) continue;

                                ctx.beginPath();
                                ctx.moveTo(tapeX + 1, y);
                                ctx.lineTo(tapeX + tapeW * 0.15, y);
                                ctx.stroke();

                                if (a >= 0 && a % 200 === 0) {
                                    ctx.fillText(a.toString(), tapeX + tapeW * 0.2, y);
                                }
                            }

                            ctx.restore();

                            // Caja del valor actual de altitud
                            var boxH = h * 0.08;
                            ctx.fillStyle = "#000000";
                            ctx.strokeStyle = "#FFD600";
                            ctx.lineWidth = 2;
                            ctx.fillRect(tapeX - 2, cy - boxH / 2, tapeW + 6, boxH);
                            ctx.strokeRect(tapeX - 2, cy - boxH / 2, tapeW + 6, boxH);

                            ctx.fillStyle = "#00FF00";
                            ctx.font = "bold " + (h * 0.05) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.textBaseline = "middle";
                            ctx.fillText(Math.round(altitude).toString(), tapeX + tapeW / 2, cy);

                            // Etiquetas
                            ctx.fillStyle = "#AAAAAA";
                            ctx.font = (h * 0.035) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.fillText("ALT", tapeX + tapeW / 2, h - h * 0.03);
                            ctx.fillText("FT", tapeX + tapeW / 2, h * 0.03);
                        }
                    }
                }
            }
        }

        // Controles interactivos
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Speed"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from: 100
                to: 380
                value: 250
            }
            Label {
                text: speedSlider.value.toFixed(0) + " kt"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Altitude"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: altSlider
                Layout.fillWidth: true
                from: 0
                to: 41000
                value: 35000
            }
            Label {
                text: altSlider.value.toFixed(0) + " ft"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(60)
            }
        }

        Label {
            text: "Vertical scrolling tapes with clipped content, color bands (green/amber/red), current value box."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
