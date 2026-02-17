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
            }
        }
    }
}
