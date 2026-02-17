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

                Label {
                    text: "ECAM — Engine & System Monitoring"
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
                    // Card 1: Engine Gauges (Dual N1)
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

                                                    // Arc sweep: from 220° to 320° (200° total sweep)
                                                    var startDeg = 220;
                                                    var endDeg = 320;
                                                    var totalSweep = 360 - startDeg + endDeg; // 100° going clockwise through top

                                                    // Wait, let me recalculate. 220° to 320° going clockwise:
                                                    // That's only 100°. Let me use 150° to 390° (=30°)
                                                    // Actually: start at 135° (bottom-left), sweep 270° to 45° (top-right)
                                                    var arcStart = 135; // 7:30 position
                                                    var arcEnd = 45;   // 1:30 position
                                                    var sweep = 270;   // degrees of arc

                                                    // Green zone: 0-80% (idle to cruise)
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

                    // ========================================
                    // Card 2: Warning Panel (ECAM Messages)
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
                                text: "Warning Panel"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Master buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                // Master WARNING
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(50)
                                    color: warningModel.count > 0 ? "#F44336" : "#5a1a1a"
                                    radius: Style.resize(4)
                                    border.color: "#F44336"
                                    border.width: 2

                                    SequentialAnimation on opacity {
                                        running: warningModel.count > 0
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.5; duration: 400 }
                                        NumberAnimation { to: 1.0; duration: 400 }
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: "MASTER\nWARNING"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: warningModel.clear()
                                    }
                                }

                                // Master CAUTION
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(50)
                                    color: cautionModel.count > 0 ? "#FF9800" : "#4a3a0a"
                                    radius: Style.resize(4)
                                    border.color: "#FF9800"
                                    border.width: 2

                                    SequentialAnimation on opacity {
                                        running: cautionModel.count > 0
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.6; duration: 500 }
                                        NumberAnimation { to: 1.0; duration: 500 }
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: "MASTER\nCAUTION"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: cautionModel.clear()
                                    }
                                }
                            }

                            ListModel { id: warningModel }
                            ListModel { id: cautionModel }

                            // Message list
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#1a1a1a"
                                radius: Style.resize(4)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)
                                    spacing: Style.resize(2)

                                    // Warnings section
                                    Repeater {
                                        model: warningModel
                                        Label {
                                            text: "\u26A0 " + model.msg
                                            font.pixelSize: Style.resize(13)
                                            font.bold: true
                                            color: "#F44336"
                                            Layout.fillWidth: true
                                        }
                                    }

                                    // Cautions section
                                    Repeater {
                                        model: cautionModel
                                        Label {
                                            text: "\u25B3 " + model.msg
                                            font.pixelSize: Style.resize(13)
                                            color: "#FF9800"
                                            Layout.fillWidth: true
                                        }
                                    }

                                    // Status messages
                                    Label {
                                        text: "\u2022 SLATS RETRACTED"
                                        font.pixelSize: Style.resize(12)
                                        color: "#4CAF50"
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        text: "\u2022 AUTO BRK: MED"
                                        font.pixelSize: Style.resize(12)
                                        color: "#4CAF50"
                                        Layout.fillWidth: true
                                    }

                                    Item { Layout.fillHeight: true }
                                }
                            }

                            // Add warning/caution buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Button {
                                    text: "+ Warning"
                                    onClicked: {
                                        var warnings = ["ENG 1 FIRE", "ENG 2 FAIL", "CABIN PRESS", "HYD G SYS LO PR", "ELEC GEN 1 FAULT"];
                                        warningModel.append({ msg: warnings[warningModel.count % warnings.length] });
                                    }
                                }
                                Button {
                                    text: "+ Caution"
                                    onClicked: {
                                        var cautions = ["FUEL L TK LO LVL", "BLEED 1 FAULT", "AIR PACK 1 OFF", "APU FAULT", "F/CTL ALTN LAW"];
                                        cautionModel.append({ msg: cautions[cautionModel.count % cautions.length] });
                                    }
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Clear All"
                                    onClicked: {
                                        warningModel.clear();
                                        cautionModel.clear();
                                    }
                                }
                            }

                            Label {
                                text: "Master WARNING (red) / CAUTION (amber) with blinking. Click master buttons or Clear to dismiss."
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Fuel Synoptic
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
                                            // Tank outline
                                            ctx.strokeStyle = green;
                                            ctx.lineWidth = 2;
                                            ctx.strokeRect(x, y, w, h);

                                            // Fuel level fill
                                            var fillH = h * (level / 100);
                                            ctx.fillStyle = green + "30";
                                            ctx.fillRect(x + 1, y + h - fillH, w - 2, fillH);

                                            // Level line
                                            ctx.strokeStyle = green;
                                            ctx.lineWidth = 1;
                                            ctx.setLineDash([4, 3]);
                                            ctx.beginPath();
                                            ctx.moveTo(x + 2, y + h - fillH);
                                            ctx.lineTo(x + w - 2, y + h - fillH);
                                            ctx.stroke();
                                            ctx.setLineDash([]);

                                            // Label
                                            ctx.fillStyle = white;
                                            ctx.font = "bold " + (h * 0.12) + "px sans-serif";
                                            ctx.textAlign = "center";
                                            ctx.fillText(label, x + w / 2, y - h * 0.08);

                                            // Quantity
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
                                                // Open: vertical line (flow through)
                                                ctx.beginPath();
                                                ctx.moveTo(x, y - r);
                                                ctx.lineTo(x, y + r);
                                                ctx.strokeStyle = green;
                                                ctx.stroke();
                                            } else {
                                                // Closed: horizontal line (blocked)
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

                                                // Check valve 1 click
                                                if (Math.abs(mouse.x - leftPipeX) < tolerance && Math.abs(mouse.y - (pipeEndY - h * 0.08)) < tolerance) {
                                                    fuelCanvas.valve1Open = !fuelCanvas.valve1Open;
                                                }
                                                // Check valve 2 click
                                                else if (Math.abs(mouse.x - rightPipeX) < tolerance && Math.abs(mouse.y - (pipeEndY - h * 0.08)) < tolerance) {
                                                    fuelCanvas.valve2Open = !fuelCanvas.valve2Open;
                                                }
                                                // Check crossfeed valve click
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

                    // ========================================
                    // Card 4: System Status
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
                                text: "System Status"
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

                                    GridLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(15)
                                        columns: 2
                                        rowSpacing: Style.resize(12)
                                        columnSpacing: Style.resize(15)

                                        // HYD System
                                        Label {
                                            text: "HYD"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                            Layout.columnSpan: 2
                                        }

                                        Repeater {
                                            model: [
                                                { name: "GREEN", clr: "#4CAF50", val: hydGreenSlider.value },
                                                { name: "BLUE", clr: "#2196F3", val: hydBlueSlider.value },
                                                { name: "YELLOW", clr: "#FFEB3B", val: hydYellowSlider.value }
                                            ]

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(8)

                                                Label {
                                                    text: modelData.name
                                                    font.pixelSize: Style.resize(12)
                                                    color: modelData.clr
                                                    Layout.preferredWidth: Style.resize(60)
                                                }

                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    height: Style.resize(16)
                                                    color: "#333"
                                                    radius: Style.resize(3)

                                                    Rectangle {
                                                        width: parent.width * modelData.val / 100
                                                        height: parent.height
                                                        color: modelData.val > 20 ? modelData.clr : "#F44336"
                                                        radius: Style.resize(3)
                                                        Behavior on width { NumberAnimation { duration: 200 } }
                                                    }
                                                }

                                                Label {
                                                    text: Math.round(modelData.val) + "%"
                                                    font.pixelSize: Style.resize(11)
                                                    color: modelData.val > 20 ? modelData.clr : "#F44336"
                                                    Layout.preferredWidth: Style.resize(35)
                                                }
                                            }
                                        }

                                        // ELEC System
                                        Label {
                                            text: "ELEC"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                            Layout.columnSpan: 2
                                            Layout.topMargin: Style.resize(5)
                                        }

                                        Repeater {
                                            model: [
                                                { name: "AC BUS 1", on: acBus1Switch.checked },
                                                { name: "AC BUS 2", on: acBus2Switch.checked },
                                                { name: "DC BAT", on: true }
                                            ]

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(8)

                                                Label {
                                                    text: modelData.name
                                                    font.pixelSize: Style.resize(12)
                                                    color: "#AAAAAA"
                                                    Layout.preferredWidth: Style.resize(70)
                                                }

                                                Rectangle {
                                                    width: Style.resize(12)
                                                    height: Style.resize(12)
                                                    radius: width / 2
                                                    color: modelData.on ? "#4CAF50" : "#F44336"
                                                }

                                                Label {
                                                    text: modelData.on ? "ON" : "OFF"
                                                    font.pixelSize: Style.resize(12)
                                                    font.bold: true
                                                    color: modelData.on ? "#4CAF50" : "#F44336"
                                                    Layout.fillWidth: true
                                                }
                                            }
                                        }

                                        // BLEED & PRESS
                                        Label {
                                            text: "BLEED / PRESS"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                            Layout.columnSpan: 2
                                            Layout.topMargin: Style.resize(5)
                                        }

                                        Repeater {
                                            model: [
                                                { name: "BLEED 1", on: bleed1Switch.checked },
                                                { name: "BLEED 2", on: bleed2Switch.checked },
                                                { name: "PACK 1", on: bleed1Switch.checked },
                                                { name: "PACK 2", on: bleed2Switch.checked }
                                            ]

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(8)

                                                Label {
                                                    text: modelData.name
                                                    font.pixelSize: Style.resize(12)
                                                    color: "#AAAAAA"
                                                    Layout.preferredWidth: Style.resize(70)
                                                }

                                                Rectangle {
                                                    width: Style.resize(12)
                                                    height: Style.resize(12)
                                                    radius: width / 2
                                                    color: modelData.on ? "#4CAF50" : "#FF9800"
                                                }

                                                Label {
                                                    text: modelData.on ? "ON" : "OFF"
                                                    font.pixelSize: Style.resize(12)
                                                    font.bold: true
                                                    color: modelData.on ? "#4CAF50" : "#FF9800"
                                                    Layout.fillWidth: true
                                                }
                                            }
                                        }

                                        Item { Layout.fillHeight: true; Layout.columnSpan: 2 }
                                    }
                                }
                            }

                            // System controls
                            GridLayout {
                                Layout.fillWidth: true
                                columns: 4
                                columnSpacing: Style.resize(8)
                                rowSpacing: Style.resize(4)

                                Label { text: "HYD G"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                Slider {
                                    id: hydGreenSlider
                                    Layout.fillWidth: true
                                    from: 0; to: 100; value: 95
                                }
                                Label { text: "HYD B"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                Slider {
                                    id: hydBlueSlider
                                    Layout.fillWidth: true
                                    from: 0; to: 100; value: 90
                                }

                                Label { text: "HYD Y"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                Slider {
                                    id: hydYellowSlider
                                    Layout.fillWidth: true
                                    from: 0; to: 100; value: 85
                                }

                                // Switches
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: Style.resize(4)
                                    Switch { id: acBus1Switch; checked: true; scale: 0.6 }
                                    Label { text: "AC1"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    Switch { id: acBus2Switch; checked: true; scale: 0.6 }
                                    Label { text: "AC2"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    Switch { id: bleed1Switch; checked: true; scale: 0.6 }
                                    Label { text: "BL1"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                    Switch { id: bleed2Switch; checked: true; scale: 0.6 }
                                    Label { text: "BL2"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                                }
                            }

                            Label {
                                text: "HYD pressure bars (Green/Blue/Yellow), ELEC bus status, BLEED/PACK indicators. Toggle switches to simulate faults."
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
