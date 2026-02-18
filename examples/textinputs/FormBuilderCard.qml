import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import qmlsnippetsstyle

Rectangle {
    id: root
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
                    root.submitted = true;
                    root.summary =
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
                    root.submitted = false;
                    root.summary = "";
                }
            }
        }

        // Summary
        Label {
            visible: root.submitted
            text: "Submitted: " + root.summary
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
