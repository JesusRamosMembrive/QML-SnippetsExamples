import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    readonly property var pageColors: ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043", "#AB47BC"]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "PageIndicator Styles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SwipeView {
            id: indicatorSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Repeater {
                model: 5
                Rectangle {
                    required property int index
                    color: Style.bgColor
                    radius: Style.resize(6)

                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(80)
                        height: Style.resize(80)
                        radius: Style.resize(40)
                        color: root.pageColors[index]
                        opacity: 0.8

                        Label {
                            anchors.centerIn: parent
                            text: (index + 1).toString()
                            font.pixelSize: Style.resize(28)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }
            }
        }

        // Default PageIndicator
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Default"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            PageIndicator {
                id: defaultIndicator
                count: indicatorSwipe.count
                currentIndex: indicatorSwipe.currentIndex
                interactive: true
                Layout.alignment: Qt.AlignHCenter
                onCurrentIndexChanged: indicatorSwipe.currentIndex = currentIndex

                delegate: Rectangle {
                    required property int index
                    implicitWidth: Style.resize(10)
                    implicitHeight: Style.resize(10)
                    radius: width / 2
                    color: index === defaultIndicator.currentIndex ? Style.mainColor : Style.inactiveColor
                    opacity: index === defaultIndicator.currentIndex ? 1.0 : 0.4

                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }

        // Bar-style indicator
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Bar style (interactive)"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(4)

                Repeater {
                    model: indicatorSwipe.count
                    Rectangle {
                        required property int index
                        width: index === indicatorSwipe.currentIndex ? Style.resize(28) : Style.resize(12)
                        height: Style.resize(5)
                        radius: Style.resize(3)
                        color: index === indicatorSwipe.currentIndex ? Style.mainColor : Style.inactiveColor

                        Behavior on width { NumberAnimation { duration: 200 } }
                        Behavior on color { ColorAnimation { duration: 200 } }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: indicatorSwipe.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}
