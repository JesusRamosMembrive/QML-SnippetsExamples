// =============================================================================
// HudCanvas.qml — Renderizado del Head-Up Display completo
// =============================================================================
// Este componente dibuja toda la simbologia del HUD de un avion de combate
// usando Canvas 2D. Todo se renderiza en verde fosforo (#00FF00) sobre fondo
// negro, simulando el aspecto real de un HUD proyectado en el parabrisas.
//
// Elementos del HUD (dibujados en orden de capas):
//   1. Heading tape: cinta horizontal de rumbo en la parte superior
//   2. Pitch ladder: escalera de cabeceo con rotacion por alabeo
//   3. Flight Path Vector (FPV): simbolo que indica la trayectoria real
//   4. Boresight: referencia fija del eje de la aeronave (forma W)
//   5. Speed box: velocidad indicada en nudos (izquierda)
//   6. Altitude box: altitud en pies (derecha)
//   7. Lower data: Mach, G, velocidad vertical, altitud radar
//
// Arquitectura del renderizado:
//   - onPaint llama a funciones separadas (drawHeadingTape, drawPitchLadder, etc.)
//   - Cada funcion recibe el contexto y las dimensiones como parametros
//   - Este patron modular hace el codigo Canvas mantenible incluso con
//     cientos de lineas de dibujo
//
// Tecnicas avanzadas Canvas 2D:
//   - setLineDash() para lineas punteadas (pitch negativo = debajo del horizonte)
//   - Clipping rectangular para heading tape y pitch ladder
//   - Multiples translate/rotate anidados con save/restore
//   - ppd (pixels per degree) como factor de escala universal
// =============================================================================
import QtQuick
import QtQuick.Controls
import utils

Rectangle {
    id: root

    // Propiedades de vuelo recibidas desde Main.qml
    property real pitch: 0
    property real roll: 0
    property real heading: 0
    property real speed: 0
    property real altitude: 0
    property real fpa: 0

    color: "#0a0a0a"
    radius: Style.resize(8)
    clip: true

    Canvas {
        id: hudCanvas
        onAvailableChanged: if (available) requestPaint()
        anchors.fill: parent

        // ---------------------------------------------------------------------
        // Paleta monocromatica del HUD:
        // hudColor (#00FF00) es el verde fosforo brillante para elementos
        // primarios. dimColor (#00AA00) es un verde atenuado para datos
        // secundarios. Simula la intensidad variable de un HUD real.
        // ---------------------------------------------------------------------
        property color hudColor: "#00FF00"
        property color dimColor: "#00AA00"

        // Propiedades locales vinculadas al root para disparar requestPaint()
        property real pitch: root.pitch
        property real roll: root.roll
        property real heading: root.heading
        property real speed: root.speed
        property real altitude: root.altitude
        property real fpa: root.fpa

        onPitchChanged: requestPaint()
        onRollChanged: requestPaint()
        onHeadingChanged: requestPaint()
        onSpeedChanged: requestPaint()
        onAltitudeChanged: requestPaint()
        onFpaChanged: requestPaint()

        // ---------------------------------------------------------------------
        // Renderizado principal: orquesta todas las capas del HUD.
        // ppd (pixels per degree) convierte grados a pixeles y se pasa
        // a las funciones de dibujo para mantener coherencia de escala.
        // El orden de dibujo importa: los elementos se superponen en capas.
        // ---------------------------------------------------------------------
        onPaint: {
            var ctx = getContext("2d");
            var w = width;
            var h = height;
            var cx = w / 2;
            var cy = h / 2;

            ctx.clearRect(0, 0, w, h);

            ctx.fillStyle = "#0a0a0a";
            ctx.fillRect(0, 0, w, h);

            var green = hudColor.toString();
            var dim = dimColor.toString();
            var ppd = h / 40; // 40 grados de campo visual vertical

            // 1. HEADING TAPE (cinta de rumbo, parte superior)
            drawHeadingTape(ctx, w, h, cx, green, dim, ppd);

            // 2. PITCH LADDER (escalera de cabeceo, rota con roll)
            drawPitchLadder(ctx, w, h, cx, cy, green, dim, ppd);

            // 3. FLIGHT PATH VECTOR (trayectoria real del avion)
            drawFPV(ctx, w, h, cx, cy, green, ppd);

            // 4. BORESIGHT SYMBOL (eje del avion, fijo en el centro)
            drawBoresight(ctx, cx, cy, green);

            // 5. SPEED BOX (velocidad, lado izquierdo)
            drawSpeedBox(ctx, w, h, cx, cy, green);

            // 6. ALTITUDE BOX (altitud, lado derecho)
            drawAltitudeBox(ctx, w, h, cx, cy, green);

            // 7. LOWER DATA (datos inferiores: Mach, G, VS, RA)
            drawLowerData(ctx, w, h, cx, green, dim);
        }

        // =====================================================================
        // CINTA DE RUMBO (heading tape)
        // Cinta horizontal en la parte superior que muestra 60 grados de rumbo.
        // El rumbo actual queda centrado, con marcas cada 5 y 10 grados.
        // Un caret (triangulo) apunta hacia la cinta desde abajo, y una caja
        // muestra el valor numerico exacto (3 digitos, ej: "045").
        //
        // ppdH = pixels per degree heading: cuantos pixeles por grado
        // en la dimension horizontal. Diferente del ppd vertical.
        //
        // normD = ((d % 360) + 360) % 360 normaliza cualquier angulo
        // al rango 0-359, necesario porque el rango visible puede
        // cruzar el 0/360 (ej: de 350 a 010).
        // =====================================================================
        function drawHeadingTape(ctx, w, h, cx, green, dim, ppd) {
            var tapeY = h * 0.06;
            var tapeH = h * 0.04;
            var ppdH = w / 60; // 60 grados visibles horizontalmente
            var hdg = heading;

            ctx.save();

            // Clipping para la cinta de rumbo
            ctx.beginPath();
            ctx.rect(cx - w * 0.35, tapeY - tapeH, w * 0.7, tapeH * 3);
            ctx.clip();

            ctx.strokeStyle = green;
            ctx.fillStyle = green;
            ctx.lineWidth = 1;

            // Marcas cada grado, solo se dibujan las de 5 y 10
            var startDeg = Math.floor(hdg - 30);
            var endDeg = Math.ceil(hdg + 30);

            for (var d = startDeg; d <= endDeg; d++) {
                var normD = ((d % 360) + 360) % 360;
                var x = cx + (d - hdg) * ppdH;

                if (normD % 10 === 0) {
                    // Marca mayor cada 10 grados
                    ctx.beginPath();
                    ctx.moveTo(x, tapeY);
                    ctx.lineTo(x, tapeY + tapeH * 0.7);
                    ctx.stroke();

                    ctx.font = (h * 0.022) + "px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "top";

                    // Puntos cardinales con texto, otros con numero
                    var label;
                    switch (normD) {
                        case 0:   label = "N"; break;
                        case 90:  label = "E"; break;
                        case 180: label = "S"; break;
                        case 270: label = "W"; break;
                        default:  label = normD.toString();
                    }
                    ctx.fillText(label, x, tapeY + tapeH * 0.8);
                } else if (normD % 5 === 0) {
                    // Marca menor cada 5 grados
                    ctx.beginPath();
                    ctx.moveTo(x, tapeY);
                    ctx.lineTo(x, tapeY + tapeH * 0.4);
                    ctx.stroke();
                }
            }

            ctx.restore();

            // Caja de lectura del rumbo (centrada sobre la cinta)
            var boxW = w * 0.06;
            var boxH = h * 0.035;
            ctx.strokeStyle = green;
            ctx.fillStyle = "#0a0a0a";
            ctx.lineWidth = 1.5;
            ctx.fillRect(cx - boxW / 2, tapeY - boxH - 2, boxW, boxH);
            ctx.strokeRect(cx - boxW / 2, tapeY - boxH - 2, boxW, boxH);

            ctx.fillStyle = green;
            ctx.font = "bold " + (h * 0.025) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            var hdgStr = Math.round(((heading % 360) + 360) % 360).toString().padStart(3, '0');
            ctx.fillText(hdgStr, cx, tapeY - boxH / 2 - 2);

            // Caret (triangulo puntero) bajo la caja
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(cx, tapeY);
            ctx.lineTo(cx - h * 0.012, tapeY - h * 0.015);
            ctx.lineTo(cx + h * 0.012, tapeY - h * 0.015);
            ctx.closePath();
            ctx.fill();
        }

        // =====================================================================
        // ESCALERA DE PITCH (pitch ladder)
        // Lineas horizontales que representan angulos de cabeceo, rotadas
        // segun el roll actual del avion. Convencion de HUD militar:
        //   - ARRIBA del horizonte (pitch positivo): lineas SOLIDAS con
        //     end caps hacia abajo (indican "nariz arriba")
        //   - DEBAJO del horizonte (pitch negativo): lineas PUNTEADAS con
        //     end caps hacia arriba y hueco central (indican "nariz abajo")
        //
        // Esta diferenciacion visual permite al piloto distinguir
        // instantaneamente si esta por encima o debajo del horizonte,
        // incluso con visibilidad parcial.
        //
        // La linea del horizonte (0 grados) es extra larga y solida.
        // Las etiquetas muestran el valor absoluto a ambos lados.
        // =====================================================================
        function drawPitchLadder(ctx, w, h, cx, cy, green, dim, ppd) {
            ctx.save();

            // Clipping central para que la escalera no invada heading tape
            var clipW = w * 0.55;
            var clipH = h * 0.7;
            ctx.beginPath();
            ctx.rect(cx - clipW / 2, cy - clipH / 2, clipW, clipH);
            ctx.clip();

            // Transformacion: centrar + rotar por roll
            ctx.translate(cx, cy);
            ctx.rotate(-roll * Math.PI / 180);

            var pitchOffset = pitch * ppd;

            ctx.strokeStyle = green;
            ctx.fillStyle = green;
            ctx.lineWidth = 1.5;
            ctx.font = (h * 0.02) + "px sans-serif";
            ctx.textBaseline = "middle";

            // Linea del horizonte (0 grados): referencia principal
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(-w * 0.35, pitchOffset);
            ctx.lineTo(w * 0.35, pitchOffset);
            ctx.stroke();
            ctx.lineWidth = 1.5;

            // Marcas de pitch a +-5, 10, 15, 20 grados
            var pitchMarks = [-20, -15, -10, -5, 5, 10, 15, 20];
            for (var i = 0; i < pitchMarks.length; i++) {
                var deg = pitchMarks[i];
                var y = pitchOffset - deg * ppd;
                var isMajor = (Math.abs(deg) % 10 === 0);
                var halfW = isMajor ? w * 0.12 : w * 0.07;

                if (deg > 0) {
                    // ---------------------------------------------------------
                    // ENCIMA del horizonte: lineas solidas.
                    // End caps hacia ABAJO (el piloto mira "hacia abajo" al
                    // horizonte desde arriba). Estandar HUD militar.
                    // ---------------------------------------------------------
                    ctx.setLineDash([]);
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(halfW, y);
                    ctx.stroke();

                    // End caps hacia abajo
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-halfW, y + h * 0.012);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(halfW, y);
                    ctx.lineTo(halfW, y + h * 0.012);
                    ctx.stroke();
                } else {
                    // ---------------------------------------------------------
                    // DEBAJO del horizonte: lineas punteadas con hueco central.
                    // setLineDash([longitud, espacio]) crea el patron punteado.
                    // El hueco central se logra dibujando dos segmentos
                    // separados (izquierdo y derecho) en lugar de una linea
                    // continua. End caps hacia ARRIBA.
                    // ---------------------------------------------------------
                    ctx.setLineDash([h * 0.015, h * 0.008]);

                    // Mitad izquierda
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-w * 0.02, y);
                    ctx.stroke();

                    // Mitad derecha
                    ctx.beginPath();
                    ctx.moveTo(w * 0.02, y);
                    ctx.lineTo(halfW, y);
                    ctx.stroke();

                    ctx.setLineDash([]);

                    // End caps hacia arriba
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-halfW, y - h * 0.012);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(halfW, y);
                    ctx.lineTo(halfW, y - h * 0.012);
                    ctx.stroke();
                }

                // Etiquetas de grados a ambos lados
                ctx.textAlign = "right";
                ctx.fillText(Math.abs(deg).toString(), -halfW - h * 0.01, y);
                ctx.textAlign = "left";
                ctx.fillText(Math.abs(deg).toString(), halfW + h * 0.01, y);
            }

            ctx.setLineDash([]);
            ctx.restore();
        }

        // =====================================================================
        // FLIGHT PATH VECTOR (FPV) — Vector de trayectoria de vuelo
        // Simbolo en forma de circulo con alas y aleta superior que indica
        // la direccion REAL del movimiento del avion (no hacia donde apunta
        // la nariz, sino hacia donde realmente va).
        //
        // La diferencia entre boresight y FPV es el angulo de ataque:
        //   - Boresight = donde apunta la nariz
        //   - FPV = donde va realmente el avion
        //   - fpa (Flight Path Angle) = separacion vertical entre ambos
        //
        // El FPV rota con el roll porque esta en el plano de referencia
        // del horizonte, no fijo en la pantalla.
        // =====================================================================
        function drawFPV(ctx, w, h, cx, cy, green, ppd) {
            ctx.save();

            ctx.translate(cx, cy);
            ctx.rotate(-roll * Math.PI / 180);

            // Posicion vertical del FPV segun el angulo de trayectoria
            var fpvY = -fpa * ppd;
            var fpvR = h * 0.018;

            ctx.strokeStyle = green;
            ctx.lineWidth = 2;

            // Circulo central
            ctx.beginPath();
            ctx.arc(0, fpvY, fpvR, 0, 2 * Math.PI);
            ctx.stroke();

            // Alas (lineas horizontales a los lados)
            ctx.beginPath();
            ctx.moveTo(-fpvR * 3, fpvY);
            ctx.lineTo(-fpvR, fpvY);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(fpvR, fpvY);
            ctx.lineTo(fpvR * 3, fpvY);
            ctx.stroke();

            // Aleta superior (linea vertical desde el circulo)
            ctx.beginPath();
            ctx.moveTo(0, fpvY - fpvR);
            ctx.lineTo(0, fpvY - fpvR * 2);
            ctx.stroke();

            ctx.restore();
        }

        // =====================================================================
        // BORESIGHT — Simbolo de referencia del eje del avion
        // Forma de W (waterline symbol) fija en el centro de la pantalla.
        // Indica hacia donde apunta la nariz del avion.
        // Cuando el FPV esta debajo del boresight, el avion tiene angulo
        // de ataque positivo (la nariz apunta mas arriba que la trayectoria).
        // =====================================================================
        function drawBoresight(ctx, cx, cy, green) {
            ctx.strokeStyle = green;
            ctx.lineWidth = 2;

            var s = 8; // mitad del tamano base

            // Simbolo W (waterline): patron estandar de HUD militar
            ctx.beginPath();
            ctx.moveTo(cx - s * 3, cy);
            ctx.lineTo(cx - s, cy);
            ctx.lineTo(cx - s * 0.5, cy + s * 0.6);
            ctx.lineTo(cx, cy);
            ctx.lineTo(cx + s * 0.5, cy + s * 0.6);
            ctx.lineTo(cx + s, cy);
            ctx.lineTo(cx + s * 3, cy);
            ctx.stroke();
        }

        // =====================================================================
        // SPEED BOX — Caja de velocidad (lado izquierdo)
        // Muestra la velocidad indicada (IAS) en nudos dentro de una caja
        // con borde verde. Un caret (triangulo) a la derecha apunta hacia
        // la escala de velocidad. La etiqueta "KTS" aparece encima.
        //
        // La escala de ticks adyacente se dibuja con clipping para mostrar
        // solo una ventana limitada del rango de velocidades.
        // =====================================================================
        function drawSpeedBox(ctx, w, h, cx, cy, green) {
            var boxW = w * 0.08;
            var boxH = h * 0.045;
            var boxX = cx - w * 0.3;
            var boxY = cy - boxH / 2;

            // Caja con fondo oscuro
            ctx.strokeStyle = green;
            ctx.fillStyle = "#0a0a0a";
            ctx.lineWidth = 1.5;
            ctx.fillRect(boxX, boxY, boxW, boxH);
            ctx.strokeRect(boxX, boxY, boxW, boxH);

            // Valor numerico de velocidad
            ctx.fillStyle = green;
            ctx.font = "bold " + (h * 0.03) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(Math.round(speed).toString(), boxX + boxW / 2, cy);

            // Etiqueta de unidad
            ctx.font = (h * 0.018) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.fillText("KTS", boxX + boxW / 2, boxY - h * 0.015);

            // Caret apuntando a la derecha (hacia la escala)
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(boxX + boxW, cy);
            ctx.lineTo(boxX + boxW + h * 0.012, cy - h * 0.012);
            ctx.lineTo(boxX + boxW + h * 0.012, cy + h * 0.012);
            ctx.closePath();
            ctx.fill();

            // Escala de ticks adyacente (cada 10 kt, con clipping)
            ctx.strokeStyle = green;
            ctx.lineWidth = 1;
            var tickX = boxX + boxW + h * 0.015;
            var spd = speed;
            var ppdS = h / 80;

            ctx.save();
            ctx.beginPath();
            ctx.rect(tickX, cy - h * 0.15, w * 0.06, h * 0.3);
            ctx.clip();

            var startS = Math.floor(spd / 10) * 10 - 40;
            for (var s = startS; s <= startS + 80; s += 10) {
                var sy = cy - (s - spd) * ppdS;
                ctx.beginPath();
                ctx.moveTo(tickX, sy);
                ctx.lineTo(tickX + w * 0.015, sy);
                ctx.stroke();
            }
            ctx.restore();
        }

        // =====================================================================
        // ALTITUDE BOX — Caja de altitud (lado derecho)
        // Espejo de la speed box pero para altitud en pies (FT).
        // El caret apunta a la izquierda y la escala muestra ticks cada 500 ft.
        // La caja se posiciona simetricamente al speed box respecto al centro.
        // =====================================================================
        function drawAltitudeBox(ctx, w, h, cx, cy, green) {
            var boxW = w * 0.09;
            var boxH = h * 0.045;
            var boxX = cx + w * 0.3 - boxW;
            var boxY = cy - boxH / 2;

            // Caja con fondo oscuro
            ctx.strokeStyle = green;
            ctx.fillStyle = "#0a0a0a";
            ctx.lineWidth = 1.5;
            ctx.fillRect(boxX, boxY, boxW, boxH);
            ctx.strokeRect(boxX, boxY, boxW, boxH);

            // Valor numerico de altitud
            ctx.fillStyle = green;
            ctx.font = "bold " + (h * 0.03) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(Math.round(altitude).toString(), boxX + boxW / 2, cy);

            // Etiqueta
            ctx.font = (h * 0.018) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.fillText("ALT", boxX + boxW / 2, boxY - h * 0.015);

            // Caret apuntando a la izquierda
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(boxX, cy);
            ctx.lineTo(boxX - h * 0.012, cy - h * 0.012);
            ctx.lineTo(boxX - h * 0.012, cy + h * 0.012);
            ctx.closePath();
            ctx.fill();

            // Escala de ticks cada 500 ft con clipping
            ctx.strokeStyle = green;
            ctx.lineWidth = 1;
            var tickX = boxX - h * 0.015;
            var alt = altitude;
            var ppdA = h / 2000;

            ctx.save();
            ctx.beginPath();
            ctx.rect(tickX - w * 0.06, cy - h * 0.15, w * 0.06, h * 0.3);
            ctx.clip();

            var startA = Math.floor(alt / 500) * 500 - 2000;
            for (var a = startA; a <= startA + 4000; a += 500) {
                var ay = cy - (a - alt) * ppdA;
                ctx.beginPath();
                ctx.moveTo(tickX, ay);
                ctx.lineTo(tickX - w * 0.015, ay);
                ctx.stroke();
            }
            ctx.restore();
        }

        // =====================================================================
        // LOWER DATA — Datos inferiores
        // Informacion secundaria en la parte baja del HUD:
        //   - Mach (izquierda): velocidad / velocidad del sonido a nivel del mar
        //     (661.5 kt). Es una aproximacion; el Mach real depende de la altitud.
        //   - G-load (izquierda, debajo): siempre 1.0G en esta demo
        //   - Velocidad vertical (derecha): calculada con la formula
        //     VS = TAS * sin(FPA) * 60 donde TAS se aproxima como speed * 1.688
        //     (conversion kt a ft/s) y FPA es el angulo de trayectoria.
        //   - Altitud radar (derecha, debajo): misma que altitud en esta demo
        //
        // Los datos secundarios usan dimColor para diferenciarse de los primarios.
        // =====================================================================
        function drawLowerData(ctx, w, h, cx, green, dim) {
            ctx.fillStyle = green;
            ctx.textBaseline = "top";
            var dataY = h * 0.82;
            var fontSize = h * 0.022;
            ctx.font = fontSize + "px sans-serif";

            // Numero Mach (aproximado a nivel del mar)
            var mach = speed / 661.5;
            ctx.textAlign = "left";
            ctx.fillText("M " + mach.toFixed(2), cx - w * 0.3, dataY);

            // Carga G (fijo en esta demo)
            ctx.fillStyle = dim;
            ctx.fillText("G  1.0", cx - w * 0.3, dataY + fontSize * 1.5);

            // Velocidad vertical calculada: TAS * sin(FPA) * 60
            ctx.fillStyle = green;
            ctx.textAlign = "right";
            var vs = Math.round(speed * 1.688 * Math.sin(fpa * Math.PI / 180) * 60);
            var vsStr = (vs >= 0 ? "+" : "") + vs;
            ctx.fillText("VS " + vsStr, cx + w * 0.3, dataY);

            // Altitud radar
            ctx.fillStyle = dim;
            ctx.fillText("RA " + Math.round(altitude).toString(), cx + w * 0.3, dataY + fontSize * 1.5);
        }
    }
}
