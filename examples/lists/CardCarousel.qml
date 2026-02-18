import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Card Carousel"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)

        ListView {
            id: carouselList
            anchors.fill: parent
            orientation: ListView.Horizontal
            clip: true
            spacing: Style.resize(15)
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: (width - Style.resize(300)) / 2
            preferredHighlightEnd: preferredHighlightBegin + Style.resize(300)
            cacheBuffer: 1000

            model: ListModel {
                ListElement { title: "Madrid"; subtitle: "Capital of Spain"; temp: "22°C"; weather: "☀"; gradient1: "#FF6B6B"; gradient2: "#EE5A24" }
                ListElement { title: "London"; subtitle: "United Kingdom"; temp: "14°C"; weather: "🌧"; gradient1: "#74B9FF"; gradient2: "#0984E3" }
                ListElement { title: "Tokyo"; subtitle: "Japan"; temp: "19°C"; weather: "⛅"; gradient1: "#A29BFE"; gradient2: "#6C5CE7" }
                ListElement { title: "New York"; subtitle: "United States"; temp: "17°C"; weather: "🌤"; gradient1: "#FDCB6E"; gradient2: "#E17055" }
                ListElement { title: "Sydney"; subtitle: "Australia"; temp: "26°C"; weather: "☀"; gradient1: "#00D1A9"; gradient2: "#00B894" }
                ListElement { title: "Paris"; subtitle: "France"; temp: "16°C"; weather: "🌥"; gradient1: "#FD79A8"; gradient2: "#E84393" }
            }

            delegate: Item {
                id: carouselDelegate
                width: Style.resize(300)
                height: carouselList.height

                required property int index
                required property string title
                required property string subtitle
                required property string temp
                required property string weather
                required property string gradient1
                required property string gradient2

                readonly property bool isCurrent: carouselList.currentIndex === carouselDelegate.index

                scale: isCurrent ? 1.0 : 0.88
                opacity: isCurrent ? 1.0 : 0.6

                Behavior on scale {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 250 }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: Style.resize(10)
                    radius: Style.resize(16)

                    gradient: Gradient {
                        GradientStop { position: 0; color: carouselDelegate.gradient1 }
                        GradientStop { position: 1; color: carouselDelegate.gradient2 }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(8)

                        Label {
                            text: carouselDelegate.weather
                            font.pixelSize: Style.resize(42)
                        }

                        Item { Layout.fillHeight: true }

                        Label {
                            text: carouselDelegate.temp
                            font.pixelSize: Style.resize(36)
                            font.bold: true
                            color: "#FFF"
                        }

                        Label {
                            text: carouselDelegate.title
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: "#FFF"
                        }

                        Label {
                            text: carouselDelegate.subtitle
                            font.pixelSize: Style.resize(13)
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }
                }
            }
        }

        // Page dots
        Row {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Style.resize(5)
            spacing: Style.resize(6)

            Repeater {
                model: carouselList.count
                delegate: Rectangle {
                    id: pageDot
                    required property int index

                    width: carouselList.currentIndex === pageDot.index ? Style.resize(20) : Style.resize(8)
                    height: Style.resize(8)
                    radius: height / 2
                    color: carouselList.currentIndex === pageDot.index ? Style.mainColor : Qt.rgba(1, 1, 1, 0.2)

                    Behavior on width {
                        NumberAnimation { duration: 200 }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
