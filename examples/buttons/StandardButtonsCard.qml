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
            text: "Standard Buttons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            Button {
                text: "Default"
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            Button {
                text: "Highlighted"
                highlighted: true
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            Button {
                text: "Flat Button"
                flat: true
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            Button {
                text: "Disabled"
                enabled: false
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            text: "flat: no background · highlighted: brighter + bold · disabled: grayed out"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.topMargin: Style.resize(10)
        }
    }
}
