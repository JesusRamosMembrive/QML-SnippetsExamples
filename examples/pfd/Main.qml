import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Primary Flight Display (PFD)"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: Artificial Horizon (ADI)
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Artificial Horizon (ADI)"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Canvas {
                                    id: adiCanvas
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width, parent.height) - Style.resize(10)
                                    height: width

                                    property real pitch: pitchSlider.value
                                    property real roll: rollSlider.value

                                    onPitchChanged: requestPaint()
                                    onRollChanged: requestPaint()

                                    onPaint: {
                                        var ctx = getContext("2d");
                                        var w = width;
                                        var h = height;
                                        var cx = w / 2;
                                        var cy = h / 2;
                                        var r = Math.min(cx, cy) - 4;

                                        ctx.clearRect(0, 0, w, h);
                                        ctx.save();

                                        // Clip to circle
                                        ctx.beginPath();
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                        ctx.clip();

                                        // Rotate for roll
                                        ctx.translate(cx, cy);
                                        ctx.rotate(-roll * Math.PI / 180);

                                        // Pitch offset: pixels per degree
                                        var ppd = r / 30;
                                        var pitchOffset = pitch * ppd;

                                        // Sky gradient
                                        var skyGrad = ctx.createLinearGradient(0, -r * 2, 0, pitchOffset);
                                        skyGrad.addColorStop(0, "#0a1e5e");
                                        skyGrad.addColorStop(0.6, "#1565C0");
                                        skyGrad.addColorStop(1, "#64B5F6");
                                        ctx.fillStyle = skyGrad;
                                        ctx.fillRect(-r * 2, -r * 2, r * 4, r * 2 + pitchOffset);

                                        // Ground gradient
                                        var gndGrad = ctx.createLinearGradient(0, pitchOffset, 0, r * 2);
                                        gndGrad.addColorStop(0, "#8B6914");
                                        gndGrad.addColorStop(0.4, "#6B4400");
                                        gndGrad.addColorStop(1, "#3E2723");
                                        ctx.fillStyle = gndGrad;
                                        ctx.fillRect(-r * 2, pitchOffset, r * 4, r * 2);

                                        // Horizon line
                                        ctx.strokeStyle = "#FFFFFF";
                                        ctx.lineWidth = 2;
                                        ctx.beginPath();
                                        ctx.moveTo(-r * 2, pitchOffset);
                                        ctx.lineTo(r * 2, pitchOffset);
                                        ctx.stroke();

                                        // Pitch ladder
                                        ctx.fillStyle = "#FFFFFF";
                                        ctx.strokeStyle = "#FFFFFF";
                                        ctx.lineWidth = 1.5;
                                        ctx.textAlign = "center";
                                        ctx.textBaseline = "middle";
                                        ctx.font = (r * 0.08) + "px sans-serif";

                                        var pitchMarks = [-20, -15, -10, -5, 5, 10, 15, 20];
                                        for (var i = 0; i < pitchMarks.length; i++) {
                                            var deg = pitchMarks[i];
                                            var y = pitchOffset - deg * ppd;
                                            var halfW = (Math.abs(deg) % 10 === 0) ? r * 0.25 : r * 0.12;

                                            ctx.beginPath();
                                            ctx.moveTo(-halfW, y);
                                            ctx.lineTo(halfW, y);
                                            ctx.stroke();

                                            if (Math.abs(deg) % 10 === 0) {
                                                ctx.fillText(Math.abs(deg).toString(), -halfW - r * 0.1, y);
                                                ctx.fillText(Math.abs(deg).toString(), halfW + r * 0.1, y);
                                            }
                                        }

                                        ctx.restore();
                                        ctx.save();

                                        // Roll arc (fixed, not rotated with pitch/roll)
                                        ctx.translate(cx, cy);
                                        ctx.strokeStyle = "#FFFFFF";
                                        ctx.lineWidth = 2;
                                        ctx.beginPath();
                                        ctx.arc(0, 0, r * 0.85, -Math.PI * 5/6, -Math.PI * 1/6);
                                        ctx.stroke();

                                        // Roll tick marks
                                        var rollMarks = [-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60];
                                        for (var j = 0; j < rollMarks.length; j++) {
                                            var angle = (-90 + rollMarks[j]) * Math.PI / 180;
                                            var innerR = (Math.abs(rollMarks[j]) % 30 === 0) ? r * 0.78 : r * 0.82;
                                            ctx.beginPath();
                                            ctx.moveTo(Math.cos(angle) * innerR, Math.sin(angle) * innerR);
                                            ctx.lineTo(Math.cos(angle) * r * 0.85, Math.sin(angle) * r * 0.85);
                                            ctx.stroke();
                                        }

                                        // Roll pointer (triangle at current roll)
                                        ctx.save();
                                        ctx.rotate(-roll * Math.PI / 180);
                                        ctx.fillStyle = "#FFFFFF";
                                        ctx.beginPath();
                                        ctx.moveTo(0, -r * 0.85);
                                        ctx.lineTo(-r * 0.04, -r * 0.78);
                                        ctx.lineTo(r * 0.04, -r * 0.78);
                                        ctx.closePath();
                                        ctx.fill();
                                        ctx.restore();

                                        // Fixed aircraft symbol (wings + center dot)
                                        ctx.strokeStyle = "#FFD600";
                                        ctx.fillStyle = "#FFD600";
                                        ctx.lineWidth = 3;

                                        // Left wing
                                        ctx.beginPath();
                                        ctx.moveTo(-r * 0.4, 0);
                                        ctx.lineTo(-r * 0.15, 0);
                                        ctx.lineTo(-r * 0.15, r * 0.05);
                                        ctx.stroke();

                                        // Right wing
                                        ctx.beginPath();
                                        ctx.moveTo(r * 0.4, 0);
                                        ctx.lineTo(r * 0.15, 0);
                                        ctx.lineTo(r * 0.15, r * 0.05);
                                        ctx.stroke();

                                        // Center dot
                                        ctx.beginPath();
                                        ctx.arc(0, 0, r * 0.03, 0, 2 * Math.PI);
                                        ctx.fill();

                                        ctx.restore();

                                        // Outer ring
                                        ctx.strokeStyle = "#333";
                                        ctx.lineWidth = 3;
                                        ctx.beginPath();
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                        ctx.stroke();
                                    }
                                }
                            }

                            // Controls
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                Label {
                                    text: "Pitch"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }
                                Slider {
                                    id: pitchSlider
                                    Layout.fillWidth: true
                                    from: -30
                                    to: 30
                                    value: 0
                                }
                                Label {
                                    text: pitchSlider.value.toFixed(0) + "°"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.preferredWidth: Style.resize(35)
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                Label {
                                    text: "Roll"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }
                                Slider {
                                    id: rollSlider
                                    Layout.fillWidth: true
                                    from: -60
                                    to: 60
                                    value: 0
                                }
                                Label {
                                    text: rollSlider.value.toFixed(0) + "°"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.preferredWidth: Style.resize(35)
                                }
                            }

                            Label {
                                text: "Canvas-drawn sky/ground, pitch ladder, roll arc. Airbus PFD core instrument."
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: Speed & Altitude Tapes
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
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

                                    // Speed Tape (left)
                                    Item {
                                        Layout.preferredWidth: parent.width * 0.35
                                        Layout.fillHeight: true

                                        Canvas {
                                            id: speedTape
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
                                                var ppk = h / 80; // pixels per knot visible

                                                ctx.clearRect(0, 0, w, h);

                                                // Tape background
                                                ctx.fillStyle = "#1a1a1a";
                                                ctx.fillRect(tapeX, 0, tapeW, h);

                                                ctx.save();
                                                ctx.beginPath();
                                                ctx.rect(tapeX, 0, tapeW, h);
                                                ctx.clip();

                                                // Speed marks
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

                                                    // Tick mark
                                                    ctx.beginPath();
                                                    ctx.moveTo(tapeX + tapeW - 1, y);
                                                    ctx.lineTo(tapeX + tapeW - tapeW * 0.15, y);
                                                    ctx.stroke();

                                                    // Speed value
                                                    if (s >= 0) {
                                                        ctx.fillText(s.toString(), tapeX + tapeW - tapeW * 0.2, y);
                                                    }
                                                }

                                                // 5-knot minor ticks
                                                for (var s2 = startSpd + 5; s2 <= endSpd; s2 += 10) {
                                                    var y2 = cy - (s2 - speed) * ppk;
                                                    if (y2 < 0 || y2 > h) continue;
                                                    ctx.beginPath();
                                                    ctx.moveTo(tapeX + tapeW - 1, y2);
                                                    ctx.lineTo(tapeX + tapeW - tapeW * 0.08, y2);
                                                    ctx.stroke();
                                                }

                                                ctx.restore();

                                                // Color bands (right edge) - simplified
                                                // VNE (red) above 340
                                                var vneY = cy - (340 - speed) * ppk;
                                                if (vneY > 0) {
                                                    ctx.fillStyle = "#FF0000";
                                                    ctx.fillRect(tapeX + tapeW, 0, 4, Math.max(0, vneY));
                                                }

                                                // Green band 180-340
                                                var greenTop = cy - (340 - speed) * ppk;
                                                var greenBot = cy - (180 - speed) * ppk;
                                                ctx.fillStyle = "#00E676";
                                                ctx.fillRect(tapeX + tapeW, Math.max(0, greenTop), 4,
                                                    Math.min(h, greenBot) - Math.max(0, greenTop));

                                                // Amber band below 180
                                                var amberTop = cy - (180 - speed) * ppk;
                                                if (amberTop < h) {
                                                    ctx.fillStyle = "#FF9800";
                                                    ctx.fillRect(tapeX + tapeW, Math.max(0, amberTop), 4, h - Math.max(0, amberTop));
                                                }

                                                // Current speed box
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

                                                // Label
                                                ctx.fillStyle = "#AAAAAA";
                                                ctx.font = (h * 0.035) + "px sans-serif";
                                                ctx.textAlign = "center";
                                                ctx.fillText("SPD", tapeX + tapeW / 2, h - h * 0.03);
                                                ctx.fillText("KTS", tapeX + tapeW / 2, h * 0.03);
                                            }
                                        }
                                    }

                                    // Altitude Tape (right)
                                    Item {
                                        Layout.preferredWidth: parent.width * 0.35
                                        Layout.fillHeight: true

                                        Canvas {
                                            id: altTape
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
                                                var ppf = h / 1000; // pixels per foot visible

                                                ctx.clearRect(0, 0, w, h);

                                                // Tape background
                                                ctx.fillStyle = "#1a1a1a";
                                                ctx.fillRect(tapeX, 0, tapeW, h);

                                                ctx.save();
                                                ctx.beginPath();
                                                ctx.rect(tapeX, 0, tapeW, h);
                                                ctx.clip();

                                                // Altitude marks
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

                                                // Current altitude box
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

                                                // Label
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

                            // Controls
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

                    // ========================================
                    // Card 3: Heading Indicator / Compass Rose
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
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

                                        // Background circle
                                        ctx.fillStyle = "#1a1a1a";
                                        ctx.beginPath();
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                        ctx.fill();

                                        // Rotate compass card by heading
                                        ctx.translate(cx, cy);
                                        ctx.rotate(-heading * Math.PI / 180);

                                        // Draw tick marks
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

                                            // Labels every 30 degrees
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

                                        // Heading bug
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

                                        // Fixed aircraft symbol at top (lubber line)
                                        ctx.strokeStyle = "#FFD600";
                                        ctx.lineWidth = 3;
                                        ctx.beginPath();
                                        ctx.moveTo(cx, cy - r + 2);
                                        ctx.lineTo(cx, cy - r * 0.6);
                                        ctx.stroke();

                                        // Fixed triangle pointer at top
                                        ctx.fillStyle = "#FFD600";
                                        ctx.beginPath();
                                        ctx.moveTo(cx, cy - r - 4);
                                        ctx.lineTo(cx - r * 0.05, cy - r + 4);
                                        ctx.lineTo(cx + r * 0.05, cy - r + 4);
                                        ctx.closePath();
                                        ctx.fill();

                                        // Digital heading readout
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

                                        // Outer ring
                                        ctx.strokeStyle = "#555";
                                        ctx.lineWidth = 2;
                                        ctx.beginPath();
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                        ctx.stroke();
                                    }
                                }
                            }

                            // Controls
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

                    // ========================================
                    // Card 4: Vertical Speed & Turn Coordinator
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
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

                                    // VSI Gauge (left)
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Canvas {
                                            id: vsiCanvas
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

                                                // Background
                                                ctx.fillStyle = "#1a1a1a";
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                                ctx.fill();

                                                // Scale: -2000 to +2000 fpm, arc from 210° to 330° (through top)
                                                // Using 7 o'clock (210°) = -2000, 12 o'clock (270°) = 0, 5 o'clock (330°) = +2000
                                                var startAngle = 210;
                                                var endAngle = 330;
                                                var totalSweep = endAngle - startAngle;

                                                ctx.strokeStyle = "#FFFFFF";
                                                ctx.fillStyle = "#FFFFFF";
                                                ctx.textAlign = "center";
                                                ctx.textBaseline = "middle";
                                                ctx.font = (r * 0.1) + "px sans-serif";

                                                // Scale marks: -2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000
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

                                                    if (isMajor) {
                                                        var labelR = r * 0.63;
                                                        var label = (Math.abs(marks[i]) / 1000).toString();
                                                        ctx.fillText(label, cx + Math.cos(angle) * labelR, cy + Math.sin(angle) * labelR);
                                                    }
                                                }

                                                // "0" label at top
                                                ctx.font = "bold " + (r * 0.12) + "px sans-serif";
                                                ctx.fillStyle = "#00FF00";
                                                var zeroAngle = (startAngle + 0.5 * totalSweep) * Math.PI / 180;
                                                ctx.fillText("0", cx + Math.cos(zeroAngle) * r * 0.55, cy + Math.sin(zeroAngle) * r * 0.55);

                                                // UP / DN labels
                                                ctx.fillStyle = "#AAAAAA";
                                                ctx.font = (r * 0.09) + "px sans-serif";
                                                ctx.fillText("DN", cx - r * 0.35, cy + r * 0.2);
                                                ctx.fillText("UP", cx + r * 0.35, cy + r * 0.2);

                                                // Needle
                                                var clampedVS = Math.max(-2000, Math.min(2000, vspeed));
                                                var needleFrac = (clampedVS + 2000) / 4000;
                                                var needleAngle = (startAngle + needleFrac * totalSweep) * Math.PI / 180;

                                                ctx.strokeStyle = "#FFFFFF";
                                                ctx.lineWidth = 3;
                                                ctx.beginPath();
                                                ctx.moveTo(cx, cy);
                                                ctx.lineTo(cx + Math.cos(needleAngle) * r * 0.8, cy + Math.sin(needleAngle) * r * 0.8);
                                                ctx.stroke();

                                                // Center hub
                                                ctx.fillStyle = "#FFD600";
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, r * 0.06, 0, 2 * Math.PI);
                                                ctx.fill();

                                                // Digital readout
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

                                                // VSI label
                                                ctx.fillStyle = "#AAAAAA";
                                                ctx.font = (r * 0.09) + "px sans-serif";
                                                ctx.fillText("V/S", cx, cy + r * 0.6);

                                                // Outer ring
                                                ctx.strokeStyle = "#555";
                                                ctx.lineWidth = 2;
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                                ctx.stroke();
                                            }
                                        }
                                    }

                                    // Turn Coordinator (right)
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Canvas {
                                            id: turnCanvas
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

                                                // Background
                                                ctx.fillStyle = "#1a1a1a";
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                                                ctx.fill();

                                                // Standard rate marks (2 min turn = 3°/s)
                                                ctx.strokeStyle = "#FFFFFF";
                                                ctx.lineWidth = 2;

                                                // Left standard rate mark
                                                var lAngle = (-90 - 30) * Math.PI / 180;
                                                ctx.beginPath();
                                                ctx.moveTo(cx + Math.cos(lAngle) * r * 0.85, cy + Math.sin(lAngle) * r * 0.85);
                                                ctx.lineTo(cx + Math.cos(lAngle) * r * 0.95, cy + Math.sin(lAngle) * r * 0.95);
                                                ctx.stroke();

                                                // Right standard rate mark
                                                var rAngle = (-90 + 30) * Math.PI / 180;
                                                ctx.beginPath();
                                                ctx.moveTo(cx + Math.cos(rAngle) * r * 0.85, cy + Math.sin(rAngle) * r * 0.85);
                                                ctx.lineTo(cx + Math.cos(rAngle) * r * 0.95, cy + Math.sin(rAngle) * r * 0.95);
                                                ctx.stroke();

                                                // Center mark
                                                ctx.beginPath();
                                                ctx.moveTo(cx, cy - r * 0.85);
                                                ctx.lineTo(cx, cy - r * 0.95);
                                                ctx.stroke();

                                                // Aircraft symbol that banks with turn rate
                                                ctx.save();
                                                ctx.translate(cx, cy);
                                                var bankAngle = turnRate * 10; // scale turn rate to bank angle
                                                ctx.rotate(bankAngle * Math.PI / 180);

                                                ctx.strokeStyle = "#FFD600";
                                                ctx.lineWidth = 3;

                                                // Wings
                                                ctx.beginPath();
                                                ctx.moveTo(-r * 0.45, 0);
                                                ctx.lineTo(-r * 0.12, 0);
                                                ctx.stroke();

                                                ctx.beginPath();
                                                ctx.moveTo(r * 0.45, 0);
                                                ctx.lineTo(r * 0.12, 0);
                                                ctx.stroke();

                                                // Tail
                                                ctx.beginPath();
                                                ctx.moveTo(0, 0);
                                                ctx.lineTo(0, r * 0.15);
                                                ctx.lineTo(-r * 0.08, r * 0.15);
                                                ctx.stroke();
                                                ctx.beginPath();
                                                ctx.moveTo(0, r * 0.15);
                                                ctx.lineTo(r * 0.08, r * 0.15);
                                                ctx.stroke();

                                                // Center
                                                ctx.fillStyle = "#FFD600";
                                                ctx.beginPath();
                                                ctx.arc(0, 0, r * 0.04, 0, 2 * Math.PI);
                                                ctx.fill();

                                                ctx.restore();

                                                // Slip/skid ball indicator (bottom)
                                                var ballTrackY = cy + r * 0.55;
                                                var ballTrackW = r * 0.5;

                                                // Track background
                                                ctx.fillStyle = "#333";
                                                ctx.fillRect(cx - ballTrackW / 2, ballTrackY - r * 0.04, ballTrackW, r * 0.08);

                                                // Center marks
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

                                                // Ball
                                                var ballOffset = slip * ballTrackW * 0.4;
                                                ctx.fillStyle = "#FFFFFF";
                                                ctx.beginPath();
                                                ctx.arc(cx + ballOffset, ballTrackY, r * 0.05, 0, 2 * Math.PI);
                                                ctx.fill();

                                                // Labels
                                                ctx.fillStyle = "#AAAAAA";
                                                ctx.font = (r * 0.08) + "px sans-serif";
                                                ctx.textAlign = "center";
                                                ctx.fillText("L", cx - r * 0.55, cy - r * 0.3);
                                                ctx.fillText("R", cx + r * 0.55, cy - r * 0.3);

                                                ctx.font = (r * 0.09) + "px sans-serif";
                                                ctx.fillText("TURN COORDINATOR", cx, cy + r * 0.78);

                                                ctx.font = (r * 0.07) + "px sans-serif";
                                                ctx.fillText("2 MIN", cx, cy + r * 0.88);

                                                // Outer ring
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

                            // Controls
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

                } // End of GridLayout
            }
        }
    }
}
