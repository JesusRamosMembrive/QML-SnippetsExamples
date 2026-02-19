// =============================================================================
// MovingMapCard.qml — Mapa movil con ruta, waypoints y simbolo de avion
// =============================================================================
// Componente central del Navigation Display. Dibuja un mapa radar estilo
// cockpit usando Canvas 2D con multiples capas: arco de brujula, anillos de
// rango, ruta del plan de vuelo (magenta), waypoints (diamantes verdes/cyan)
// y simbolo de avion en el centro.
//
// Patrones y conceptos clave:
// - Multiples propiedades disparan requestPaint(): heading, range, mode y
//   selectedWp. Canvas solo se redibuja cuando algo cambia (eficiente).
// - Transformaciones 2D para heading-up vs north-up: en modo PLAN la ruta
//   no rota; en los demas modos rota con el heading negativo.
// - Conversion de distancia nautica a pixeles: (dist / range) * maxRadius.
// - Funciones auxiliares extraidas (drawCompassArc, drawAircraftSymbol)
//   para mantener onPaint legible.
// - El heading viene de un Slider local y se expone como property para
//   que otros componentes (CompassRoseCard, ModeRangeCard) lo lean.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // heading se expone como property publica vinculada al slider.
    // Otros componentes como CompassRoseCard lo leen directamente.
    property real heading: headingSlider.value
    property real currentRange: 40
    property string ndMode: "ROSE"
    property int selectedWp: -1
    property var flightPlan: []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Moving Map"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#0a0f0a"
                radius: Style.resize(6)

                // ── Canvas del mapa movil ───────────────────────────
                // Propiedades locales (hdg, rng, mode, selWp) crean
                // bindings con onChanged -> requestPaint(). Esto es mas
                // eficiente que repintar en un timer: solo se redibuja
                // cuando un valor realmente cambia.
                Canvas {
                    id: mapCanvas
                    onAvailableChanged: if (available) requestPaint()
                    anchors.fill: parent
                    anchors.margins: Style.resize(4)

                    property real hdg: root.heading
                    property real rng: root.currentRange
                    property string mode: root.ndMode
                    property int selWp: root.selectedWp

                    onHdgChanged: requestPaint()
                    onRngChanged: requestPaint()
                    onModeChanged: requestPaint()
                    onSelWpChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d");
                        var w = width;
                        var h = height;
                        var cx = w / 2;
                        var cy = h / 2;
                        var maxR = Math.min(cx, cy) - 25;

                        ctx.clearRect(0, 0, w, h);

                        // Colores estandar de aviacion:
                        // verde=datos activos, magenta=ruta, cyan=seleccion, blanco=referencias
                        var green = "#00FF00";
                        var magenta = "#FF00FF";
                        var cyan = "#00FFFF";
                        var white = "#FFFFFF";

                        // Arco de brujula en el borde exterior
                        drawCompassArc(ctx, cx, cy, maxR + 15, hdg, mode);

                        // ── Anillos de rango ────────────────────────
                        // 4 anillos concentricos que dividen el rango en cuartos.
                        // Ayudan al piloto a estimar distancias visualmente.
                        ctx.strokeStyle = "#1a3a1a";
                        ctx.lineWidth = 1;
                        for (var i = 1; i <= 4; i++) {
                            ctx.beginPath();
                            ctx.arc(cx, cy, maxR * i / 4, 0, 2 * Math.PI);
                            ctx.stroke();
                        }

                        // Etiquetas de distancia en cada anillo
                        ctx.fillStyle = "#556655";
                        ctx.font = (maxR * 0.07) + "px sans-serif";
                        ctx.textAlign = "left";
                        ctx.textBaseline = "top";
                        for (var i = 1; i <= 4; i++) {
                            var ringR = maxR * i / 4;
                            var rangeVal = Math.round(rng * i / 4);
                            ctx.fillText(rangeVal + "", cx + 4, cy - ringR + 2);
                        }

                        // ── Plan de vuelo (ruta + waypoints) ────────
                        // En heading-up, la ruta rota con el heading para que
                        // "arriba" siempre sea la proa del avion.
                        // En modo PLAN, la ruta se muestra con norte arriba (sin rotacion).
                        ctx.save();
                        ctx.translate(cx, cy);
                        var rotAngle = (mode === "PLAN") ? 0 : -hdg;
                        ctx.rotate(rotAngle * Math.PI / 180);

                        // Lineas de ruta en magenta (color estandar ARINC para rutas)
                        var plan = root.flightPlan;
                        ctx.strokeStyle = magenta;
                        ctx.lineWidth = 2;
                        var prevX = 0, prevY = 0;
                        for (var i = 0; i < plan.length; i++) {
                            var wp = plan[i];
                            var angle = wp.brg * Math.PI / 180;
                            // Conversion de millas nauticas a pixeles:
                            // la proporcion dist/rng mapea al radio disponible.
                            var pixDist = (wp.dist / rng) * maxR;
                            var wpx = pixDist * Math.sin(angle);
                            var wpy = -pixDist * Math.cos(angle);

                            if (i > 0 && pixDist <= maxR * 1.3) {
                                ctx.beginPath();
                                ctx.moveTo(prevX, prevY);
                                ctx.lineTo(wpx, wpy);
                                ctx.stroke();
                            }
                            prevX = wpx;
                            prevY = wpy;
                        }

                        // Simbolos de waypoint: diamantes (forma estandar ARINC).
                        // El waypoint seleccionado se muestra en cyan y mas grande.
                        for (var i = 1; i < plan.length; i++) {
                            var wp = plan[i];
                            var angle = wp.brg * Math.PI / 180;
                            var pixDist = (wp.dist / rng) * maxR;
                            var wpx = pixDist * Math.sin(angle);
                            var wpy = -pixDist * Math.cos(angle);

                            if (pixDist > maxR * 1.1) continue;

                            var isSelected = (i === selWp);
                            var wpColor = isSelected ? cyan : green;
                            var sz = isSelected ? 7 : 5;

                            ctx.fillStyle = wpColor;
                            ctx.beginPath();
                            ctx.moveTo(wpx, wpy - sz);
                            ctx.lineTo(wpx + sz, wpy);
                            ctx.lineTo(wpx, wpy + sz);
                            ctx.lineTo(wpx - sz, wpy);
                            ctx.closePath();
                            ctx.fill();

                            ctx.fillStyle = wpColor;
                            ctx.font = (maxR * 0.07) + "px sans-serif";
                            ctx.textAlign = "left";
                            ctx.textBaseline = "bottom";
                            ctx.fillText(wp.name, wpx + sz + 3, wpy - 2);
                        }

                        ctx.restore();

                        // Simbolo del avion: siempre en el centro, apuntando arriba.
                        // No rota porque en heading-up el avion siempre "mira" hacia arriba.
                        drawAircraftSymbol(ctx, cx, cy, white);

                        // ── HUD (Head-Up Display) del mapa ─────────
                        // Readout de heading arriba centro
                        var hdgStr = Math.round(hdg).toString().padStart(3, "0");
                        ctx.fillStyle = "#000000";
                        ctx.fillRect(cx - 28, 3, 56, 18);
                        ctx.strokeStyle = green;
                        ctx.lineWidth = 1;
                        ctx.strokeRect(cx - 28, 3, 56, 18);
                        ctx.fillStyle = green;
                        ctx.font = "bold " + (maxR * 0.08) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";
                        ctx.fillText("HDG " + hdgStr + "\u00B0", cx, 12);

                        // Modo y rango en las esquinas inferiores
                        ctx.fillStyle = green;
                        ctx.font = (maxR * 0.07) + "px sans-serif";
                        ctx.textAlign = "left";
                        ctx.textBaseline = "bottom";
                        ctx.fillText(mode, 5, h - 5);
                        ctx.textAlign = "right";
                        ctx.fillText(Math.round(rng) + " NM", w - 5, h - 5);
                    }

                    // ── Funcion auxiliar: arco de brujula ───────────
                    // Dibuja marcas y etiquetas en el borde exterior del mapa.
                    // Se aplica la misma logica de rotacion heading-up / north-up.
                    function drawCompassArc(ctx, cx, cy, r, hdg, mode) {
                        var arcColor = "#446644";
                        var labelColor = "#88AA88";
                        var rotAngle = (mode === "PLAN") ? 0 : -hdg;

                        ctx.strokeStyle = arcColor;
                        ctx.lineWidth = 1;

                        for (var deg = 0; deg < 360; deg += 5) {
                            var drawDeg = deg + rotAngle;
                            var rad = drawDeg * Math.PI / 180;
                            var innerR = (deg % 10 === 0) ? r - 8 : r - 5;

                            ctx.beginPath();
                            ctx.moveTo(cx + Math.cos(rad - Math.PI/2) * innerR, cy + Math.sin(rad - Math.PI/2) * innerR);
                            ctx.lineTo(cx + Math.cos(rad - Math.PI/2) * r, cy + Math.sin(rad - Math.PI/2) * r);
                            ctx.stroke();
                        }

                        ctx.font = "bold " + (r * 0.055) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";

                        var cardinals = [
                            { deg: 0, label: "N" }, { deg: 30, label: "3" },
                            { deg: 60, label: "6" }, { deg: 90, label: "E" },
                            { deg: 120, label: "12" }, { deg: 150, label: "15" },
                            { deg: 180, label: "S" }, { deg: 210, label: "21" },
                            { deg: 240, label: "24" }, { deg: 270, label: "W" },
                            { deg: 300, label: "30" }, { deg: 330, label: "33" }
                        ];

                        for (var i = 0; i < cardinals.length; i++) {
                            var c = cardinals[i];
                            var drawDeg = c.deg + rotAngle;
                            var rad = drawDeg * Math.PI / 180;
                            var labelR = r - 16;
                            var lx = cx + Math.cos(rad - Math.PI/2) * labelR;
                            var ly = cy + Math.sin(rad - Math.PI/2) * labelR;

                            ctx.fillStyle = (c.label === "N" || c.label === "E" || c.label === "S" || c.label === "W") ? "#FFFFFF" : labelColor;
                            ctx.fillText(c.label, lx, ly);
                        }
                    }

                    // ── Funcion auxiliar: simbolo de avion ──────────
                    // Dibuja una silueta simplificada de avion con lineas:
                    // fuselaje vertical, alas horizontales y estabilizador.
                    function drawAircraftSymbol(ctx, cx, cy, color) {
                        ctx.strokeStyle = color;
                        ctx.lineWidth = 2;

                        ctx.beginPath();
                        ctx.moveTo(cx, cy - 12);
                        ctx.lineTo(cx, cy + 10);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.moveTo(cx - 14, cy + 2);
                        ctx.lineTo(cx + 14, cy + 2);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.moveTo(cx - 6, cy + 10);
                        ctx.lineTo(cx + 6, cy + 10);
                        ctx.stroke();

                        ctx.fillStyle = color;
                        ctx.beginPath();
                        ctx.arc(cx, cy - 12, 2, 0, 2 * Math.PI);
                        ctx.fill();
                    }
                }
            }
        }

        // ── Control de heading ──────────────────────────────────
        // Slider que simula el selector de heading del autopiloto.
        // Su valor se propaga automaticamente via la property heading
        // a todos los componentes que la leen.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "HDG"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: headingSlider
                Layout.fillWidth: true
                from: 0; to: 359; value: 45
                stepSize: 1
            }
            Label {
                text: Math.round(headingSlider.value) + "\u00B0"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        Label {
            text: "Canvas moving map with heading-up rotation. Magenta route, green waypoints. PLAN mode shows north-up."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
