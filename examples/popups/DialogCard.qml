import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // Dialogs (defined here for proper overlay)
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

        Button {
            text: "Info Dialog"
            Layout.fillWidth: true
            onClicked: infoDialog.open()
        }

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
