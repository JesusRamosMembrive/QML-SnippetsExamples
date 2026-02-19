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
            text: "Onboarding Wizard"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SwipeView {
            id: wizardSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: false

            // Step 1
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2460"; font.pixelSize: Style.resize(36); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Welcome"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Get started with the setup wizard"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Step 2
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2461"; font.pixelSize: Style.resize(36); color: "#FEA601"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Configure"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Set your preferences"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Step 3
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2462"; font.pixelSize: Style.resize(36); color: "#4FC3F7"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Review"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Check everything is correct"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Step 4
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2714"; font.pixelSize: Style.resize(36); color: "#66BB6A"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Done!"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "You are all set"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }

        // Progress bar
        ProgressBar {
            Layout.fillWidth: true
            value: (wizardSwipe.currentIndex + 1) / wizardSwipe.count
        }

        // Step indicator + navigation
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Back"
                visible: wizardSwipe.currentIndex > 0
                onClicked: wizardSwipe.currentIndex--
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Step " + (wizardSwipe.currentIndex + 1) + " of " + wizardSwipe.count
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: wizardSwipe.currentIndex === wizardSwipe.count - 1 ? "Finish" : "Next"
                onClicked: {
                    if (wizardSwipe.currentIndex < wizardSwipe.count - 1)
                        wizardSwipe.currentIndex++
                    else
                        wizardSwipe.currentIndex = 0
                }
            }
        }
    }
}
