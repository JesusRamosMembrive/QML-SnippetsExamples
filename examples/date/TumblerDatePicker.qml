// =============================================================================
// TumblerDatePicker.qml — Selector de fecha con ruedas giratorias (Tumbler)
// =============================================================================
// Implementa un date picker estilo iOS/Android con 3 Tumblers: dia, mes y
// anio. Expone la fecha seleccionada como propiedades readonly y funciones
// setter para que el padre pueda modificar la fecha programaticamente.
//
// Patrones clave para el aprendiz:
// - Tumbler: control de rueda giratoria de Qt Quick Controls 2. Cada uno
//   tiene un modelo (numerico o array de strings) y un delegate que define
//   como se renderiza cada elemento.
// - Tumbler.displacement: propiedad attached que indica la distancia del
//   elemento al centro. Se usa para escalar fuente, opacidad y color,
//   creando el efecto de "profundidad" tipico de pickers nativos.
// - pragma ComponentBehavior: Bound: necesario en Qt 6.5+ para que los
//   delegates accedan a propiedades del componente padre de forma segura.
// - Validacion automatica de dias: onCurrentDayCountChanged ajusta el dia
//   seleccionado si excede los dias del nuevo mes (ej: de 31 a 28 en Feb).
// - new Date(year, month+1, 0).getDate(): truco de JS para obtener los
//   dias de un mes. El dia 0 del mes siguiente = ultimo dia del mes actual.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    readonly property list<string> monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    // -------------------------------------------------------------------------
    // Propiedades readonly derivadas del currentIndex de cada Tumbler.
    // Al ser readonly, solo se pueden cambiar mediante las funciones setter
    // (setDay, setMonth, setYear), garantizando consistencia.
    // -------------------------------------------------------------------------
    readonly property int selectedYear:  2000 + yearTumbler.currentIndex
    readonly property int selectedMonth: monthTumbler.currentIndex
    readonly property int selectedDay:   dayTumbler.currentIndex + 1
    readonly property int currentDayCount: daysInMonth(selectedMonth, selectedYear)

    // Truco de JS: new Date(year, month+1, 0) crea el "dia 0" del mes
    // siguiente, que es el ultimo dia del mes actual. getDate() lo devuelve.
    function daysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate()
    }

    // Funciones setter publicas: permiten al padre (Main.qml) actualizar
    // la fecha desde el CalendarCard sin acceder directamente a los Tumblers.
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

    // Validacion: si al cambiar de mes el dia seleccionado excede los dias
    // disponibles (ej: 31 de enero -> febrero con 28), se ajusta al ultimo dia.
    onCurrentDayCountChanged: {
        if (dayTumbler.currentIndex >= currentDayCount)
            dayTumbler.currentIndex = currentDayCount - 1
    }

    // Inicializa el picker en la fecha actual del sistema.
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

        // -----------------------------------------------------------------
        // Los 3 Tumblers: dia (numerico, wrap), mes (strings, wrap) y
        // anio (numerico, sin wrap para evitar ciclo infinito).
        // visibleItemCount: 5 muestra el item central + 2 arriba y 2 abajo.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(10)

            // Tumbler de dia: modelo dinamico (currentDayCount cambia con
            // el mes/anio). wrap: true permite scroll circular.
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

                    // Delegate con efecto de profundidad: font.pixelSize,
                    // opacity y color varian segun Tumbler.displacement.
                    // displacement = 0 en el centro, +/-1 en los extremos.
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

            // Tumbler de mes: usa monthNames como modelo de strings.
            // El delegate por defecto de Tumbler renderiza strings,
            // por lo que no necesita delegate personalizado aqui.
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

            // Tumbler de anio: modelo numerico de 51 elementos (2000-2050).
            // wrap: false para que no sea ciclico (los anios tienen limites).
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
                    model: 51  // 2000-2050
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

        // -----------------------------------------------------------------
        // Resumen de la fecha seleccionada: rectangulo con fondo teal
        // semitransparente y la fecha formateada como DD / MM / YYYY.
        // -----------------------------------------------------------------
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
