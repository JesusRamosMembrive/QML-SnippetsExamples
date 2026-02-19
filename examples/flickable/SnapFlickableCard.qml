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
            text: "Snap Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Flick horizontally \u2014 snaps to pages"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Flickable {
                id: snapFlick
                anchors.fill: parent
                contentWidth: snapRow.width
                contentHeight: height
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds

                property int currentPage: Math.round(contentX / width)

                onMovementEnded: {
                    var page = Math.round(contentX / width)
                    contentX = page * width
                }
                Behavior on contentX { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

                Row {
                    id: snapRow
                    height: snapFlick.height

                    Repeater {
                        model: ListModel {
                            ListElement { title: "Welcome";  icon: "\u2605"; clr: "#00D1A9" }
                            ListElement { title: "Features"; icon: "\u2699"; clr: "#FEA601" }
                            ListElement { title: "Gallery";  icon: "\u25A3"; clr: "#4FC3F7" }
                            ListElement { title: "Profile";  icon: "\u263A"; clr: "#AB47BC" }
                            ListElement { title: "Settings"; icon: "\u2692"; clr: "#FF7043" }
                        }

                        Rectangle {
                            id: snapDelegate
                            required property string title
                            required property string icon
                            required property string clr
                            required property int index
                            width: snapFlick.width
                            height: snapFlick.height
                            color: "transparent"

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: Style.resize(10)
                                radius: Style.resize(12)
                                color: snapDelegate.clr
                                opacity: 0.15
                                border.color: snapDelegate.clr
                                border.width: Style.resize(2)
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(10)

                                Label {
                                    text: snapDelegate.icon
                                    font.pixelSize: Style.resize(48)
                                    color: snapDelegate.clr
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Label {
                                    text: snapDelegate.title
                                    font.pixelSize: Style.resize(20)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Label {
                                    text: "Page " + (snapDelegate.index + 1) + " of 5"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }

            // Page dots
            Row {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(8)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Style.resize(8)

                Repeater {
                    model: 5

                    Rectangle {
                        required property int index
                        width: Style.resize(8)
                        height: Style.resize(8)
                        radius: Style.resize(4)
                        color: snapFlick.currentPage === index ? Style.mainColor : Style.inactiveColor

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
            }
        }
    }
}
