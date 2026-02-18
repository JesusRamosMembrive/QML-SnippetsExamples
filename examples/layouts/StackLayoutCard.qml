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
        spacing: Style.resize(10)

        Label {
            text: "StackLayout"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Page buttons
        RowLayout {
            id: pageButtons
            Layout.fillWidth: true
            spacing: Style.resize(6)

            property int currentPage: 0

            Button {
                text: "Page 1"
                Layout.fillWidth: true
                highlighted: parent.currentPage === 0
                onClicked: parent.currentPage = 0
            }

            Button {
                text: "Page 2"
                Layout.fillWidth: true
                highlighted: parent.currentPage === 1
                onClicked: parent.currentPage = 1
            }

            Button {
                text: "Page 3"
                Layout.fillWidth: true
                highlighted: parent.currentPage === 2
                onClicked: parent.currentPage = 2
            }
        }

        // Page indicator
        Label {
            text: "Current page: " + (stackLayout.currentIndex + 1) + " of 3"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        // StackLayout
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            StackLayout {
                id: stackLayout
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                currentIndex: pageButtons.currentPage

                // Page 1
                Rectangle {
                    color: "#4A90D920"
                    radius: Style.resize(8)
                    border.color: "#4A90D9"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Rectangle {
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: Style.resize(8)
                            color: "#4A90D9"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Page 1: Welcome"
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#4A90D9"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "StackLayout shows one child at a time"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Page 2
                Rectangle {
                    color: "#00D1A920"
                    radius: Style.resize(8)
                    border.color: "#00D1A9"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        RowLayout {
                            spacing: Style.resize(8)
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: 3
                                Rectangle {
                                    width: Style.resize(40)
                                    height: Style.resize(40)
                                    radius: width / 2
                                    color: "#00D1A9"

                                    Label {
                                        anchors.centerIn: parent
                                        text: (index + 1)
                                        color: "white"
                                        font.bold: true
                                    }
                                }
                            }
                        }

                        Label {
                            text: "Page 2: Content"
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#00D1A9"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Only the current page is visible and laid out"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Page 3
                Rectangle {
                    color: "#FEA60120"
                    radius: Style.resize(8)
                    border.color: "#FEA601"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Rectangle {
                            width: Style.resize(80)
                            height: Style.resize(50)
                            radius: Style.resize(25)
                            color: "#FEA601"
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                anchors.centerIn: parent
                                text: "Done!"
                                color: "white"
                                font.bold: true
                                font.pixelSize: Style.resize(16)
                            }
                        }

                        Label {
                            text: "Page 3: Summary"
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#FEA601"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Use currentIndex to switch between pages"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        Label {
            text: "StackLayout stacks children, only the current page is visible"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
