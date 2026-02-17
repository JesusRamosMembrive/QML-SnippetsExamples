import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

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
                    text: "Transforms & Effects Examples"
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
                    // Card 1: 2D Transforms
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(8)

                            Label {
                                text: "2D Transforms"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Rotation slider
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Rotation: " + rotSlider.value.toFixed(0) + "°"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(100) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: rotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
                                }
                            }

                            // Scale slider
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Scale: " + scaleSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(100) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: scaleSlider; anchors.fill: parent; from: 0.3; to: 2.0; value: 1.0; stepSize: 0.05 }
                                }
                            }

                            // Origin buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)

                                property int originMode: 0 // 0=Center, 1=TopLeft, 2=BottomRight

                                Label { text: "Origin:"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }

                                Button {
                                    text: "Center"
                                    highlighted: parent.originMode === 0
                                    onClicked: parent.originMode = 0
                                }
                                Button {
                                    text: "TopLeft"
                                    highlighted: parent.originMode === 1
                                    onClicked: parent.originMode = 1
                                }
                                Button {
                                    text: "BottomRight"
                                    highlighted: parent.originMode === 2
                                    onClicked: parent.originMode = 2
                                }
                            }

                            // Preview area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(6)
                                }

                                Rectangle {
                                    id: transformRect
                                    anchors.centerIn: parent
                                    width: Style.resize(80)
                                    height: Style.resize(80)
                                    radius: Style.resize(8)
                                    color: Style.mainColor

                                    rotation: rotSlider.value
                                    scale: scaleSlider.value
                                    transformOrigin: {
                                        var mode = transformRect.parent.parent.children[3].originMode
                                        if (mode === 1) return Item.TopLeft
                                        if (mode === 2) return Item.BottomRight
                                        return Item.Center
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: "QML"
                                        font.pixelSize: Style.resize(20)
                                        font.bold: true
                                        color: "white"
                                    }

                                    // Origin dot
                                    Rectangle {
                                        width: Style.resize(8)
                                        height: Style.resize(8)
                                        radius: width / 2
                                        color: "#FF5900"
                                        x: {
                                            var mode = transformRect.parent.parent.children[3].originMode
                                            if (mode === 1) return -width/2
                                            if (mode === 2) return transformRect.width - width/2
                                            return transformRect.width/2 - width/2
                                        }
                                        y: {
                                            var mode = transformRect.parent.parent.children[3].originMode
                                            if (mode === 1) return -height/2
                                            if (mode === 2) return transformRect.height - height/2
                                            return transformRect.height/2 - height/2
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "rotation, scale, and transformOrigin control 2D transforms"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: 3D Rotation
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(8)

                            Label {
                                text: "3D Rotation"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // X axis
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "X: " + xRotSlider.value.toFixed(0) + "°"; font.pixelSize: Style.resize(12); color: "#E74C3C"; Layout.preferredWidth: Style.resize(60) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: xRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
                                }
                            }

                            // Y axis
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Y: " + yRotSlider.value.toFixed(0) + "°"; font.pixelSize: Style.resize(12); color: "#00D1A9"; Layout.preferredWidth: Style.resize(60) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: yRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
                                }
                            }

                            // Z axis
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Z: " + zRotSlider.value.toFixed(0) + "°"; font.pixelSize: Style.resize(12); color: "#4A90D9"; Layout.preferredWidth: Style.resize(60) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: zRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
                                }
                            }

                            Button {
                                text: "Reset"
                                onClicked: { xRotSlider.value = 0; yRotSlider.value = 0; zRotSlider.value = 0 }
                            }

                            // 3D preview
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(6)
                                }

                                Rectangle {
                                    id: rect3d
                                    anchors.centerIn: parent
                                    width: Style.resize(100)
                                    height: Style.resize(100)
                                    radius: Style.resize(10)
                                    color: "#4A90D9"

                                    transform: [
                                        Rotation {
                                            origin.x: rect3d.width / 2
                                            origin.y: rect3d.height / 2
                                            axis { x: 1; y: 0; z: 0 }
                                            angle: xRotSlider.value
                                        },
                                        Rotation {
                                            origin.x: rect3d.width / 2
                                            origin.y: rect3d.height / 2
                                            axis { x: 0; y: 1; z: 0 }
                                            angle: yRotSlider.value
                                        },
                                        Rotation {
                                            origin.x: rect3d.width / 2
                                            origin.y: rect3d.height / 2
                                            axis { x: 0; y: 0; z: 1 }
                                            angle: zRotSlider.value
                                        }
                                    ]

                                    Label {
                                        anchors.centerIn: parent
                                        text: "3D"
                                        font.pixelSize: Style.resize(28)
                                        font.bold: true
                                        color: "white"
                                    }
                                }
                            }

                            Label {
                                text: "Rotation with axis { x; y; z } creates 3D perspective effects"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: GraphicalEffects
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "GraphicalEffects"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // DropShadow
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Shadow: " + shadowSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: shadowSlider; anchors.fill: parent; from: 0; to: 30; value: 12; stepSize: 1 }
                                }
                            }

                            // Blur
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Blur: " + blurSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: blurSlider; anchors.fill: parent; from: 0; to: 20; value: 0; stepSize: 1 }
                                }
                            }

                            // Hue
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: "Hue: " + hueSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
                                Item {
                                    Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                                    Slider { id: hueSlider; anchors.fill: parent; from: 0; to: 1.0; value: 0; stepSize: 0.01 }
                                }
                            }

                            // Effects preview
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(15)

                                // DropShadow
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: Style.resize(6)

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.bgColor
                                            radius: Style.resize(4)
                                        }

                                        Rectangle {
                                            id: shadowSource
                                            anchors.centerIn: parent
                                            width: Style.resize(60)
                                            height: Style.resize(60)
                                            radius: Style.resize(8)
                                            color: Style.mainColor
                                            visible: false

                                            Label {
                                                anchors.centerIn: parent
                                                text: "A"
                                                font.pixelSize: Style.resize(24)
                                                font.bold: true
                                                color: "white"
                                            }
                                        }

                                        DropShadow {
                                            anchors.fill: shadowSource
                                            source: shadowSource
                                            horizontalOffset: Style.resize(3)
                                            verticalOffset: Style.resize(3)
                                            radius: shadowSlider.value
                                            samples: 25
                                            color: Qt.rgba(0, 0, 0, 0.4)
                                        }
                                    }

                                    Label {
                                        text: "DropShadow"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // GaussianBlur
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: Style.resize(6)

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.bgColor
                                            radius: Style.resize(4)
                                        }

                                        Rectangle {
                                            id: blurSource
                                            anchors.centerIn: parent
                                            width: Style.resize(60)
                                            height: Style.resize(60)
                                            radius: Style.resize(8)
                                            color: "#4A90D9"
                                            visible: false

                                            Label {
                                                anchors.centerIn: parent
                                                text: "B"
                                                font.pixelSize: Style.resize(24)
                                                font.bold: true
                                                color: "white"
                                            }
                                        }

                                        GaussianBlur {
                                            anchors.fill: blurSource
                                            source: blurSource
                                            radius: blurSlider.value
                                            samples: blurSlider.value * 2 + 1
                                        }
                                    }

                                    Label {
                                        text: "GaussianBlur"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Colorize
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: Style.resize(6)

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Rectangle {
                                            anchors.fill: parent
                                            color: Style.bgColor
                                            radius: Style.resize(4)
                                        }

                                        Rectangle {
                                            id: colorizeSource
                                            anchors.centerIn: parent
                                            width: Style.resize(60)
                                            height: Style.resize(60)
                                            radius: Style.resize(8)
                                            color: "#FEA601"
                                            visible: false

                                            Label {
                                                anchors.centerIn: parent
                                                text: "C"
                                                font.pixelSize: Style.resize(24)
                                                font.bold: true
                                                color: "white"
                                            }
                                        }

                                        Colorize {
                                            anchors.fill: colorizeSource
                                            source: colorizeSource
                                            hue: hueSlider.value
                                            saturation: 0.8
                                            lightness: 0.0
                                        }
                                    }

                                    Label {
                                        text: "Colorize"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: "Qt5Compat.GraphicalEffects: shadow, blur, and color manipulation"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Card Flip
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Card Flip"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                text: flipCard.flipped ? "Showing: Back" : "Showing: Front"
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.fontSecondaryColor
                            }

                            // Flip area
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: Style.bgColor
                                    radius: Style.resize(6)
                                }

                                Item {
                                    id: flipCard
                                    anchors.centerIn: parent
                                    width: Style.resize(180)
                                    height: Style.resize(220)

                                    property bool flipped: false
                                    property real flipAngle: 0

                                    Behavior on flipAngle {
                                        NumberAnimation {
                                            duration: 600
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    transform: Rotation {
                                        origin.x: flipCard.width / 2
                                        origin.y: flipCard.height / 2
                                        axis { x: 0; y: 1; z: 0 }
                                        angle: flipCard.flipAngle
                                    }

                                    // Front face
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Style.resize(12)
                                        color: Style.mainColor
                                        visible: flipCard.flipAngle < 90 || flipCard.flipAngle > 270

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(12)

                                            Rectangle {
                                                width: Style.resize(60)
                                                height: Style.resize(60)
                                                radius: width / 2
                                                color: "white"
                                                Layout.alignment: Qt.AlignHCenter

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "Qt"
                                                    font.pixelSize: Style.resize(24)
                                                    font.bold: true
                                                    color: Style.mainColor
                                                }
                                            }

                                            Label {
                                                text: "FRONT"
                                                font.pixelSize: Style.resize(22)
                                                font.bold: true
                                                color: "white"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "Click to flip"
                                                font.pixelSize: Style.resize(13)
                                                color: Qt.rgba(1, 1, 1, 0.7)
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }

                                    // Back face (mirrored horizontally so text reads correctly)
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Style.resize(12)
                                        color: "#FEA601"
                                        visible: flipCard.flipAngle >= 90 && flipCard.flipAngle <= 270

                                        // Mirror to counteract the Y rotation
                                        transform: Scale {
                                            origin.x: flipCard.width / 2
                                            xScale: -1
                                        }

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(12)

                                            Rectangle {
                                                width: Style.resize(60)
                                                height: Style.resize(60)
                                                radius: Style.resize(8)
                                                color: "white"
                                                Layout.alignment: Qt.AlignHCenter

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "QML"
                                                    font.pixelSize: Style.resize(18)
                                                    font.bold: true
                                                    color: "#FEA601"
                                                }
                                            }

                                            Label {
                                                text: "BACK"
                                                font.pixelSize: Style.resize(22)
                                                font.bold: true
                                                color: "white"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "Click to flip back"
                                                font.pixelSize: Style.resize(13)
                                                color: Qt.rgba(1, 1, 1, 0.7)
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            flipCard.flipped = !flipCard.flipped
                                            flipCard.flipAngle = flipCard.flipped ? 180 : 0
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "3D Y-axis Rotation to create a card flip. Click to toggle front/back"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout

                // ========================================
                // Card 5: Custom Transform Creations
                // ========================================
                Rectangle {
                    id: card5Transforms
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    property bool carouselActive: false
                    property bool neonActive: false
                    property bool waveActive: false

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Transform Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: 3D carousel, parallax depth, spring physics, neon glow, matrix shear, wave grids"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // --- Section 1: 3D Carousel ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "1. 3D Carousel"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Transforms.carouselActive ? "Pause" : "Start"
                                    onClicked: card5Transforms.carouselActive = !card5Transforms.carouselActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(260)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Item {
                                    id: carouselArea
                                    anchors.fill: parent

                                    property real carouselAngle: 0

                                    Timer {
                                        interval: 50
                                        repeat: true
                                        running: root.fullSize && card5Transforms.carouselActive
                                        onTriggered: carouselArea.carouselAngle += 0.8
                                    }

                                    Repeater {
                                        model: [
                                            { color: "#00D1A9", label: "Qt", idx: 0 },
                                            { color: "#FF5900", label: "QML", idx: 1 },
                                            { color: "#4A90D9", label: "C++", idx: 2 },
                                            { color: "#9B59B6", label: "JS", idx: 3 },
                                            { color: "#FEA601", label: "UI", idx: 4 }
                                        ]

                                        Rectangle {
                                            property real itemAngle: (carouselArea.carouselAngle + modelData.idx * 72) * Math.PI / 180
                                            property real depth: (Math.cos(itemAngle) + 1) / 2

                                            x: carouselArea.width / 2 + Math.sin(itemAngle) * carouselArea.width * 0.28 - width / 2
                                            y: carouselArea.height / 2 - height / 2 + (1 - depth) * Style.resize(12)
                                            z: depth * 10
                                            width: Style.resize(90)
                                            height: Style.resize(120)
                                            radius: Style.resize(10)
                                            color: modelData.color
                                            scale: 0.55 + 0.45 * depth
                                            opacity: 0.3 + 0.7 * depth

                                            ColumnLayout {
                                                anchors.centerIn: parent
                                                spacing: Style.resize(6)

                                                Label {
                                                    text: modelData.label
                                                    font.pixelSize: Style.resize(22)
                                                    font.bold: true
                                                    color: "white"
                                                    Layout.alignment: Qt.AlignHCenter
                                                }
                                                Label {
                                                    text: "Card " + (modelData.idx + 1)
                                                    font.pixelSize: Style.resize(11)
                                                    color: Qt.rgba(1, 1, 1, 0.7)
                                                    Layout.alignment: Qt.AlignHCenter
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 2: Parallax Depth ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "2. Parallax Depth"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            Rectangle {
                                id: parallaxContainer
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(220)
                                color: "#0C1445"
                                radius: Style.resize(6)
                                clip: true

                                property real mx: 0
                                property real my: 0

                                // Far layer (0.05x)
                                Rectangle {
                                    x: parallaxContainer.width * 0.72 + parallaxContainer.mx * 8
                                    y: parallaxContainer.height * 0.18 + parallaxContainer.my * 5
                                    width: Style.resize(60); height: width; radius: width / 2
                                    color: "#FFFFFF10"; border.color: "#FFFFFF30"; border.width: 1
                                }
                                Rectangle {
                                    x: parallaxContainer.width * 0.12 + parallaxContainer.mx * 8
                                    y: parallaxContainer.height * 0.55 + parallaxContainer.my * 5
                                    width: Style.resize(45); height: width; radius: width / 2
                                    color: "#9B59B610"; border.color: "#9B59B630"; border.width: 1
                                }

                                // Mid layer (0.15x)
                                Rectangle {
                                    x: parallaxContainer.width * 0.35 + parallaxContainer.mx * 25
                                    y: parallaxContainer.height * 0.28 + parallaxContainer.my * 18
                                    width: Style.resize(80); height: Style.resize(50); radius: Style.resize(8)
                                    color: "#4A90D918"; border.color: "#4A90D950"; border.width: 1
                                }
                                Rectangle {
                                    x: parallaxContainer.width * 0.58 + parallaxContainer.mx * 25
                                    y: parallaxContainer.height * 0.52 + parallaxContainer.my * 18
                                    width: Style.resize(55); height: Style.resize(35); radius: Style.resize(6)
                                    color: "#00D1A918"; border.color: "#00D1A950"; border.width: 1
                                }

                                // Near layer (0.3x)
                                Rectangle {
                                    x: parallaxContainer.width * 0.22 + parallaxContainer.mx * 50
                                    y: parallaxContainer.height * 0.42 + parallaxContainer.my * 40
                                    width: Style.resize(30); height: width; radius: width / 2
                                    color: "#FF590035"; border.color: "#FF5900"; border.width: 1.5
                                }
                                Rectangle {
                                    x: parallaxContainer.width * 0.52 + parallaxContainer.mx * 50
                                    y: parallaxContainer.height * 0.65 + parallaxContainer.my * 40
                                    width: Style.resize(25); height: width; radius: width / 2
                                    color: "#FEA60135"; border.color: "#FEA601"; border.width: 1.5
                                }
                                Rectangle {
                                    x: parallaxContainer.width * 0.8 + parallaxContainer.mx * 50
                                    y: parallaxContainer.height * 0.22 + parallaxContainer.my * 40
                                    width: Style.resize(20); height: width; radius: width / 2
                                    color: "#E74C3C35"; border.color: "#E74C3C"; border.width: 1.5
                                }

                                // Depth labels
                                Row {
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: Style.resize(6)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: Style.resize(20)

                                    Label { text: "Far (0.05x)"; font.pixelSize: Style.resize(9); color: "#FFFFFF50" }
                                    Label { text: "Mid (0.15x)"; font.pixelSize: Style.resize(9); color: "#4A90D980" }
                                    Label { text: "Near (0.3x)"; font.pixelSize: Style.resize(9); color: "#FF590090" }
                                }

                                Label {
                                    anchors.top: parent.top
                                    anchors.topMargin: Style.resize(8)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "Move your mouse over this area"
                                    font.pixelSize: Style.resize(11)
                                    color: "#FFFFFF40"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onPositionChanged: function(mouse) {
                                        parallaxContainer.mx = (mouse.x / parallaxContainer.width - 0.5) * 2
                                        parallaxContainer.my = (mouse.y / parallaxContainer.height - 0.5) * 2
                                    }
                                    onExited: { parallaxContainer.mx = 0; parallaxContainer.my = 0 }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 3: Elastic Spring ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "3. Elastic Spring"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(200)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Item {
                                    id: springSection
                                    anchors.fill: parent
                                    property bool isDragging: false

                                    // Center crosshair
                                    Rectangle {
                                        x: springSection.width / 2 - Style.resize(15)
                                        y: springSection.height / 2 - 0.5
                                        width: Style.resize(30); height: 1
                                        color: Style.inactiveColor; opacity: 0.5
                                    }
                                    Rectangle {
                                        x: springSection.width / 2 - 0.5
                                        y: springSection.height / 2 - Style.resize(15)
                                        width: 1; height: Style.resize(30)
                                        color: Style.inactiveColor; opacity: 0.5
                                    }

                                    // Trail circles (show spring path)
                                    Rectangle {
                                        x: springSection.width / 2 - width / 2
                                        y: springSection.height / 2 - height / 2
                                        width: Style.resize(120); height: width; radius: width / 2
                                        color: "transparent"
                                        border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.3
                                    }
                                    Rectangle {
                                        x: springSection.width / 2 - width / 2
                                        y: springSection.height / 2 - height / 2
                                        width: Style.resize(80); height: width; radius: width / 2
                                        color: "transparent"
                                        border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.2
                                    }

                                    Rectangle {
                                        id: springBall
                                        x: springSection.width / 2 - width / 2
                                        y: springSection.height / 2 - height / 2
                                        width: Style.resize(50); height: width; radius: width / 2
                                        color: Style.mainColor

                                        Behavior on x {
                                            enabled: !springSection.isDragging
                                            SpringAnimation { spring: 3; damping: 0.12 }
                                        }
                                        Behavior on y {
                                            enabled: !springSection.isDragging
                                            SpringAnimation { spring: 3; damping: 0.12 }
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: "Drag"
                                            font.pixelSize: Style.resize(11)
                                            font.bold: true
                                            color: "white"
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onPressed: function(mouse) {
                                            springSection.isDragging = true
                                            springBall.x = mouse.x - springBall.width / 2
                                            springBall.y = mouse.y - springBall.height / 2
                                        }
                                        onPositionChanged: function(mouse) {
                                            if (pressed) {
                                                springBall.x = mouse.x - springBall.width / 2
                                                springBall.y = mouse.y - springBall.height / 2
                                            }
                                        }
                                        onReleased: {
                                            springSection.isDragging = false
                                            springBall.x = springSection.width / 2 - springBall.width / 2
                                            springBall.y = springSection.height / 2 - springBall.height / 2
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 4: Neon Glow ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "4. Neon Glow"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Transforms.neonActive ? "Pause" : "Start"
                                    onClicked: card5Transforms.neonActive = !card5Transforms.neonActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(130)
                                color: "#0A0A14"
                                radius: Style.resize(6)

                                Item {
                                    id: neonContainer
                                    anchors.fill: parent

                                    property real neonTime: 0

                                    Timer {
                                        interval: 50
                                        repeat: true
                                        running: root.fullSize && card5Transforms.neonActive
                                        onTriggered: neonContainer.neonTime += 0.06
                                    }

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(40)

                                        // Sign 1: NEON
                                        Item {
                                            Layout.preferredWidth: Style.resize(110)
                                            Layout.preferredHeight: Style.resize(60)

                                            Label {
                                                id: neon1Label
                                                anchors.centerIn: parent
                                                text: "NEON"
                                                font.pixelSize: Style.resize(32)
                                                font.bold: true
                                                color: "#FF1493"
                                                visible: false
                                            }

                                            Glow {
                                                anchors.fill: neon1Label
                                                source: neon1Label
                                                radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime))
                                                samples: 25
                                                color: "#FF1493"
                                            }
                                        }

                                        // Sign 2: GLOW
                                        Item {
                                            Layout.preferredWidth: Style.resize(110)
                                            Layout.preferredHeight: Style.resize(60)

                                            Label {
                                                id: neon2Label
                                                anchors.centerIn: parent
                                                text: "GLOW"
                                                font.pixelSize: Style.resize(32)
                                                font.bold: true
                                                color: "#00BFFF"
                                                visible: false
                                            }

                                            Glow {
                                                anchors.fill: neon2Label
                                                source: neon2Label
                                                radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime + 2.1))
                                                samples: 25
                                                color: "#00BFFF"
                                            }
                                        }

                                        // Sign 3: QML
                                        Item {
                                            Layout.preferredWidth: Style.resize(110)
                                            Layout.preferredHeight: Style.resize(60)

                                            Label {
                                                id: neon3Label
                                                anchors.centerIn: parent
                                                text: "QML"
                                                font.pixelSize: Style.resize(32)
                                                font.bold: true
                                                color: "#39FF14"
                                                visible: false
                                            }

                                            Glow {
                                                anchors.fill: neon3Label
                                                source: neon3Label
                                                radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime + 4.2))
                                                samples: 25
                                                color: "#39FF14"
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 5: Matrix Shear ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: "5. Matrix Shear Transform"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Shear X: " + shearXSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: shearXSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
                                }
                                ColumnLayout {
                                    spacing: Style.resize(2)
                                    Label { text: "Shear Y: " + shearYSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                                    Slider { id: shearYSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: "Reset"
                                    onClicked: { shearXSlider.value = 0; shearYSlider.value = 0 }
                                }
                            }

                            // Matrix display
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(36)
                                color: Style.bgColor
                                radius: Style.resize(4)

                                Label {
                                    anchors.centerIn: parent
                                    text: "Matrix4x4:  [ 1.00, " + shearXSlider.value.toFixed(2) + " ;  " + shearYSlider.value.toFixed(2) + ", 1.00 ]"
                                    font.pixelSize: Style.resize(12)
                                    font.family: "Courier"
                                    color: Style.mainColor
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(200)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                // Grid background for reference
                                Canvas {
                                    anchors.fill: parent
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.strokeStyle = "#2A2D35"
                                        ctx.lineWidth = 0.5
                                        var grid = 30
                                        for (var gx = 0; gx < width; gx += grid) {
                                            ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, height); ctx.stroke()
                                        }
                                        for (var gy = 0; gy < height; gy += grid) {
                                            ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(width, gy); ctx.stroke()
                                        }
                                    }
                                }

                                Rectangle {
                                    id: shearRect
                                    anchors.centerIn: parent
                                    width: Style.resize(100)
                                    height: Style.resize(100)
                                    radius: Style.resize(8)
                                    color: "#4A90D9"
                                    border.color: "#6AB0FF"
                                    border.width: 2

                                    transform: Matrix4x4 {
                                        matrix: Qt.matrix4x4(
                                            1,                  shearXSlider.value, 0, -shearXSlider.value * shearRect.height / 2,
                                            shearYSlider.value, 1,                  0, -shearYSlider.value * shearRect.width / 2,
                                            0,                  0,                  1, 0,
                                            0,                  0,                  0, 1
                                        )
                                    }

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(4)

                                        Label {
                                            text: "SHEAR"
                                            font.pixelSize: Style.resize(18)
                                            font.bold: true
                                            color: "white"
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                        Label {
                                            text: "Matrix4x4"
                                            font.pixelSize: Style.resize(10)
                                            color: Qt.rgba(1, 1, 1, 0.6)
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }

                                // Ghost outline of original position
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: Style.resize(100)
                                    height: Style.resize(100)
                                    radius: Style.resize(8)
                                    color: "transparent"
                                    border.color: "#4A90D930"
                                    border.width: 1
                                    visible: Math.abs(shearXSlider.value) > 0.01 || Math.abs(shearYSlider.value) > 0.01
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: 1; color: Style.inactiveColor; opacity: 0.3 }

                        // --- Section 6: Wave Grid ---
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "6. Wave Grid"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Button {
                                    text: card5Transforms.waveActive ? "Pause" : "Start"
                                    onClicked: card5Transforms.waveActive = !card5Transforms.waveActive
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(230)
                                color: Style.surfaceColor
                                radius: Style.resize(6)
                                clip: true

                                Item {
                                    id: waveSection
                                    anchors.fill: parent
                                    property real wavePhase: 0

                                    Timer {
                                        interval: 40
                                        repeat: true
                                        running: root.fullSize && card5Transforms.waveActive
                                        onTriggered: waveSection.wavePhase += 0.08
                                    }

                                    Grid {
                                        anchors.centerIn: parent
                                        rows: 6
                                        columns: 10
                                        spacing: Style.resize(4)

                                        Repeater {
                                            model: 60

                                            Rectangle {
                                                property int col: index % 10
                                                property int row: Math.floor(index / 10)
                                                property real wave: Math.sin(waveSection.wavePhase + (col + row) * 0.4)
                                                property real t: (wave + 1) / 2

                                                width: Style.resize(22)
                                                height: Style.resize(22)
                                                radius: Style.resize(4)
                                                scale: 0.55 + 0.45 * t
                                                color: Qt.rgba(1 - t * 0.75, t * 0.6 + 0.3, t * 0.5 + 0.2, 1)

                                                transform: Translate { y: wave * Style.resize(12) }
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
}
