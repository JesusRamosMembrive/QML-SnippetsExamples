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
            }
        }
    }
}
