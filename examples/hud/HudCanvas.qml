import QtQuick
import QtQuick.Controls
import utils

Rectangle {
    id: root

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
        anchors.fill: parent

        property color hudColor: "#00FF00"
        property color dimColor: "#00AA00"

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

        onPaint: {
            var ctx = getContext("2d");
            var w = width;
            var h = height;
            var cx = w / 2;
            var cy = h / 2;

            ctx.clearRect(0, 0, w, h);

            // Background
            ctx.fillStyle = "#0a0a0a";
            ctx.fillRect(0, 0, w, h);

            var green = hudColor.toString();
            var dim = dimColor.toString();
            var ppd = h / 40; // pixels per degree

            // 1. HEADING TAPE (top, fixed)
            drawHeadingTape(ctx, w, h, cx, green, dim, ppd);

            // 2. PITCH LADDER (rotates with roll)
            drawPitchLadder(ctx, w, h, cx, cy, green, dim, ppd);

            // 3. FLIGHT PATH VECTOR
            drawFPV(ctx, w, h, cx, cy, green, ppd);

            // 4. BORESIGHT SYMBOL (fixed center)
            drawBoresight(ctx, cx, cy, green);

            // 5. SPEED BOX (left side)
            drawSpeedBox(ctx, w, h, cx, cy, green);

            // 6. ALTITUDE BOX (right side)
            drawAltitudeBox(ctx, w, h, cx, cy, green);

            // 7. LOWER DATA
            drawLowerData(ctx, w, h, cx, green, dim);
        }

        function drawHeadingTape(ctx, w, h, cx, green, dim, ppd) {
            var tapeY = h * 0.06;
            var tapeH = h * 0.04;
            var ppdH = w / 60; // pixels per degree heading (60° visible)
            var hdg = heading;

            ctx.save();

            // Clip heading tape area
            ctx.beginPath();
            ctx.rect(cx - w * 0.35, tapeY - tapeH, w * 0.7, tapeH * 3);
            ctx.clip();

            ctx.strokeStyle = green;
            ctx.fillStyle = green;
            ctx.lineWidth = 1;

            // Draw tick marks
            var startDeg = Math.floor(hdg - 30);
            var endDeg = Math.ceil(hdg + 30);

            for (var d = startDeg; d <= endDeg; d++) {
                var normD = ((d % 360) + 360) % 360;
                var x = cx + (d - hdg) * ppdH;

                if (normD % 10 === 0) {
                    // Major tick
                    ctx.beginPath();
                    ctx.moveTo(x, tapeY);
                    ctx.lineTo(x, tapeY + tapeH * 0.7);
                    ctx.stroke();

                    // Label
                    ctx.font = (h * 0.022) + "px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "top";

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
                    // Minor tick
                    ctx.beginPath();
                    ctx.moveTo(x, tapeY);
                    ctx.lineTo(x, tapeY + tapeH * 0.4);
                    ctx.stroke();
                }
            }

            ctx.restore();

            // Heading readout box (centered above tape)
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

            // Center caret below tape
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(cx, tapeY);
            ctx.lineTo(cx - h * 0.012, tapeY - h * 0.015);
            ctx.lineTo(cx + h * 0.012, tapeY - h * 0.015);
            ctx.closePath();
            ctx.fill();
        }

        function drawPitchLadder(ctx, w, h, cx, cy, green, dim, ppd) {
            ctx.save();

            // Clip to central area (avoid drawing over heading tape and edges)
            var clipW = w * 0.55;
            var clipH = h * 0.7;
            ctx.beginPath();
            ctx.rect(cx - clipW / 2, cy - clipH / 2, clipW, clipH);
            ctx.clip();

            // Translate to center, apply roll rotation
            ctx.translate(cx, cy);
            ctx.rotate(-roll * Math.PI / 180);

            var pitchOffset = pitch * ppd;

            ctx.strokeStyle = green;
            ctx.fillStyle = green;
            ctx.lineWidth = 1.5;
            ctx.font = (h * 0.02) + "px sans-serif";
            ctx.textBaseline = "middle";

            // Horizon line (0°) — extra long
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(-w * 0.35, pitchOffset);
            ctx.lineTo(w * 0.35, pitchOffset);
            ctx.stroke();
            ctx.lineWidth = 1.5;

            // Pitch marks
            var pitchMarks = [-20, -15, -10, -5, 5, 10, 15, 20];
            for (var i = 0; i < pitchMarks.length; i++) {
                var deg = pitchMarks[i];
                var y = pitchOffset - deg * ppd;
                var isMajor = (Math.abs(deg) % 10 === 0);
                var halfW = isMajor ? w * 0.12 : w * 0.07;

                if (deg > 0) {
                    // Above horizon: solid lines
                    ctx.setLineDash([]);
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(halfW, y);
                    ctx.stroke();

                    // End caps (small downward ticks)
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-halfW, y + h * 0.012);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(halfW, y);
                    ctx.lineTo(halfW, y + h * 0.012);
                    ctx.stroke();
                } else {
                    // Below horizon: dashed lines with center gap
                    ctx.setLineDash([h * 0.015, h * 0.008]);

                    // Left half
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-w * 0.02, y);
                    ctx.stroke();

                    // Right half
                    ctx.beginPath();
                    ctx.moveTo(w * 0.02, y);
                    ctx.lineTo(halfW, y);
                    ctx.stroke();

                    ctx.setLineDash([]);

                    // End caps (small upward ticks for below-horizon)
                    ctx.beginPath();
                    ctx.moveTo(-halfW, y);
                    ctx.lineTo(-halfW, y - h * 0.012);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(halfW, y);
                    ctx.lineTo(halfW, y - h * 0.012);
                    ctx.stroke();
                }

                // Degree labels
                ctx.textAlign = "right";
                ctx.fillText(Math.abs(deg).toString(), -halfW - h * 0.01, y);
                ctx.textAlign = "left";
                ctx.fillText(Math.abs(deg).toString(), halfW + h * 0.01, y);
            }

            ctx.setLineDash([]);
            ctx.restore();
        }

        function drawFPV(ctx, w, h, cx, cy, green, ppd) {
            ctx.save();

            ctx.translate(cx, cy);
            ctx.rotate(-roll * Math.PI / 180);

            // FPV position: offset by flight path angle
            var fpvY = -fpa * ppd;
            var fpvR = h * 0.018;

            ctx.strokeStyle = green;
            ctx.lineWidth = 2;

            // Circle
            ctx.beginPath();
            ctx.arc(0, fpvY, fpvR, 0, 2 * Math.PI);
            ctx.stroke();

            // Wings (horizontal lines)
            ctx.beginPath();
            ctx.moveTo(-fpvR * 3, fpvY);
            ctx.lineTo(-fpvR, fpvY);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(fpvR, fpvY);
            ctx.lineTo(fpvR * 3, fpvY);
            ctx.stroke();

            // Top fin
            ctx.beginPath();
            ctx.moveTo(0, fpvY - fpvR);
            ctx.lineTo(0, fpvY - fpvR * 2);
            ctx.stroke();

            ctx.restore();
        }

        function drawBoresight(ctx, cx, cy, green) {
            ctx.strokeStyle = green;
            ctx.lineWidth = 2;

            var s = 8; // half-size

            // W-shape waterline symbol
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

        function drawSpeedBox(ctx, w, h, cx, cy, green) {
            var boxW = w * 0.08;
            var boxH = h * 0.045;
            var boxX = cx - w * 0.3;
            var boxY = cy - boxH / 2;

            // Box
            ctx.strokeStyle = green;
            ctx.fillStyle = "#0a0a0a";
            ctx.lineWidth = 1.5;
            ctx.fillRect(boxX, boxY, boxW, boxH);
            ctx.strokeRect(boxX, boxY, boxW, boxH);

            // Speed value
            ctx.fillStyle = green;
            ctx.font = "bold " + (h * 0.03) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(Math.round(speed).toString(), boxX + boxW / 2, cy);

            // Label
            ctx.font = (h * 0.018) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.fillText("KTS", boxX + boxW / 2, boxY - h * 0.015);

            // Caret pointing right
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(boxX + boxW, cy);
            ctx.lineTo(boxX + boxW + h * 0.012, cy - h * 0.012);
            ctx.lineTo(boxX + boxW + h * 0.012, cy + h * 0.012);
            ctx.closePath();
            ctx.fill();

            // Speed scale ticks (to the right of box)
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

        function drawAltitudeBox(ctx, w, h, cx, cy, green) {
            var boxW = w * 0.09;
            var boxH = h * 0.045;
            var boxX = cx + w * 0.3 - boxW;
            var boxY = cy - boxH / 2;

            // Box
            ctx.strokeStyle = green;
            ctx.fillStyle = "#0a0a0a";
            ctx.lineWidth = 1.5;
            ctx.fillRect(boxX, boxY, boxW, boxH);
            ctx.strokeRect(boxX, boxY, boxW, boxH);

            // Altitude value
            ctx.fillStyle = green;
            ctx.font = "bold " + (h * 0.03) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(Math.round(altitude).toString(), boxX + boxW / 2, cy);

            // Label
            ctx.font = (h * 0.018) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.fillText("ALT", boxX + boxW / 2, boxY - h * 0.015);

            // Caret pointing left
            ctx.fillStyle = green;
            ctx.beginPath();
            ctx.moveTo(boxX, cy);
            ctx.lineTo(boxX - h * 0.012, cy - h * 0.012);
            ctx.lineTo(boxX - h * 0.012, cy + h * 0.012);
            ctx.closePath();
            ctx.fill();

            // Altitude scale ticks (to the left of box)
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

        function drawLowerData(ctx, w, h, cx, green, dim) {
            ctx.fillStyle = green;
            ctx.textBaseline = "top";
            var dataY = h * 0.82;
            var fontSize = h * 0.022;
            ctx.font = fontSize + "px sans-serif";

            // Mach number (left)
            var mach = speed / 661.5; // approximate Mach at sea level
            ctx.textAlign = "left";
            ctx.fillText("M " + mach.toFixed(2), cx - w * 0.3, dataY);

            // G-load (left, below mach)
            ctx.fillStyle = dim;
            ctx.fillText("G  1.0", cx - w * 0.3, dataY + fontSize * 1.5);

            // Vertical speed (right)
            ctx.fillStyle = green;
            ctx.textAlign = "right";
            var vs = Math.round(speed * 1.688 * Math.sin(fpa * Math.PI / 180) * 60);
            var vsStr = (vs >= 0 ? "+" : "") + vs;
            ctx.fillText("VS " + vsStr, cx + w * 0.3, dataY);

            // Radar altitude (right, below VS)
            ctx.fillStyle = dim;
            ctx.fillText("RA " + Math.round(altitude).toString(), cx + w * 0.3, dataY + fontSize * 1.5);
        }
    }
}
