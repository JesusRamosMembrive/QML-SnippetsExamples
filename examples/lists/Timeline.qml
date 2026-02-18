import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Timeline"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(420)
        color: Style.bgColor
        radius: Style.resize(8)
        clip: true

        ListView {
            id: timelineList
            anchors.fill: parent
            anchors.margins: Style.resize(10)
            clip: true
            spacing: 0

            model: ListModel {
                ListElement { title: "Project Kickoff"; desc: "Initial requirements gathered and team assembled"; date: "Jan 5"; clr: "#5B8DEF"; done: true }
                ListElement { title: "Architecture Design"; desc: "Module system, style engine, and navigation pattern defined"; date: "Jan 18"; clr: "#00D1A9"; done: true }
                ListElement { title: "Core Components"; desc: "Buttons, sliders, dials, indicators, and text inputs completed"; date: "Feb 3"; clr: "#34C759"; done: true }
                ListElement { title: "Advanced Pages"; desc: "Canvas, shapes, particles, transforms, and animations added"; date: "Feb 14"; clr: "#FF9500"; done: true }
                ListElement { title: "Maps & Navigation"; desc: "OpenStreetMap integration with GPS simulation and compass"; date: "Feb 17"; clr: "#AF52DE"; done: false }
                ListElement { title: "Testing & Polish"; desc: "Performance optimization, dark theme, and contrast fixes"; date: "Mar 1"; clr: "#FF3B30"; done: false }
                ListElement { title: "Release v1.0"; desc: "Final build, documentation, and deployment"; date: "Mar 15"; clr: "#FEA601"; done: false }
            }

            delegate: Item {
                id: timelineDelegate
                width: timelineList.width
                height: Style.resize(70)

                required property int index
                required property string title
                required property string desc
                required property string date
                required property string clr
                required property bool done

                // Vertical line
                Rectangle {
                    id: timelineLine
                    anchors.horizontalCenter: timelineDot.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Style.resize(2)
                    color: Qt.rgba(1, 1, 1, 0.1)
                }

                // Dot
                Rectangle {
                    id: timelineDot
                    x: Style.resize(40)
                    anchors.verticalCenter: parent.verticalCenter
                    width: Style.resize(16)
                    height: Style.resize(16)
                    radius: width / 2
                    color: timelineDelegate.done ? timelineDelegate.clr : "transparent"
                    border.color: timelineDelegate.clr
                    border.width: Style.resize(2)

                    // Inner dot for completed
                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(6)
                        height: Style.resize(6)
                        radius: width / 2
                        color: "#FFF"
                        visible: timelineDelegate.done
                    }
                }

                // Date label (left)
                Label {
                    anchors.right: timelineDot.left
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    text: timelineDelegate.date
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: timelineDelegate.done ? timelineDelegate.clr : Style.inactiveColor
                    horizontalAlignment: Text.AlignRight
                    width: Style.resize(30)
                }

                // Content (right)
                ColumnLayout {
                    anchors.left: timelineDot.right
                    anchors.leftMargin: Style.resize(14)
                    anchors.right: parent.right
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.resize(3)

                    Label {
                        text: timelineDelegate.title
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: timelineDelegate.done ? Style.fontPrimaryColor : Style.inactiveColor
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Label {
                        text: timelineDelegate.desc
                        font.pixelSize: Style.resize(11)
                        color: timelineDelegate.done ? Style.fontSecondaryColor : Qt.rgba(1, 1, 1, 0.25)
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
