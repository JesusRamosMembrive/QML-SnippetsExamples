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
                    text: "Dials & Indicators Examples"
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
                    // Card 1: Dial
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "Dial"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(20)

                                // Basic Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Dial {
                                        id: basicDial
                                        Layout.preferredWidth: Style.resize(140)
                                        Layout.preferredHeight: Style.resize(140)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 100
                                        value: 35
                                    }

                                    Label {
                                        text: "Basic (0-100)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Stepped Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Dial {
                                        id: steppedDial
                                        Layout.preferredWidth: Style.resize(140)
                                        Layout.preferredHeight: Style.resize(140)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 100
                                        stepSize: 10
                                        snapMode: Dial.SnapAlways
                                        value: 50
                                    }

                                    Label {
                                        text: "Stepped (10)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Temperature Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Dial {
                                        id: tempDial
                                        Layout.preferredWidth: Style.resize(140)
                                        Layout.preferredHeight: Style.resize(140)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 40
                                        stepSize: 1
                                        snapMode: Dial.SnapAlways
                                        value: 21
                                        suffix: "°C"
                                    }

                                    Label {
                                        text: "Temp (0-40°C)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: "Dial provides a rotary control for selecting values within a range"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: ProgressBar
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "ProgressBar"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Determinate ProgressBar
                            Label {
                                text: "Determinate: " + (progressSlider.value * 100).toFixed(0) + "%"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                            }

                            ProgressBar {
                                id: determinateBar
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(8)
                                from: 0
                                to: 1
                                value: progressSlider.value
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)

                                Slider {
                                    id: progressSlider
                                    anchors.fill: parent
                                    anchors.leftMargin: Style.resize(10)
                                    anchors.rightMargin: Style.resize(10)
                                    from: 0
                                    to: 1
                                    value: 0.65
                                    stepSize: 0.01
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                color: Style.bgColor
                            }

                            // Indeterminate ProgressBar
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Indeterminate:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontPrimaryColor
                                    Layout.fillWidth: true
                                }

                                Switch {
                                    id: indeterminateSwitch
                                    text: indeterminateSwitch.checked ? "ON" : "OFF"
                                    checked: true
                                }
                            }

                            ProgressBar {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(8)
                                indeterminate: indeterminateSwitch.checked
                            }

                            Item { Layout.fillHeight: true }

                            Label {
                                text: "ProgressBar shows task completion. Indeterminate mode indicates unknown duration"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: BusyIndicator
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "BusyIndicator"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Switch {
                                id: busySwitch
                                text: "Running"
                                checked: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(40)
                                Layout.alignment: Qt.AlignHCenter

                                // Default size
                                ColumnLayout {
                                    spacing: Style.resize(10)
                                    Layout.alignment: Qt.AlignHCenter

                                    BusyIndicator {
                                        running: busySwitch.checked
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Label {
                                        text: "Default (40px)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Large size
                                ColumnLayout {
                                    spacing: Style.resize(10)
                                    Layout.alignment: Qt.AlignHCenter

                                    BusyIndicator {
                                        running: busySwitch.checked
                                        implicitWidth: Style.resize(80)
                                        implicitHeight: Style.resize(80)
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Label {
                                        text: "Large (80px)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Custom gradient arc spinner
                                ColumnLayout {
                                    spacing: Style.resize(10)
                                    Layout.alignment: Qt.AlignHCenter

                                    Rectangle {
                                        Layout.preferredWidth: Style.resize(90)
                                        Layout.preferredHeight: Style.resize(90)
                                        Layout.alignment: Qt.AlignHCenter
                                        radius: Style.resize(12)
                                        color: "#1B2838"

                                        Item {
                                            id: spinnerContainer
                                            anchors.centerIn: parent
                                            width: Style.resize(50)
                                            height: Style.resize(50)

                                            RotationAnimation on rotation {
                                                from: 0; to: 360
                                                duration: 1200
                                                loops: Animation.Infinite
                                                running: busySwitch.checked
                                            }

                                            Canvas {
                                                id: gradientSpinner
                                                anchors.fill: parent

                                                onPaint: {
                                                    var ctx = getContext("2d")
                                                    ctx.reset()

                                                    var cx = width / 2
                                                    var cy = height / 2
                                                    var r = cx - Style.resize(4)
                                                    var lw = Style.resize(3.5)
                                                    var steps = 40
                                                    var arcSpan = 1.6 * Math.PI // ~290°

                                                    for (var i = 0; i < steps; i++) {
                                                        var a0 = -Math.PI / 2 + (i / steps) * arcSpan
                                                        var a1 = -Math.PI / 2 + ((i + 1.5) / steps) * arcSpan
                                                        var alpha = i / steps

                                                        ctx.beginPath()
                                                        ctx.arc(cx, cy, r, a0, a1, false)
                                                        ctx.strokeStyle = Qt.rgba(0, 0.82, 0.66, alpha)
                                                        ctx.lineWidth = lw
                                                        ctx.lineCap = "round"
                                                        ctx.stroke()
                                                    }
                                                }

                                                Component.onCompleted: requestPaint()
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Custom (Canvas)"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: busySwitch.checked ? "Status: Loading..." : "Status: Idle"
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: busySwitch.checked ? Style.mainColor : Style.inactiveColor
                            }

                            Label {
                                text: "BusyIndicator shows that an operation is in progress"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 4: Interactive Demo - System Monitor
                    // ========================================
                    Rectangle {
                        id: monitorCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        property real cpuValue: 25

                        Timer {
                            running: root.fullSize
                            interval: 1500
                            repeat: true
                            onTriggered: {
                                monitorCard.cpuValue = Math.min(100, Math.max(0,
                                    monitorCard.cpuValue + (Math.random() * 30 - 15)));
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(12)

                            Label {
                                text: "Interactive Demo - System Monitor"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // CPU Dial + BusyIndicator
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(20)
                                Layout.alignment: Qt.AlignHCenter

                                ColumnLayout {
                                    spacing: Style.resize(5)
                                    Layout.alignment: Qt.AlignHCenter

                                    Dial {
                                        id: cpuDial
                                        Layout.preferredWidth: Style.resize(130)
                                        Layout.preferredHeight: Style.resize(130)
                                        Layout.alignment: Qt.AlignHCenter
                                        from: 0
                                        to: 100
                                        value: monitorCard.cpuValue
                                        enabled: false
                                        suffix: "%"
                                        progressColor: monitorCard.cpuValue > 80 ? "#FF5900" : Style.mainColor

                                        Behavior on value {
                                            NumberAnimation { duration: 500 }
                                        }
                                    }

                                    Label {
                                        text: "CPU Usage"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // High CPU warning
                                ColumnLayout {
                                    spacing: Style.resize(5)
                                    Layout.alignment: Qt.AlignHCenter

                                    BusyIndicator {
                                        running: monitorCard.cpuValue > 80
                                        opacity: monitorCard.cpuValue > 80 ? 1.0 : 0.2
                                        Layout.alignment: Qt.AlignHCenter

                                        Behavior on opacity {
                                            NumberAnimation { duration: 300 }
                                        }
                                    }

                                    Label {
                                        text: monitorCard.cpuValue > 80 ? "High Load!" : "Normal"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: monitorCard.cpuValue > 80
                                        color: monitorCard.cpuValue > 80 ? "#FF5900" : Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            // Memory ProgressBar
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(4)

                                Label {
                                    text: "Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontPrimaryColor
                                }

                                ProgressBar {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(8)
                                    value: memorySlider.value
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: memorySlider
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        from: 0
                                        to: 1
                                        value: 0.62
                                        stepSize: 0.01
                                    }
                                }
                            }

                            // Disk ProgressBar
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(4)

                                Label {
                                    text: "Disk: 78%"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontPrimaryColor
                                }

                                ProgressBar {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(8)
                                    value: 0.78
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: "CPU: " + monitorCard.cpuValue.toFixed(0) + "%"
                                      + "  |  Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                                      + "  |  Disk: 78%"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Indicators & Gauges
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(1800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Indicators & Gauges"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // ── Section 1: Speedometer Gauge ──────────────────
                        Label {
                            text: "Speedometer Gauge"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(30)
                            Layout.alignment: Qt.AlignHCenter

                            // Speedometer
                            Item {
                                id: speedoContainer
                                Layout.preferredWidth: Style.resize(260)
                                Layout.preferredHeight: Style.resize(260)

                                property real speed: speedControl.value
                                property real maxSpeed: 240

                                Canvas {
                                    id: speedoCanvas
                                    anchors.fill: parent

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.reset()

                                        var cx = width / 2
                                        var cy = height / 2
                                        var r = Math.min(cx, cy) - Style.resize(15)

                                        // Background arc (full sweep 240°)
                                        var startAngle = (150) * Math.PI / 180
                                        var endAngle = (390) * Math.PI / 180

                                        // Outer ring
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, startAngle, endAngle, false)
                                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.08)
                                        ctx.lineWidth = Style.resize(18)
                                        ctx.lineCap = "butt"
                                        ctx.stroke()

                                        // Speed arc with gradient color
                                        var speedFraction = speedoContainer.speed / speedoContainer.maxSpeed
                                        var speedAngle = startAngle + speedFraction * (endAngle - startAngle)

                                        // Color zones: green → yellow → red
                                        var segments = 60
                                        for (var i = 0; i < segments; i++) {
                                            var frac = i / segments
                                            var a0 = startAngle + frac * (speedAngle - startAngle)
                                            var a1 = startAngle + (frac + 1.5 / segments) * (speedAngle - startAngle)
                                            if (a1 > speedAngle) a1 = speedAngle
                                            if (a0 >= speedAngle) break

                                            var totalFrac = frac * speedFraction
                                            var r_c, g_c, b_c
                                            if (totalFrac < 0.5) {
                                                r_c = totalFrac * 2
                                                g_c = 0.82
                                                b_c = 0.66 * (1 - totalFrac)
                                            } else {
                                                r_c = 1.0
                                                g_c = 0.82 * (1 - (totalFrac - 0.5) * 2)
                                                b_c = 0
                                            }
                                            ctx.beginPath()
                                            ctx.arc(cx, cy, r, a0, a1, false)
                                            ctx.strokeStyle = Qt.rgba(r_c, g_c, b_c, 0.9)
                                            ctx.lineWidth = Style.resize(18)
                                            ctx.lineCap = "butt"
                                            ctx.stroke()
                                        }

                                        // Tick marks
                                        for (var t = 0; t <= 12; t++) {
                                            var tickAngle = startAngle + (t / 12) * (endAngle - startAngle)
                                            var isMajor = (t % 2 === 0)
                                            var tickInner = r - Style.resize(isMajor ? 28 : 22)
                                            var tickOuter = r - Style.resize(10)

                                            ctx.beginPath()
                                            ctx.moveTo(cx + tickOuter * Math.cos(tickAngle),
                                                       cy + tickOuter * Math.sin(tickAngle))
                                            ctx.lineTo(cx + tickInner * Math.cos(tickAngle),
                                                       cy + tickInner * Math.sin(tickAngle))
                                            ctx.strokeStyle = isMajor ? Style.fontPrimaryColor : Qt.rgba(1, 1, 1, 0.3)
                                            ctx.lineWidth = isMajor ? Style.resize(2) : Style.resize(1)
                                            ctx.stroke()

                                            // Labels for major ticks
                                            if (isMajor) {
                                                var labelR = r - Style.resize(40)
                                                var labelVal = Math.round(t / 12 * speedoContainer.maxSpeed)
                                                ctx.font = Style.resize(11) + "px sans-serif"
                                                ctx.fillStyle = Style.fontSecondaryColor
                                                ctx.textAlign = "center"
                                                ctx.textBaseline = "middle"
                                                ctx.fillText(labelVal,
                                                    cx + labelR * Math.cos(tickAngle),
                                                    cy + labelR * Math.sin(tickAngle))
                                            }
                                        }

                                        // Needle
                                        var needleAngle = startAngle + speedFraction * (endAngle - startAngle)
                                        var needleLen = r - Style.resize(30)
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy)
                                        ctx.lineTo(cx + needleLen * Math.cos(needleAngle),
                                                   cy + needleLen * Math.sin(needleAngle))
                                        ctx.strokeStyle = "#FF3B30"
                                        ctx.lineWidth = Style.resize(2.5)
                                        ctx.lineCap = "round"
                                        ctx.stroke()

                                        // Center hub
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, Style.resize(8), 0, 2 * Math.PI)
                                        ctx.fillStyle = "#FF3B30"
                                        ctx.fill()
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, Style.resize(4), 0, 2 * Math.PI)
                                        ctx.fillStyle = Style.cardColor
                                        ctx.fill()
                                    }

                                    Connections {
                                        target: speedoContainer
                                        function onSpeedChanged() { speedoCanvas.requestPaint() }
                                    }
                                    Component.onCompleted: requestPaint()
                                }

                                // Digital readout
                                Column {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: Style.resize(40)
                                    spacing: Style.resize(2)

                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Math.round(speedoContainer.speed).toString()
                                        font.pixelSize: Style.resize(36)
                                        font.bold: true
                                        color: Style.fontPrimaryColor
                                    }
                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "km/h"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }

                            // Speed slider control
                            ColumnLayout {
                                Layout.fillHeight: true
                                spacing: Style.resize(10)
                                Layout.alignment: Qt.AlignVCenter

                                Label {
                                    text: "Speed"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    id: speedControl
                                    Layout.preferredWidth: Style.resize(200)
                                    from: 0
                                    to: 240
                                    value: 85
                                    stepSize: 1
                                }

                                Label {
                                    text: Math.round(speedControl.value) + " km/h"
                                    font.pixelSize: Style.resize(14)
                                    font.bold: true
                                    color: speedControl.value > 180 ? "#FF3B30"
                                         : speedControl.value > 120 ? "#FFA500"
                                         : Style.mainColor
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 2: Circular Progress Rings ────────────
                        Label {
                            text: "Circular Progress Rings"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(25)
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: [
                                    { label: "Downloads", value: 0.73, clr: "#00D1A9", icon: "↓" },
                                    { label: "Storage", value: 0.58, clr: "#5B8DEF", icon: "◉" },
                                    { label: "Battery", value: 0.91, clr: "#34C759", icon: "⚡" },
                                    { label: "Upload", value: 0.35, clr: "#FF9500", icon: "↑" }
                                ]

                                delegate: ColumnLayout {
                                    id: ringDelegate
                                    spacing: Style.resize(8)

                                    required property var modelData
                                    required property int index

                                    property real animatedValue: 0
                                    NumberAnimation on animatedValue {
                                        from: 0; to: ringDelegate.modelData.value
                                        duration: 1200 + ringDelegate.index * 200
                                        easing.type: Easing.OutCubic
                                        running: root.fullSize
                                    }

                                    Item {
                                        Layout.preferredWidth: Style.resize(110)
                                        Layout.preferredHeight: Style.resize(110)
                                        Layout.alignment: Qt.AlignHCenter

                                        Canvas {
                                            id: ringCanvas
                                            anchors.fill: parent

                                            property real val: ringDelegate.animatedValue
                                            onValChanged: requestPaint()

                                            onPaint: {
                                                var ctx = getContext("2d")
                                                ctx.reset()
                                                var cx = width / 2, cy = height / 2
                                                var r = cx - Style.resize(10)
                                                var lw = Style.resize(8)

                                                // Background ring
                                                ctx.beginPath()
                                                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                                ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                                                ctx.lineWidth = lw
                                                ctx.stroke()

                                                // Progress ring
                                                var start = -Math.PI / 2
                                                var end = start + ringDelegate.animatedValue * 2 * Math.PI
                                                ctx.beginPath()
                                                ctx.arc(cx, cy, r, start, end, false)
                                                ctx.strokeStyle = ringDelegate.modelData.clr
                                                ctx.lineWidth = lw
                                                ctx.lineCap = "round"
                                                ctx.stroke()
                                            }

                                            Component.onCompleted: requestPaint()
                                        }

                                        // Center text
                                        Column {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(1)

                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: ringDelegate.modelData.icon
                                                font.pixelSize: Style.resize(18)
                                                color: ringDelegate.modelData.clr
                                            }
                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: Math.round(ringDelegate.animatedValue * 100) + "%"
                                                font.pixelSize: Style.resize(14)
                                                font.bold: true
                                                color: Style.fontPrimaryColor
                                            }
                                        }
                                    }

                                    Label {
                                        text: ringDelegate.modelData.label
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 3: Battery Indicator ──────────────────
                        Label {
                            text: "Battery Indicator"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(30)
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: [
                                    { level: 0.95, charging: true,  label: "Charging" },
                                    { level: 0.72, charging: false, label: "Good" },
                                    { level: 0.35, charging: false, label: "Medium" },
                                    { level: 0.12, charging: false, label: "Low" },
                                    { level: 0.05, charging: false, label: "Critical" }
                                ]

                                delegate: ColumnLayout {
                                    id: batteryDelegate
                                    spacing: Style.resize(8)

                                    required property var modelData
                                    required property int index

                                    readonly property color batteryColor:
                                        modelData.level > 0.5  ? "#34C759"
                                      : modelData.level > 0.2  ? "#FF9500"
                                      : "#FF3B30"

                                    Item {
                                        Layout.preferredWidth: Style.resize(52)
                                        Layout.preferredHeight: Style.resize(90)
                                        Layout.alignment: Qt.AlignHCenter

                                        // Battery tip
                                        Rectangle {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            width: Style.resize(18)
                                            height: Style.resize(6)
                                            radius: Style.resize(2)
                                            color: Qt.rgba(1, 1, 1, 0.2)
                                        }

                                        // Battery body
                                        Rectangle {
                                            id: batteryBody
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            anchors.topMargin: Style.resize(5)
                                            width: Style.resize(44)
                                            height: Style.resize(76)
                                            radius: Style.resize(6)
                                            color: "transparent"
                                            border.color: Qt.rgba(1, 1, 1, 0.2)
                                            border.width: Style.resize(2)

                                            // Fill level
                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.margins: Style.resize(4)
                                                width: parent.width - Style.resize(8)
                                                height: (parent.height - Style.resize(8)) * batteryDelegate.modelData.level
                                                radius: Style.resize(3)
                                                color: batteryDelegate.batteryColor

                                                Behavior on height {
                                                    NumberAnimation { duration: 600 }
                                                }

                                                // Pulse animation for low battery
                                                SequentialAnimation on opacity {
                                                    loops: Animation.Infinite
                                                    running: batteryDelegate.modelData.level <= 0.12
                                                    NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                                                    NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
                                                }
                                            }

                                            // Charging bolt
                                            Label {
                                                anchors.centerIn: parent
                                                text: "⚡"
                                                font.pixelSize: Style.resize(20)
                                                visible: batteryDelegate.modelData.charging
                                                opacity: chargingBoltAnim.running ? 1.0 : 0.0

                                                SequentialAnimation on opacity {
                                                    id: chargingBoltAnim
                                                    loops: Animation.Infinite
                                                    running: batteryDelegate.modelData.charging
                                                    NumberAnimation { from: 0.4; to: 1.0; duration: 800 }
                                                    NumberAnimation { from: 1.0; to: 0.4; duration: 800 }
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: Math.round(batteryDelegate.modelData.level * 100) + "%"
                                        font.pixelSize: Style.resize(14)
                                        font.bold: true
                                        color: batteryDelegate.batteryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Label {
                                        text: batteryDelegate.modelData.label
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 4: Signal Strength Bars ───────────────
                        Label {
                            text: "Signal Strength"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(40)
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: [
                                    { bars: 5, label: "Excellent", clr: "#34C759" },
                                    { bars: 4, label: "Good", clr: "#34C759" },
                                    { bars: 3, label: "Fair", clr: "#FF9500" },
                                    { bars: 2, label: "Weak", clr: "#FF9500" },
                                    { bars: 1, label: "Poor", clr: "#FF3B30" },
                                    { bars: 0, label: "None", clr: "#FF3B30" }
                                ]

                                delegate: ColumnLayout {
                                    id: signalDelegate
                                    spacing: Style.resize(8)

                                    required property var modelData
                                    required property int index

                                    Row {
                                        Layout.alignment: Qt.AlignHCenter
                                        spacing: Style.resize(3)

                                        Repeater {
                                            model: 5
                                            delegate: Rectangle {
                                                id: signalBar

                                                required property int index

                                                width: Style.resize(8)
                                                height: Style.resize(10 + index * 8)
                                                radius: Style.resize(2)
                                                anchors.bottom: parent.bottom
                                                color: signalBar.index < signalDelegate.modelData.bars
                                                       ? signalDelegate.modelData.clr
                                                       : Qt.rgba(1, 1, 1, 0.1)

                                                Behavior on color {
                                                    ColorAnimation { duration: 300 }
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: signalDelegate.modelData.label
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 5: Thermometer ────────────────────────
                        Label {
                            text: "Thermometer"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(30)
                            Layout.alignment: Qt.AlignHCenter

                            Item {
                                id: thermoContainer
                                Layout.preferredWidth: Style.resize(80)
                                Layout.preferredHeight: Style.resize(220)

                                property real temperature: thermoSlider.value
                                property real minTemp: -20
                                property real maxTemp: 50

                                readonly property color thermoColor:
                                    temperature > 35 ? "#FF3B30"
                                  : temperature > 20 ? "#FF9500"
                                  : temperature > 5  ? "#34C759"
                                  : "#5B8DEF"

                                // Thermometer body
                                Rectangle {
                                    id: thermoTube
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: Style.resize(10)
                                    width: Style.resize(24)
                                    height: Style.resize(150)
                                    radius: width / 2
                                    color: Qt.rgba(1, 1, 1, 0.06)
                                    border.color: Qt.rgba(1, 1, 1, 0.15)
                                    border.width: Style.resize(1)

                                    // Mercury fill
                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.margins: Style.resize(3)
                                        width: parent.width - Style.resize(6)
                                        height: Math.max(Style.resize(6),
                                            (parent.height - Style.resize(6))
                                            * ((thermoContainer.temperature - thermoContainer.minTemp)
                                               / (thermoContainer.maxTemp - thermoContainer.minTemp)))
                                        radius: width / 2
                                        color: thermoContainer.thermoColor

                                        Behavior on height {
                                            NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
                                        }
                                        Behavior on color {
                                            ColorAnimation { duration: 400 }
                                        }
                                    }

                                    // Tick marks
                                    Repeater {
                                        model: 8 // -20, -10, 0, 10, 20, 30, 40, 50
                                        delegate: Item {
                                            id: thermoTick
                                            required property int index

                                            readonly property real tickTemp: -20 + thermoTick.index * 10
                                            readonly property real fraction:
                                                (tickTemp - thermoContainer.minTemp)
                                                / (thermoContainer.maxTemp - thermoContainer.minTemp)

                                            y: thermoTube.height - Style.resize(3)
                                               - fraction * (thermoTube.height - Style.resize(6))
                                               - Style.resize(1)

                                            Rectangle {
                                                x: thermoTube.width + Style.resize(3)
                                                width: Style.resize(8)
                                                height: Style.resize(1)
                                                color: Qt.rgba(1, 1, 1, 0.3)
                                            }

                                            Label {
                                                x: thermoTube.width + Style.resize(14)
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: thermoTick.tickTemp + "°"
                                                font.pixelSize: Style.resize(9)
                                                color: Style.fontSecondaryColor
                                            }
                                        }
                                    }
                                }

                                // Bulb at bottom
                                Rectangle {
                                    anchors.horizontalCenter: thermoTube.horizontalCenter
                                    anchors.top: thermoTube.bottom
                                    anchors.topMargin: Style.resize(-10)
                                    width: Style.resize(36)
                                    height: Style.resize(36)
                                    radius: width / 2
                                    color: thermoContainer.thermoColor

                                    Behavior on color {
                                        ColorAnimation { duration: 400 }
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: Math.round(thermoContainer.temperature) + "°"
                                        font.pixelSize: Style.resize(10)
                                        font.bold: true
                                        color: "#FFFFFF"
                                    }
                                }
                            }

                            // Temperature control
                            ColumnLayout {
                                Layout.alignment: Qt.AlignVCenter
                                spacing: Style.resize(10)

                                Label {
                                    text: "Temperature"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    id: thermoSlider
                                    Layout.preferredWidth: Style.resize(200)
                                    from: -20
                                    to: 50
                                    value: 22
                                    stepSize: 1
                                }

                                Label {
                                    text: Math.round(thermoSlider.value) + " °C"
                                    font.pixelSize: Style.resize(18)
                                    font.bold: true
                                    color: thermoContainer.thermoColor
                                }

                                Label {
                                    text: thermoSlider.value > 35 ? "🔥 Hot"
                                        : thermoSlider.value > 20 ? "☀ Warm"
                                        : thermoSlider.value > 5  ? "🌤 Cool"
                                        : "❄ Cold"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 6: Animated Level Meter (VU Meter) ────
                        Label {
                            text: "VU Level Meter"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: vuMeterItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(100)

                            property var levels: [0.6, 0.8, 0.5, 0.9, 0.3, 0.7, 0.65, 0.85,
                                                  0.4, 0.75, 0.55, 0.7, 0.6, 0.45, 0.8, 0.5,
                                                  0.9, 0.35, 0.65, 0.7]

                            Timer {
                                id: vuTimer
                                running: root.fullSize
                                interval: 100
                                repeat: true
                                onTriggered: {
                                    var newLevels = []
                                    for (var i = 0; i < vuRepeater.count; i++) {
                                        var prev = vuMeterItem.levels[i] || 0.5
                                        var next = Math.max(0.05, Math.min(1.0,
                                            prev + (Math.random() - 0.48) * 0.3))
                                        newLevels.push(next)
                                    }
                                    vuMeterItem.levels = newLevels
                                }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: Style.resize(4)

                                Repeater {
                                    id: vuRepeater
                                    model: 20

                                    delegate: Item {
                                        id: vuBar
                                        required property int index

                                        width: Style.resize(16)
                                        height: Style.resize(80)

                                        property real level: vuMeterItem.levels[vuBar.index] || 0.5

                                        Column {
                                            anchors.bottom: parent.bottom
                                            width: parent.width
                                            spacing: Style.resize(2)

                                            Repeater {
                                                model: 10

                                                delegate: Rectangle {
                                                    id: vuSegment
                                                    required property int index

                                                    readonly property int segIndex: 9 - vuSegment.index
                                                    readonly property bool active:
                                                        segIndex < Math.round(vuBar.level * 10)

                                                    width: vuBar.width
                                                    height: Style.resize(5)
                                                    radius: Style.resize(1)
                                                    color: !active ? Qt.rgba(1, 1, 1, 0.06)
                                                         : segIndex >= 8 ? "#FF3B30"
                                                         : segIndex >= 6 ? "#FF9500"
                                                         : "#34C759"

                                                    opacity: active ? 1.0 : 0.4

                                                    Behavior on color {
                                                        ColorAnimation { duration: 80 }
                                                    }
                                                    Behavior on opacity {
                                                        NumberAnimation { duration: 80 }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 7: Radial Gauge (RPM Tachometer) ──────
                        Label {
                            text: "RPM Tachometer"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(30)
                            Layout.alignment: Qt.AlignHCenter

                            Item {
                                id: rpmContainer
                                Layout.preferredWidth: Style.resize(240)
                                Layout.preferredHeight: Style.resize(240)

                                property real rpm: rpmSlider.value
                                property real maxRpm: 8000

                                Canvas {
                                    id: rpmCanvas
                                    anchors.fill: parent

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.reset()

                                        var cx = width / 2, cy = height / 2
                                        var r = Math.min(cx, cy) - Style.resize(10)

                                        var startAngle = (135) * Math.PI / 180
                                        var endAngle = (405) * Math.PI / 180
                                        var totalSweep = endAngle - startAngle

                                        // Background arc
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, startAngle, endAngle, false)
                                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                                        ctx.lineWidth = Style.resize(14)
                                        ctx.lineCap = "butt"
                                        ctx.stroke()

                                        // Red zone (6000-8000)
                                        var redStart = startAngle + (6000 / rpmContainer.maxRpm) * totalSweep
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, redStart, endAngle, false)
                                        ctx.strokeStyle = Qt.rgba(1, 0.23, 0.19, 0.3)
                                        ctx.lineWidth = Style.resize(14)
                                        ctx.stroke()

                                        // Active arc
                                        var rpmFrac = rpmContainer.rpm / rpmContainer.maxRpm
                                        var rpmAngle = startAngle + rpmFrac * totalSweep
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, startAngle, rpmAngle, false)
                                        ctx.strokeStyle = rpmContainer.rpm > 6000 ? "#FF3B30" : "#5B8DEF"
                                        ctx.lineWidth = Style.resize(14)
                                        ctx.lineCap = "butt"
                                        ctx.stroke()

                                        // Tick marks (0-8 for x1000)
                                        for (var t = 0; t <= 8; t++) {
                                            var tickAngle = startAngle + (t / 8) * totalSweep
                                            var innerR = r - Style.resize(20)
                                            var outerR = r - Style.resize(8)

                                            ctx.beginPath()
                                            ctx.moveTo(cx + outerR * Math.cos(tickAngle),
                                                       cy + outerR * Math.sin(tickAngle))
                                            ctx.lineTo(cx + innerR * Math.cos(tickAngle),
                                                       cy + innerR * Math.sin(tickAngle))
                                            ctx.strokeStyle = t >= 6 ? "#FF3B30" : Style.fontPrimaryColor
                                            ctx.lineWidth = Style.resize(2)
                                            ctx.stroke()

                                            // Labels
                                            var labelR = r - Style.resize(32)
                                            ctx.font = "bold " + Style.resize(11) + "px sans-serif"
                                            ctx.fillStyle = t >= 6 ? "#FF3B30" : Style.fontSecondaryColor
                                            ctx.textAlign = "center"
                                            ctx.textBaseline = "middle"
                                            ctx.fillText(t,
                                                cx + labelR * Math.cos(tickAngle),
                                                cy + labelR * Math.sin(tickAngle))
                                        }

                                        // Needle
                                        var needleAngle = startAngle + rpmFrac * totalSweep
                                        var needleLen = r - Style.resize(26)
                                        ctx.beginPath()
                                        ctx.moveTo(cx - Style.resize(6) * Math.cos(needleAngle + Math.PI / 2),
                                                   cy - Style.resize(6) * Math.sin(needleAngle + Math.PI / 2))
                                        ctx.lineTo(cx + needleLen * Math.cos(needleAngle),
                                                   cy + needleLen * Math.sin(needleAngle))
                                        ctx.lineTo(cx + Style.resize(6) * Math.cos(needleAngle + Math.PI / 2),
                                                   cy + Style.resize(6) * Math.sin(needleAngle + Math.PI / 2))
                                        ctx.closePath()
                                        ctx.fillStyle = "#FF3B30"
                                        ctx.fill()

                                        // Center cap
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, Style.resize(10), 0, 2 * Math.PI)
                                        ctx.fillStyle = "#444"
                                        ctx.fill()
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, Style.resize(5), 0, 2 * Math.PI)
                                        ctx.fillStyle = "#222"
                                        ctx.fill()
                                    }

                                    Connections {
                                        target: rpmContainer
                                        function onRpmChanged() { rpmCanvas.requestPaint() }
                                    }
                                    Component.onCompleted: requestPaint()
                                }

                                // Digital readout
                                Column {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: Style.resize(50)
                                    spacing: Style.resize(2)

                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Math.round(rpmContainer.rpm).toString()
                                        font.pixelSize: Style.resize(28)
                                        font.bold: true
                                        color: rpmContainer.rpm > 6000 ? "#FF3B30" : Style.fontPrimaryColor
                                    }
                                    Label {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "× 1000 RPM"
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }

                            // RPM control
                            ColumnLayout {
                                Layout.alignment: Qt.AlignVCenter
                                spacing: Style.resize(10)

                                Label {
                                    text: "RPM"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    id: rpmSlider
                                    Layout.preferredWidth: Style.resize(200)
                                    from: 0
                                    to: 8000
                                    value: 3200
                                    stepSize: 100
                                }

                                Label {
                                    text: Math.round(rpmSlider.value) + " RPM"
                                    font.pixelSize: Style.resize(14)
                                    font.bold: true
                                    color: rpmSlider.value > 6000 ? "#FF3B30" : "#5B8DEF"
                                }

                                // Gear indicator
                                RowLayout {
                                    spacing: Style.resize(5)

                                    Repeater {
                                        model: ["N", "1", "2", "3", "4", "5", "6"]
                                        delegate: Rectangle {
                                            id: gearRect
                                            required property string modelData
                                            required property int index

                                            readonly property int gear: {
                                                var r = rpmSlider.value
                                                if (r < 200)  return 0  // N
                                                if (r < 1500) return 1
                                                if (r < 2800) return 2
                                                if (r < 4200) return 3
                                                if (r < 5500) return 4
                                                if (r < 6800) return 5
                                                return 6
                                            }
                                            readonly property bool active: gearRect.index === gear

                                            width: Style.resize(28)
                                            height: Style.resize(28)
                                            radius: Style.resize(4)
                                            color: active ? Style.mainColor : Qt.rgba(1, 1, 1, 0.06)

                                            Behavior on color {
                                                ColorAnimation { duration: 200 }
                                            }

                                            Label {
                                                anchors.centerIn: parent
                                                text: gearRect.modelData
                                                font.pixelSize: Style.resize(12)
                                                font.bold: active
                                                color: active ? "#000" : Style.fontSecondaryColor
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(1)
                            color: Style.bgColor
                        }

                        // ── Section 8: Step Progress Indicator ────────────
                        Label {
                            text: "Step Progress"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: stepProgressItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(80)

                            property int currentStep: 2
                            property var stepLabels: ["Order", "Payment", "Processing", "Shipping", "Delivered"]

                            Row {
                                anchors.centerIn: parent
                                spacing: 0

                                Repeater {
                                    model: 5
                                    delegate: Row {
                                        id: stepDelegate
                                        required property int index

                                        readonly property bool completed:
                                            stepDelegate.index < stepProgressItem.currentStep
                                        readonly property bool active:
                                            stepDelegate.index === stepProgressItem.currentStep

                                        // Step circle
                                        Column {
                                            spacing: Style.resize(6)

                                            Rectangle {
                                                id: stepCircle
                                                width: Style.resize(36)
                                                height: Style.resize(36)
                                                radius: width / 2
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                color: stepDelegate.completed ? Style.mainColor
                                                     : stepDelegate.active ? Style.mainColor
                                                     : Qt.rgba(1, 1, 1, 0.1)
                                                border.color: stepDelegate.active ? Style.mainColor : "transparent"
                                                border.width: stepDelegate.active ? Style.resize(2) : 0

                                                Behavior on color {
                                                    ColorAnimation { duration: 300 }
                                                }

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: stepDelegate.completed ? "✓" : (stepDelegate.index + 1)
                                                    font.pixelSize: Style.resize(14)
                                                    font.bold: true
                                                    color: stepDelegate.completed || stepDelegate.active
                                                           ? "#000" : Style.fontSecondaryColor
                                                }

                                                // Pulse animation for active step
                                                Rectangle {
                                                    anchors.fill: parent
                                                    radius: parent.radius
                                                    color: "transparent"
                                                    border.color: Style.mainColor
                                                    border.width: Style.resize(2)
                                                    visible: stepDelegate.active

                                                    SequentialAnimation on scale {
                                                        loops: Animation.Infinite
                                                        running: stepDelegate.active
                                                        NumberAnimation { from: 1.0; to: 1.4; duration: 800 }
                                                        NumberAnimation { from: 1.4; to: 1.0; duration: 800 }
                                                    }
                                                    SequentialAnimation on opacity {
                                                        loops: Animation.Infinite
                                                        running: stepDelegate.active
                                                        NumberAnimation { from: 0.6; to: 0.0; duration: 800 }
                                                        NumberAnimation { from: 0.0; to: 0.6; duration: 800 }
                                                    }
                                                }
                                            }

                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: stepProgressItem.stepLabels[stepDelegate.index]
                                                font.pixelSize: Style.resize(10)
                                                color: stepDelegate.completed || stepDelegate.active
                                                       ? Style.fontPrimaryColor : Style.fontSecondaryColor
                                                font.bold: stepDelegate.active
                                            }
                                        }

                                        // Connector line (not after last step)
                                        Rectangle {
                                            visible: stepDelegate.index < 4
                                            y: Style.resize(18) - height / 2
                                            width: Style.resize(50)
                                            height: Style.resize(3)
                                            radius: Style.resize(1)
                                            color: stepDelegate.completed ? Style.mainColor
                                                 : Qt.rgba(1, 1, 1, 0.1)

                                            Behavior on color {
                                                ColorAnimation { duration: 300 }
                                            }
                                        }
                                    }
                                }
                            }

                            // Navigation buttons
                            RowLayout {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: Style.resize(15)

                                Button {
                                    text: "← Back"
                                    flat: true
                                    enabled: stepProgressItem.currentStep > 0
                                    onClicked: stepProgressItem.currentStep--
                                }

                                Button {
                                    text: "Next →"
                                    flat: true
                                    enabled: stepProgressItem.currentStep < 4
                                    onClicked: stepProgressItem.currentStep++
                                }

                                Button {
                                    text: "Reset"
                                    flat: true
                                    onClicked: stepProgressItem.currentStep = 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
