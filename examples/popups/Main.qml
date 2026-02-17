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

    // ========================================
    // Dialogs (defined at root level for proper overlay)
    // ========================================

    // Info Dialog
    Dialog {
        id: infoDialog
        title: "Information"
        standardButtons: Dialog.Ok

        Label {
            text: "This is a simple informational dialog.\nIt displays a message to the user."
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
        }
    }

    // Confirm Dialog
    Dialog {
        id: confirmDialog
        title: "Confirm Action"
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: "Are you sure you want to proceed?\nThis action can be reversed."
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
        }

        onAccepted: confirmResultLabel.text = "Result: Accepted"
        onRejected: confirmResultLabel.text = "Result: Rejected"
    }

    // Input Dialog
    Dialog {
        id: inputDialog
        title: "Enter Text"
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            anchors.fill: parent
            spacing: Style.resize(10)

            Label {
                text: "Please enter your name:"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            TextField {
                id: inputDialogField
                Layout.fillWidth: true
                placeholderText: "Type here..."
            }
        }

        onAccepted: inputResultLabel.text = "Entered: " + inputDialogField.text
        onRejected: inputResultLabel.text = "Cancelled"
        onOpened: {
            inputDialogField.text = ""
            inputDialogField.forceActiveFocus()
        }
    }

    // Basic Popup
    Popup {
        id: basicPopup
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        width: Style.resize(250)
        height: Style.resize(150)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        modal: false

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(8)
            border.color: Style.mainColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(10)

            Label {
                text: "Basic Popup"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "Click outside or press Esc to close"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Button {
                text: "Close"
                onClicked: basicPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 100 }
        }
    }

    // Modal Popup
    Popup {
        id: modalPopup
        anchors.centerIn: parent
        width: Style.resize(300)
        height: Style.resize(200)
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        parent: Overlay.overlay

        Overlay.modal: Rectangle {
            color: Qt.rgba(0, 0, 0, 0.4)
        }

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(12)
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(15)

            Label {
                text: "Modal Popup"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "The background is dimmed.\nInteraction is blocked until this is closed."
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            Button {
                text: "Got it"
                onClicked: modalPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
        }
    }

    // Dropdown Menu
    Menu {
        id: dropdownMenu

        MenuItem {
            text: "Cut"
            onTriggered: menuResultLabel.text = "Selected: Cut"
        }
        MenuItem {
            text: "Copy"
            onTriggered: menuResultLabel.text = "Selected: Copy"
        }
        MenuItem {
            text: "Paste"
            onTriggered: menuResultLabel.text = "Selected: Paste"
        }

        MenuSeparator {}

        MenuItem {
            text: "Bold"
            checkable: true
            checked: true
            onTriggered: menuResultLabel.text = "Bold: " + (checked ? "ON" : "OFF")
        }
        MenuItem {
            text: "Italic"
            checkable: true
            onTriggered: menuResultLabel.text = "Italic: " + (checked ? "ON" : "OFF")
        }
    }

    // Context Menu
    Menu {
        id: contextMenu

        MenuItem {
            text: "Select All"
            onTriggered: menuResultLabel.text = "Context: Select All"
        }
        MenuItem {
            text: "Delete"
            onTriggered: menuResultLabel.text = "Context: Delete"
        }

        MenuSeparator {}

        MenuItem {
            text: "Properties"
            onTriggered: menuResultLabel.text = "Context: Properties"
        }
    }

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
                    text: "Popups & Dialogs Examples"
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
                    // Card 1: Dialog
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
                                text: "Dialog"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Info Dialog button
                            Button {
                                text: "Info Dialog"
                                Layout.fillWidth: true
                                onClicked: infoDialog.open()
                            }

                            // Confirm Dialog button + result
                            Button {
                                text: "Confirm Dialog"
                                Layout.fillWidth: true
                                onClicked: confirmDialog.open()
                            }

                            Label {
                                id: confirmResultLabel
                                text: "Result: —"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                            }

                            // Input Dialog button + result
                            Button {
                                text: "Input Dialog"
                                Layout.fillWidth: true
                                onClicked: inputDialog.open()
                            }

                            Label {
                                id: inputResultLabel
                                text: "Entered: —"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontSecondaryColor
                            }

                            Item { Layout.fillHeight: true }

                            Label {
                                text: "Dialog provides modal windows for user interaction with standard buttons"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: Popup
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
                                text: "Popup"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Button {
                                text: "Basic Popup"
                                Layout.fillWidth: true
                                onClicked: basicPopup.open()
                            }

                            Button {
                                text: "Modal Popup"
                                Layout.fillWidth: true
                                onClicked: modalPopup.open()
                            }

                            Item { Layout.fillHeight: true }

                            // Popup comparison info
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: infoColumn.implicitHeight + Style.resize(20)
                                color: Style.bgColor
                                radius: Style.resize(6)

                                ColumnLayout {
                                    id: infoColumn
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "Basic vs Modal:"
                                        font.pixelSize: Style.resize(13)
                                        font.bold: true
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        text: "• Basic: no overlay, click outside to close"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.fillWidth: true
                                    }

                                    Label {
                                        text: "• Modal: dims background, blocks interaction"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            Label {
                                text: "Popup shows overlay content with enter/exit transitions"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: ToolTip
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
                                text: "ToolTip"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Instant tooltip
                            Button {
                                text: "Instant ToolTip"
                                Layout.fillWidth: true
                                ToolTip.delay: 0
                                ToolTip.timeout: 3000
                                ToolTip.visible: hovered
                                ToolTip.text: "This appears immediately!"
                            }

                            // Short delay tooltip
                            Button {
                                text: "500ms Delay"
                                Layout.fillWidth: true
                                ToolTip.delay: 500
                                ToolTip.timeout: 3000
                                ToolTip.visible: hovered
                                ToolTip.text: "This appears after 500ms"
                            }

                            // Long delay tooltip
                            Button {
                                text: "1500ms Delay"
                                Layout.fillWidth: true
                                ToolTip.delay: 1500
                                ToolTip.timeout: 5000
                                ToolTip.visible: hovered
                                ToolTip.text: "This appears after 1.5 seconds"
                            }

                            Item { Layout.fillHeight: true }

                            // Hover area
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(60)
                                color: Style.bgColor
                                radius: Style.resize(8)
                                border.color: Style.inactiveColor
                                border.width: 1

                                Label {
                                    anchors.centerIn: parent
                                    text: "Hover over this area"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                MouseArea {
                                    id: hoverArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }

                                ToolTip {
                                    parent: hoverArea
                                    visible: hoverArea.containsMouse
                                    delay: 300
                                    timeout: 4000
                                    text: "ToolTips work on any item with a MouseArea"
                                }
                            }

                            Label {
                                text: "ToolTip shows contextual help on hover with configurable delay and timeout"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Menu
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
                                text: "Menu"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Dropdown menu button
                            Button {
                                id: menuButton
                                text: "Open Menu"
                                Layout.fillWidth: true
                                onClicked: dropdownMenu.popup(menuButton, 0, menuButton.height)
                            }

                            // Context menu area
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(80)
                                color: Style.bgColor
                                radius: Style.resize(8)
                                border.color: Style.inactiveColor
                                border.width: 1

                                Label {
                                    anchors.centerIn: parent
                                    text: "Right-click here"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.RightButton
                                    onClicked: function(mouse) {
                                        contextMenu.popup()
                                    }
                                }
                            }

                            // Result label
                            Label {
                                id: menuResultLabel
                                text: "Selected: —"
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Item { Layout.fillHeight: true }

                            // Menu info
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: menuInfoCol.implicitHeight + Style.resize(20)
                                color: Style.bgColor
                                radius: Style.resize(6)

                                ColumnLayout {
                                    id: menuInfoCol
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(4)

                                    Label {
                                        text: "Menu supports:"
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        text: "• Regular items, separators"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        text: "• Checkable items (Bold, Italic)"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }

                                    Label {
                                        text: "• Context menu (right-click)"
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                    }
                                }
                            }

                            Label {
                                text: "Menu provides dropdown and context menus with rich item types"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Popup Patterns
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3200)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Popup Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // ── Section 1: Toast Notifications ────────────────
                        Label {
                            text: "Toast Notifications"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: toastSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(300)

                            property var toasts: []
                            property int nextId: 0

                            function addToast(type, message) {
                                var colors = {
                                    success: { bg: "#1A3A2A", border: "#34C759", icon: "✓" },
                                    error:   { bg: "#3A1A1A", border: "#FF3B30", icon: "✕" },
                                    warning: { bg: "#3A2E1A", border: "#FF9500", icon: "⚠" },
                                    info:    { bg: "#1A2A3A", border: "#5B8DEF", icon: "ℹ" }
                                }
                                var c = colors[type]
                                var t = toastSection.toasts.slice()
                                t.push({ id: toastSection.nextId++, type: type, msg: message,
                                         bg: c.bg, border: c.border, icon: c.icon, life: 4.0 })
                                if (t.length > 5) t.shift()
                                toastSection.toasts = t
                            }

                            Timer {
                                running: toastSection.toasts.length > 0
                                interval: 100
                                repeat: true
                                onTriggered: {
                                    var t = toastSection.toasts.slice()
                                    var alive = []
                                    for (var i = 0; i < t.length; i++) {
                                        t[i].life -= 0.1
                                        if (t[i].life > 0) alive.push(t[i])
                                    }
                                    toastSection.toasts = alive
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            // Trigger buttons
                            Row {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottomMargin: Style.resize(15)
                                spacing: Style.resize(10)
                                z: 1

                                Button {
                                    text: "✓ Success"
                                    flat: true
                                    font.pixelSize: Style.resize(11)
                                    onClicked: toastSection.addToast("success", "Operation completed successfully!")
                                }
                                Button {
                                    text: "✕ Error"
                                    flat: true
                                    font.pixelSize: Style.resize(11)
                                    onClicked: toastSection.addToast("error", "Connection failed. Please try again.")
                                }
                                Button {
                                    text: "⚠ Warning"
                                    flat: true
                                    font.pixelSize: Style.resize(11)
                                    onClicked: toastSection.addToast("warning", "Storage is almost full (92%)")
                                }
                                Button {
                                    text: "ℹ Info"
                                    flat: true
                                    font.pixelSize: Style.resize(11)
                                    onClicked: toastSection.addToast("info", "New version available: v2.4.1")
                                }
                            }

                            // Toast stack
                            Column {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.topMargin: Style.resize(10)
                                spacing: Style.resize(6)
                                width: parent.width * 0.85

                                Repeater {
                                    model: toastSection.toasts.length

                                    delegate: Rectangle {
                                        id: toastItem
                                        required property int index

                                        readonly property var toast: toastSection.toasts[toastItem.index] || {}
                                        readonly property real life: toast.life || 0

                                        width: parent.width
                                        height: Style.resize(46)
                                        radius: Style.resize(8)
                                        color: toast.bg || "transparent"
                                        border.color: toast.border || "transparent"
                                        border.width: Style.resize(1)
                                        opacity: Math.min(1, life * 2)

                                        Behavior on opacity {
                                            NumberAnimation { duration: 150 }
                                        }

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(12)
                                            spacing: Style.resize(10)

                                            Label {
                                                text: toastItem.toast.icon || ""
                                                font.pixelSize: Style.resize(16)
                                                color: toastItem.toast.border || "#FFF"
                                            }

                                            Label {
                                                text: toastItem.toast.msg || ""
                                                font.pixelSize: Style.resize(12)
                                                color: Style.fontPrimaryColor
                                                elide: Text.ElideRight
                                                Layout.fillWidth: true
                                            }

                                            // Progress bar showing remaining time
                                            Rectangle {
                                                Layout.preferredWidth: Style.resize(40)
                                                Layout.preferredHeight: Style.resize(3)
                                                radius: Style.resize(1)
                                                color: Qt.rgba(1, 1, 1, 0.1)

                                                Rectangle {
                                                    width: parent.width * Math.max(0, (toastItem.life / 4.0))
                                                    height: parent.height
                                                    radius: parent.radius
                                                    color: toastItem.toast.border || "#FFF"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 2: Alert Cards ────────────────────────
                        Label {
                            text: "Alert Cards"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Repeater {
                                model: [
                                    { type: "success", icon: "✓", title: "Success",
                                      msg: "Your changes have been saved successfully.",
                                      bg: "#1A3A2A", accent: "#34C759" },
                                    { type: "error", icon: "✕", title: "Error",
                                      msg: "Unable to connect to the server. Check your network.",
                                      bg: "#3A1A1A", accent: "#FF3B30" },
                                    { type: "warning", icon: "⚠", title: "Warning",
                                      msg: "This action cannot be undone. Proceed with caution.",
                                      bg: "#3A2E1A", accent: "#FF9500" },
                                    { type: "info", icon: "ℹ", title: "Information",
                                      msg: "Scheduled maintenance window: Sunday 2:00-4:00 AM UTC.",
                                      bg: "#1A2A3A", accent: "#5B8DEF" }
                                ]

                                delegate: Rectangle {
                                    id: alertCard
                                    required property var modelData
                                    required property int index

                                    property bool dismissed: false

                                    Layout.fillWidth: true
                                    height: dismissed ? 0 : Style.resize(70)
                                    radius: Style.resize(8)
                                    color: alertCard.modelData.bg
                                    border.color: Qt.rgba(
                                        Qt.color(alertCard.modelData.accent).r,
                                        Qt.color(alertCard.modelData.accent).g,
                                        Qt.color(alertCard.modelData.accent).b, 0.3)
                                    border.width: Style.resize(1)
                                    clip: true
                                    opacity: dismissed ? 0 : 1

                                    Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                                    Behavior on opacity { NumberAnimation { duration: 200 } }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(14)
                                        spacing: Style.resize(12)

                                        // Icon circle
                                        Rectangle {
                                            width: Style.resize(34)
                                            height: Style.resize(34)
                                            radius: width / 2
                                            color: Qt.rgba(
                                                Qt.color(alertCard.modelData.accent).r,
                                                Qt.color(alertCard.modelData.accent).g,
                                                Qt.color(alertCard.modelData.accent).b, 0.2)

                                            Label {
                                                anchors.centerIn: parent
                                                text: alertCard.modelData.icon
                                                font.pixelSize: Style.resize(16)
                                                font.bold: true
                                                color: alertCard.modelData.accent
                                            }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: Style.resize(2)

                                            Label {
                                                text: alertCard.modelData.title
                                                font.pixelSize: Style.resize(14)
                                                font.bold: true
                                                color: alertCard.modelData.accent
                                            }
                                            Label {
                                                text: alertCard.modelData.msg
                                                font.pixelSize: Style.resize(11)
                                                color: Style.fontSecondaryColor
                                                elide: Text.ElideRight
                                                Layout.fillWidth: true
                                            }
                                        }

                                        // Dismiss button
                                        Rectangle {
                                            width: Style.resize(24)
                                            height: Style.resize(24)
                                            radius: width / 2
                                            color: alertDismissMa.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"

                                            Label {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: Style.resize(12)
                                                color: Style.inactiveColor
                                            }

                                            MouseArea {
                                                id: alertDismissMa
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: alertCard.dismissed = true
                                            }
                                        }
                                    }
                                }
                            }

                            Button {
                                text: "Reset Alerts"
                                flat: true
                                font.pixelSize: Style.resize(11)
                                Layout.alignment: Qt.AlignHCenter
                                onClicked: {
                                    // Force re-creation by toggling visibility
                                    for (var i = 0; i < parent.children.length; i++) {
                                        var child = parent.children[i]
                                        if (child.dismissed !== undefined)
                                            child.dismissed = false
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 3: Bottom Sheet ───────────────────────
                        Label {
                            text: "Bottom Sheet"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: bottomSheetSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(350)
                            clip: true

                            property bool sheetOpen: false

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            // Background content
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(15)

                                Label {
                                    text: "Main Content Area"
                                    font.pixelSize: Style.resize(16)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Button {
                                    text: "Open Bottom Sheet"
                                    Layout.alignment: Qt.AlignHCenter
                                    onClicked: bottomSheetSection.sheetOpen = true
                                }
                            }

                            // Dim overlay
                            Rectangle {
                                anchors.fill: parent
                                color: Qt.rgba(0, 0, 0, 0.4)
                                opacity: bottomSheetSection.sheetOpen ? 1 : 0
                                visible: opacity > 0

                                Behavior on opacity { NumberAnimation { duration: 200 } }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: bottomSheetSection.sheetOpen = false
                                }
                            }

                            // Sheet
                            Rectangle {
                                id: bottomSheet
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: Style.resize(240)
                                radius: Style.resize(16)
                                color: Style.cardColor
                                y: bottomSheetSection.sheetOpen
                                   ? parent.height - height
                                   : parent.height

                                Behavior on y {
                                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(16)
                                    spacing: Style.resize(12)

                                    // Drag handle
                                    Rectangle {
                                        Layout.alignment: Qt.AlignHCenter
                                        width: Style.resize(40)
                                        height: Style.resize(4)
                                        radius: Style.resize(2)
                                        color: Qt.rgba(1, 1, 1, 0.2)
                                    }

                                    Label {
                                        text: "Share with"
                                        font.pixelSize: Style.resize(16)
                                        font.bold: true
                                        color: Style.fontPrimaryColor
                                    }

                                    // Share options
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Style.resize(15)
                                        Layout.alignment: Qt.AlignHCenter

                                        Repeater {
                                            model: [
                                                { name: "Email", icon: "✉", clr: "#5B8DEF" },
                                                { name: "Link", icon: "🔗", clr: "#00D1A9" },
                                                { name: "Twitter", icon: "𝕏", clr: "#1DA1F2" },
                                                { name: "Slack", icon: "#", clr: "#E01E5A" },
                                                { name: "Save", icon: "💾", clr: "#FF9500" }
                                            ]

                                            delegate: ColumnLayout {
                                                id: shareDelegate
                                                required property var modelData
                                                spacing: Style.resize(6)

                                                Rectangle {
                                                    Layout.preferredWidth: Style.resize(48)
                                                    Layout.preferredHeight: Style.resize(48)
                                                    Layout.alignment: Qt.AlignHCenter
                                                    radius: Style.resize(12)
                                                    color: Qt.rgba(
                                                        Qt.color(shareDelegate.modelData.clr).r,
                                                        Qt.color(shareDelegate.modelData.clr).g,
                                                        Qt.color(shareDelegate.modelData.clr).b, 0.15)

                                                    scale: shareMa.containsMouse ? 1.15 : 1.0
                                                    Behavior on scale { NumberAnimation { duration: 100 } }

                                                    Label {
                                                        anchors.centerIn: parent
                                                        text: shareDelegate.modelData.icon
                                                        font.pixelSize: Style.resize(20)
                                                    }

                                                    MouseArea {
                                                        id: shareMa
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: bottomSheetSection.sheetOpen = false
                                                    }
                                                }

                                                Label {
                                                    text: shareDelegate.modelData.name
                                                    font.pixelSize: Style.resize(10)
                                                    color: Style.fontSecondaryColor
                                                    Layout.alignment: Qt.AlignHCenter
                                                }
                                            }
                                        }
                                    }

                                    // Action buttons
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Style.resize(10)

                                        Button {
                                            text: "Copy Link"
                                            Layout.fillWidth: true
                                            onClicked: bottomSheetSection.sheetOpen = false
                                        }

                                        Button {
                                            text: "Cancel"
                                            flat: true
                                            Layout.fillWidth: true
                                            onClicked: bottomSheetSection.sheetOpen = false
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 4: Snackbar ───────────────────────────
                        Label {
                            text: "Snackbar with Action"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: snackbarSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(200)
                            clip: true

                            property bool snackVisible: false
                            property string snackMessage: ""
                            property string snackAction: ""
                            property int deletedCount: 0

                            function showSnack(msg, action) {
                                snackMessage = msg
                                snackAction = action
                                snackVisible = true
                                snackTimer.restart()
                            }

                            Timer {
                                id: snackTimer
                                interval: 4000
                                onTriggered: snackbarSection.snackVisible = false
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            // Demo content
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(12)

                                Label {
                                    text: "Deleted items: " + snackbarSection.deletedCount
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Row {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(10)

                                    Button {
                                        text: "Delete Item"
                                        onClicked: {
                                            snackbarSection.deletedCount++
                                            snackbarSection.showSnack(
                                                "Item deleted", "UNDO")
                                        }
                                    }

                                    Button {
                                        text: "Archive"
                                        flat: true
                                        onClicked: {
                                            snackbarSection.showSnack(
                                                "Conversation archived", "VIEW")
                                        }
                                    }

                                    Button {
                                        text: "Send"
                                        flat: true
                                        onClicked: {
                                            snackbarSection.showSnack(
                                                "Message sent to 3 recipients", "")
                                        }
                                    }
                                }
                            }

                            // Snackbar
                            Rectangle {
                                id: snackbar
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: snackbarSection.snackVisible ? Style.resize(12) : -height
                                width: Math.min(parent.width - Style.resize(30), Style.resize(400))
                                height: Style.resize(46)
                                radius: Style.resize(8)
                                color: "#323232"

                                Behavior on anchors.bottomMargin {
                                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Style.resize(16)
                                    anchors.rightMargin: Style.resize(8)
                                    spacing: Style.resize(10)

                                    Label {
                                        text: snackbarSection.snackMessage
                                        font.pixelSize: Style.resize(13)
                                        color: "#E0E0E0"
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Button {
                                        visible: snackbarSection.snackAction !== ""
                                        text: snackbarSection.snackAction
                                        flat: true
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        onClicked: {
                                            if (snackbarSection.snackAction === "UNDO")
                                                snackbarSection.deletedCount = Math.max(0, snackbarSection.deletedCount - 1)
                                            snackbarSection.snackVisible = false
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 5: Floating Action Menu (FAB) ─────────
                        Label {
                            text: "Floating Action Button"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: fabSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(280)
                            clip: true

                            property bool fabOpen: false
                            property string lastAction: ""

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            Label {
                                anchors.centerIn: parent
                                text: fabSection.lastAction || "Tap the + button"
                                font.pixelSize: Style.resize(14)
                                color: Style.fontSecondaryColor
                            }

                            // Dim overlay
                            Rectangle {
                                anchors.fill: parent
                                color: Qt.rgba(0, 0, 0, 0.3)
                                opacity: fabSection.fabOpen ? 1 : 0
                                visible: opacity > 0

                                Behavior on opacity { NumberAnimation { duration: 200 } }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: fabSection.fabOpen = false
                                }
                            }

                            // FAB menu items
                            Repeater {
                                model: [
                                    { label: "Camera", icon: "📷", clr: "#FF3B30", offset: 180 },
                                    { label: "Photo", icon: "🖼", clr: "#FF9500", offset: 130 },
                                    { label: "File", icon: "📁", clr: "#5B8DEF", offset: 80 }
                                ]

                                delegate: Item {
                                    id: fabMenuItem
                                    required property var modelData
                                    required property int index

                                    anchors.right: parent.right
                                    anchors.rightMargin: Style.resize(20)
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: fabSection.fabOpen
                                        ? Style.resize(fabMenuItem.modelData.offset)
                                        : Style.resize(20)
                                    width: fabMenuRow.implicitWidth
                                    height: Style.resize(42)
                                    opacity: fabSection.fabOpen ? 1 : 0
                                    scale: fabSection.fabOpen ? 1 : 0.5

                                    Behavior on anchors.bottomMargin {
                                        NumberAnimation {
                                            duration: 250
                                            easing.type: Easing.OutBack
                                        }
                                    }
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                                    Row {
                                        id: fabMenuRow
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: Style.resize(10)

                                        // Label chip
                                        Rectangle {
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: fabMenuLabel.implicitWidth + Style.resize(16)
                                            height: Style.resize(28)
                                            radius: Style.resize(6)
                                            color: Style.cardColor

                                            Label {
                                                id: fabMenuLabel
                                                anchors.centerIn: parent
                                                text: fabMenuItem.modelData.label
                                                font.pixelSize: Style.resize(12)
                                                color: Style.fontPrimaryColor
                                            }
                                        }

                                        // Circle button
                                        Rectangle {
                                            width: Style.resize(42)
                                            height: Style.resize(42)
                                            radius: width / 2
                                            color: fabMenuItem.modelData.clr

                                            Label {
                                                anchors.centerIn: parent
                                                text: fabMenuItem.modelData.icon
                                                font.pixelSize: Style.resize(18)
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    fabSection.lastAction = fabMenuItem.modelData.label + " selected"
                                                    fabSection.fabOpen = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Main FAB button
                            Rectangle {
                                id: fabButton
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: Style.resize(20)
                                width: Style.resize(52)
                                height: Style.resize(52)
                                radius: width / 2
                                color: Style.mainColor

                                rotation: fabSection.fabOpen ? 45 : 0
                                Behavior on rotation {
                                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                }

                                Label {
                                    anchors.centerIn: parent
                                    text: "+"
                                    font.pixelSize: Style.resize(28)
                                    font.bold: true
                                    color: "#000"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: fabSection.fabOpen = !fabSection.fabOpen
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 6: Command Palette ────────────────────
                        Label {
                            text: "Command Palette"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: paletteSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(350)
                            clip: true

                            property bool paletteOpen: false
                            property string selectedCmd: ""

                            readonly property var commands: [
                                { cmd: "Open File", shortcut: "Ctrl+O", icon: "📂", cat: "File" },
                                { cmd: "Save", shortcut: "Ctrl+S", icon: "💾", cat: "File" },
                                { cmd: "Find & Replace", shortcut: "Ctrl+H", icon: "🔍", cat: "Edit" },
                                { cmd: "Toggle Terminal", shortcut: "Ctrl+`", icon: "▸", cat: "View" },
                                { cmd: "Go to Definition", shortcut: "F12", icon: "→", cat: "Navigate" },
                                { cmd: "Run Build", shortcut: "Ctrl+B", icon: "⚙", cat: "Build" },
                                { cmd: "Git Commit", shortcut: "Ctrl+K", icon: "✓", cat: "Git" },
                                { cmd: "Toggle Sidebar", shortcut: "Ctrl+B", icon: "◧", cat: "View" },
                                { cmd: "Format Document", shortcut: "Alt+F", icon: "✎", cat: "Edit" },
                                { cmd: "Debug Start", shortcut: "F5", icon: "▶", cat: "Debug" }
                            ]

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                            }

                            // Background content
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(12)

                                Label {
                                    text: paletteSection.selectedCmd || "No command selected"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Button {
                                    text: "Open Command Palette"
                                    Layout.alignment: Qt.AlignHCenter
                                    onClicked: {
                                        paletteSection.paletteOpen = true
                                        paletteSearchField.text = ""
                                        paletteSearchField.forceActiveFocus()
                                    }
                                }
                            }

                            // Palette overlay
                            Rectangle {
                                anchors.fill: parent
                                color: Qt.rgba(0, 0, 0, 0.5)
                                opacity: paletteSection.paletteOpen ? 1 : 0
                                visible: opacity > 0

                                Behavior on opacity { NumberAnimation { duration: 150 } }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: paletteSection.paletteOpen = false
                                }
                            }

                            // Palette panel
                            Rectangle {
                                id: palettePanel
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: paletteSection.paletteOpen ? Style.resize(20) : -height
                                width: parent.width * 0.8
                                height: Style.resize(290)
                                radius: Style.resize(12)
                                color: Style.cardColor
                                border.color: Style.mainColor
                                border.width: Style.resize(1)

                                Behavior on anchors.topMargin {
                                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(12)
                                    spacing: Style.resize(8)

                                    // Search field
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(36)
                                        radius: Style.resize(8)
                                        color: Style.bgColor

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(8)
                                            spacing: Style.resize(8)

                                            Label {
                                                text: ">"
                                                font.pixelSize: Style.resize(14)
                                                font.bold: true
                                                color: Style.mainColor
                                            }

                                            TextInput {
                                                id: paletteSearchField
                                                Layout.fillWidth: true
                                                font.pixelSize: Style.resize(13)
                                                font.family: Style.fontFamilyRegular
                                                color: Style.fontPrimaryColor
                                                clip: true
                                                selectByMouse: true

                                                Text {
                                                    anchors.fill: parent
                                                    text: "Type a command..."
                                                    font: parent.font
                                                    color: Style.inactiveColor
                                                    visible: !parent.text && !parent.activeFocus
                                                    verticalAlignment: Text.AlignVCenter
                                                }
                                            }
                                        }
                                    }

                                    // Results list
                                    ListView {
                                        id: paletteResults
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        clip: true
                                        spacing: Style.resize(2)
                                        currentIndex: 0

                                        model: {
                                            var filter = paletteSearchField.text.toLowerCase()
                                            var results = []
                                            for (var i = 0; i < paletteSection.commands.length; i++) {
                                                var c = paletteSection.commands[i]
                                                if (!filter || c.cmd.toLowerCase().indexOf(filter) >= 0
                                                    || c.cat.toLowerCase().indexOf(filter) >= 0) {
                                                    results.push(c)
                                                }
                                            }
                                            return results
                                        }

                                        delegate: Rectangle {
                                            id: cmdItem
                                            required property var modelData
                                            required property int index

                                            width: paletteResults.width
                                            height: Style.resize(34)
                                            radius: Style.resize(6)
                                            color: paletteResults.currentIndex === cmdItem.index
                                                   ? Qt.rgba(0, 0.82, 0.66, 0.1)
                                                   : cmdHoverMa.containsMouse
                                                     ? Qt.rgba(1, 1, 1, 0.04)
                                                     : "transparent"

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: Style.resize(10)
                                                anchors.rightMargin: Style.resize(10)
                                                spacing: Style.resize(8)

                                                Label {
                                                    text: cmdItem.modelData.icon
                                                    font.pixelSize: Style.resize(14)
                                                }

                                                Label {
                                                    text: cmdItem.modelData.cmd
                                                    font.pixelSize: Style.resize(13)
                                                    color: Style.fontPrimaryColor
                                                    Layout.fillWidth: true
                                                }

                                                Rectangle {
                                                    width: catLabel.implicitWidth + Style.resize(10)
                                                    height: Style.resize(18)
                                                    radius: Style.resize(3)
                                                    color: Qt.rgba(1, 1, 1, 0.06)

                                                    Label {
                                                        id: catLabel
                                                        anchors.centerIn: parent
                                                        text: cmdItem.modelData.cat
                                                        font.pixelSize: Style.resize(9)
                                                        color: Style.inactiveColor
                                                    }
                                                }

                                                Label {
                                                    text: cmdItem.modelData.shortcut
                                                    font.pixelSize: Style.resize(10)
                                                    font.family: "monospace"
                                                    color: Style.inactiveColor
                                                }
                                            }

                                            MouseArea {
                                                id: cmdHoverMa
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    paletteSection.selectedCmd = "Executed: " + cmdItem.modelData.cmd
                                                    paletteSection.paletteOpen = false
                                                }
                                                onEntered: paletteResults.currentIndex = cmdItem.index
                                            }
                                        }
                                    }

                                    // Footer
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Style.resize(10)

                                        Label {
                                            text: paletteResults.count + " commands"
                                            font.pixelSize: Style.resize(10)
                                            color: Style.inactiveColor
                                            Layout.fillWidth: true
                                        }

                                        Label {
                                            text: "↑↓ Navigate   ↵ Select   Esc Close"
                                            font.pixelSize: Style.resize(10)
                                            color: Style.inactiveColor
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
