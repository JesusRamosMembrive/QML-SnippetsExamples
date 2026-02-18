import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Star Rating"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: ratingItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(50)

        property int rating: 3
        property int hoverRating: -1

        RowLayout {
            anchors.centerIn: parent
            spacing: Style.resize(8)

            Repeater {
                model: 5

                Label {
                    id: starLabel
                    required property int index

                    property bool filled: {
                        var r = ratingItem.hoverRating >= 0
                                ? ratingItem.hoverRating : ratingItem.rating
                        return index < r
                    }

                    text: filled ? "\u2605" : "\u2606"
                    font.pixelSize: Style.resize(36)
                    color: filled ? "#FFD54F" : Style.inactiveColor

                    scale: starMa.containsMouse ? 1.2 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: starMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ratingItem.rating = starLabel.index + 1
                        onEntered: ratingItem.hoverRating = starLabel.index + 1
                        onExited: ratingItem.hoverRating = -1
                    }
                }
            }

            Label {
                text: ratingItem.rating + " / 5"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: "#FFD54F"
                Layout.leftMargin: Style.resize(15)
            }
        }
    }
}
