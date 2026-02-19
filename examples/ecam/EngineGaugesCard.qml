// =============================================================================
// EngineGaugesCard.qml — Indicadores de Motor N1 (ECAM Upper Display)
// =============================================================================
// Simula los indicadores de empuje N1 (rotacion del fan) de un bimotor Airbus.
// En el ECAM real, N1 es el parametro principal de empuje y se muestra con
// arcos de color que indican el rango operativo:
//   - Verde (0-80%): rango normal
//   - Ambar (80-95%): empuje alto, atencion
//   - Rojo (95-100%): limite, posible excedencia
//
// Tecnicas Canvas 2D utilizadas:
//   - Arcos coloreados: segmentos de arco con ctx.arc() y diferentes colores
//   - Aguja rotativa: linea desde cerca del centro hasta el perimetro
//   - Funcion reutilizable: drawEngineGauge() se usa para ambos motores
//   - Reutilizacion cross-Canvas: eng2Canvas llama a eng1Canvas.drawEngineGauge()
//     pasando su propio contexto. Esto evita duplicar la funcion de dibujo.
//
// Trigonometria del arco:
//   arcStart = 135 grados (abajo-izquierda)
//   sweep = 270 grados (3/4 de circulo, sentido horario)
//   angulo_de_marca = arcStart + sweep * (porcentaje / 100)
//   Esto mapea linealmente 0-100% al arco de 135 a 405 (=45) grados.
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
            text: "Engine Gauges (N1)"
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

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(10)
                    spacing: Style.resize(10)

                    // =========================================================
                    // MOTOR 1 (izquierda)
                    // Contiene la funcion drawEngineGauge() que es reutilizada
                    // por el Motor 2. El patron de "definir la funcion en un
                    // Canvas y llamarla desde otro" es util para evitar
                    // duplicacion cuando ambos instrumentos son identicos
                    // pero con datos diferentes.
                    // =========================================================
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Canvas {
                            id: eng1Canvas
                            onAvailableChanged: if (available) requestPaint()
                            anchors.fill: parent

                            property real n1: n1Slider.value

                            onN1Changed: requestPaint()

                            onPaint: {
                                drawEngineGauge(getContext("2d"), width, height, n1, "ENG 1");
                            }

                            // -------------------------------------------------
                            // Funcion principal de dibujo del indicador N1.
                            // Parametros: ctx, dimensiones, valor, etiqueta.
                            // Se define aqui y se reutiliza en eng2Canvas.
                            // -------------------------------------------------
                            function drawEngineGauge(ctx, w, h, value, label) {
                                var cx = w / 2;
                                var cy = h * 0.5;
                                var r = Math.min(cx, cy) - 10;

                                ctx.clearRect(0, 0, w, h);

                                // Arco de 270 grados (3/4 de circulo)
                                // arcStart = 135 (abajo-izquierda), sweep = 270
                                var arcStart = 135;
                                var arcEnd = 45;
                                var sweep = 270;

                                // -------------------------------------------------
                                // Zonas de color del arco:
                                // Cada zona es un segmento de arco dibujado con
                                // drawArcSegment(). Los rangos porcentuales se
                                // convierten a angulos: arcStart + sweep * fraccion
                                //   Verde:  0% a 80% del arco
                                //   Ambar: 80% a 95% del arco
                                //   Rojo:  95% a 100% del arco
                                // -------------------------------------------------
                                drawArcSegment(ctx, cx, cy, r, arcStart, arcStart + sweep * 0.80, "#4CAF50", 6);
                                drawArcSegment(ctx, cx, cy, r, arcStart + sweep * 0.80, arcStart + sweep * 0.95, "#FF9800", 6);
                                drawArcSegment(ctx, cx, cy, r, arcStart + sweep * 0.95, arcStart + sweep, "#F44336", 6);

                                // Arco de fondo tenue (referencia visual)
                                drawArcSegment(ctx, cx, cy, r * 0.85, arcStart, arcStart + sweep, "#333333", 3);

                                // -------------------------------------------------
                                // Marcas de escala cada 10%:
                                // Marcas mayores (cada 20%) son mas largas y llevan
                                // etiqueta numerica. La posicion se calcula con:
                                //   angulo = (arcStart + sweep * pct/100) en radianes
                                //   x = cx + cos(angulo) * radio
                                //   y = cy + sin(angulo) * radio
                                // -------------------------------------------------
                                ctx.strokeStyle = "#AAAAAA";
                                ctx.fillStyle = "#AAAAAA";
                                ctx.font = (r * 0.14) + "px sans-serif";
                                ctx.textAlign = "center";
                                ctx.textBaseline = "middle";

                                for (var pct = 0; pct <= 100; pct += 10) {
                                    var tickAngle = (arcStart + sweep * pct / 100) * Math.PI / 180;
                                    var innerR = (pct % 20 === 0) ? r * 0.72 : r * 0.78;
                                    ctx.lineWidth = (pct % 20 === 0) ? 2 : 1;

                                    ctx.beginPath();
                                    ctx.moveTo(cx + Math.cos(tickAngle) * innerR, cy + Math.sin(tickAngle) * innerR);
                                    ctx.lineTo(cx + Math.cos(tickAngle) * r * 0.82, cy + Math.sin(tickAngle) * r * 0.82);
                                    ctx.stroke();

                                    if (pct % 20 === 0) {
                                        var labelR = r * 0.62;
                                        ctx.fillText(pct.toString(), cx + Math.cos(tickAngle) * labelR, cy + Math.sin(tickAngle) * labelR);
                                    }
                                }

                                // -------------------------------------------------
                                // Aguja del indicador:
                                // Se clampea el valor a 0-100, se convierte a angulo
                                // dentro del arco y se dibuja una linea desde r*0.3
                                // (cerca del centro) hasta r*0.85 (perimetro).
                                // No empieza en el centro exacto para dejar espacio
                                // al hub central.
                                // -------------------------------------------------
                                var needlePct = Math.max(0, Math.min(100, value));
                                var needleAngle = (arcStart + sweep * needlePct / 100) * Math.PI / 180;
                                ctx.strokeStyle = "#FFFFFF";
                                ctx.lineWidth = 3;
                                ctx.beginPath();
                                ctx.moveTo(cx + Math.cos(needleAngle) * r * 0.3, cy + Math.sin(needleAngle) * r * 0.3);
                                ctx.lineTo(cx + Math.cos(needleAngle) * r * 0.85, cy + Math.sin(needleAngle) * r * 0.85);
                                ctx.stroke();

                                // Hub central
                                ctx.fillStyle = "#555";
                                ctx.beginPath();
                                ctx.arc(cx, cy, r * 0.08, 0, 2 * Math.PI);
                                ctx.fill();

                                // -------------------------------------------------
                                // Lectura digital: el color cambia segun la zona
                                // (verde/ambar/rojo) para reforzar la indicacion
                                // visual del arco.
                                // -------------------------------------------------
                                var valueColor = value > 95 ? "#F44336" : (value > 80 ? "#FF9800" : "#4CAF50");
                                ctx.fillStyle = valueColor;
                                ctx.font = "bold " + (r * 0.28) + "px sans-serif";
                                ctx.textAlign = "center";
                                ctx.fillText(value.toFixed(1), cx, cy + r * 0.35);

                                ctx.fillStyle = "#AAAAAA";
                                ctx.font = (r * 0.13) + "px sans-serif";
                                ctx.fillText("% N1", cx, cy + r * 0.52);

                                // Etiqueta del motor
                                ctx.fillStyle = "#FFFFFF";
                                ctx.font = "bold " + (r * 0.15) + "px sans-serif";
                                ctx.fillText(label, cx, h - r * 0.15);
                            }

                            // Funcion auxiliar para dibujar un segmento de arco
                            // con color y grosor especificos
                            function drawArcSegment(ctx, cx, cy, r, startDeg, endDeg, color, lineWidth) {
                                ctx.strokeStyle = color;
                                ctx.lineWidth = lineWidth;
                                ctx.beginPath();
                                ctx.arc(cx, cy, r, startDeg * Math.PI / 180, endDeg * Math.PI / 180);
                                ctx.stroke();
                            }
                        }
                    }

                    // =========================================================
                    // MOTOR 2 (derecha)
                    // Reutiliza la funcion drawEngineGauge() definida en
                    // eng1Canvas pero con su propio contexto 2D y datos.
                    // Este patron demuestra que las funciones de un Canvas
                    // son accesibles desde otros componentes por su id.
                    // =========================================================
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Canvas {
                            id: eng2Canvas
                            onAvailableChanged: if (available) requestPaint()
                            anchors.fill: parent

                            property real n1: n2Slider.value

                            onN1Changed: requestPaint()

                            onPaint: {
                                eng1Canvas.drawEngineGauge(getContext("2d"), width, height, n1, "ENG 2");
                            }
                        }
                    }
                }
            }
        }

        // Controles de empuje
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "ENG 1"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: n1Slider
                Layout.fillWidth: true
                from: 0; to: 104; value: 85
            }
            Label {
                text: "ENG 2"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: n2Slider
                Layout.fillWidth: true
                from: 0; to: 104; value: 85
            }
        }

        Label {
            text: "Canvas arc gauges with green/amber/red zones, rotating needle, digital N1 readout."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
