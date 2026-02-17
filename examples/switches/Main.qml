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
            }
        }
    }
}
