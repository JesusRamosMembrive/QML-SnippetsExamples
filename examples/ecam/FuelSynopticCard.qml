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
            text: "Fuel Synoptic"
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
                    id: fuelCanvas
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)

                    property real leftFuel: leftFuelSlider.value
                    property real centerFuel: centerFuelSlider.value
                    property real rightFuel: rightFuelSlider.value
                    property bool valve1Open: true
                    property bool valve2Open: true
                    property bool crossfeedOpen: false

                    onLeftFuelChanged: requestPaint()
                    onCenterFuelChanged: requestPaint()
                    onRightFuelChanged: requestPaint()
                    onValve1OpenChanged: requestPaint()
                    onValve2OpenChanged: requestPaint()
                    onCrossfeedOpenChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d");
                        var w = width;
                        var h = height;
                        ctx.clearRect(0, 0, w, h);

                        var green = "#4CAF50";
                        var amber = "#FF9800";
                        var white = "#FFFFFF";
                        var dim = "#555555";

                        ctx.font = (h * 0.035) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";

                        // Tank positions
                        var tankW = w * 0.22;
                        var tankH = h * 0.35;
                        var leftX = w * 0.08;
                        var centerX = w * 0.39;
                        var rightX = w * 0.70;
                        var tankY = h * 0.08;

                        // Draw tanks
                        drawTank(ctx, leftX, tankY, tankW, tankH, leftFuel, "LEFT", green, white);
                        drawTank(ctx, centerX, tankY, tankW, tankH, centerFuel, "CENTER", green, white);
                        drawTank(ctx, rightX, tankY, tankW, tankH, rightFuel, "RIGHT", green, white);

                        // Pipes from tanks down
                        var pipeY = tankY + tankH + h * 0.02;
                        var pipeEndY = h * 0.65;
                        var leftPipeX = leftX + tankW / 2;
                        var centerPipeX = centerX + tankW / 2;
                        var rightPipeX = rightX + tankW / 2;

                        ctx.strokeStyle = valve1Open ? green : dim;
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.moveTo(leftPipeX, pipeY);
                        ctx.lineTo(leftPipeX, pipeEndY);
                        ctx.stroke();

                        ctx.strokeStyle = green;
                        ctx.beginPath();
                        ctx.moveTo(centerPipeX, pipeY);
                        ctx.lineTo(centerPipeX, h * 0.55);
                        ctx.stroke();

                        ctx.strokeStyle = valve2Open ? green : dim;
                        ctx.beginPath();
                        ctx.moveTo(rightPipeX, pipeY);
                        ctx.lineTo(rightPipeX, pipeEndY);
                        ctx.stroke();

                        // Crossfeed pipe (horizontal)
                        var crossY = h * 0.55;
                        ctx.strokeStyle = crossfeedOpen ? green : dim;
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.moveTo(leftPipeX, crossY);
                        ctx.lineTo(rightPipeX, crossY);
                        ctx.stroke();

                        // Center tank feeds into crossfeed
                        ctx.strokeStyle = green;
                        ctx.beginPath();
                        ctx.moveTo(centerPipeX, h * 0.55);
                        ctx.lineTo(centerPipeX, crossY);
                        ctx.stroke();

                        // Valves
                        drawValve(ctx, leftPipeX, pipeEndY - h * 0.08, valve1Open, green, amber);
                        drawValve(ctx, rightPipeX, pipeEndY - h * 0.08, valve2Open, green, amber);
                        drawValve(ctx, centerPipeX, crossY, crossfeedOpen, green, amber);

                        // Valve labels
                        ctx.fillStyle = white;
                        ctx.font = (h * 0.028) + "px sans-serif";
                        ctx.fillText("V1", leftPipeX + w * 0.05, pipeEndY - h * 0.08);
                        ctx.fillText("V2", rightPipeX + w * 0.05, pipeEndY - h * 0.08);
                        ctx.fillText("X-FEED", centerPipeX, crossY + h * 0.05);

                        // Engine feed lines
                        var engY = h * 0.75;
                        ctx.strokeStyle = valve1Open ? green : dim;
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.moveTo(leftPipeX, pipeEndY);
                        ctx.lineTo(leftPipeX, engY);
                        ctx.stroke();

                        ctx.strokeStyle = valve2Open ? green : dim;
                        ctx.beginPath();
                        ctx.moveTo(rightPipeX, pipeEndY);
                        ctx.lineTo(rightPipeX, engY);
                        ctx.stroke();

                        // Engine boxes
                        var engBoxW = w * 0.15;
                        var engBoxH = h * 0.12;
                        ctx.strokeStyle = green;
                        ctx.lineWidth = 2;
                        ctx.strokeRect(leftPipeX - engBoxW / 2, engY, engBoxW, engBoxH);
                        ctx.strokeRect(rightPipeX - engBoxW / 2, engY, engBoxW, engBoxH);

                        ctx.fillStyle = white;
                        ctx.font = "bold " + (h * 0.032) + "px sans-serif";
                        ctx.fillText("ENG 1", leftPipeX, engY + engBoxH / 2);
                        ctx.fillText("ENG 2", rightPipeX, engY + engBoxH / 2);

                        // Total fuel
                        var totalKg = Math.round((leftFuel + centerFuel + rightFuel) * 100);
                        ctx.fillStyle = green;
                        ctx.font = "bold " + (h * 0.035) + "px sans-serif";
                        ctx.fillText("FOB: " + totalKg + " KG", w / 2, h * 0.95);
                    }

                    function drawTank(ctx, x, y, w, h, level, label, green, white) {
                        ctx.strokeStyle = green;
                        ctx.lineWidth = 2;
                        ctx.strokeRect(x, y, w, h);

                        var fillH = h * (level / 100);
                        ctx.fillStyle = green + "30";
                        ctx.fillRect(x + 1, y + h - fillH, w - 2, fillH);

                        ctx.strokeStyle = green;
                        ctx.lineWidth = 1;
                        ctx.setLineDash([4, 3]);
                        ctx.beginPath();
                        ctx.moveTo(x + 2, y + h - fillH);
                        ctx.lineTo(x + w - 2, y + h - fillH);
                        ctx.stroke();
                        ctx.setLineDash([]);

                        ctx.fillStyle = white;
                        ctx.font = "bold " + (h * 0.12) + "px sans-serif";
                        ctx.textAlign = "center";
                        ctx.fillText(label, x + w / 2, y - h * 0.08);

                        ctx.fillStyle = green;
                        ctx.font = "bold " + (h * 0.14) + "px sans-serif";
                        ctx.fillText(Math.round(level * 100) + "", x + w / 2, y + h / 2);

                        ctx.font = (h * 0.09) + "px sans-serif";
                        ctx.fillText("KG", x + w / 2, y + h / 2 + h * 0.14);
                    }

                    function drawValve(ctx, x, y, isOpen, green, amber) {
                        var r = 8;
                        ctx.beginPath();
                        ctx.arc(x, y, r, 0, 2 * Math.PI);
                        ctx.strokeStyle = isOpen ? green : amber;
                        ctx.lineWidth = 2;
                        ctx.stroke();

                        if (isOpen) {
                            ctx.beginPath();
                            ctx.moveTo(x, y - r);
                            ctx.lineTo(x, y + r);
                            ctx.strokeStyle = green;
                            ctx.stroke();
                        } else {
                            ctx.beginPath();
                            ctx.moveTo(x - r, y);
                            ctx.lineTo(x + r, y);
                            ctx.strokeStyle = amber;
                            ctx.stroke();
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: function(mouse) {
                            var w = fuelCanvas.width;
                            var h = fuelCanvas.height;
                            var leftPipeX = w * 0.08 + w * 0.22 / 2;
                            var centerPipeX = w * 0.39 + w * 0.22 / 2;
                            var rightPipeX = w * 0.70 + w * 0.22 / 2;
                            var pipeEndY = h * 0.65;
                            var crossY = h * 0.55;

                            var tolerance = 15;

                            if (Math.abs(mouse.x - leftPipeX) < tolerance && Math.abs(mouse.y - (pipeEndY - h * 0.08)) < tolerance) {
                                fuelCanvas.valve1Open = !fuelCanvas.valve1Open;
                            }
                            else if (Math.abs(mouse.x - rightPipeX) < tolerance && Math.abs(mouse.y - (pipeEndY - h * 0.08)) < tolerance) {
                                fuelCanvas.valve2Open = !fuelCanvas.valve2Open;
                            }
                            else if (Math.abs(mouse.x - centerPipeX) < tolerance && Math.abs(mouse.y - crossY) < tolerance) {
                                fuelCanvas.crossfeedOpen = !fuelCanvas.crossfeedOpen;
                            }
                        }
                    }
                }
            }
        }

        // Fuel sliders
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label { text: "L"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }
            Slider {
                id: leftFuelSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 75
            }
            Label { text: "C"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }
            Slider {
                id: centerFuelSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 50
            }
            Label { text: "R"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }
            Slider {
                id: rightFuelSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 75
            }
        }

        Label {
            text: "Canvas fuel schematic: tanks with fill levels, pipes, clickable valves (circle=open, bar=closed). Click valves to toggle."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
