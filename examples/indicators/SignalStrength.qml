import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    // ── Section 4: Signal Strength Bars ───────────────
    Label {
        text: "Signal Strength"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(40)
        Layout.alignment: Qt.AlignHCenter

        Repeater {
            model: [
                { bars: 5, label: "Excellent", clr: "#34C759" },
                { bars: 4, label: "Good", clr: "#34C759" },
                { bars: 3, label: "Fair", clr: "#FF9500" },
                { bars: 2, label: "Weak", clr: "#FF9500" },
                { bars: 1, label: "Poor", clr: "#FF3B30" },
                { bars: 0, label: "None", clr: "#FF3B30" }
            ]

            delegate: ColumnLayout {
                id: signalDelegate
                spacing: Style.resize(8)

                required property var modelData
                required property int index

                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.resize(3)

                    Repeater {
                        model: 5
                        delegate: Rectangle {
                            id: signalBar

                            required property int index

                            width: Style.resize(8)
                            height: Style.resize(10 + index * 8)
                            radius: Style.resize(2)
                            anchors.bottom: parent.bottom
                            color: signalBar.index < signalDelegate.modelData.bars
                                   ? signalDelegate.modelData.clr
                                   : Qt.rgba(1, 1, 1, 0.1)

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }
                        }
                    }
                }

                Label {
                    text: signalDelegate.modelData.label
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
