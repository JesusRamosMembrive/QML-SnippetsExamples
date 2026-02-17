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
                    text: "Text Input Examples"
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
                    // Card 1: TextField
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
                                text: "TextField"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Basic TextField
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(5)

                                Label {
                                    text: "Basic text input:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                TextField {
                                    id: nameField
                                    Layout.fillWidth: true
                                    placeholderText: "Enter your name"
                                }
                            }

                            // Password TextField
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(5)

                                Label {
                                    text: "Password (echoMode: Password):"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                TextField {
                                    id: passwordField
                                    Layout.fillWidth: true
                                    placeholderText: "Enter password"
                                    echoMode: TextInput.Password
                                }
                            }

                            // Numbers-only TextField
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(5)

                                Label {
                                    text: "Numbers only (with validator):"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                TextField {
                                    id: numberField
                                    Layout.fillWidth: true
                                    placeholderText: "Numbers only"
                                    validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }
                                    inputMethodHints: Qt.ImhDigitsOnly
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: "Name: " + (nameField.text || "-")
                                      + "  |  Password: " + (passwordField.text.length > 0 ? passwordField.text.length + " chars" : "-")
                                      + "  |  Number: " + (numberField.text || "-")
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Label {
                                text: "TextField provides single-line text input with validation and echo modes"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 2: TextArea
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
                                text: "TextArea"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                text: "Multi-line text input with word wrap:"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                            }

                            TextArea {
                                id: messageArea
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(150)
                                placeholderText: "Type your message here..."
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Characters: " + messageArea.text.length + " / 200"
                                    font.pixelSize: Style.resize(13)
                                    color: messageArea.text.length > 200 ? "#FF5900" : Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }

                                GradientButton {
                                    text: "Clear"
                                    startColor: "#FF5900"
                                    endColor: "#FF8C00"
                                    width: Style.resize(80)
                                    height: Style.resize(32)
                                    onClicked: messageArea.text = ""
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: "TextArea provides multi-line text editing with word wrap and scrolling"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 3: ComboBox & SpinBox
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
                                text: "ComboBox & SpinBox"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // ComboBox
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(5)

                                Label {
                                    text: "Color (ComboBox):"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                ComboBox {
                                    id: colorCombo
                                    Layout.fillWidth: true
                                    model: ["Red", "Green", "Blue", "Orange", "Purple"]
                                }
                            }

                            // SpinBox - Radius
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Style.resize(5)

                                    Label {
                                        text: "Radius (SpinBox):"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.fontSecondaryColor
                                    }

                                    SpinBox {
                                        id: radiusSpin
                                        from: 0
                                        to: 50
                                        stepSize: 5
                                        value: 10
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Style.resize(5)

                                    Label {
                                        text: "Size (SpinBox):"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.fontSecondaryColor
                                    }

                                    SpinBox {
                                        id: sizeSpin
                                        from: 50
                                        to: 200
                                        stepSize: 10
                                        value: 100
                                    }
                                }
                            }

                            // Preview Rectangle
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumHeight: Style.resize(100)

                                Rectangle {
                                    id: previewRect
                                    anchors.centerIn: parent
                                    width: sizeSpin.value
                                    height: sizeSpin.value
                                    radius: radiusSpin.value
                                    color: {
                                        switch (colorCombo.currentIndex) {
                                            case 0: return "#E74C3C";
                                            case 1: return "#2ECC71";
                                            case 2: return "#3498DB";
                                            case 3: return "#E67E22";
                                            case 4: return "#9B59B6";
                                            default: return "#E74C3C";
                                        }
                                    }

                                    Behavior on width { NumberAnimation { duration: 200 } }
                                    Behavior on height { NumberAnimation { duration: 200 } }
                                    Behavior on radius { NumberAnimation { duration: 200 } }
                                    Behavior on color { ColorAnimation { duration: 200 } }

                                    Label {
                                        anchors.centerIn: parent
                                        text: previewRect.width.toFixed(0) + "x" + previewRect.height.toFixed(0)
                                              + " r:" + previewRect.radius.toFixed(0)
                                        color: "white"
                                        font.pixelSize: Style.resize(11)
                                        font.bold: true
                                    }
                                }
                            }

                            Label {
                                text: "ComboBox provides dropdown selection, SpinBox provides bounded numeric input"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Interactive Demo - Form Builder
                    // ========================================
                    Rectangle {
                        id: formCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        property bool submitted: false
                        property string summary: ""

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(12)

                            Label {
                                text: "Interactive Demo - Form Builder"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Name
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(3)

                                Label {
                                    text: "Full Name:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                TextField {
                                    id: formName
                                    Layout.fillWidth: true
                                    placeholderText: "John Doe"
                                }
                            }

                            // Department
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(3)

                                Label {
                                    text: "Department:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                ComboBox {
                                    id: formDept
                                    Layout.fillWidth: true
                                    model: ["Engineering", "Design", "Marketing", "Sales"]
                                }
                            }

                            // Years of Experience
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Years of Experience:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                SpinBox {
                                    id: formYears
                                    from: 0
                                    to: 30
                                    value: 0
                                    stepSize: 1
                                }
                            }

                            // Bio
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(3)

                                Label {
                                    text: "Bio:"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }

                                TextArea {
                                    id: formBio
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(60)
                                    placeholderText: "Tell us about yourself..."
                                }
                            }

                            // Buttons
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                GlowButton {
                                    text: "Submit"
                                    glowColor: "#00D1A8"
                                    width: Style.resize(100)
                                    height: Style.resize(35)
                                    onClicked: {
                                        formCard.submitted = true;
                                        formCard.summary =
                                            formName.text + " | " + formDept.currentText
                                            + " | " + formYears.value + " yrs | "
                                            + (formBio.text.length > 0 ? formBio.text.substring(0, 30) + "..." : "No bio");
                                    }
                                }

                                PulseButton {
                                    text: "Reset"
                                    pulseColor: "#FF5900"
                                    width: Style.resize(100)
                                    height: Style.resize(35)
                                    onClicked: {
                                        formName.text = "";
                                        formDept.currentIndex = 0;
                                        formYears.value = 0;
                                        formBio.text = "";
                                        formCard.submitted = false;
                                        formCard.summary = "";
                                    }
                                }
                            }

                            // Summary
                            Label {
                                visible: parent.parent.submitted
                                text: "Submitted: " + parent.parent.summary
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: Style.mainColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Label {
                                text: "Combining all input controls into a practical form"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                } // End of GridLayout

                // ========================================
                // Card 5: Custom Input Controls
                // ========================================
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customInputsCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customInputsCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Input Controls"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted input components built from scratch with Rectangle, TextInput, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // ── 1: Custom Search Bar ──────────────────
                        Label {
                            text: "Search Bar"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: Style.resize(46)
                            radius: height / 2
                            color: Style.surfaceColor
                            border.color: searchInput.activeFocus ? Style.mainColor : "#3A3D45"
                            border.width: searchInput.activeFocus ? 2 : 1

                            Behavior on border.color { ColorAnimation { duration: 200 } }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(16)
                                anchors.rightMargin: Style.resize(12)
                                spacing: Style.resize(10)

                                // Search icon
                                Label {
                                    text: "\uD83D\uDD0D"
                                    font.pixelSize: Style.resize(18)
                                    opacity: searchInput.activeFocus ? 1.0 : 0.5

                                    Behavior on opacity { NumberAnimation { duration: 200 } }
                                }

                                TextInput {
                                    id: searchInput
                                    Layout.fillWidth: true
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                    clip: true
                                    selectByMouse: true
                                    selectionColor: Style.mainColor

                                    Text {
                                        anchors.fill: parent
                                        text: "Search anything..."
                                        font: parent.font
                                        color: Style.inactiveColor
                                        visible: !parent.text && !parent.activeFocus
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                // Clear button
                                Rectangle {
                                    width: Style.resize(24)
                                    height: width
                                    radius: width / 2
                                    color: clearMa.containsMouse ? "#4A4D55" : "transparent"
                                    visible: searchInput.text.length > 0

                                    Label {
                                        anchors.centerIn: parent
                                        text: "\u2715"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.fontSecondaryColor
                                    }

                                    MouseArea {
                                        id: clearMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: searchInput.text = ""
                                    }
                                }
                            }
                        }

                        // ── 2: PIN / OTP Input ────────────────────
                        Label {
                            text: "PIN / Verification Code"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        Item {
                            id: pinContainer
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(70)

                            property string pinValue: ""
                            property int pinLength: 6
                            property bool completed: pinValue.length === pinLength

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(10)

                                Repeater {
                                    model: pinContainer.pinLength

                                    Rectangle {
                                        id: pinBox
                                        required property int index

                                        width: Style.resize(48)
                                        height: Style.resize(56)
                                        radius: Style.resize(10)
                                        color: Style.surfaceColor
                                        border.color: {
                                            if (pinContainer.completed) return Style.mainColor
                                            if (index === pinContainer.pinValue.length) return Style.mainColor
                                            if (index < pinContainer.pinValue.length) return "#4FC3F7"
                                            return "#3A3D45"
                                        }
                                        border.width: index === pinContainer.pinValue.length ? 2 : 1

                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        scale: index === pinContainer.pinValue.length ? 1.05 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 150 } }

                                        Label {
                                            anchors.centerIn: parent
                                            text: index < pinContainer.pinValue.length
                                                  ? pinContainer.pinValue.charAt(index) : ""
                                            font.pixelSize: Style.resize(22)
                                            font.bold: true
                                            color: pinContainer.completed ? Style.mainColor : "white"

                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }

                                        // Cursor blink
                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: Style.resize(2)
                                            height: Style.resize(24)
                                            color: Style.mainColor
                                            visible: index === pinContainer.pinValue.length
                                                     && pinHiddenInput.activeFocus

                                            SequentialAnimation on opacity {
                                                running: visible
                                                loops: Animation.Infinite
                                                NumberAnimation { from: 1; to: 0; duration: 500 }
                                                NumberAnimation { from: 0; to: 1; duration: 500 }
                                            }
                                        }
                                    }
                                }

                                // Status
                                Label {
                                    text: pinContainer.completed ? "\u2705" : ""
                                    font.pixelSize: Style.resize(24)
                                    Layout.leftMargin: Style.resize(10)
                                }
                            }

                            // Hidden input to capture keyboard
                            TextInput {
                                id: pinHiddenInput
                                width: 1; height: 1
                                opacity: 0
                                maximumLength: pinContainer.pinLength
                                validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }
                                inputMethodHints: Qt.ImhDigitsOnly
                                onTextChanged: pinContainer.pinValue = text
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: pinHiddenInput.forceActiveFocus()
                            }

                            // Reset link
                            Label {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Reset"
                                font.pixelSize: Style.resize(12)
                                color: pinResetMa.containsMouse ? Style.mainColor : Style.fontSecondaryColor

                                MouseArea {
                                    id: pinResetMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { pinHiddenInput.text = ""; pinHiddenInput.forceActiveFocus() }
                                }
                            }
                        }

                        // ── 3: Tag Input ──────────────────────────
                        Label {
                            text: "Tag Input"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        Rectangle {
                            id: tagContainer
                            Layout.fillWidth: true
                            implicitHeight: tagFlow.implicitHeight + Style.resize(20)
                            radius: Style.resize(8)
                            color: Style.surfaceColor
                            border.color: tagInput.activeFocus ? Style.mainColor : "#3A3D45"
                            border.width: tagInput.activeFocus ? 2 : 1

                            Behavior on border.color { ColorAnimation { duration: 200 } }

                            property var tags: ["QML", "Qt Quick", "JavaScript"]

                            property var tagColors: [
                                "#4FC3F7", "#66BB6A", "#FF8A65",
                                "#CE93D8", "#FFD54F", "#EF5350",
                                "#26A69A", "#AB47BC", "#42A5F5"
                            ]

                            function addTag(text) {
                                var t = text.trim()
                                if (t.length > 0 && tags.indexOf(t) === -1) {
                                    tags = tags.concat([t])
                                }
                            }

                            function removeTag(idx) {
                                var copy = tags.slice()
                                copy.splice(idx, 1)
                                tags = copy
                            }

                            Flow {
                                id: tagFlow
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(6)

                                Repeater {
                                    model: tagContainer.tags.length

                                    Rectangle {
                                        id: tagChip
                                        required property int index

                                        property string tagText: tagContainer.tags[index]
                                        property string chipColor: tagContainer.tagColors[index % tagContainer.tagColors.length]

                                        width: chipRow.implicitWidth + Style.resize(16)
                                        height: Style.resize(30)
                                        radius: height / 2
                                        color: Qt.rgba(Qt.color(chipColor).r,
                                                       Qt.color(chipColor).g,
                                                       Qt.color(chipColor).b, 0.2)
                                        border.color: chipColor
                                        border.width: 1

                                        RowLayout {
                                            id: chipRow
                                            anchors.centerIn: parent
                                            spacing: Style.resize(4)

                                            Label {
                                                text: tagChip.tagText
                                                font.pixelSize: Style.resize(12)
                                                font.bold: true
                                                color: tagChip.chipColor
                                            }

                                            Label {
                                                text: "\u2715"
                                                font.pixelSize: Style.resize(10)
                                                color: tagChip.chipColor
                                                opacity: tagRemoveMa.containsMouse ? 1.0 : 0.6

                                                MouseArea {
                                                    id: tagRemoveMa
                                                    anchors.fill: parent
                                                    anchors.margins: -4
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: tagContainer.removeTag(tagChip.index)
                                                }
                                            }
                                        }
                                    }
                                }

                                // Inline text input
                                TextInput {
                                    id: tagInput
                                    width: Style.resize(180)
                                    height: Style.resize(30)
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontPrimaryColor
                                    clip: true
                                    verticalAlignment: TextInput.AlignVCenter
                                    selectByMouse: true
                                    selectionColor: Style.mainColor

                                    Text {
                                        anchors.fill: parent
                                        text: "Type and press Enter to add..."
                                        font: parent.font
                                        color: Style.inactiveColor
                                        visible: !parent.text && !parent.activeFocus
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Keys.onReturnPressed: {
                                        tagContainer.addTag(text)
                                        text = ""
                                    }
                                    Keys.onEnterPressed: {
                                        tagContainer.addTag(text)
                                        text = ""
                                    }
                                }
                            }
                        }

                        // ── 4: Inline Editable Labels ─────────────
                        Label {
                            text: "Click-to-Edit Labels"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: Style.resize(15)
                            rowSpacing: Style.resize(10)

                            Repeater {
                                model: [
                                    { label: "Project Name", value: "QML Snippets", color: "#4FC3F7" },
                                    { label: "Version", value: "1.0.0", color: "#66BB6A" },
                                    { label: "Author", value: "Developer", color: "#FF8A65" },
                                    { label: "License", value: "MIT", color: "#CE93D8" }
                                ]

                                Rectangle {
                                    id: editableField
                                    required property var modelData
                                    required property int index

                                    property bool editing: false
                                    property string currentValue: modelData.value

                                    Layout.fillWidth: true
                                    height: Style.resize(60)
                                    radius: Style.resize(8)
                                    color: editing ? Style.surfaceColor : "transparent"
                                    border.color: editing ? modelData.color : "transparent"
                                    border.width: editing ? 2 : 0

                                    Behavior on color { ColorAnimation { duration: 200 } }

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(10)
                                        spacing: Style.resize(2)

                                        Label {
                                            text: editableField.modelData.label
                                            font.pixelSize: Style.resize(11)
                                            font.bold: true
                                            color: editableField.modelData.color
                                        }

                                        // Display mode
                                        Label {
                                            visible: !editableField.editing
                                            text: editableField.currentValue
                                            font.pixelSize: Style.resize(15)
                                            color: Style.fontPrimaryColor
                                            Layout.fillWidth: true

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    editableField.editing = true
                                                    inlineEditor.text = editableField.currentValue
                                                    inlineEditor.forceActiveFocus()
                                                    inlineEditor.selectAll()
                                                }
                                            }
                                        }

                                        // Edit mode
                                        TextInput {
                                            id: inlineEditor
                                            visible: editableField.editing
                                            font.pixelSize: Style.resize(15)
                                            color: Style.fontPrimaryColor
                                            Layout.fillWidth: true
                                            selectByMouse: true
                                            selectionColor: editableField.modelData.color

                                            Keys.onReturnPressed: {
                                                editableField.currentValue = text
                                                editableField.editing = false
                                            }
                                            Keys.onEscapePressed: {
                                                editableField.editing = false
                                            }
                                            onActiveFocusChanged: {
                                                if (!activeFocus && editableField.editing) {
                                                    editableField.currentValue = text
                                                    editableField.editing = false
                                                }
                                            }
                                        }
                                    }

                                    // Edit hint icon
                                    Label {
                                        anchors.right: parent.right
                                        anchors.rightMargin: Style.resize(10)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: editableField.editing ? "\u2705" : "\u270F"
                                        font.pixelSize: Style.resize(14)
                                        opacity: editableField.editing ? 1.0 : 0.4
                                    }
                                }
                            }
                        }

                        // ── 5: Star Rating ────────────────────────
                        Label {
                            text: "Star Rating"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        Item {
                            id: ratingItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(50)

                            property int rating: 3
                            property int hoverRating: -1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(8)

                                Repeater {
                                    model: 5

                                    Label {
                                        id: starLabel
                                        required property int index

                                        property bool filled: {
                                            var r = ratingItem.hoverRating >= 0
                                                    ? ratingItem.hoverRating : ratingItem.rating
                                            return index < r
                                        }

                                        text: filled ? "\u2605" : "\u2606"
                                        font.pixelSize: Style.resize(36)
                                        color: filled ? "#FFD54F" : Style.inactiveColor

                                        scale: starMa.containsMouse ? 1.2 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                        Behavior on color { ColorAnimation { duration: 150 } }

                                        MouseArea {
                                            id: starMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: ratingItem.rating = starLabel.index + 1
                                            onEntered: ratingItem.hoverRating = starLabel.index + 1
                                            onExited: ratingItem.hoverRating = -1
                                        }
                                    }
                                }

                                Label {
                                    text: ratingItem.rating + " / 5"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: "#FFD54F"
                                    Layout.leftMargin: Style.resize(15)
                                }
                            }
                        }

                        // ── 6: Character Limit with Progress ──────
                        Label {
                            text: "Character Limit with Progress Ring"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(46)
                                radius: Style.resize(8)
                                color: Style.surfaceColor
                                border.color: limitInput.activeFocus ? progressColor : "#3A3D45"
                                border.width: limitInput.activeFocus ? 2 : 1

                                property real progress: limitInput.text.length / 140
                                property string progressColor: {
                                    if (progress > 0.9) return "#EF5350"
                                    if (progress > 0.7) return "#FFA726"
                                    return Style.mainColor
                                }

                                Behavior on border.color { ColorAnimation { duration: 200 } }

                                TextInput {
                                    id: limitInput
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(12)
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                    clip: true
                                    maximumLength: 140
                                    selectByMouse: true
                                    selectionColor: Style.mainColor
                                    verticalAlignment: TextInput.AlignVCenter

                                    Text {
                                        anchors.fill: parent
                                        text: "Tweet something (140 chars max)..."
                                        font: parent.font
                                        color: Style.inactiveColor
                                        visible: !parent.text && !parent.activeFocus
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }

                            // Progress ring
                            Item {
                                width: Style.resize(44)
                                height: Style.resize(44)

                                property real progress: limitInput.text.length / 140
                                property string ringColor: {
                                    if (progress > 0.9) return "#EF5350"
                                    if (progress > 0.7) return "#FFA726"
                                    return Style.mainColor
                                }

                                Canvas {
                                    id: progressRing
                                    anchors.fill: parent

                                    property real prog: parent.progress
                                    property string rColor: parent.ringColor

                                    onProgChanged: requestPaint()

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var w = width
                                        var h = height
                                        var cx = w / 2
                                        var cy = h / 2
                                        var r = Math.min(cx, cy) - 4
                                        var startAngle = -Math.PI / 2

                                        ctx.clearRect(0, 0, w, h)

                                        // Background ring
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                                        ctx.strokeStyle = "#3A3D45"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // Progress arc
                                        if (prog > 0) {
                                            ctx.beginPath()
                                            ctx.arc(cx, cy, r, startAngle,
                                                    startAngle + 2 * Math.PI * Math.min(prog, 1))
                                            ctx.strokeStyle = rColor
                                            ctx.lineWidth = 3
                                            ctx.lineCap = "round"
                                            ctx.stroke()
                                        }
                                    }
                                }

                                Label {
                                    anchors.centerIn: parent
                                    text: 140 - limitInput.text.length
                                    font.pixelSize: Style.resize(11)
                                    font.bold: true
                                    color: parent.ringColor
                                }
                            }
                        }

                        // ── 7: Color Picker Input ─────────────────
                        Label {
                            text: "Color Picker"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.topMargin: Style.resize(5)
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(10)

                            property string selectedColor: "#00D1A9"

                            // Color swatches
                            Repeater {
                                model: [
                                    "#EF5350", "#FF7043", "#FFA726", "#FFCA28",
                                    "#66BB6A", "#26A69A", "#00D1A9", "#42A5F5",
                                    "#5C6BC0", "#AB47BC", "#EC407A", "#8D6E63"
                                ]

                                Rectangle {
                                    id: swatch
                                    required property string modelData
                                    required property int index

                                    width: Style.resize(32)
                                    height: Style.resize(32)
                                    radius: Style.resize(6)
                                    color: modelData
                                    border.color: parent.selectedColor === modelData
                                                  ? "white" : "transparent"
                                    border.width: 2

                                    scale: swatchMa.containsMouse ? 1.15 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }

                                    MouseArea {
                                        id: swatchMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: swatch.parent.selectedColor = swatch.modelData
                                    }
                                }
                            }

                            Item { Layout.fillWidth: true }

                            // Selected color preview + hex
                            Rectangle {
                                width: Style.resize(120)
                                height: Style.resize(32)
                                radius: Style.resize(6)
                                color: parent.selectedColor

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.parent.selectedColor
                                    font.pixelSize: Style.resize(12)
                                    font.bold: true
                                    font.family: "monospace"
                                    color: "white"
                                }
                            }
                        }
                    }
                }

            }
        }
    }
}
