import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import settingsmgr
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    SettingsManager { id: settings }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Preferences"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Q_PROPERTY backed by QSettings — changes persist across restarts"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Theme
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Theme:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            ComboBox {
                Layout.fillWidth: true
                model: ["Dark", "Light", "System"]
                currentIndex: model.indexOf(settings.theme)
                onCurrentTextChanged: settings.theme = currentText
            }
        }

        // Font size
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Font size:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Slider {
                Layout.fillWidth: true
                from: 8; to: 24; value: settings.fontSize; stepSize: 1
                onMoved: settings.fontSize = value
            }

            Label {
                text: settings.fontSize + " px"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // Username
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Username:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            TextField {
                Layout.fillWidth: true
                text: settings.userName
                font.pixelSize: Style.resize(11)
                onTextChanged: settings.userName = text
            }
        }

        // Notifications
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Notifications:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Switch {
                checked: settings.notifications
                onCheckedChanged: settings.notifications = checked
            }

            Label {
                text: settings.notifications ? "Enabled" : "Disabled"
                font.pixelSize: Style.resize(11)
                color: settings.notifications ? "#00D1A9" : "#FF6B6B"
            }
        }

        // Volume
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Volume:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Slider {
                Layout.fillWidth: true
                from: 0; to: 1; value: settings.volume
                onMoved: settings.volume = value
            }

            Label {
                text: (settings.volume * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        Item { Layout.fillHeight: true }

        // Preview
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(50)
            radius: Style.resize(6)
            color: settings.theme === "Light" ? "#E8E8E8" : Style.surfaceColor

            Label {
                anchors.centerIn: parent
                text: "Preview: " + settings.userName + " (" + settings.theme + " theme)"
                font.pixelSize: settings.fontSize
                color: settings.theme === "Light" ? "#333333" : Style.fontPrimaryColor
            }
        }
    }
}
