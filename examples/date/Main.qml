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

                    TumblerDatePicker {
                        id: picker
                        Layout.preferredWidth: Style.resize(400)
                        Layout.preferredHeight: Style.resize(420)
                    }

                    CalendarCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(420)
                        monthNames: picker.monthNames
                        selectedYear: picker.selectedYear
                        selectedMonth: picker.selectedMonth
                        selectedDay: picker.selectedDay
                        onPreviousMonth: {
                            if (picker.selectedMonth === 0) {
                                picker.setMonth(11)
                                if (picker.selectedYear > 2000)
                                    picker.setYear(picker.selectedYear - 1)
                            } else {
                                picker.setMonth(picker.selectedMonth - 1)
                            }
                        }
                        onNextMonth: {
                            if (picker.selectedMonth === 11) {
                                picker.setMonth(0)
                                if (picker.selectedYear < 2050)
                                    picker.setYear(picker.selectedYear + 1)
                            } else {
                                picker.setMonth(picker.selectedMonth + 1)
                            }
                        }
                        onDayClicked: (day) => picker.setDay(day)
                        onTodayClicked: picker.goToToday()
                    }
                }

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
}
