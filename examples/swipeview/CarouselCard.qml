import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    readonly property var cards: [
        { title: "Buttons",    icon: "\u25A3", clr: "#00D1A9", desc: "Standard, icon and styled buttons" },
        { title: "Sliders",    icon: "\u2501", clr: "#FEA601", desc: "Range sliders, custom handles" },
        { title: "Animations", icon: "\u25B7", clr: "#4FC3F7", desc: "Transitions and behaviors" },
        { title: "Particles",  icon: "\u2726", clr: "#FF7043", desc: "Emitters, affectors, trails" },
        { title: "Canvas",     icon: "\u25CB", clr: "#AB47BC", desc: "2D drawing and paths" },
        { title: "Graphs",     icon: "\u2581\u2583\u2585\u2587", clr: "#EC407A", desc: "Charts and real-time plots" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Card Carousel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SwipeView {
            id: carouselSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Repeater {
                model: root.cards

                Rectangle {
                    required property var modelData
                    required property int index
                    color: Style.bgColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Label {
                            text: modelData.icon
                            font.pixelSize: Style.resize(48)
                            color: modelData.clr
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.title
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.desc
                            font.pixelSize: Style.resize(14)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle {
                            Layout.preferredWidth: Style.resize(50)
                            Layout.preferredHeight: Style.resize(4)
                            radius: Style.resize(2)
                            color: modelData.clr
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // Dot indicator
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: Style.resize(8)

            Repeater {
                model: carouselSwipe.count
                Rectangle {
                    required property int index
                    width: Style.resize(10)
                    height: Style.resize(10)
                    radius: width / 2
                    color: index === carouselSwipe.currentIndex
                           ? root.cards[index].clr
                           : Style.inactiveColor
                    opacity: index === carouselSwipe.currentIndex ? 1.0 : 0.3

                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: carouselSwipe.currentIndex = index
                    }
                }
            }
        }
    }
}
