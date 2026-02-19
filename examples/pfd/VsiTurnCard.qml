// =============================================================================
// VsiTurnCard.qml — VSI (Variometro) y Coordinador de Viraje
// =============================================================================
// Contiene dos instrumentos de vuelo lado a lado:
//
// 1. VSI (Vertical Speed Indicator): variometro que muestra la velocidad
//    vertical en pies por minuto (fpm). Usa un arco de 120 grados con aguja
//    rotativa. Rango: -2000 a +2000 fpm.
//
// 2. Turn Coordinator: indicador de viraje y deslizamiento lateral.
//    Muestra la tasa de giro con un avion que se inclina, y un inclinometro
//    (bola de slip/skid) que indica si el viraje esta coordinado.
//
// Tecnicas Canvas 2D utilizadas:
//   - Escala de arco: mapeo lineal de un rango de valores a un rango angular
//   - Aguja rotativa: linea desde el centro hasta un punto en coordenadas polares
//   - Simbolo de avion inclinado: rotacion del contexto proporcional a la tasa de giro
//   - Indicador de bola: desplazamiento horizontal lineal del circulo
//
// Trigonometria del VSI:
//   frac = (valor + 2000) / 4000  ->  fraccion normalizada 0..1
//   angulo = startAngle + frac * totalSweep  ->  angulo en grados
//   El arco va de 210 a 330 grados (pasando por arriba, donde esta el 0).
//
// Coordinador de viraje:
//   bankAngle = turnRate * 10: factor de escala visual (3 deg/s = 30 grados bank)
//   La bola se desplaza linealmente: slip * ancho * factor
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
            text: "VSI & Turn Coordinator"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: Style.resize(15)

                // =============================================================
                // VSI (VARIOMETRO)
                // Instrumento de arco con aguja que indica la velocidad vertical.
                // El arco abarca de 210 a 330 grados (120 grados de barrido)
                // pasando por la parte superior (270 = arriba = cero fpm).
                // El "0" queda arriba para que subir (positivo) sea a la derecha
                // y bajar (negativo) a la izquierda, convencion estandar.
                // =============================================================
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Canvas {
                        id: vsiCanvas
                        onAvailableChanged: if (available) requestPaint()
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) - Style.resize(5)
                        height: width

                        property real vspeed: vsiSlider.value

                        onVspeedChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d");
                            var w = width;
                            var h = height;
                            var cx = w / 2;
                            var cy = h / 2;
                            var r = Math.min(cx, cy) - 6;

                            ctx.clearRect(0, 0, w, h);

                            // Fondo circular
                            ctx.fillStyle = "#1a1a1a";
                            ctx.beginPath();
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                            ctx.fill();

                            // -------------------------------------------------
                            // Escala del arco:
                            // startAngle = 210 grados (abajo-izquierda)
                            // endAngle = 330 grados (abajo-derecha)
                            // totalSweep = 120 grados pasando por arriba
                            //
                            // Mapeo: -2000 fpm -> 210 grados (izquierda)
                            //            0 fpm -> 270 grados (arriba)
                            //        +2000 fpm -> 330 grados (derecha)
                            //
                            // frac = (valor + 2000) / 4000 normaliza a 0..1
                            // angulo = 210 + frac * 120
                            // -------------------------------------------------
                            var startAngle = 210;
                            var endAngle = 330;
                            var totalSweep = endAngle - startAngle;

                            ctx.strokeStyle = "#FFFFFF";
                            ctx.fillStyle = "#FFFFFF";
                            ctx.textAlign = "center";
                            ctx.textBaseline = "middle";
                            ctx.font = (r * 0.1) + "px sans-serif";

                            // Marcas de escala: valores clave del variometro
                            var marks = [-2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000];
                            for (var i = 0; i < marks.length; i++) {
                                var frac = (marks[i] + 2000) / 4000;
                                var angle = (startAngle + frac * totalSweep) * Math.PI / 180;
                                var isMajor = (Math.abs(marks[i]) % 1000 === 0);
                                var innerR = isMajor ? r * 0.75 : r * 0.82;

                                ctx.lineWidth = isMajor ? 2 : 1;
                                ctx.beginPath();
                                ctx.moveTo(cx + Math.cos(angle) * innerR, cy + Math.sin(angle) * innerR);
                                ctx.lineTo(cx + Math.cos(angle) * r * 0.9, cy + Math.sin(angle) * r * 0.9);
                                ctx.stroke();

                                // Etiquetas en miles (ej: 2 = 2000 fpm)
                                if (isMajor) {
                                    var labelR = r * 0.63;
                                    var label = (Math.abs(marks[i]) / 1000).toString();
                                    ctx.fillText(label, cx + Math.cos(angle) * labelR, cy + Math.sin(angle) * labelR);
                                }
                            }

                            // Etiqueta "0" resaltada en verde en la posicion superior
                            ctx.font = "bold " + (r * 0.12) + "px sans-serif";
                            ctx.fillStyle = "#00FF00";
                            var zeroAngle = (startAngle + 0.5 * totalSweep) * Math.PI / 180;
                            ctx.fillText("0", cx + Math.cos(zeroAngle) * r * 0.55, cy + Math.sin(zeroAngle) * r * 0.55);

                            // Etiquetas UP/DN para indicar subida/bajada
                            ctx.fillStyle = "#AAAAAA";
                            ctx.font = (r * 0.09) + "px sans-serif";
                            ctx.fillText("DN", cx - r * 0.35, cy + r * 0.2);
                            ctx.fillText("UP", cx + r * 0.35, cy + r * 0.2);

                            // -------------------------------------------------
                            // Aguja del variometro:
                            // Se clampea el valor al rango +-2000, se normaliza
                            // a fraccion y se convierte al angulo correspondiente
                            // en el arco. La aguja va del centro al perimetro.
                            // -------------------------------------------------
                            var clampedVS = Math.max(-2000, Math.min(2000, vspeed));
                            var needleFrac = (clampedVS + 2000) / 4000;
                            var needleAngle = (startAngle + needleFrac * totalSweep) * Math.PI / 180;

                            ctx.strokeStyle = "#FFFFFF";
                            ctx.lineWidth = 3;
                            ctx.beginPath();
                            ctx.moveTo(cx, cy);
                            ctx.lineTo(cx + Math.cos(needleAngle) * r * 0.8, cy + Math.sin(needleAngle) * r * 0.8);
                            ctx.stroke();

                            // Punto central (hub) de la aguja
                            ctx.fillStyle = "#FFD600";
                            ctx.beginPath();
                            ctx.arc(cx, cy, r * 0.06, 0, 2 * Math.PI);
                            ctx.fill();

                            // Lectura digital con signo (+/-)
                            ctx.fillStyle = "#000000";
                            ctx.fillRect(cx - r * 0.3, cy + r * 0.3, r * 0.6, r * 0.2);
                            ctx.strokeStyle = "#555";
                            ctx.lineWidth = 1;
                            ctx.strokeRect(cx - r * 0.3, cy + r * 0.3, r * 0.6, r * 0.2);

                            ctx.fillStyle = "#00FF00";
                            ctx.font = "bold " + (r * 0.11) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.textBaseline = "middle";
                            var vsStr = (vspeed >= 0 ? "+" : "") + Math.round(vspeed).toString();
                            ctx.fillText(vsStr + " fpm", cx, cy + r * 0.4);

                            // Etiqueta del instrumento
                            ctx.fillStyle = "#AAAAAA";
                            ctx.font = (r * 0.09) + "px sans-serif";
                            ctx.fillText("V/S", cx, cy + r * 0.6);

                            // Anillo exterior
                            ctx.strokeStyle = "#555";
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                            ctx.stroke();
                        }
                    }
                }

                // =============================================================
                // COORDINADOR DE VIRAJE (Turn Coordinator)
                // Instrumento que combina dos indicaciones:
                //
                // 1. Tasa de giro: un avion estilizado que se inclina
                //    proporcionalmente a la tasa de viraje. Las marcas L/R
                //    a 30 grados indican "standard rate" (3 deg/s = viraje
                //    completo de 360 grados en 2 minutos, de ahi "2 MIN").
                //
                // 2. Inclinometro (slip/skid ball): bola blanca que se
                //    desplaza lateralmente. Centrada = viraje coordinado.
                //    Desplazada = deslizamiento lateral (falta o exceso
                //    de rudder). Las dos marcas verticales delimitan el
                //    rango aceptable.
                // =============================================================
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Canvas {
                        id: turnCanvas
                        onAvailableChanged: if (available) requestPaint()
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) - Style.resize(5)
                        height: width

                        property real turnRate: turnSlider.value
                        property real slip: slipSlider.value

                        onTurnRateChanged: requestPaint()
                        onSlipChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d");
                            var w = width;
                            var h = height;
                            var cx = w / 2;
                            var cy = h / 2;
                            var r = Math.min(cx, cy) - 6;

                            ctx.clearRect(0, 0, w, h);

                            // Fondo circular
                            ctx.fillStyle = "#1a1a1a";
                            ctx.beginPath();
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                            ctx.fill();

                            // -------------------------------------------------
                            // Marcas de standard rate:
                            // +-30 grados desde la vertical (arriba).
                            // Standard rate turn = 3 deg/s -> 360 en 2 minutos.
                            // El angulo se convierte restando 90 (para que 0 = arriba)
                            // y se dibuja en coordenadas polares.
                            // -------------------------------------------------
                            ctx.strokeStyle = "#FFFFFF";
                            ctx.lineWidth = 2;

                            // Marca izquierda (-30 grados desde vertical)
                            var lAngle = (-90 - 30) * Math.PI / 180;
                            ctx.beginPath();
                            ctx.moveTo(cx + Math.cos(lAngle) * r * 0.85, cy + Math.sin(lAngle) * r * 0.85);
                            ctx.lineTo(cx + Math.cos(lAngle) * r * 0.95, cy + Math.sin(lAngle) * r * 0.95);
                            ctx.stroke();

                            // Marca derecha (+30 grados desde vertical)
                            var rAngle = (-90 + 30) * Math.PI / 180;
                            ctx.beginPath();
                            ctx.moveTo(cx + Math.cos(rAngle) * r * 0.85, cy + Math.sin(rAngle) * r * 0.85);
                            ctx.lineTo(cx + Math.cos(rAngle) * r * 0.95, cy + Math.sin(rAngle) * r * 0.95);
                            ctx.stroke();

                            // Marca central (0 grados de giro)
                            ctx.beginPath();
                            ctx.moveTo(cx, cy - r * 0.85);
                            ctx.lineTo(cx, cy - r * 0.95);
                            ctx.stroke();

                            // -------------------------------------------------
                            // Simbolo del avion que se inclina:
                            // El angulo de bank visual = turnRate * 10
                            // (factor de escala para que 3 deg/s de giro
                            // se vea como 30 grados de inclinacion).
                            // Se usa translate + rotate para girar todo el avion.
                            // -------------------------------------------------
                            ctx.save();
                            ctx.translate(cx, cy);
                            var bankAngle = turnRate * 10;
                            ctx.rotate(bankAngle * Math.PI / 180);

                            ctx.strokeStyle = "#FFD600";
                            ctx.lineWidth = 3;

                            // Alas del avion
                            ctx.beginPath();
                            ctx.moveTo(-r * 0.45, 0);
                            ctx.lineTo(-r * 0.12, 0);
                            ctx.stroke();

                            ctx.beginPath();
                            ctx.moveTo(r * 0.45, 0);
                            ctx.lineTo(r * 0.12, 0);
                            ctx.stroke();

                            // Cola del avion
                            ctx.beginPath();
                            ctx.moveTo(0, 0);
                            ctx.lineTo(0, r * 0.15);
                            ctx.lineTo(-r * 0.08, r * 0.15);
                            ctx.stroke();
                            ctx.beginPath();
                            ctx.moveTo(0, r * 0.15);
                            ctx.lineTo(r * 0.08, r * 0.15);
                            ctx.stroke();

                            // Centro del avion
                            ctx.fillStyle = "#FFD600";
                            ctx.beginPath();
                            ctx.arc(0, 0, r * 0.04, 0, 2 * Math.PI);
                            ctx.fill();

                            ctx.restore();

                            // -------------------------------------------------
                            // Inclinometro (bola de slip/skid):
                            // Pista horizontal gris con bola blanca que se
                            // desplaza segun el valor de slip (-1 a +1).
                            // Dos marcas verticales blancas delimitan el rango
                            // centrado aceptable. Bola centrada = coordinado.
                            // -------------------------------------------------
                            var ballTrackY = cy + r * 0.55;
                            var ballTrackW = r * 0.5;

                            // Fondo de la pista
                            ctx.fillStyle = "#333";
                            ctx.fillRect(cx - ballTrackW / 2, ballTrackY - r * 0.04, ballTrackW, r * 0.08);

                            // Marcas centrales
                            ctx.strokeStyle = "#FFFFFF";
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.moveTo(cx - r * 0.06, ballTrackY - r * 0.06);
                            ctx.lineTo(cx - r * 0.06, ballTrackY + r * 0.06);
                            ctx.stroke();
                            ctx.beginPath();
                            ctx.moveTo(cx + r * 0.06, ballTrackY - r * 0.06);
                            ctx.lineTo(cx + r * 0.06, ballTrackY + r * 0.06);
                            ctx.stroke();

                            // Bola
                            var ballOffset = slip * ballTrackW * 0.4;
                            ctx.fillStyle = "#FFFFFF";
                            ctx.beginPath();
                            ctx.arc(cx + ballOffset, ballTrackY, r * 0.05, 0, 2 * Math.PI);
                            ctx.fill();

                            // Etiquetas
                            ctx.fillStyle = "#AAAAAA";
                            ctx.font = (r * 0.08) + "px sans-serif";
                            ctx.textAlign = "center";
                            ctx.fillText("L", cx - r * 0.55, cy - r * 0.3);
                            ctx.fillText("R", cx + r * 0.55, cy - r * 0.3);

                            ctx.font = (r * 0.09) + "px sans-serif";
                            ctx.fillText("TURN COORDINATOR", cx, cy + r * 0.78);

                            ctx.font = (r * 0.07) + "px sans-serif";
                            ctx.fillText("2 MIN", cx, cy + r * 0.88);

                            // Anillo exterior
                            ctx.strokeStyle = "#555";
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                            ctx.stroke();
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
                text: "V/S"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: vsiSlider
                Layout.fillWidth: true
                from: -2000
                to: 2000
                value: 0
            }
            Label {
                text: (vsiSlider.value >= 0 ? "+" : "") + vsiSlider.value.toFixed(0) + " fpm"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(65)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Turn"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: turnSlider
                Layout.fillWidth: true
                from: -3
                to: 3
                value: 0
            }
            Label {
                text: "Slip"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: slipSlider
                Layout.preferredWidth: Style.resize(80)
                from: -1
                to: 1
                value: 0
            }
        }

        Label {
            text: "VSI needle gauge with arc scale. Turn coordinator with banking aircraft and slip ball."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
