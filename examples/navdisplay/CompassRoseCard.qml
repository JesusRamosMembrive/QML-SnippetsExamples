import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property real heading: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Compass Rose"
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

                Canvas {
                    id: compassCanvas
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)

                    property real hdg: root.heading

                    onHdgChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d");
                        var w = width;
                        var h = height;
                        var cx = w / 2;
                        var cy = h / 2;
                        var r = Math.min(cx, cy) - 20;

                        ctx.clearRect(0, 0, w, h);

                        var green = "#00FF00";
                        var white = "#FFFFFF";

                        // Outer ring
                        ctx.strokeStyle = "#444444";
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.arc(cx, cy, r + 5, 0, 2 * Math.PI);
                        ctx.stroke();

                        // Rotating compass card
                        ctx.save();
                        ctx.translate(cx, cy);
                        ctx.rotate(-hdg * Math.PI / 180);

                        // Tick marks every 5 degrees
                        for (var deg = 0; deg < 360; deg += 5) {
                            var rad = (deg - 90) * Math.PI / 180;
                            var isCardinal = (deg % 90 === 0);
                            var isMajor = (deg % 10 === 0);
                            var innerR;
                            if (isCardinal) innerR = r - 20;
                            else if (isMajor) innerR = r - 12;
                            else innerR = r - 6;

                            ctx.strokeStyle = isCardinal ? white : "#888888";
                            ctx.lineWidth = isCardinal ? 2 : 1;
                            ctx.beginPath();
                            ctx.moveTo(Math.cos(rad) * innerR, Math.sin(rad) * innerR);
                            ctx.lineTo(Math.cos(rad) * r, Math.sin(rad) * r);
                            ctx.stroke();
                        }

                        // Labels every 30 degrees
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";
                        ctx.font = "bold " + (r * 0.11) + "px sans-serif";

                        var labels = [
                            { deg: 0, text: "N", color: white },
                            { deg: 30, text: "3", color: green },
                            { deg: 60, text: "6", color: green },
                            { deg: 90, text: "E", color: white },
                            { deg: 120, text: "12", color: green },
                            { deg: 150, text: "15", color: green },
                            { deg: 180, text: "S", color: white },
                            { deg: 210, text: "21", color: green },
                            { deg: 240, text: "24", color: green },
                            { deg: 270, text: "W", color: white },
                            { deg: 300, text: "30", color: green },
                            { deg: 330, text: "33", color: green }
                        ];

                        for (var i = 0; i < labels.length; i++) {
                            var l = labels[i];
                            var rad = (l.deg - 90) * Math.PI / 180;
                            var labelR = r - 32;
                            ctx.fillStyle = l.color;
                            ctx.fillText(l.text, Math.cos(rad) * labelR, Math.sin(rad) * labelR);
                        }

                        // North arrow (red triangle)
                        ctx.fillStyle = "#FF4444";
                        var nRad = -Math.PI / 2;
                        var nR = r + 2;
                        ctx.beginPath();
                        ctx.moveTo(Math.cos(nRad) * nR, Math.sin(nRad) * nR);
                        ctx.lineTo(Math.cos(nRad - 0.06) * (nR - 14), Math.sin(nRad - 0.06) * (nR - 14));
                        ctx.lineTo(Math.cos(nRad + 0.06) * (nR - 14), Math.sin(nRad + 0.06) * (nR - 14));
                        ctx.closePath();
                        ctx.fill();

                        ctx.restore();

                        // Fixed lubber line (yellow triangle at top)
                        ctx.fillStyle = "#FFFF00";
                        ctx.beginPath();
                        ctx.moveTo(cx, cy - r - 8);
                        ctx.lineTo(cx - 7, cy - r + 5);
                        ctx.lineTo(cx + 7, cy - r + 5);
                        ctx.closePath();
                        ctx.fill();

                        // Center dot
                        ctx.fillStyle = white;
                        ctx.beginPath();
                        ctx.arc(cx, cy, 3, 0, 2 * Math.PI);
                        ctx.fill();

                        // Heading readout box
                        var hdgStr = Math.round(hdg).toString().padStart(3, "0");
                        ctx.fillStyle = "#000000";
                        ctx.fillRect(cx - 25, 5, 50, 20);
                        ctx.strokeStyle = green;
                        ctx.lineWidth = 1;
                        ctx.strokeRect(cx - 25, 5, 50, 20);
                        ctx.fillStyle = green;
                        ctx.font = "bold " + (r * 0.09) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";
                        ctx.fillText(hdgStr + "\u00B0", cx, 15);
                    }
                }
            }
        }

        Label {
            text: "Full 360\u00B0 rotating compass card. Yellow lubber line at top, red north arrow. Heading slider drives rotation."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
