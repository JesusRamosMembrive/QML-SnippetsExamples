// =============================================================================
// Main.qml — Pagina principal del modulo Date
// =============================================================================
// Pagina de ejemplo que combina dos componentes de seleccion de fecha:
// un TumblerDatePicker (ruedas giratorias) y un CalendarCard (cuadricula
// mensual con MonthGrid). Ambos estan sincronizados bidireccionalmente:
// cambiar la fecha en uno actualiza el otro automaticamente.
//
// Este archivo demuestra un patron importante: la comunicacion entre
// componentes hermanos mediante propiedades y senales. El TumblerDatePicker
// expone la fecha como propiedades readonly, y el CalendarCard emite
// senales (previousMonth, nextMonth, dayClicked, todayClicked) que el
// padre (este Main.qml) conecta a funciones del picker.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // Patron de navegacion estandar del proyecto.
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

                // ---------------------------------------------------------
                // Layout horizontal: TumblerDatePicker a la izquierda
                // con ancho fijo, CalendarCard a la derecha expandiendose.
                // La sincronizacion funciona asi:
                // - Picker -> Calendar: las propiedades monthNames,
                //   selectedYear/Month/Day se pasan como bindings.
                // - Calendar -> Picker: las senales del calendar se
                //   conectan a funciones setMonth/setYear/setDay/goToToday
                //   del picker, creando un flujo bidireccional.
                // ---------------------------------------------------------
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
