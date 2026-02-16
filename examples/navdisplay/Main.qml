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
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // Shared ND properties
    property real heading: headingSlider.value
    property int rangeIndex: 2
    property var rangeValues: [10, 20, 40, 80, 160, 320]
    property real currentRange: rangeValues[rangeIndex]
    property string ndMode: "ROSE"
    property int selectedWp: -1

    // Flight plan: bearing (magnetic) and distance (NM) from aircraft
    property var flightPlan: [
        { name: "DEPART", brg: 0,   dist: 0,   alt: "----",  eta: "--:--" },
        { name: "MOPAR",  brg: 25,  dist: 12,  alt: "FL120", eta: "00:04" },
        { name: "OKRIX",  brg: 40,  dist: 28,  alt: "FL240", eta: "00:09" },
        { name: "VESAN",  brg: 15,  dist: 52,  alt: "FL350", eta: "00:18" },
        { name: "LARAN",  brg: 355, dist: 85,  alt: "FL370", eta: "00:28" },
        { name: "ASTER",  brg: 340, dist: 120, alt: "FL370", eta: "00:35" },
        { name: "ARRIV",  brg: 330, dist: 160, alt: "FL180", eta: "00:45" }
    ]

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
                    text: "Navigation Display"
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
                    // Card 1: Moving Map
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Moving Map"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#0a0f0a"
                                    radius: Style.resize(6)

                                    Canvas {
                                        id: mapCanvas
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(4)

                                        property real hdg: root.heading
                                        property real rng: root.currentRange
                                        property string mode: root.ndMode
                                        property int selWp: root.selectedWp

                                        onHdgChanged: requestPaint()
                                        onRngChanged: requestPaint()
                                        onModeChanged: requestPaint()
                                        onSelWpChanged: requestPaint()

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            var w = width;
                                            var h = height;
                                            var cx = w / 2;
                                            var cy = h / 2;
                                            var maxR = Math.min(cx, cy) - 25;

                                            ctx.clearRect(0, 0, w, h);

                                            var green = "#00FF00";
                                            var magenta = "#FF00FF";
                                            var cyan = "#00FFFF";
                                            var white = "#FFFFFF";

                                            // Compass arc around the edge
                                            drawCompassArc(ctx, cx, cy, maxR + 15, hdg, mode);

                                            // Range rings
                                            ctx.strokeStyle = "#1a3a1a";
                                            ctx.lineWidth = 1;
                                            for (var i = 1; i <= 4; i++) {
                                                ctx.beginPath();
                                                ctx.arc(cx, cy, maxR * i / 4, 0, 2 * Math.PI);
                                                ctx.stroke();
                                            }

                                            // Range labels
                                            ctx.fillStyle = "#556655";
                                            ctx.font = (maxR * 0.07) + "px sans-serif";
                                            ctx.textAlign = "left";
                                            ctx.textBaseline = "top";
                                            for (var i = 1; i <= 4; i++) {
                                                var ringR = maxR * i / 4;
                                                var rangeVal = Math.round(rng * i / 4);
                                                ctx.fillText(rangeVal + "", cx + 4, cy - ringR + 2);
                                            }

                                            // Draw flight plan (rotated for heading-up or north-up)
                                            ctx.save();
                                            ctx.translate(cx, cy);
                                            var rotAngle = (mode === "PLAN") ? 0 : -hdg;
                                            ctx.rotate(rotAngle * Math.PI / 180);

                                            // Route lines (magenta)
                                            var plan = root.flightPlan;
                                            ctx.strokeStyle = magenta;
                                            ctx.lineWidth = 2;
                                            var prevX = 0, prevY = 0;
                                            for (var i = 0; i < plan.length; i++) {
                                                var wp = plan[i];
                                                var angle = wp.brg * Math.PI / 180;
                                                var pixDist = (wp.dist / rng) * maxR;
                                                var wpx = pixDist * Math.sin(angle);
                                                var wpy = -pixDist * Math.cos(angle);

                                                if (i > 0 && pixDist <= maxR * 1.3) {
                                                    ctx.beginPath();
                                                    ctx.moveTo(prevX, prevY);
                                                    ctx.lineTo(wpx, wpy);
                                                    ctx.stroke();
                                                }
                                                prevX = wpx;
                                                prevY = wpy;
                                            }

                                            // Waypoint symbols
                                            for (var i = 1; i < plan.length; i++) {
                                                var wp = plan[i];
                                                var angle = wp.brg * Math.PI / 180;
                                                var pixDist = (wp.dist / rng) * maxR;
                                                var wpx = pixDist * Math.sin(angle);
                                                var wpy = -pixDist * Math.cos(angle);

                                                if (pixDist > maxR * 1.1) continue;

                                                var isSelected = (i === selWp);
                                                var wpColor = isSelected ? cyan : green;
                                                var sz = isSelected ? 7 : 5;

                                                // Diamond
                                                ctx.fillStyle = wpColor;
                                                ctx.beginPath();
                                                ctx.moveTo(wpx, wpy - sz);
                                                ctx.lineTo(wpx + sz, wpy);
                                                ctx.lineTo(wpx, wpy + sz);
                                                ctx.lineTo(wpx - sz, wpy);
                                                ctx.closePath();
                                                ctx.fill();

                                                // Label
                                                ctx.fillStyle = wpColor;
                                                ctx.font = (maxR * 0.07) + "px sans-serif";
                                                ctx.textAlign = "left";
                                                ctx.textBaseline = "bottom";
                                                ctx.fillText(wp.name, wpx + sz + 3, wpy - 2);
                                            }

                                            ctx.restore();

                                            // Aircraft symbol (always at center, pointing up)
                                            drawAircraftSymbol(ctx, cx, cy, white);

                                            // Heading readout (top center)
                                            var hdgStr = Math.round(hdg).toString().padStart(3, "0");
                                            ctx.fillStyle = "#000000";
                                            ctx.fillRect(cx - 28, 3, 56, 18);
                                            ctx.strokeStyle = green;
                                            ctx.lineWidth = 1;
                                            ctx.strokeRect(cx - 28, 3, 56, 18);
                                            ctx.fillStyle = green;
                                            ctx.font = "bold " + (maxR * 0.08) + "px sans-serif";
                                            ctx.textAlign = "center";
                                            ctx.textBaseline = "middle";
                                            ctx.fillText("HDG " + hdgStr + "\u00B0", cx, 12);

                                            // Mode and range (bottom corners)
                                            ctx.fillStyle = green;
                                            ctx.font = (maxR * 0.07) + "px sans-serif";
                                            ctx.textAlign = "left";
                                            ctx.textBaseline = "bottom";
                                            ctx.fillText(mode, 5, h - 5);
                                            ctx.textAlign = "right";
                                            ctx.fillText(Math.round(rng) + " NM", w - 5, h - 5);
                                        }

                                        function drawCompassArc(ctx, cx, cy, r, hdg, mode) {
                                            var arcColor = "#446644";
                                            var labelColor = "#88AA88";
                                            var rotAngle = (mode === "PLAN") ? 0 : -hdg;

                                            ctx.strokeStyle = arcColor;
                                            ctx.lineWidth = 1;

                                            for (var deg = 0; deg < 360; deg += 5) {
                                                var drawDeg = deg + rotAngle;
                                                var rad = drawDeg * Math.PI / 180;
                                                var innerR = (deg % 10 === 0) ? r - 8 : r - 5;

                                                ctx.beginPath();
                                                ctx.moveTo(cx + Math.cos(rad - Math.PI/2) * innerR, cy + Math.sin(rad - Math.PI/2) * innerR);
                                                ctx.lineTo(cx + Math.cos(rad - Math.PI/2) * r, cy + Math.sin(rad - Math.PI/2) * r);
                                                ctx.stroke();
                                            }

                                            // Labels every 30 degrees
                                            ctx.font = "bold " + (r * 0.055) + "px sans-serif";
                                            ctx.textAlign = "center";
                                            ctx.textBaseline = "middle";

                                            var cardinals = [
                                                { deg: 0, label: "N" }, { deg: 30, label: "3" },
                                                { deg: 60, label: "6" }, { deg: 90, label: "E" },
                                                { deg: 120, label: "12" }, { deg: 150, label: "15" },
                                                { deg: 180, label: "S" }, { deg: 210, label: "21" },
                                                { deg: 240, label: "24" }, { deg: 270, label: "W" },
                                                { deg: 300, label: "30" }, { deg: 330, label: "33" }
                                            ];

                                            for (var i = 0; i < cardinals.length; i++) {
                                                var c = cardinals[i];
                                                var drawDeg = c.deg + rotAngle;
                                                var rad = drawDeg * Math.PI / 180;
                                                var labelR = r - 16;
                                                var lx = cx + Math.cos(rad - Math.PI/2) * labelR;
                                                var ly = cy + Math.sin(rad - Math.PI/2) * labelR;

                                                ctx.fillStyle = (c.label === "N" || c.label === "E" || c.label === "S" || c.label === "W") ? "#FFFFFF" : labelColor;
                                                ctx.fillText(c.label, lx, ly);
                                            }
                                        }

                                        function drawAircraftSymbol(ctx, cx, cy, color) {
                                            ctx.strokeStyle = color;
                                            ctx.lineWidth = 2;

                                            // Fuselage
                                            ctx.beginPath();
                                            ctx.moveTo(cx, cy - 12);
                                            ctx.lineTo(cx, cy + 10);
                                            ctx.stroke();

                                            // Wings
                                            ctx.beginPath();
                                            ctx.moveTo(cx - 14, cy + 2);
                                            ctx.lineTo(cx + 14, cy + 2);
                                            ctx.stroke();

                                            // Tail
                                            ctx.beginPath();
                                            ctx.moveTo(cx - 6, cy + 10);
                                            ctx.lineTo(cx + 6, cy + 10);
                                            ctx.stroke();

                                            // Nose dot
                                            ctx.fillStyle = color;
                                            ctx.beginPath();
                                            ctx.arc(cx, cy - 12, 2, 0, 2 * Math.PI);
                                            ctx.fill();
                                        }
                                    }
                                }
                            }

                            // Heading slider
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Label {
                                    text: "HDG"
                                    font.pixelSize: Style.resize(12)
                                    color: "#666"
                                }
                                Slider {
                                    id: headingSlider
                                    Layout.fillWidth: true
                                    from: 0; to: 359; value: 45
                                    stepSize: 1
                                }
                                Label {
                                    text: Math.round(headingSlider.value) + "\u00B0"
                                    font.pixelSize: Style.resize(12)
                                    color: "#666"
                                    Layout.preferredWidth: Style.resize(35)
                                }
                            }

                            Label {
                                text: "Canvas moving map with heading-up rotation. Magenta route, green waypoints. PLAN mode shows north-up."
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: Flight Plan List
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Flight Plan"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Header row
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(30)
                                color: "#2a2a2a"
                                radius: Style.resize(4)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Style.resize(10)
                                    anchors.rightMargin: Style.resize(10)
                                    spacing: Style.resize(5)

                                    Label { text: "WPT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(55) }
                                    Label { text: "BRG"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(35); horizontalAlignment: Text.AlignRight }
                                    Label { text: "DIST"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(45); horizontalAlignment: Text.AlignRight }
                                    Label { text: "ALT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(50); horizontalAlignment: Text.AlignRight }
                                    Label { text: "ETA"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                                }
                            }

                            // Waypoint list
                            ListView {
                                id: wpListView
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: root.flightPlan.length

                                delegate: Rectangle {
                                    required property int index

                                    width: wpListView.width
                                    height: Style.resize(36)
                                    color: {
                                        if (index === root.selectedWp) return "#1a3a3a";
                                        if (wpMa.containsMouse) return "#1a1a2a";
                                        return (index % 2 === 0) ? "#1a1a1a" : "#222222";
                                    }
                                    radius: Style.resize(2)

                                    property var wp: root.flightPlan[index]

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        spacing: Style.resize(5)

                                        Label {
                                            text: wp.name
                                            font.pixelSize: Style.resize(13)
                                            font.bold: true
                                            color: index === root.selectedWp ? "#00FFFF" : "#00FF00"
                                            Layout.preferredWidth: Style.resize(55)
                                        }
                                        Label {
                                            text: wp.brg + "\u00B0"
                                            font.pixelSize: Style.resize(12)
                                            color: "#AAAAAA"
                                            Layout.preferredWidth: Style.resize(35)
                                            horizontalAlignment: Text.AlignRight
                                        }
                                        Label {
                                            text: wp.dist + " NM"
                                            font.pixelSize: Style.resize(12)
                                            color: "#AAAAAA"
                                            Layout.preferredWidth: Style.resize(45)
                                            horizontalAlignment: Text.AlignRight
                                        }
                                        Label {
                                            text: wp.alt
                                            font.pixelSize: Style.resize(12)
                                            color: "#FFFFFF"
                                            Layout.preferredWidth: Style.resize(50)
                                            horizontalAlignment: Text.AlignRight
                                        }
                                        Label {
                                            text: wp.eta
                                            font.pixelSize: Style.resize(12)
                                            color: "#FFFFFF"
                                            Layout.fillWidth: true
                                            horizontalAlignment: Text.AlignRight
                                        }
                                    }

                                    MouseArea {
                                        id: wpMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: root.selectedWp = index
                                    }
                                }
                            }

                            Label {
                                text: "Click a waypoint to highlight it on the map (cyan). Shows bearing, distance, altitude, and ETA."
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Compass Rose
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        color: "white"
                        radius: Style.resize(8)

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
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Mode & Range Selector
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Mode & Range"
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

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(15)
                                        spacing: Style.resize(15)

                                        // ND Mode
                                        Label {
                                            text: "ND MODE"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                        }

                                        GridLayout {
                                            Layout.fillWidth: true
                                            columns: 2
                                            columnSpacing: Style.resize(8)
                                            rowSpacing: Style.resize(8)

                                            Repeater {
                                                model: ["ROSE", "ARC", "PLAN", "VOR"]

                                                Rectangle {
                                                    required property string modelData

                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: Style.resize(40)
                                                    color: root.ndMode === modelData ? "#00FF00" : "#333333"
                                                    radius: Style.resize(4)
                                                    border.color: "#00FF00"
                                                    border.width: root.ndMode === modelData ? 2 : 1

                                                    Label {
                                                        anchors.centerIn: parent
                                                        text: parent.modelData
                                                        font.pixelSize: Style.resize(14)
                                                        font.bold: true
                                                        color: parent.color === "#00FF00" ? "#000000" : "#00FF00"
                                                    }

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: root.ndMode = parent.modelData
                                                    }
                                                }
                                            }
                                        }

                                        // Range
                                        Label {
                                            text: "RANGE"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                            Layout.topMargin: Style.resize(10)
                                        }

                                        GridLayout {
                                            Layout.fillWidth: true
                                            columns: 3
                                            columnSpacing: Style.resize(8)
                                            rowSpacing: Style.resize(8)

                                            Repeater {
                                                model: root.rangeValues.length

                                                Rectangle {
                                                    required property int index

                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: Style.resize(36)
                                                    color: root.rangeIndex === index ? "#00FF00" : "#333333"
                                                    radius: Style.resize(4)
                                                    border.color: "#00FF00"
                                                    border.width: root.rangeIndex === index ? 2 : 1

                                                    Label {
                                                        anchors.centerIn: parent
                                                        text: root.rangeValues[parent.index] + " NM"
                                                        font.pixelSize: Style.resize(12)
                                                        font.bold: true
                                                        color: parent.color === "#00FF00" ? "#000000" : "#00FF00"
                                                    }

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: root.rangeIndex = parent.index
                                                    }
                                                }
                                            }
                                        }

                                        // Status info
                                        Item { Layout.preferredHeight: Style.resize(10) }

                                        Label {
                                            text: "STATUS"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#FFFFFF"
                                        }

                                        GridLayout {
                                            Layout.fillWidth: true
                                            columns: 2
                                            columnSpacing: Style.resize(10)
                                            rowSpacing: Style.resize(4)

                                            Label { text: "Mode:"; font.pixelSize: Style.resize(12); color: "#888888" }
                                            Label { text: root.ndMode; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                                            Label { text: "Range:"; font.pixelSize: Style.resize(12); color: "#888888" }
                                            Label { text: root.currentRange + " NM"; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                                            Label { text: "Heading:"; font.pixelSize: Style.resize(12); color: "#888888" }
                                            Label { text: Math.round(root.heading).toString().padStart(3, "0") + "\u00B0"; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                                            Label { text: "Waypoints:"; font.pixelSize: Style.resize(12); color: "#888888" }
                                            Label { text: root.flightPlan.length; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }
                                        }

                                        Item { Layout.fillHeight: true }
                                    }
                                }
                            }

                            Label {
                                text: "Switch ND mode (ROSE/ARC/PLAN/VOR) and range. PLAN mode is north-up, others heading-up."
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End GridLayout
            }
        }
    }
}
