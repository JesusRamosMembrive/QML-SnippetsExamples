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

                    // Engine 1
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Canvas {
                            id: eng1Canvas
                            anchors.fill: parent

                            property real n1: n1Slider.value

                            onN1Changed: requestPaint()

                            onPaint: {
                                drawEngineGauge(getContext("2d"), width, height, n1, "ENG 1");
                            }

                            function drawEngineGauge(ctx, w, h, value, label) {
                                var cx = w / 2;
                                var cy = h * 0.5;
                                var r = Math.min(cx, cy) - 10;

                                ctx.clearRect(0, 0, w, h);

                                var arcStart = 135;
                                var arcEnd = 45;
                                var sweep = 270;

                                // Green zone: 0-80%
                                drawArcSegment(ctx, cx, cy, r, arcStart, arcStart + sweep * 0.80, "#4CAF50", 6);
                                // Amber zone: 80-95%
                                drawArcSegment(ctx, cx, cy, r, arcStart + sweep * 0.80, arcStart + sweep * 0.95, "#FF9800", 6);
                                // Red zone: 95-100%
                                drawArcSegment(ctx, cx, cy, r, arcStart + sweep * 0.95, arcStart + sweep, "#F44336", 6);

                                // Background arc (dim)
                                drawArcSegment(ctx, cx, cy, r * 0.85, arcStart, arcStart + sweep, "#333333", 3);

                                // Tick marks
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

                                // Needle
                                var needlePct = Math.max(0, Math.min(100, value));
                                var needleAngle = (arcStart + sweep * needlePct / 100) * Math.PI / 180;
                                ctx.strokeStyle = "#FFFFFF";
                                ctx.lineWidth = 3;
                                ctx.beginPath();
                                ctx.moveTo(cx + Math.cos(needleAngle) * r * 0.3, cy + Math.sin(needleAngle) * r * 0.3);
                                ctx.lineTo(cx + Math.cos(needleAngle) * r * 0.85, cy + Math.sin(needleAngle) * r * 0.85);
                                ctx.stroke();

                                // Center hub
                                ctx.fillStyle = "#555";
                                ctx.beginPath();
                                ctx.arc(cx, cy, r * 0.08, 0, 2 * Math.PI);
                                ctx.fill();

                                // Digital readout
                                var valueColor = value > 95 ? "#F44336" : (value > 80 ? "#FF9800" : "#4CAF50");
                                ctx.fillStyle = valueColor;
                                ctx.font = "bold " + (r * 0.28) + "px sans-serif";
                                ctx.textAlign = "center";
                                ctx.fillText(value.toFixed(1), cx, cy + r * 0.35);

                                ctx.fillStyle = "#AAAAAA";
                                ctx.font = (r * 0.13) + "px sans-serif";
                                ctx.fillText("% N1", cx, cy + r * 0.52);

                                // Engine label
                                ctx.fillStyle = "#FFFFFF";
                                ctx.font = "bold " + (r * 0.15) + "px sans-serif";
                                ctx.fillText(label, cx, h - r * 0.15);
                            }

                            function drawArcSegment(ctx, cx, cy, r, startDeg, endDeg, color, lineWidth) {
                                ctx.strokeStyle = color;
                                ctx.lineWidth = lineWidth;
                                ctx.beginPath();
                                ctx.arc(cx, cy, r, startDeg * Math.PI / 180, endDeg * Math.PI / 180);
                                ctx.stroke();
                            }
                        }
                    }

                    // Engine 2
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Canvas {
                            id: eng2Canvas
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

        // Controls
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
