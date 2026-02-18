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
