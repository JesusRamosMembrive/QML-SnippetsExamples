import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var flightPlan: []
    property int selectedWp: -1
    signal waypointSelected(int index)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Flight Plan"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Header row
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(30)
            color: "#2a2a2a"
            radius: Style.resize(4)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(10)
                anchors.rightMargin: Style.resize(10)
                spacing: Style.resize(5)

                Label { text: "WPT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(55) }
                Label { text: "BRG"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(35); horizontalAlignment: Text.AlignRight }
                Label { text: "DIST"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(45); horizontalAlignment: Text.AlignRight }
                Label { text: "ALT"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.preferredWidth: Style.resize(50); horizontalAlignment: Text.AlignRight }
                Label { text: "ETA"; font.pixelSize: Style.resize(11); font.bold: true; color: "#00FF00"; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
            }
        }

        // Waypoint list
        ListView {
            id: wpListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.flightPlan.length

            delegate: Rectangle {
                required property int index

                width: wpListView.width
                height: Style.resize(36)
                color: {
                    if (index === root.selectedWp) return "#1a3a3a";
                    if (wpMa.containsMouse) return "#1a1a2a";
                    return (index % 2 === 0) ? "#1a1a1a" : "#222222";
                }
                radius: Style.resize(2)

                property var wp: root.flightPlan[index]

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    spacing: Style.resize(5)

                    Label {
                        text: wp.name
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: index === root.selectedWp ? "#00FFFF" : "#00FF00"
                        Layout.preferredWidth: Style.resize(55)
                    }
                    Label {
                        text: wp.brg + "\u00B0"
                        font.pixelSize: Style.resize(12)
                        color: "#AAAAAA"
                        Layout.preferredWidth: Style.resize(35)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.dist + " NM"
                        font.pixelSize: Style.resize(12)
                        color: "#AAAAAA"
                        Layout.preferredWidth: Style.resize(45)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.alt
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF"
                        Layout.preferredWidth: Style.resize(50)
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        text: wp.eta
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                MouseArea {
                    id: wpMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.waypointSelected(index)
                }
            }
        }

        Label {
            text: "Click a waypoint to highlight it on the map (cyan). Shows bearing, distance, altitude, and ETA."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
