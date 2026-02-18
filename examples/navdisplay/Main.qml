import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // Shared state
    property int selectedWp: -1

    property var flightPlan: [
        { name: "DEPART", brg: 0,   dist: 0,   alt: "----",  eta: "--:--" },
        { name: "MOPAR",  brg: 25,  dist: 12,  alt: "FL120", eta: "00:04" },
        { name: "OKRIX",  brg: 40,  dist: 28,  alt: "FL240", eta: "00:09" },
        { name: "VESAN",  brg: 15,  dist: 52,  alt: "FL350", eta: "00:18" },
        { name: "LARAN",  brg: 355, dist: 85,  alt: "FL370", eta: "00:28" },
        { name: "ASTER",  brg: 340, dist: 120, alt: "FL370", eta: "00:35" },
        { name: "ARRIV",  brg: 330, dist: 160, alt: "FL180", eta: "00:45" }
    ]

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "Navigation Display"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    MovingMapCard {
                        id: movingMap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        currentRange: modeRange.currentRange
                        ndMode: modeRange.ndMode
                        selectedWp: root.selectedWp
                        flightPlan: root.flightPlan
                    }

                    FlightPlanCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        flightPlan: root.flightPlan
                        selectedWp: root.selectedWp
                        onWaypointSelected: (index) => root.selectedWp = index
                    }

                    CompassRoseCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        heading: movingMap.heading
                    }

                    ModeRangeCard {
                        id: modeRange
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                        heading: movingMap.heading
                        flightPlan: root.flightPlan
                    }
                }
            }
        }
    }
}
