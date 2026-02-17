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
                    text: "Animations Examples"
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
                    // Card 1: Easing Curves
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
                            spacing: Style.resize(10)

                            Label {
                                text: "Easing Curves"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Button {
                                text: "Play"
                                onClicked: {
                                    easingAnim1.restart()
                                    easingAnim2.restart()
                                    easingAnim3.restart()
                                    easingAnim4.restart()
                                }
                            }

                            // Easing bars container
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: Style.resize(8)

                                    // Bar 1: Linear
                                    ColumnLayout {
                                        spacing: Style.resize(2)
                                        Layout.fillWidth: true

                                        Label {
                                            text: "Linear"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: Style.resize(24)

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height
                                                radius: height / 2
                                                color: Style.bgColor
                                            }

                                            Rectangle {
                                                id: bar1
                                                x: 0
                                                width: Style.resize(24)
                                                height: parent.height
                                                radius: height / 2
                                                color: "#4A90D9"

                                                PropertyAnimation {
                                                    id: easingAnim1
                                                    target: bar1
                                                    property: "x"
                                                    from: 0
                                                    to: bar1.parent.width - bar1.width
                                                    duration: 1500
                                                    easing.type: Easing.Linear
                                                }
                                            }
                                        }
                                    }

                                    // Bar 2: InOutQuad
                                    ColumnLayout {
                                        spacing: Style.resize(2)
                                        Layout.fillWidth: true

                                        Label {
                                            text: "InOutQuad"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: Style.resize(24)

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height
                                                radius: height / 2
                                                color: Style.bgColor
                                            }

                                            Rectangle {
                                                id: bar2
                                                x: 0
                                                width: Style.resize(24)
                                                height: parent.height
                                                radius: height / 2
                                                color: Style.mainColor

                                                PropertyAnimation {
                                                    id: easingAnim2
                                                    target: bar2
                                                    property: "x"
                                                    from: 0
                                                    to: bar2.parent.width - bar2.width
                                                    duration: 1500
                                                    easing.type: Easing.InOutQuad
                                                }
                                            }
                                        }
                                    }

                                    // Bar 3: OutBounce
                                    ColumnLayout {
                                        spacing: Style.resize(2)
                                        Layout.fillWidth: true

                                        Label {
                                            text: "OutBounce"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: Style.resize(24)

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height
                                                radius: height / 2
                                                color: Style.bgColor
                                            }

                                            Rectangle {
                                                id: bar3
                                                x: 0
                                                width: Style.resize(24)
                                                height: parent.height
                                                radius: height / 2
                                                color: "#FEA601"

                                                PropertyAnimation {
                                                    id: easingAnim3
                                                    target: bar3
                                                    property: "x"
                                                    from: 0
                                                    to: bar3.parent.width - bar3.width
                                                    duration: 1500
                                                    easing.type: Easing.OutBounce
                                                }
                                            }
                                        }
                                    }

                                    // Bar 4: InElastic
                                    ColumnLayout {
                                        spacing: Style.resize(2)
                                        Layout.fillWidth: true

                                        Label {
                                            text: "InElastic"
                                            font.pixelSize: Style.resize(11)
                                            color: Style.fontSecondaryColor
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: Style.resize(24)

                                            Rectangle {
                                                width: parent.width
                                                height: parent.height
                                                radius: height / 2
                                                color: Style.bgColor
                                            }

                                            Rectangle {
                                                id: bar4
                                                x: 0
                                                width: Style.resize(24)
                                                height: parent.height
                                                radius: height / 2
                                                color: "#FF5900"

                                                PropertyAnimation {
                                                    id: easingAnim4
                                                    target: bar4
                                                    property: "x"
                                                    from: 0
                                                    to: bar4.parent.width - bar4.width
                                                    duration: 1500
                                                    easing.type: Easing.InElastic
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "Compare how different easing curves affect animation feel"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: Sequential & Parallel
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
                            spacing: Style.resize(10)

                            Label {
                                text: "Sequential & Parallel"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Button {
                                text: "Play"
                                onClicked: {
                                    // Reset positions
                                    seqRect.x = 0
                                    seqRect.scale = 1.0
                                    seqRect.color = "#4A90D9"
                                    parRect.x = 0
                                    parRect.scale = 1.0
                                    parRect.color = "#4A90D9"
                                    seqAnim.restart()
                                    parAnim.restart()
                                }
                            }

                            // Animation area
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // Sequential column
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: Style.resize(5)

                                    Label {
                                        text: "Sequential"
                                        font.pixelSize: Style.resize(13)
                                        font.bold: true
                                        color: Style.fontPrimaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.bgColor
                                            radius: Style.resize(4)
                                        }

                                        Rectangle {
                                            id: seqRect
                                            x: 0
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: Style.resize(40)
                                            height: Style.resize(40)
                                            radius: Style.resize(6)
                                            color: "#4A90D9"

                                            SequentialAnimation {
                                                id: seqAnim

                                                // Step 1: Move right
                                                NumberAnimation {
                                                    target: seqRect
                                                    property: "x"
                                                    to: seqRect.parent.width - seqRect.width
                                                    duration: 600
                                                    easing.type: Easing.InOutQuad
                                                }

                                                // Step 2: Change color
                                                ColorAnimation {
                                                    target: seqRect
                                                    property: "color"
                                                    to: Style.mainColor
                                                    duration: 400
                                                }

                                                // Step 3: Scale up
                                                NumberAnimation {
                                                    target: seqRect
                                                    property: "scale"
                                                    to: 1.5
                                                    duration: 400
                                                    easing.type: Easing.OutBack
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Move → Color → Scale"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Parallel column
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: Style.resize(5)

                                    Label {
                                        text: "Parallel"
                                        font.pixelSize: Style.resize(13)
                                        font.bold: true
                                        color: Style.fontPrimaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.bgColor
                                            radius: Style.resize(4)
                                        }

                                        Rectangle {
                                            id: parRect
                                            x: 0
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: Style.resize(40)
                                            height: Style.resize(40)
                                            radius: Style.resize(6)
                                            color: "#4A90D9"

                                            ParallelAnimation {
                                                id: parAnim

                                                NumberAnimation {
                                                    target: parRect
                                                    property: "x"
                                                    to: parRect.parent.width - parRect.width
                                                    duration: 800
                                                    easing.type: Easing.InOutQuad
                                                }

                                                ColorAnimation {
                                                    target: parRect
                                                    property: "color"
                                                    to: Style.mainColor
                                                    duration: 800
                                                }

                                                NumberAnimation {
                                                    target: parRect
                                                    property: "scale"
                                                    to: 1.5
                                                    duration: 800
                                                    easing.type: Easing.OutBack
                                                }
                                            }
                                        }
                                    }

                                    Label {
                                        text: "Move + Color + Scale"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: "Sequential runs animations one after another. Parallel runs them simultaneously"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Behavior & Spring
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
                            spacing: Style.resize(10)

                            Label {
                                text: "Behavior & Spring"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Spring controls
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Spring: " + springSlider.value.toFixed(1)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: springSlider
                                        anchors.fill: parent
                                        from: 0.5
                                        to: 5.0
                                        value: 2.0
                                        stepSize: 0.1
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Damping: " + dampingSlider.value.toFixed(2)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: dampingSlider
                                        anchors.fill: parent
                                        from: 0.02
                                        to: 0.4
                                        value: 0.1
                                        stepSize: 0.01
                                    }
                                }
                            }

                            // Bounce area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    id: springArea
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(8)
                                    border.color: Style.inactiveColor
                                    border.width: 1

                                    Label {
                                        anchors.centerIn: parent
                                        text: "Click anywhere"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.inactiveColor
                                        opacity: 0.5
                                    }

                                    Rectangle {
                                        id: springBall
                                        x: springArea.width / 2 - width / 2
                                        y: springArea.height / 2 - height / 2
                                        width: Style.resize(30)
                                        height: Style.resize(30)
                                        radius: width / 2
                                        color: Style.mainColor

                                        Behavior on x {
                                            SpringAnimation {
                                                spring: springSlider.value
                                                damping: dampingSlider.value
                                            }
                                        }

                                        Behavior on y {
                                            SpringAnimation {
                                                spring: springSlider.value
                                                damping: dampingSlider.value
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: function(mouse) {
                                            springBall.x = mouse.x - springBall.width / 2
                                            springBall.y = mouse.y - springBall.height / 2
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "Click to move. Adjust spring (stiffness) and damping (settling speed)"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: States & Transitions
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
                                text: "States & Transitions"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                text: "Current: " + morphRect.state
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            // Morph area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(8)
                                }

                                Rectangle {
                                    id: morphRect
                                    anchors.centerIn: parent
                                    width: Style.resize(100)
                                    height: Style.resize(100)
                                    radius: 0
                                    color: "#4A90D9"
                                    state: "square"

                                    states: [
                                        State {
                                            name: "square"
                                            PropertyChanges {
                                                target: morphRect
                                                width: Style.resize(100)
                                                height: Style.resize(100)
                                                radius: 0
                                                color: "#4A90D9"
                                            }
                                        },
                                        State {
                                            name: "circle"
                                            PropertyChanges {
                                                target: morphRect
                                                width: Style.resize(100)
                                                height: Style.resize(100)
                                                radius: Style.resize(50)
                                                color: "#00D1A9"
                                            }
                                        },
                                        State {
                                            name: "wide"
                                            PropertyChanges {
                                                target: morphRect
                                                width: Style.resize(200)
                                                height: Style.resize(80)
                                                radius: Style.resize(10)
                                                color: "#FEA601"
                                            }
                                        }
                                    ]

                                    transitions: [
                                        Transition {
                                            NumberAnimation {
                                                properties: "width,height,radius"
                                                duration: 500
                                                easing.type: Easing.OutBounce
                                            }
                                            ColorAnimation {
                                                duration: 500
                                            }
                                        }
                                    ]
                                }
                            }

                            // State buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)
                                Layout.alignment: Qt.AlignHCenter

                                Button {
                                    text: "Square"
                                    onClicked: morphRect.state = "square"
                                    highlighted: morphRect.state === "square"
                                }

                                Button {
                                    text: "Circle"
                                    onClicked: morphRect.state = "circle"
                                    highlighted: morphRect.state === "circle"
                                }

                                Button {
                                    text: "Wide"
                                    onClicked: morphRect.state = "wide"
                                    highlighted: morphRect.state === "wide"
                                }
                            }

                            Label {
                                text: "States define property sets. Transitions animate between them automatically"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Complex Animations
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Label {
                                text: "Custom Complex Animations"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                                Layout.fillWidth: true
                            }

                            Button {
                                text: "▶ Start All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = true
                                    orbitSection.sectionActive = true
                                    waveSection.sectionActive = true
                                    lissajousSection.sectionActive = true
                                    cradleSection.sectionActive = true
                                    breathSection.sectionActive = true
                                    matrixSection.sectionActive = true
                                }
                            }

                            Button {
                                text: "■ Stop All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = false
                                    orbitSection.sectionActive = false
                                    waveSection.sectionActive = false
                                    lissajousSection.sectionActive = false
                                    cradleSection.sectionActive = false
                                    breathSection.sectionActive = false
                                    matrixSection.sectionActive = false
                                }
                            }
                        }

                        // ── Section 1: Particle Fountain ──────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Particle Fountain"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: particleSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: particleSection.sectionActive = !particleSection.sectionActive
                            }
                        }

                        Item {
                            id: particleSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(280)

                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property var particles: []
                            property real gravity: gravitySlider.value
                            property real wind: windSlider.value
                            property int maxParticles: 120

                            Canvas {
                                id: particleCanvas
                                anchors.fill: parent

                                Rectangle {
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(8)
                                    z: -1
                                }

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.reset()

                                    var ps = particleSection.particles
                                    for (var i = 0; i < ps.length; i++) {
                                        var p = ps[i]
                                        var life = p.life / p.maxLife
                                        var alpha = life > 0.7 ? (1 - life) / 0.3
                                                  : life < 0.3 ? life / 0.3
                                                  : 1.0
                                        var size = p.size * (0.5 + 0.5 * life)
                                        ctx.beginPath()
                                        ctx.arc(p.x, p.y, size, 0, 2 * Math.PI)
                                        ctx.fillStyle = Qt.rgba(p.r, p.g, p.b, alpha * 0.85)
                                        ctx.fill()
                                    }
                                }
                            }

                            Timer {
                                running: particleSection.running
                                interval: 25
                                repeat: true
                                onTriggered: {
                                    var ps = particleSection.particles
                                    var w = particleCanvas.width
                                    var h = particleCanvas.height
                                    var grav = particleSection.gravity
                                    var wnd = particleSection.wind

                                    // Spawn new particles
                                    for (var s = 0; s < 3; s++) {
                                        if (ps.length < particleSection.maxParticles) {
                                            var angle = -Math.PI / 2 + (Math.random() - 0.5) * 0.8
                                            var speed = 3 + Math.random() * 4
                                            var hue = Math.random()
                                            var r, g, b
                                            if (hue < 0.33) {
                                                r = 0; g = 0.82; b = 0.66
                                            } else if (hue < 0.66) {
                                                r = 0.35; g = 0.55; b = 0.94
                                            } else {
                                                r = 1.0; g = 0.58; b = 0
                                            }
                                            ps.push({
                                                x: w / 2, y: h - 10,
                                                vx: Math.cos(angle) * speed,
                                                vy: Math.sin(angle) * speed,
                                                life: 1.0, maxLife: 1.0,
                                                size: 2 + Math.random() * 4,
                                                r: r, g: g, b: b
                                            })
                                        }
                                    }

                                    // Update particles
                                    var alive = []
                                    for (var i = 0; i < ps.length; i++) {
                                        var p = ps[i]
                                        p.vy += grav * 0.025
                                        p.vx += wnd * 0.01
                                        p.x += p.vx
                                        p.y += p.vy
                                        p.life -= 0.012
                                        if (p.life > 0 && p.x > -10 && p.x < w + 10
                                            && p.y > -10 && p.y < h + 10)
                                            alive.push(p)
                                    }
                                    particleSection.particles = alive
                                    particleCanvas.requestPaint()
                                }
                            }

                            // Controls overlay
                            Row {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(15)

                                Column {
                                    spacing: Style.resize(2)
                                    Label {
                                        text: "Gravity: " + gravitySlider.value.toFixed(1)
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                    Slider {
                                        id: gravitySlider
                                        width: Style.resize(120)
                                        from: -2; to: 5; value: 2.0; stepSize: 0.1
                                    }
                                }

                                Column {
                                    spacing: Style.resize(2)
                                    Label {
                                        text: "Wind: " + windSlider.value.toFixed(1)
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                    Slider {
                                        id: windSlider
                                        width: Style.resize(120)
                                        from: -3; to: 3; value: 0; stepSize: 0.1
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 2: Orbital Motion ─────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Orbital System"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: orbitSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: orbitSection.sectionActive = !orbitSection.sectionActive
                            }
                        }

                        Item {
                            id: orbitSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(300)

                            property real time: 0
                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property real speedMul: orbitSpeedSlider.value

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: orbitSection.running
                                interval: 30
                                repeat: true
                                onTriggered: {
                                    orbitSection.time += 0.03 * orbitSection.speedMul
                                }
                            }

                            Canvas {
                                id: orbitCanvas
                                anchors.fill: parent

                                property real t: orbitSection.time
                                onTChanged: requestPaint()

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.reset()

                                    var cx = width / 2
                                    var cy = height / 2
                                    var t = orbitSection.time

                                    var orbits = [
                                        { r: 40,  speed: 2.0,  size: 6,  color: "#5B8DEF", trail: 20 },
                                        { r: 70,  speed: 1.3,  size: 8,  color: "#00D1A9", trail: 25 },
                                        { r: 105, speed: 0.8,  size: 10, color: "#FF9500", trail: 30 },
                                        { r: 135, speed: 0.5,  size: 7,  color: "#FF3B30", trail: 22 }
                                    ]

                                    // Draw orbit paths
                                    for (var o = 0; o < orbits.length; o++) {
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, orbits[o].r, 0, 2 * Math.PI)
                                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                                        ctx.lineWidth = 1
                                        ctx.stroke()
                                    }

                                    // Draw trails and planets
                                    for (var j = 0; j < orbits.length; j++) {
                                        var orb = orbits[j]
                                        var trailLen = orb.trail

                                        // Trail
                                        for (var k = trailLen; k >= 0; k--) {
                                            var tt = t * orb.speed - k * 0.04
                                            var tx = cx + orb.r * Math.cos(tt)
                                            var ty = cy + orb.r * Math.sin(tt)
                                            var alpha = (1 - k / trailLen) * 0.4
                                            var sz = orb.size * (1 - k / trailLen) * 0.6
                                            ctx.beginPath()
                                            ctx.arc(tx, ty, sz, 0, 2 * Math.PI)
                                            ctx.fillStyle = Qt.hsla(0, 0, 1, alpha * 0.3)
                                            ctx.fill()
                                        }

                                        // Planet
                                        var px = cx + orb.r * Math.cos(t * orb.speed)
                                        var py = cy + orb.r * Math.sin(t * orb.speed)
                                        ctx.beginPath()
                                        ctx.arc(px, py, orb.size, 0, 2 * Math.PI)
                                        ctx.fillStyle = orb.color
                                        ctx.fill()

                                        // Glow
                                        var grad = ctx.createRadialGradient(px, py, 0, px, py, orb.size * 2.5)
                                        grad.addColorStop(0, Qt.rgba(
                                            Qt.color(orb.color).r,
                                            Qt.color(orb.color).g,
                                            Qt.color(orb.color).b, 0.3))
                                        grad.addColorStop(1, "transparent")
                                        ctx.beginPath()
                                        ctx.arc(px, py, orb.size * 2.5, 0, 2 * Math.PI)
                                        ctx.fillStyle = grad
                                        ctx.fill()
                                    }

                                    // Sun
                                    var sunGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, 18)
                                    sunGrad.addColorStop(0, "#FFF4D4")
                                    sunGrad.addColorStop(0.6, "#FEA601")
                                    sunGrad.addColorStop(1, Qt.rgba(1, 0.65, 0, 0))
                                    ctx.beginPath()
                                    ctx.arc(cx, cy, 18, 0, 2 * Math.PI)
                                    ctx.fillStyle = sunGrad
                                    ctx.fill()

                                    // Sun core
                                    ctx.beginPath()
                                    ctx.arc(cx, cy, 8, 0, 2 * Math.PI)
                                    ctx.fillStyle = "#FFFFFF"
                                    ctx.fill()
                                }
                            }

                            // Speed control
                            Row {
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(8)

                                Label {
                                    text: "Speed"
                                    font.pixelSize: Style.resize(10)
                                    color: Style.fontSecondaryColor
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Slider {
                                    id: orbitSpeedSlider
                                    width: Style.resize(120)
                                    from: 0.1; to: 5; value: 1; stepSize: 0.1
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 3: Wave Bars ──────────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Sine Wave Bars"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: waveSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: waveSection.sectionActive = !waveSection.sectionActive
                            }
                        }

                        Item {
                            id: waveSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(160)

                            property real time: 0
                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property real freq: waveFreqSlider.value
                            property real amp: waveAmpSlider.value

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: waveSection.running
                                interval: 30
                                repeat: true
                                onTriggered: waveSection.time += 0.06
                            }

                            Row {
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: Style.resize(-10)
                                spacing: Style.resize(3)

                                Repeater {
                                    model: 32
                                    delegate: Rectangle {
                                        id: waveBar
                                        required property int index

                                        readonly property real phase: waveBar.index * waveSection.freq * 0.3
                                        readonly property real wave:
                                            Math.sin(waveSection.time * 3 + phase) * waveSection.amp

                                        width: Style.resize(10)
                                        height: Style.resize(20) + Math.abs(wave) * Style.resize(80)
                                        radius: Style.resize(3)
                                        anchors.verticalCenter: parent.verticalCenter

                                        color: Qt.hsla(
                                            0.47 + waveBar.index * 0.015,
                                            0.7,
                                            0.45 + Math.abs(wave) * 0.2,
                                            1.0)

                                        Behavior on height {
                                            NumberAnimation { duration: 50 }
                                        }
                                    }
                                }
                            }

                            // Controls
                            Row {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottomMargin: Style.resize(5)
                                spacing: Style.resize(20)

                                Row {
                                    spacing: Style.resize(5)
                                    Label {
                                        text: "Freq"
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Slider {
                                        id: waveFreqSlider
                                        width: Style.resize(100)
                                        from: 0.3; to: 3; value: 1; stepSize: 0.1
                                    }
                                }

                                Row {
                                    spacing: Style.resize(5)
                                    Label {
                                        text: "Amp"
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Slider {
                                        id: waveAmpSlider
                                        width: Style.resize(100)
                                        from: 0.1; to: 1.5; value: 1; stepSize: 0.1
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 4: Lissajous Curve ────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Lissajous Curve Tracer"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: lissajousSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: lissajousSection.sectionActive = !lissajousSection.sectionActive
                            }
                        }

                        Item {
                            id: lissajousSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(300)

                            property real time: 0
                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property int freqA: lissASlider.value
                            property int freqB: lissBSlider.value
                            property real phase: lissPhaseSlider.value
                            property var trail: []
                            property int maxTrail: 500

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: lissajousSection.running
                                interval: 16
                                repeat: true
                                onTriggered: {
                                    lissajousSection.time += 0.025
                                    var t = lissajousSection.time
                                    var cx = lissajousCanvas.width / 2
                                    var cy = lissajousCanvas.height / 2
                                    var rx = cx - 30
                                    var ry = cy - 30
                                    var x = cx + rx * Math.sin(lissajousSection.freqA * t + lissajousSection.phase)
                                    var y = cy + ry * Math.sin(lissajousSection.freqB * t)
                                    var tr = lissajousSection.trail
                                    tr.push({ x: x, y: y })
                                    if (tr.length > lissajousSection.maxTrail)
                                        tr.splice(0, tr.length - lissajousSection.maxTrail)
                                    lissajousSection.trail = tr
                                    lissajousCanvas.requestPaint()
                                }
                            }

                            Canvas {
                                id: lissajousCanvas
                                anchors.fill: parent

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.reset()

                                    var tr = lissajousSection.trail
                                    if (tr.length < 2) return

                                    for (var i = 1; i < tr.length; i++) {
                                        var frac = i / tr.length
                                        ctx.beginPath()
                                        ctx.moveTo(tr[i-1].x, tr[i-1].y)
                                        ctx.lineTo(tr[i].x, tr[i].y)

                                        var hue = (frac * 0.3 + 0.47) % 1
                                        ctx.strokeStyle = Qt.hsla(hue, 0.75, 0.55, frac * 0.9)
                                        ctx.lineWidth = 1 + frac * 2.5
                                        ctx.lineCap = "round"
                                        ctx.stroke()
                                    }

                                    // Head dot
                                    var last = tr[tr.length - 1]
                                    ctx.beginPath()
                                    ctx.arc(last.x, last.y, 5, 0, 2 * Math.PI)
                                    ctx.fillStyle = "#FFFFFF"
                                    ctx.fill()

                                    // Glow
                                    var glow = ctx.createRadialGradient(last.x, last.y, 0, last.x, last.y, 15)
                                    glow.addColorStop(0, Qt.rgba(0, 0.82, 0.66, 0.5))
                                    glow.addColorStop(1, "transparent")
                                    ctx.beginPath()
                                    ctx.arc(last.x, last.y, 15, 0, 2 * Math.PI)
                                    ctx.fillStyle = glow
                                    ctx.fill()
                                }
                            }

                            // Controls
                            Row {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(12)

                                Column {
                                    spacing: Style.resize(2)
                                    Label {
                                        text: "A: " + lissASlider.value
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                    Slider {
                                        id: lissASlider
                                        width: Style.resize(80)
                                        from: 1; to: 7; value: 3; stepSize: 1
                                    }
                                }

                                Column {
                                    spacing: Style.resize(2)
                                    Label {
                                        text: "B: " + lissBSlider.value
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                    Slider {
                                        id: lissBSlider
                                        width: Style.resize(80)
                                        from: 1; to: 7; value: 2; stepSize: 1
                                    }
                                }

                                Column {
                                    spacing: Style.resize(2)
                                    Label {
                                        text: "φ: " + lissPhaseSlider.value.toFixed(1)
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                    }
                                    Slider {
                                        id: lissPhaseSlider
                                        width: Style.resize(80)
                                        from: 0; to: 3.14; value: 1.57; stepSize: 0.1
                                    }
                                }

                                Button {
                                    text: "Clear"
                                    flat: true
                                    font.pixelSize: Style.resize(10)
                                    onClicked: {
                                        lissajousSection.trail = []
                                        lissajousSection.time = 0
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 5: Newton's Cradle ────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Newton's Cradle"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: cradleSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: cradleSection.sectionActive = !cradleSection.sectionActive
                            }
                        }

                        Item {
                            id: cradleSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(220)

                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property real time: 0
                            property real energy: 0.85  // amplitude in radians
                            property real damping: 0.9995
                            property int ballCount: 5
                            property real stringLen: 120
                            property real ballRadius: 14

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: cradleSection.running
                                interval: 16
                                repeat: true
                                onTriggered: {
                                    cradleSection.time += 0.05
                                    cradleSection.energy *= cradleSection.damping
                                    cradleCanvas.requestPaint()
                                }
                            }

                            Canvas {
                                id: cradleCanvas
                                anchors.fill: parent

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.reset()

                                    var cx = width / 2
                                    var topY = Style.resize(30)
                                    var sLen = Style.resize(cradleSection.stringLen)
                                    var bRad = Style.resize(cradleSection.ballRadius)
                                    var spacing = bRad * 2.1
                                    var n = cradleSection.ballCount
                                    var t = cradleSection.time
                                    var amp = cradleSection.energy

                                    // Top bar
                                    var barLeft = cx - (n - 1) * spacing / 2 - Style.resize(20)
                                    var barRight = cx + (n - 1) * spacing / 2 + Style.resize(20)
                                    ctx.beginPath()
                                    ctx.moveTo(barLeft, topY)
                                    ctx.lineTo(barRight, topY)
                                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.3)
                                    ctx.lineWidth = Style.resize(3)
                                    ctx.lineCap = "round"
                                    ctx.stroke()

                                    // Pendulum cycle: left swings out, then right swings out
                                    var phase = Math.sin(t * 3.5)  // oscillation
                                    var leftAngle = phase > 0 ? amp * phase : 0
                                    var rightAngle = phase < 0 ? -amp * phase : 0

                                    for (var i = 0; i < n; i++) {
                                        var anchorX = cx + (i - (n - 1) / 2) * spacing
                                        var angle = 0

                                        if (i === 0) angle = -leftAngle
                                        else if (i === n - 1) angle = rightAngle

                                        var ballX = anchorX + sLen * Math.sin(angle)
                                        var ballY = topY + sLen * Math.cos(angle)

                                        // String
                                        ctx.beginPath()
                                        ctx.moveTo(anchorX, topY)
                                        ctx.lineTo(ballX, ballY)
                                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.2)
                                        ctx.lineWidth = Style.resize(1.5)
                                        ctx.stroke()

                                        // Ball shadow
                                        var shadowGrad = ctx.createRadialGradient(
                                            ballX, ballY, bRad * 0.3,
                                            ballX, ballY, bRad * 1.5)
                                        shadowGrad.addColorStop(0, Qt.rgba(0, 0, 0, 0.2))
                                        shadowGrad.addColorStop(1, "transparent")
                                        ctx.beginPath()
                                        ctx.arc(ballX, ballY + bRad * 0.3, bRad * 1.5, 0, 2 * Math.PI)
                                        ctx.fillStyle = shadowGrad
                                        ctx.fill()

                                        // Ball
                                        var ballGrad = ctx.createRadialGradient(
                                            ballX - bRad * 0.3, ballY - bRad * 0.3, bRad * 0.1,
                                            ballX, ballY, bRad)
                                        ballGrad.addColorStop(0, "#E0E0E0")
                                        ballGrad.addColorStop(0.5, "#A0A0A0")
                                        ballGrad.addColorStop(1, "#606060")
                                        ctx.beginPath()
                                        ctx.arc(ballX, ballY, bRad, 0, 2 * Math.PI)
                                        ctx.fillStyle = ballGrad
                                        ctx.fill()

                                        // Highlight
                                        ctx.beginPath()
                                        ctx.arc(ballX - bRad * 0.25, ballY - bRad * 0.25,
                                                bRad * 0.35, 0, 2 * Math.PI)
                                        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.4)
                                        ctx.fill()
                                    }
                                }
                            }

                            // Reset button
                            Button {
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                anchors.margins: Style.resize(10)
                                text: "Reset"
                                flat: true
                                font.pixelSize: Style.resize(10)
                                onClicked: {
                                    cradleSection.energy = 0.85
                                    cradleSection.time = 0
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 6: Flip Card 3D ───────────────────────
                        Label {
                            text: "3D Flip Cards"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(20)
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: [
                                    { front: "Click Me", back: "Hello!", clr: "#00D1A9" },
                                    { front: "Hover", back: "Surprise!", clr: "#5B8DEF" },
                                    { front: "Flip", back: "Magic!", clr: "#FF9500" },
                                    { front: "Touch", back: "Nice!", clr: "#FF3B30" }
                                ]

                                delegate: Item {
                                    id: flipCard
                                    Layout.preferredWidth: Style.resize(140)
                                    Layout.preferredHeight: Style.resize(180)

                                    required property var modelData
                                    required property int index

                                    property bool flipped: false
                                    property real flipAngle: 0

                                    Behavior on flipAngle {
                                        NumberAnimation {
                                            duration: 600
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    // Front face
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Style.resize(12)
                                        color: flipCard.modelData.clr
                                        visible: flipCard.flipAngle < 90
                                        opacity: visible ? 1 : 0

                                        transform: Rotation {
                                            origin.x: flipCard.width / 2
                                            origin.y: flipCard.height / 2
                                            axis { x: 0; y: 1; z: 0 }
                                            angle: flipCard.flipAngle
                                        }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(10)

                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: "▶"
                                                font.pixelSize: Style.resize(30)
                                                color: "#FFFFFF"
                                            }
                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: flipCard.modelData.front
                                                font.pixelSize: Style.resize(16)
                                                font.bold: true
                                                color: "#FFFFFF"
                                            }
                                        }
                                    }

                                    // Back face
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Style.resize(12)
                                        color: Style.surfaceColor
                                        border.color: flipCard.modelData.clr
                                        border.width: Style.resize(2)
                                        visible: flipCard.flipAngle >= 90
                                        opacity: visible ? 1 : 0

                                        transform: Rotation {
                                            origin.x: flipCard.width / 2
                                            origin.y: flipCard.height / 2
                                            axis { x: 0; y: 1; z: 0 }
                                            angle: flipCard.flipAngle - 180
                                        }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(10)

                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: "✦"
                                                font.pixelSize: Style.resize(30)
                                                color: flipCard.modelData.clr
                                            }
                                            Label {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: flipCard.modelData.back
                                                font.pixelSize: Style.resize(16)
                                                font.bold: true
                                                color: flipCard.modelData.clr
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            flipCard.flipped = !flipCard.flipped
                                            flipCard.flipAngle = flipCard.flipped ? 180 : 0
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 7: Staggered List Animation ───────────
                        Label {
                            text: "Staggered List Entrance"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: staggerSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(320)

                            property bool animating: false
                            property int animStep: -1

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                id: staggerTimer
                                interval: 80
                                repeat: true
                                running: false
                                onTriggered: {
                                    staggerSection.animStep++
                                    if (staggerSection.animStep >= staggerRepeater.count) {
                                        staggerTimer.stop()
                                        staggerSection.animating = false
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(6)

                                Repeater {
                                    id: staggerRepeater
                                    model: [
                                        { icon: "✉", title: "New message from Alex", sub: "Hey, are you free tomorrow?", clr: "#5B8DEF" },
                                        { icon: "📅", title: "Meeting at 3 PM", sub: "Conference Room B — Project Review", clr: "#00D1A9" },
                                        { icon: "⚡", title: "Build succeeded", sub: "All 47 tests passed", clr: "#34C759" },
                                        { icon: "🔔", title: "System update available", sub: "Version 2.4.1 — Security patch", clr: "#FF9500" },
                                        { icon: "❤", title: "Your post was liked", sub: "12 people liked your photo", clr: "#FF3B30" },
                                        { icon: "📦", title: "Package delivered", sub: "Your order #4821 has arrived", clr: "#AF52DE" },
                                        { icon: "🎯", title: "Goal reached!", sub: "You completed 100% of daily tasks", clr: "#FEA601" }
                                    ]

                                    delegate: Rectangle {
                                        id: staggerItem
                                        required property var modelData
                                        required property int index

                                        width: parent.width
                                        height: Style.resize(38)
                                        radius: Style.resize(8)
                                        color: staggerItemMa.containsMouse
                                               ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

                                        property bool shown: staggerItem.index <= staggerSection.animStep

                                        opacity: shown ? 1 : 0
                                        x: shown ? 0 : Style.resize(60)

                                        Behavior on opacity {
                                            NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                                        }
                                        Behavior on x {
                                            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                                        }

                                        MouseArea {
                                            id: staggerItemMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                        }

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: Style.resize(12)
                                            anchors.rightMargin: Style.resize(12)
                                            spacing: Style.resize(12)

                                            Rectangle {
                                                Layout.preferredWidth: Style.resize(28)
                                                Layout.preferredHeight: Style.resize(28)
                                                radius: Style.resize(6)
                                                color: Qt.rgba(
                                                    Qt.color(staggerItem.modelData.clr).r,
                                                    Qt.color(staggerItem.modelData.clr).g,
                                                    Qt.color(staggerItem.modelData.clr).b, 0.15)

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: staggerItem.modelData.icon
                                                    font.pixelSize: Style.resize(14)
                                                }
                                            }

                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(1)

                                                Label {
                                                    text: staggerItem.modelData.title
                                                    font.pixelSize: Style.resize(13)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }
                                                Label {
                                                    text: staggerItem.modelData.sub
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontSecondaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }
                                            }

                                            Rectangle {
                                                Layout.preferredWidth: Style.resize(8)
                                                Layout.preferredHeight: Style.resize(8)
                                                radius: width / 2
                                                color: staggerItem.modelData.clr
                                            }
                                        }
                                    }
                                }
                            }

                            // Play button
                            Button {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottomMargin: Style.resize(8)
                                text: staggerSection.animating ? "Animating..." : "▶ Play Entrance"
                                flat: true
                                enabled: !staggerSection.animating
                                onClicked: {
                                    staggerSection.animStep = -1
                                    staggerSection.animating = true
                                    staggerTimer.start()
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 8: Breathing Circles ──────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Breathing Circles"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: breathSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: breathSection.sectionActive = !breathSection.sectionActive
                            }
                        }

                        Item {
                            id: breathSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(250)

                            property real time: 0
                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: breathSection.running
                                interval: 30
                                repeat: true
                                onTriggered: {
                                    breathSection.time += 0.03
                                    breathCanvas.requestPaint()
                                }
                            }

                            Canvas {
                                id: breathCanvas
                                anchors.fill: parent

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.reset()

                                    var cx = width / 2
                                    var cy = height / 2
                                    var t = breathSection.time

                                    var rings = 8
                                    var maxR = Math.min(cx, cy) - 20

                                    for (var i = rings - 1; i >= 0; i--) {
                                        var baseR = maxR * (i + 1) / rings
                                        var pulse = Math.sin(t * 1.8 - i * 0.5) * 0.15 + 1.0
                                        var r = baseR * pulse

                                        var hue = (0.47 + i * 0.04) % 1
                                        var alpha = 0.08 + (1 - i / rings) * 0.12
                                        var lightness = 0.3 + (1 - i / rings) * 0.25

                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.fillStyle = Qt.hsla(hue, 0.6, lightness, alpha)
                                        ctx.fill()

                                        // Ring border
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.strokeStyle = Qt.hsla(hue, 0.7, 0.55,
                                            alpha + 0.1 * Math.max(0, Math.sin(t * 1.8 - i * 0.5)))
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()
                                    }

                                    // Center orb
                                    var orbPulse = Math.sin(t * 1.8) * 0.3 + 1.0
                                    var orbR = 12 * orbPulse
                                    var orbGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, orbR * 2)
                                    orbGrad.addColorStop(0, Qt.rgba(0, 0.82, 0.66, 0.9))
                                    orbGrad.addColorStop(0.5, Qt.rgba(0, 0.82, 0.66, 0.3))
                                    orbGrad.addColorStop(1, "transparent")
                                    ctx.beginPath()
                                    ctx.arc(cx, cy, orbR * 2, 0, 2 * Math.PI)
                                    ctx.fillStyle = orbGrad
                                    ctx.fill()

                                    ctx.beginPath()
                                    ctx.arc(cx, cy, orbR, 0, 2 * Math.PI)
                                    ctx.fillStyle = "#FFFFFF"
                                    ctx.fill()
                                }
                            }

                            // Breathing guide text
                            Label {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottomMargin: Style.resize(10)
                                text: {
                                    var phase = Math.sin(breathSection.time * 1.8)
                                    if (phase > 0.3) return "Inhale..."
                                    if (phase < -0.3) return "Exhale..."
                                    return "Hold..."
                                }
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.mainColor
                                opacity: 0.7
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 9: Matrix Rain ────────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Matrix Rain"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }
                            Button {
                                text: matrixSection.sectionActive ? "■ Stop" : "▶ Play"
                                flat: true
                                font.pixelSize: Style.resize(12)
                                onClicked: matrixSection.sectionActive = !matrixSection.sectionActive
                            }
                        }

                        Item {
                            id: matrixSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(250)

                            property bool sectionActive: false
                            property bool running: root.fullSize && sectionActive
                            property var columns: []
                            property bool initialized: false

                            Rectangle {
                                anchors.fill: parent
                                color: "#0A0A0A"
                                radius: Style.resize(8)
                            }

                            Timer {
                                running: matrixSection.running && matrixCanvas.width > 0
                                interval: 50
                                repeat: true
                                onTriggered: {
                                    var cols = matrixSection.columns
                                    var colCount = Math.floor(matrixCanvas.width / 14)
                                    var rowCount = Math.floor(matrixCanvas.height / 16)

                                    // Initialize columns
                                    if (!matrixSection.initialized || cols.length !== colCount) {
                                        cols = []
                                        for (var c = 0; c < colCount; c++) {
                                            cols.push({
                                                y: Math.floor(Math.random() * rowCount),
                                                speed: 0.3 + Math.random() * 0.7,
                                                chars: []
                                            })
                                            // Pre-fill chars
                                            for (var ch = 0; ch < rowCount; ch++) {
                                                cols[c].chars.push(
                                                    String.fromCharCode(0x30A0 + Math.floor(Math.random() * 96)))
                                            }
                                        }
                                        matrixSection.initialized = true
                                    }

                                    // Advance columns
                                    for (var i = 0; i < cols.length; i++) {
                                        cols[i].y += cols[i].speed
                                        if (cols[i].y > rowCount + 8) {
                                            cols[i].y = -Math.floor(Math.random() * 8)
                                            cols[i].speed = 0.3 + Math.random() * 0.7
                                        }
                                        // Randomize a char occasionally
                                        if (Math.random() < 0.05) {
                                            var ri = Math.floor(Math.random() * rowCount)
                                            cols[i].chars[ri] =
                                                String.fromCharCode(0x30A0 + Math.floor(Math.random() * 96))
                                        }
                                    }
                                    matrixSection.columns = cols
                                    matrixCanvas.requestPaint()
                                }
                            }

                            Canvas {
                                id: matrixCanvas
                                anchors.fill: parent
                                anchors.margins: Style.resize(1)

                                onPaint: {
                                    var ctx = getContext("2d")
                                    // Fade effect
                                    ctx.fillStyle = Qt.rgba(0.04, 0.04, 0.04, 0.15)
                                    ctx.fillRect(0, 0, width, height)

                                    var cols = matrixSection.columns
                                    if (!cols || cols.length === 0) return

                                    var fontSize = 14
                                    var rowH = 16
                                    var rowCount = Math.floor(height / rowH)

                                    ctx.font = fontSize + "px monospace"

                                    for (var c = 0; c < cols.length; c++) {
                                        var col = cols[c]
                                        var headY = Math.floor(col.y)

                                        for (var r = 0; r < rowCount; r++) {
                                            var dist = headY - r
                                            if (dist < 0 || dist > 20) continue

                                            var alpha = dist === 0 ? 1.0 : Math.max(0, 1 - dist / 20)

                                            if (dist === 0) {
                                                ctx.fillStyle = "#FFFFFF"
                                            } else if (dist < 3) {
                                                ctx.fillStyle = Qt.rgba(0.3, 1, 0.3, alpha)
                                            } else {
                                                ctx.fillStyle = Qt.rgba(0, 0.7, 0, alpha * 0.7)
                                            }

                                            var ch = col.chars[r % col.chars.length]
                                            ctx.fillText(ch, c * 14 + 2, r * rowH + fontSize)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
