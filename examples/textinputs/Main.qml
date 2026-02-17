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
            }
        }
    }
}
