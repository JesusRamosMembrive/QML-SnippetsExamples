pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    readonly property var monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    readonly property int selectedYear:  2000 + yearTumbler.currentIndex
    readonly property int selectedMonth: monthTumbler.currentIndex
    readonly property int selectedDay:   dayTumbler.currentIndex + 1
    readonly property int currentDayCount: daysInMonth(selectedMonth, selectedYear)

    function daysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate()
    }

    function setDay(day)   { dayTumbler.currentIndex = day - 1 }
    function setMonth(month) { monthTumbler.currentIndex = month }
    function setYear(year) { yearTumbler.currentIndex = year - 2000 }

    function pad2(n: int) : string {
        return n < 10 ? "0" + n : "" + n
    }

    function goToToday() {
        var now = new Date()
        yearTumbler.currentIndex  = now.getFullYear() - 2000
        monthTumbler.currentIndex = now.getMonth()
        dayTumbler.currentIndex   = now.getDate() - 1
    }

    onCurrentDayCountChanged: {
        if (dayTumbler.currentIndex >= currentDayCount)
            dayTumbler.currentIndex = currentDayCount - 1
    }

    Component.onCompleted: goToToday()

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
                        required property int modelData
                        required property int index

                        text: root.pad2(modelData + 1)
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
                        required property int modelData
                        required property int index

                        text: "" + (2000 + modelData)
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
                    }
                }
            }
        }

        // Selected date display
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(40)
            color: { let c = Qt.color(Style.mainColor); return Qt.rgba(c.r, c.g, c.b, 0.1) }
            radius: Style.resize(6)

            Label {
                anchors.centerIn: parent
                text: root.pad2(root.selectedDay)
                      + " / "
                      + root.pad2(root.selectedMonth + 1)
                      + " / " + root.selectedYear
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }
        }
    }
}
