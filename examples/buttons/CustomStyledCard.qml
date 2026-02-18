import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Custom Styled Buttons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                text: "Success"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#00D1A8"
                palette.buttonText: "white"
            }

            Button {
                text: "Warning"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FFE361"
                palette.buttonText: "#333"
            }

            Button {
                text: "Danger"
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FF5900"
                palette.buttonText: "white"
            }
        }

        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                text: "Success Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#00D1A8"
            }

            Button {
                text: "Warning Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FFE361"
            }

            Button {
                text: "Danger Flat"
                flat: true
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
                palette.button: "#FF5900"
            }
        }

        Label {
            text: "palette.button changes color for both solid and flat variants"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
