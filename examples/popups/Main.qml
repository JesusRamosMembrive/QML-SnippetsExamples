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
            color: "#333"
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
            color: "#333"
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
                color: "#333"
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
            color: "white"
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
                color: "#666"
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
            color: "white"
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
                color: "#333"
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
                        color: "white"
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
                                color: "#333"
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
                                color: "#333"
                            }

                            Item { Layout.fillHeight: true }

                            Label {
                                text: "Dialog provides modal windows for user interaction with standard buttons"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
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
                        color: "white"
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
                                        color: "#333"
                                    }

                                    Label {
                                        text: "• Basic: no overlay, click outside to close"
                                        font.pixelSize: Style.resize(11)
                                        color: "#666"
                                        Layout.fillWidth: true
                                    }

                                    Label {
                                        text: "• Modal: dims background, blocks interaction"
                                        font.pixelSize: Style.resize(11)
                                        color: "#666"
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            Label {
                                text: "Popup shows overlay content with enter/exit transitions"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
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
                        color: "white"
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
                                    color: "#666"
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
                                color: "#666"
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
                        color: "white"
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
                                    color: "#666"
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
                                        color: "#333"
                                    }

                                    Label {
                                        text: "• Regular items, separators"
                                        font.pixelSize: Style.resize(11)
                                        color: "#666"
                                    }

                                    Label {
                                        text: "• Checkable items (Bold, Italic)"
                                        font.pixelSize: Style.resize(11)
                                        color: "#666"
                                    }

                                    Label {
                                        text: "• Context menu (right-click)"
                                        font.pixelSize: Style.resize(11)
                                        color: "#666"
                                    }
                                }
                            }

                            Label {
                                text: "Menu provides dropdown and context menus with rich item types"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
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
