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
