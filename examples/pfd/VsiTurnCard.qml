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

                // VSI Gauge (left)
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

                            // Background
                            ctx.fillStyle = "#1a1a1a";
                            ctx.beginPath();
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                            ctx.fill();

                            // Scale: -2000 to +2000 fpm, arc from 210° to 330° (through top)
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
