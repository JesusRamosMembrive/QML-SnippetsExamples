// =============================================================================
// CalendarCard.qml — Tarjeta de ejemplo: calendario mensual con MonthGrid
// =============================================================================
// Calendario interactivo construido con los controles nativos de Qt 6:
// DayOfWeekRow para la cabecera de dias de la semana y MonthGrid para la
// cuadricula del mes. Diseñado como componente "controlado": recibe la
// fecha seleccionada como propiedades y emite senales para que el padre
// gestione la logica de navegacion.
//
// Patrones clave para el aprendiz:
// - MonthGrid + DayOfWeekRow: componentes de Qt Quick Controls 2 que
//   generan automaticamente la estructura del calendario, incluyendo los
//   dias de meses adyacentes en las filas incompletas.
// - Patron "controlled component": las propiedades selectedYear/Month/Day
//   vienen del padre (Main.qml), y las acciones del usuario se comunican
//   mediante senales (previousMonth, nextMonth, dayClicked, todayClicked).
//   Esto mantiene el estado en un unico lugar (el picker).
// - delegate personalizado con multiples estados visuales: seleccionado
//   (fondo teal), hoy (fondo teal semitransparente), otro mes (texto
//   muy tenue) y dia normal. Se usa una cadena de ternarios para el color.
// - model.today: propiedad del modelo de MonthGrid que indica si la celda
//   corresponde a la fecha actual del sistema.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Propiedades recibidas del padre. Al ser bindings, cualquier cambio
    // en el TumblerDatePicker se refleja aqui automaticamente.
    property var monthNames: []
    property int selectedYear: 2000
    property int selectedMonth: 0
    property int selectedDay: 1

    // Senales que el padre conecta para manejar la logica de navegacion.
    // Este componente no modifica el estado directamente; solo notifica.
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

        // -----------------------------------------------------------------
        // Cabecera de navegacion: botones "<" y ">" para cambiar de mes,
        // con el nombre del mes y anio centrado. Los botones emiten las
        // senales previousMonth/nextMonth que el padre gestiona.
        // -----------------------------------------------------------------
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

        // -----------------------------------------------------------------
        // Cabecera de dias de la semana: DayOfWeekRow genera automaticamente
        // las abreviaturas (Mon, Tue...) segun el locale. El delegate
        // personalizado permite controlar el estilo visual.
        // -----------------------------------------------------------------
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

        // Separador visual entre la cabecera y la cuadricula.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Style.bgColor
        }

        // -----------------------------------------------------------------
        // Cuadricula del mes: MonthGrid genera 6 filas x 7 columnas de dias.
        // Las celdas de meses adyacentes (model.month != monthGrid.month)
        // se muestran con opacidad reducida. El delegate usa 3 propiedades
        // computadas (isCurrentMonth, isSelected, isToday) para simplificar
        // la logica de estilo condicional.
        // -----------------------------------------------------------------
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

                // Propiedades computadas para legibilidad del codigo.
                readonly property bool isCurrentMonth:
                    model.month === monthGrid.month
                readonly property bool isSelected:
                    isCurrentMonth
                    && model.day === root.selectedDay
                readonly property bool isToday: model.today

                implicitWidth: (monthGrid.width - 6 * monthGrid.spacing) / 7
                implicitHeight: Style.resize(36)
                radius: width / 2
                // Jerarquia de colores: seleccionado > hoy > transparente.
                color: isSelected ? Style.mainColor
                     : isToday   ? Qt.rgba(Style.mainColor.r,
                                            Style.mainColor.g,
                                            Style.mainColor.b, 0.15)
                     : "transparent"

                // Texto del dia con colores condicionales:
                // seleccionado usa color de contraste, dias de otro mes
                // usan opacidad muy baja, hoy usa teal, resto usa blanco.
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

        // Boton "Today" para volver rapidamente a la fecha actual.
        Button {
            text: "Today"
            flat: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: Style.resize(32)
            onClicked: root.todayClicked()
        }
    }
}
