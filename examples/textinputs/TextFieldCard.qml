import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
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
