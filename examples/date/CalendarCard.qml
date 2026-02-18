import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var monthNames: []
    property int selectedYear: 2000
    property int selectedMonth: 0
    property int selectedDay: 1

    signal previousMonth()
    signal nextMonth()
    signal dayClicked(int day)
    signal todayClicked()

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
                onClicked: root.previousMonth()
            }

            Label {
                text: (root.monthNames.length > 0
                       ? root.monthNames[root.selectedMonth] : "")
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
                onClicked: root.nextMonth()
            }
        }

        // Day-of-week header
        DayOfWeekRow {
            id: dayOfWeekRow
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(30)
            locale: Qt.locale("en_US")

            delegate: Item {
                implicitWidth: (dayOfWeekRow.width - 6 * 2) / 7
                implicitHeight: Style.resize(30)

                required property string shortName

                Text {
                    anchors.centerIn: parent
                    text: parent.shortName
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    font.family: Style.fontFamilyBold
                    color: Style.inactiveColor
                }
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

                implicitWidth: (monthGrid.width - 6 * monthGrid.spacing) / 7
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
                        root.dayClicked(dayDelegate.model.day)
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
            onClicked: root.todayClicked()
        }
    }
}
