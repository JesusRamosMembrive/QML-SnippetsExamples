import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Masonry Grid (Pinterest-style)"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: masonrySection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(350)

        readonly property var items: [
            { title: "Sunset Beach", h: 120, clr: "#FF6B6B" },
            { title: "Mountain View", h: 160, clr: "#5B8DEF" },
            { title: "City Lights", h: 100, clr: "#FEA601" },
            { title: "Forest Trail", h: 180, clr: "#00D1A9" },
            { title: "Ocean Waves", h: 130, clr: "#AF52DE" },
            { title: "Snow Peaks", h: 150, clr: "#FF9500" },
            { title: "Desert Dunes", h: 110, clr: "#FF3B30" },
            { title: "Flower Field", h: 140, clr: "#34C759" },
            { title: "Rainy Day", h: 170, clr: "#636E72" },
            { title: "Aurora", h: 125, clr: "#E84393" },
            { title: "Starry Night", h: 155, clr: "#0984E3" },
            { title: "Autumn Leaves", h: 100, clr: "#E17055" }
        ]
        readonly property int colCount: 3

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            Row {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(8)

                Repeater {
                    model: masonrySection.colCount

                    delegate: Column {
                        id: masonryCol
                        required property int index

                        width: (parent.width - Style.resize(8) * (masonrySection.colCount - 1)) / masonrySection.colCount
                        spacing: Style.resize(8)

                        Repeater {
                            model: {
                                var colItems = []
                                for (var i = masonryCol.index; i < masonrySection.items.length; i += masonrySection.colCount) {
                                    colItems.push(masonrySection.items[i])
                                }
                                return colItems
                            }

                            delegate: Rectangle {
                                id: masonryCard
                                required property var modelData
                                required property int index

                                width: parent.width
                                height: Style.resize(masonryCard.modelData.h)
                                radius: Style.resize(8)
                                color: masonryCard.modelData.clr

                                scale: masonryHoverMa.containsMouse ? 1.03 : 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }

                                ColumnLayout {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(2)

                                    Label {
                                        text: masonryCard.modelData.title
                                        font.pixelSize: Style.resize(12)
                                        font.bold: true
                                        color: "#FFF"
                                    }
                                    Label {
                                        text: masonryCard.modelData.h + "px"
                                        font.pixelSize: Style.resize(10)
                                        color: Qt.rgba(1, 1, 1, 0.7)
                                    }
                                }

                                MouseArea {
                                    id: masonryHoverMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
