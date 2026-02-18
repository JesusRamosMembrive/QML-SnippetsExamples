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
