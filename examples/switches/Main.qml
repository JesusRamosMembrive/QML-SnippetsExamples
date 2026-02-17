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
                    text: "Switch, CheckBox & RadioButton Examples"
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
                    // Card 1: Basic Switch
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(20)

                            Label {
                                text: "Basic Switch"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                Switch {
                                    id: wifiSwitch
                                    text: "Wi-Fi"
                                }

                                Switch {
                                    id: bluetoothSwitch
                                    text: "Bluetooth"
                                    checked: true
                                }

                                Switch {
                                    id: airplaneSwitch
                                    text: "Airplane Mode"
                                    enabled: false
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: "Wi-Fi: " + (wifiSwitch.checked ? "ON" : "OFF")
                                      + "  |  Bluetooth: " + (bluetoothSwitch.checked ? "ON" : "OFF")
                                      + "  |  Airplane: " + (airplaneSwitch.checked ? "ON" : "OFF")
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Label {
                                text: "Switch provides a toggleable on/off control with animated indicator"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 2: CheckBox
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "CheckBox"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            CheckBox {
                                id: selectAllCheckBox
                                text: "Select All"
                                tristate: true
                                checkState: {
                                    var checked = 0;
                                    if (optionA.checked) checked++;
                                    if (optionB.checked) checked++;
                                    if (optionC.checked) checked++;
                                    if (checked === 3) return Qt.Checked;
                                    if (checked === 0) return Qt.Unchecked;
                                    return Qt.PartiallyChecked;
                                }
                                onClicked: {
                                    var newState = (checkState !== Qt.Checked);
                                    optionA.checked = newState;
                                    optionB.checked = newState;
                                    optionC.checked = newState;
                                }
                            }

                            ColumnLayout {
                                Layout.leftMargin: Style.resize(30)
                                spacing: Style.resize(5)

                                CheckBox {
                                    id: optionA
                                    text: "Option A"
                                    checked: true
                                }

                                CheckBox {
                                    id: optionB
                                    text: "Option B"
                                }

                                CheckBox {
                                    id: optionC
                                    text: "Option C"
                                    checked: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: {
                                    var selected = [];
                                    if (optionA.checked) selected.push("A");
                                    if (optionB.checked) selected.push("B");
                                    if (optionC.checked) selected.push("C");
                                    return "Selected: " + (selected.length > 0 ? selected.join(", ") : "none");
                                }
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                            }

                            Label {
                                text: "CheckBox supports checked, unchecked, and partially checked (tristate) states"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 3: RadioButton Group
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "RadioButton Group"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            ButtonGroup {
                                id: sizeGroup
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(5)

                                RadioButton {
                                    id: radioSmall
                                    text: "Small"
                                    ButtonGroup.group: sizeGroup
                                }

                                RadioButton {
                                    id: radioMedium
                                    text: "Medium"
                                    checked: true
                                    ButtonGroup.group: sizeGroup
                                }

                                RadioButton {
                                    id: radioLarge
                                    text: "Large"
                                    ButtonGroup.group: sizeGroup
                                }
                            }

                            // Preview Rectangle
                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(130)

                                Rectangle {
                                    id: previewRect
                                    anchors.centerIn: parent
                                    width: radioSmall.checked ? Style.resize(40)
                                           : radioMedium.checked ? Style.resize(80)
                                           : Style.resize(120)
                                    height: width
                                    color: Style.mainColor
                                    radius: Style.resize(8)

                                    Behavior on width {
                                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: previewRect.width.toFixed(0) + "px"
                                        color: "white"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                    }
                                }
                            }

                            Label {
                                text: "Selected size: " + (radioSmall.checked ? "Small" : radioMedium.checked ? "Medium" : "Large")
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                            }

                            Label {
                                text: "RadioButtons in a ButtonGroup ensure exclusive selection"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 4: Interactive Demo - Smart Home Panel
                    // ========================================
                    Rectangle {
                        id: smartHomeCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                        color: darkModeSwitch.checked ? "#1E2028" : Style.cardColor
                        radius: Style.resize(8)

                        Behavior on color {
                            ColorAnimation { duration: 300 }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "Interactive Demo - Smart Home Panel"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            CheckBox {
                                id: enableZoneCheckBox
                                text: "Enable Zone"
                                checked: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
                            }

                            Switch {
                                id: darkModeSwitch
                                text: "Dark Mode"
                                enabled: enableZoneCheckBox.checked
                            }

                            Label {
                                text: "Temperature:"
                                font.pixelSize: Style.resize(14)
                                color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
                                font.bold: true
                            }

                            ButtonGroup {
                                id: tempGroup
                            }

                            RowLayout {
                                spacing: Style.resize(10)

                                RadioButton {
                                    id: tempLow
                                    text: "Low"
                                    ButtonGroup.group: tempGroup
                                    enabled: enableZoneCheckBox.checked
                                }

                                RadioButton {
                                    id: tempMedium
                                    text: "Medium"
                                    checked: true
                                    ButtonGroup.group: tempGroup
                                    enabled: enableZoneCheckBox.checked
                                }

                                RadioButton {
                                    id: tempHigh
                                    text: "High"
                                    ButtonGroup.group: tempGroup
                                    enabled: enableZoneCheckBox.checked
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
                            }

                            Label {
                                text: "Zone: " + (enableZoneCheckBox.checked ? "Enabled" : "Disabled")
                                      + "  |  Mode: " + (darkModeSwitch.checked ? "Dark" : "Light")
                                      + "  |  Temp: " + (tempLow.checked ? "Low" : tempMedium.checked ? "Medium" : "High")
                                font.pixelSize: Style.resize(13)
                                color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Label {
                                text: "Controls interact: CheckBox enables the zone, Switch toggles theme, RadioButtons select temperature"
                                font.pixelSize: Style.resize(12)
                                color: darkModeSwitch.checked ? "#999" : Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                } // End of GridLayout

                // ========================================
                // Card 5: Custom Styled Switches
                // ========================================
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customSwitchesCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customSwitchesCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Styled Switches"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted toggles built from scratch with Rectangle, MouseArea, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // ── Row 1: Icon Toggle Cards ──────────────
                        Label {
                            text: "Icon Toggles"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Repeater {
                                model: [
                                    { icon: "\uD83D\uDCF6", label: "Wi-Fi",    accent: "#4FC3F7" },
                                    { icon: "\u2699",        label: "Gear",     accent: "#FF8A65" },
                                    { icon: "\uD83D\uDD14", label: "Alerts",   accent: "#FFD54F" },
                                    { icon: "\uD83D\uDCCD", label: "Location", accent: "#81C784" },
                                    { icon: "\u2708",        label: "Flight",   accent: "#CE93D8" }
                                ]

                                Rectangle {
                                    id: iconToggle
                                    required property var modelData
                                    required property int index

                                    property bool on: index === 0 || index === 3

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(90)
                                    radius: Style.resize(12)
                                    color: on ? Qt.rgba(Qt.color(modelData.accent).r,
                                                        Qt.color(modelData.accent).g,
                                                        Qt.color(modelData.accent).b, 0.15)
                                             : Style.surfaceColor
                                    border.color: on ? modelData.accent : "#3A3D45"
                                    border.width: on ? 2 : 1

                                    Behavior on color { ColorAnimation { duration: 250 } }
                                    Behavior on border.color { ColorAnimation { duration: 250 } }

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(6)

                                        Label {
                                            text: iconToggle.modelData.icon
                                            font.pixelSize: Style.resize(28)
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter
                                            opacity: iconToggle.on ? 1.0 : 0.4

                                            Behavior on opacity { NumberAnimation { duration: 200 } }
                                        }

                                        Label {
                                            text: iconToggle.modelData.label
                                            font.pixelSize: Style.resize(11)
                                            font.bold: true
                                            color: iconToggle.on ? iconToggle.modelData.accent
                                                                 : Style.fontSecondaryColor
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter

                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: iconToggle.on = !iconToggle.on
                                    }
                                }
                            }
                        }

                        // ── Row 2: Colored Track Switches ─────────
                        Label {
                            text: "Colored Track Switches"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: Style.resize(20)
                            rowSpacing: Style.resize(12)

                            Repeater {
                                model: [
                                    { label: "Notifications", color: "#4FC3F7", checked: true },
                                    { label: "Do Not Disturb", color: "#EF5350", checked: false },
                                    { label: "Auto-Sync", color: "#66BB6A", checked: true },
                                    { label: "Power Saver", color: "#FFA726", checked: false }
                                ]

                                RowLayout {
                                    id: colorSwitchRow
                                    required property var modelData
                                    required property int index

                                    property bool on: modelData.checked

                                    Layout.fillWidth: true
                                    spacing: Style.resize(12)

                                    // Custom track
                                    Rectangle {
                                        id: colorTrack
                                        width: Style.resize(52)
                                        height: Style.resize(28)
                                        radius: height / 2
                                        color: colorSwitchRow.on
                                               ? colorSwitchRow.modelData.color
                                               : "#3A3D45"

                                        Behavior on color { ColorAnimation { duration: 250 } }

                                        // Knob
                                        Rectangle {
                                            id: colorKnob
                                            width: Style.resize(22)
                                            height: width
                                            radius: width / 2
                                            color: "white"
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: colorSwitchRow.on
                                               ? parent.width - width - Style.resize(3)
                                               : Style.resize(3)

                                            Behavior on x {
                                                NumberAnimation {
                                                    duration: 200
                                                    easing.type: Easing.InOutQuad
                                                }
                                            }

                                            // Shadow
                                            layer.enabled: true
                                            layer.effect: Item {}
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: colorSwitchRow.on = !colorSwitchRow.on
                                        }
                                    }

                                    Label {
                                        text: colorSwitchRow.modelData.label
                                        font.pixelSize: Style.resize(14)
                                        color: colorSwitchRow.on ? "white" : Style.fontSecondaryColor
                                        Layout.fillWidth: true

                                        Behavior on color { ColorAnimation { duration: 200 } }
                                    }
                                }
                            }
                        }

                        // ── Row 3: Pill ON/OFF Toggle ─────────────
                        Label {
                            text: "Pill Toggles with Text"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Repeater {
                                model: [
                                    { label: "GPS",     color: "#66BB6A" },
                                    { label: "NFC",     color: "#42A5F5" },
                                    { label: "VPN",     color: "#AB47BC" },
                                    { label: "Hotspot", color: "#FF7043" }
                                ]

                                Rectangle {
                                    id: pillToggle
                                    required property var modelData
                                    required property int index

                                    property bool on: index % 2 === 0

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(44)
                                    radius: height / 2
                                    color: on ? modelData.color : Style.surfaceColor
                                    border.color: on ? modelData.color : "#3A3D45"
                                    border.width: 1

                                    Behavior on color { ColorAnimation { duration: 300 } }
                                    Behavior on border.color { ColorAnimation { duration: 300 } }

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(6)

                                        Label {
                                            text: pillToggle.modelData.label
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: pillToggle.on ? "white" : Style.fontSecondaryColor

                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }

                                        Label {
                                            text: pillToggle.on ? "ON" : "OFF"
                                            font.pixelSize: Style.resize(11)
                                            font.bold: true
                                            color: pillToggle.on ? Qt.rgba(1,1,1,0.7) : Style.inactiveColor
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: pillToggle.on = !pillToggle.on
                                    }
                                }
                            }
                        }

                        // ── Row 4: Day/Night Toggle ───────────────
                        Label {
                            text: "Day / Night Switch"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(80)

                            property bool isNight: true

                            Rectangle {
                                id: dayNightTrack
                                anchors.centerIn: parent
                                width: Style.resize(160)
                                height: Style.resize(60)
                                radius: height / 2
                                color: parent.isNight ? "#1A237E" : "#42A5F5"

                                Behavior on color { ColorAnimation { duration: 500 } }

                                // Stars (visible at night)
                                Repeater {
                                    model: [
                                        { sx: 0.2, sy: 0.25, size: 3 },
                                        { sx: 0.35, sy: 0.6, size: 2 },
                                        { sx: 0.7, sy: 0.2, size: 2.5 },
                                        { sx: 0.8, sy: 0.65, size: 2 },
                                        { sx: 0.55, sy: 0.35, size: 1.5 }
                                    ]

                                    Rectangle {
                                        required property var modelData
                                        x: dayNightTrack.width * modelData.sx
                                        y: dayNightTrack.height * modelData.sy
                                        width: modelData.size
                                        height: width
                                        radius: width / 2
                                        color: "white"
                                        opacity: dayNightTrack.parent.isNight ? 0.8 : 0.0

                                        Behavior on opacity { NumberAnimation { duration: 400 } }
                                    }
                                }

                                // Knob (sun / moon)
                                Rectangle {
                                    id: dayNightKnob
                                    width: Style.resize(48)
                                    height: width
                                    radius: width / 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: dayNightTrack.parent.isNight
                                       ? parent.width - width - Style.resize(6)
                                       : Style.resize(6)
                                    color: dayNightTrack.parent.isNight ? "#ECEFF1" : "#FFD54F"

                                    Behavior on x {
                                        NumberAnimation {
                                            duration: 400
                                            easing.type: Easing.InOutCubic
                                        }
                                    }
                                    Behavior on color { ColorAnimation { duration: 400 } }

                                    // Moon crater (night only)
                                    Rectangle {
                                        x: parent.width * 0.55
                                        y: parent.height * 0.2
                                        width: parent.width * 0.2
                                        height: width
                                        radius: width / 2
                                        color: Qt.darker(parent.color, 1.15)
                                        opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                                        Behavior on opacity { NumberAnimation { duration: 300 } }
                                    }

                                    Rectangle {
                                        x: parent.width * 0.3
                                        y: parent.height * 0.55
                                        width: parent.width * 0.15
                                        height: width
                                        radius: width / 2
                                        color: Qt.darker(parent.color, 1.15)
                                        opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                                        Behavior on opacity { NumberAnimation { duration: 300 } }
                                    }

                                    // Sun rays (day only)
                                    Repeater {
                                        model: 8

                                        Rectangle {
                                            required property int index
                                            property real angle: index * 45

                                            width: Style.resize(3)
                                            height: Style.resize(8)
                                            radius: width / 2
                                            color: "#FFD54F"
                                            opacity: dayNightTrack.parent.isNight ? 0.0 : 0.9
                                            anchors.centerIn: parent
                                            anchors.verticalCenterOffset: -parent.width * 0.55

                                            transform: Rotation {
                                                origin.x: width / 2
                                                origin.y: parent.width * 0.55
                                                angle: parent.angle
                                            }

                                            Behavior on opacity { NumberAnimation { duration: 300 } }
                                        }
                                    }

                                    Label {
                                        anchors.centerIn: parent
                                        text: dayNightTrack.parent.isNight ? "\uD83C\uDF19" : "\u2600"
                                        font.pixelSize: Style.resize(20)
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: dayNightTrack.parent.isNight = !dayNightTrack.parent.isNight
                                }
                            }

                            // Status text
                            Label {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: parent.isNight ? "Night Mode" : "Day Mode"
                                font.pixelSize: Style.resize(14)
                                color: parent.isNight ? "#90CAF9" : "#FFD54F"
                                font.bold: true

                                Behavior on color { ColorAnimation { duration: 400 } }
                            }
                        }

                        // ── Row 5: Large Knob Toggles ─────────────
                        Label {
                            text: "Large Knob Toggles"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(20)

                            Repeater {
                                model: [
                                    { icon: "\uD83D\uDD0A", offIcon: "\uD83D\uDD07", label: "Sound",  color: "#7E57C2" },
                                    { icon: "\uD83D\uDD06", offIcon: "\uD83D\uDD05", label: "Screen", color: "#26A69A" },
                                    { icon: "\uD83D\uDD12", offIcon: "\uD83D\uDD13", label: "Lock",   color: "#EF5350" },
                                    { icon: "\u26A1",        offIcon: "\uD83D\uDD0C", label: "Power",  color: "#FFA726" }
                                ]

                                Item {
                                    id: largeToggleItem
                                    required property var modelData
                                    required property int index

                                    property bool on: index < 2

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(100)

                                    ColumnLayout {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: Style.resize(8)

                                        // Large circular knob
                                        Rectangle {
                                            id: largeKnob
                                            Layout.preferredWidth: Style.resize(64)
                                            Layout.preferredHeight: Style.resize(64)
                                            Layout.alignment: Qt.AlignHCenter
                                            radius: width / 2
                                            color: largeToggleItem.on
                                                   ? largeToggleItem.modelData.color
                                                   : Style.surfaceColor
                                            border.color: largeToggleItem.on
                                                          ? Qt.lighter(largeToggleItem.modelData.color, 1.3)
                                                          : "#3A3D45"
                                            border.width: 2

                                            Behavior on color { ColorAnimation { duration: 250 } }
                                            Behavior on border.color { ColorAnimation { duration: 250 } }

                                            scale: knobMa.pressed ? 0.9 : (knobMa.containsMouse ? 1.05 : 1.0)
                                            Behavior on scale { NumberAnimation { duration: 150 } }

                                            Label {
                                                anchors.centerIn: parent
                                                text: largeToggleItem.on
                                                      ? largeToggleItem.modelData.icon
                                                      : largeToggleItem.modelData.offIcon
                                                font.pixelSize: Style.resize(26)
                                            }

                                            MouseArea {
                                                id: knobMa
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: largeToggleItem.on = !largeToggleItem.on
                                            }
                                        }

                                        Label {
                                            text: largeToggleItem.modelData.label
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: largeToggleItem.on
                                                   ? largeToggleItem.modelData.color
                                                   : Style.fontSecondaryColor
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.alignment: Qt.AlignHCenter

                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }
                                    }
                                }
                            }
                        }

                        // ── Row 6: Square Segment Toggle ──────────
                        Label {
                            text: "Segmented Toggle"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        Item {
                            id: segmentedItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(50)

                            property int selectedSegment: 1

                            Rectangle {
                                anchors.centerIn: parent
                                width: Style.resize(400)
                                height: Style.resize(42)
                                radius: Style.resize(8)
                                color: Style.surfaceColor
                                border.color: "#3A3D45"
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(3)
                                    spacing: Style.resize(3)

                                    Repeater {
                                        model: [
                                            { text: "\u2600  Light",   idx: 0 },
                                            { text: "\uD83C\uDF19  Dark",    idx: 1 },
                                            { text: "\u2699  System",  idx: 2 }
                                        ]

                                        Rectangle {
                                            id: segItem
                                            required property var modelData

                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: Style.resize(6)
                                            color: segmentedItem.selectedSegment === modelData.idx
                                                   ? Style.mainColor : "transparent"

                                            Behavior on color { ColorAnimation { duration: 200 } }

                                            Label {
                                                anchors.centerIn: parent
                                                text: segItem.modelData.text
                                                font.pixelSize: Style.resize(13)
                                                font.bold: true
                                                color: segmentedItem.selectedSegment === segItem.modelData.idx
                                                       ? "#1A1D23" : Style.fontSecondaryColor
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: segmentedItem.selectedSegment = segItem.modelData.idx
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
