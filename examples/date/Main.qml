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

    // ── Date logic ──────────────────────────────────────────
    readonly property var monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    function daysInMonth(month, year) {
        // month: 0-based (0 = January)
        return new Date(year, month + 1, 0).getDate()
    }

    // Selected values derived from tumbler indices
    readonly property int selectedYear:  2000 + yearTumbler.currentIndex
    readonly property int selectedMonth: monthTumbler.currentIndex          // 0-based
    readonly property int selectedDay:   dayTumbler.currentIndex + 1        // 1-based
    readonly property int currentDayCount: daysInMonth(selectedMonth, selectedYear)

    // ── UI ──────────────────────────────────────────────────
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
                spacing: Style.resize(30)

                // Header
                Label {
                    text: "Date Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // ═══════════════════════════════════════
                    // Container 1: Tumbler Date Picker
                    // ═══════════════════════════════════════
                    Rectangle {
                        Layout.preferredWidth: Style.resize(400)
                        Layout.preferredHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "Tumbler Date Picker"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // The 3 tumblers
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(10)

                                // Day tumbler
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "Day"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.inactiveColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Tumbler {
                                        id: dayTumbler
                                        model: root.currentDayCount
                                        visibleItemCount: 5
                                        wrap: true
                                        Layout.preferredWidth: Style.resize(80)
                                        Layout.preferredHeight: Style.resize(220)

                                        delegate: Text {
                                            text: (modelData + 1).toString().padStart(2, '0')
                                            font.pixelSize: Style.resize(18)
                                                * (1.0 - 0.3 * Math.abs(Tumbler.displacement))
                                            font.family: Style.fontFamilyRegular
                                            font.bold: Math.abs(Tumbler.displacement) < 0.5
                                            color: Math.abs(Tumbler.displacement) < 0.5
                                                   ? Style.fontPrimaryColor
                                                   : Style.inactiveColor
                                            opacity: 1.0 - Math.abs(Tumbler.displacement)
                                                     / (dayTumbler.visibleItemCount / 2)
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter

                                            required property var modelData
                                            required property int index
                                        }
                                    }
                                }

                                // Month tumbler
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "Month"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.inactiveColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Tumbler {
                                        id: monthTumbler
                                        model: root.monthNames
                                        visibleItemCount: 5
                                        wrap: true
                                        Layout.preferredWidth: Style.resize(130)
                                        Layout.preferredHeight: Style.resize(220)
                                    }
                                }

                                // Year tumbler
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "Year"
                                        font.pixelSize: Style.resize(13)
                                        color: Style.inactiveColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Tumbler {
                                        id: yearTumbler
                                        model: 51  // 2000–2050
                                        visibleItemCount: 5
                                        wrap: false
                                        Layout.preferredWidth: Style.resize(80)
                                        Layout.preferredHeight: Style.resize(220)

                                        delegate: Text {
                                            text: (2000 + modelData).toString()
                                            font.pixelSize: Style.resize(18)
                                                * (1.0 - 0.3 * Math.abs(Tumbler.displacement))
                                            font.family: Style.fontFamilyRegular
                                            font.bold: Math.abs(Tumbler.displacement) < 0.5
                                            color: Math.abs(Tumbler.displacement) < 0.5
                                                   ? Style.fontPrimaryColor
                                                   : Style.inactiveColor
                                            opacity: 1.0 - Math.abs(Tumbler.displacement)
                                                     / (yearTumbler.visibleItemCount / 2)
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter

                                            required property var modelData
                                            required property int index
                                        }
                                    }
                                }
                            }

                            // Selected date display
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                                color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                                               Style.mainColor.b, 0.1)
                                radius: Style.resize(6)

                                Label {
                                    anchors.centerIn: parent
                                    text: root.selectedDay.toString().padStart(2, '0')
                                          + " / "
                                          + (root.selectedMonth + 1).toString().padStart(2, '0')
                                          + " / " + root.selectedYear
                                    font.pixelSize: Style.resize(18)
                                    font.bold: true
                                    color: Style.mainColor
                                }
                            }
                        }
                    }

                    // ═══════════════════════════════════════
                    // Container 2: Calendar
                    // ═══════════════════════════════════════
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Calendar"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Month / Year navigation header
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Button {
                                    text: "<"
                                    flat: true
                                    Layout.preferredWidth: Style.resize(40)
                                    Layout.preferredHeight: Style.resize(36)
                                    onClicked: {
                                        if (monthTumbler.currentIndex === 0) {
                                            monthTumbler.currentIndex = 11
                                            if (yearTumbler.currentIndex > 0)
                                                yearTumbler.currentIndex--
                                        } else {
                                            monthTumbler.currentIndex--
                                        }
                                    }
                                }

                                Label {
                                    text: root.monthNames[root.selectedMonth]
                                          + " " + root.selectedYear
                                    font.pixelSize: Style.resize(18)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: ">"
                                    flat: true
                                    Layout.preferredWidth: Style.resize(40)
                                    Layout.preferredHeight: Style.resize(36)
                                    onClicked: {
                                        if (monthTumbler.currentIndex === 11) {
                                            monthTumbler.currentIndex = 0
                                            if (yearTumbler.currentIndex < 50)
                                                yearTumbler.currentIndex++
                                        } else {
                                            monthTumbler.currentIndex++
                                        }
                                    }
                                }
                            }

                            // Day-of-week header
                            DayOfWeekRow {
                                id: dayOfWeekRow
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(30)
                                locale: Qt.locale("en_US")

                                delegate: Text {
                                    text: shortName
                                    font.pixelSize: Style.resize(13)
                                    font.bold: true
                                    font.family: Style.fontFamilyBold
                                    color: Style.inactiveColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter

                                    required property string shortName
                                }
                            }

                            // Separator
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1
                                color: Style.bgColor
                            }

                            // Month grid
                            MonthGrid {
                                id: monthGrid
                                month: Math.max(0, root.selectedMonth)
                                year: root.selectedYear
                                locale: Qt.locale("en_US")
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(2)

                                delegate: Rectangle {
                                    id: dayDelegate

                                    required property var model

                                    readonly property bool isCurrentMonth:
                                        model.month === monthGrid.month
                                    readonly property bool isSelected:
                                        isCurrentMonth
                                        && model.day === root.selectedDay
                                    readonly property bool isToday: model.today

                                    implicitWidth: Style.resize(36)
                                    implicitHeight: Style.resize(36)
                                    radius: width / 2
                                    color: isSelected ? Style.mainColor
                                         : isToday   ? Qt.rgba(Style.mainColor.r,
                                                                Style.mainColor.g,
                                                                Style.mainColor.b, 0.15)
                                         : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: dayDelegate.model.day
                                        font.pixelSize: Style.resize(14)
                                        font.family: Style.fontFamilyRegular
                                        font.bold: dayDelegate.isSelected
                                                   || dayDelegate.isToday
                                        color: dayDelegate.isSelected
                                               ? Style.fontContrastColor
                                             : !dayDelegate.isCurrentMonth
                                               ? Qt.rgba(Style.inactiveColor.r,
                                                         Style.inactiveColor.g,
                                                         Style.inactiveColor.b, 0.4)
                                             : dayDelegate.isToday
                                               ? Style.mainColor
                                               : Style.fontPrimaryColor
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (!dayDelegate.isCurrentMonth)
                                                return
                                            dayTumbler.currentIndex =
                                                dayDelegate.model.day - 1
                                        }
                                    }
                                }
                            }

                            // Today button
                            Button {
                                text: "Today"
                                flat: true
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredHeight: Style.resize(32)
                                onClicked: {
                                    var now = new Date()
                                    yearTumbler.currentIndex  = now.getFullYear() - 2000
                                    monthTumbler.currentIndex = now.getMonth()
                                    dayTumbler.currentIndex   = now.getDate() - 1
                                }
                            }
                        }
                    }
                }

                // Info label
                Label {
                    text: "The Tumbler picker and MonthGrid calendar stay in sync — "
                          + "change either one and the other updates automatically."
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }

    // ── Clamp day index when month/year changes ─────────────
    onCurrentDayCountChanged: {
        if (dayTumbler.currentIndex >= currentDayCount)
            dayTumbler.currentIndex = currentDayCount - 1
    }

    // Set initial date to today
    Component.onCompleted: {
        var now = new Date()
        yearTumbler.currentIndex  = now.getFullYear() - 2000
        monthTumbler.currentIndex = now.getMonth()
        dayTumbler.currentIndex   = now.getDate() - 1
    }
}
