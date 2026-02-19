// =============================================================================
// GridLayoutCard.qml — Demo interactiva de GridLayout con span de celdas
// =============================================================================
// GridLayout es el layout mas versatil de Qt Quick Layouts. Permite organizar
// elementos en una cuadricula de filas y columnas, similar a CSS Grid o a
// las tablas de HTML, pero con la ventaja de ser reactivo.
//
// Conceptos clave demostrados:
// 1. columns: define cuantas columnas tiene la cuadricula. Los hijos se
//    colocan automaticamente de izquierda a derecha, saltando a la
//    siguiente fila al llenar las columnas.
//
// 2. Layout.columnSpan / Layout.rowSpan: permiten que una celda ocupe
//    multiples columnas o filas, creando layouts asimetricos (como un
//    "merge cells" en una hoja de calculo).
//
// 3. Math.min(2, colSlider.value): proteccion necesaria porque el
//    columnSpan no puede exceder el numero total de columnas — si el
//    slider baja a 2, un span de 3 causaria un error.
//
// 4. Slider reactivo: permite cambiar el numero de columnas en vivo
//    para visualizar como se redistribuyen los elementos.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "GridLayout"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // Control interactivo del numero de columnas
        // El slider vincula su valor a la propiedad `columns` del GridLayout.
        // Cambiar columnas re-distribuye automaticamente todos los hijos.
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Columns: " + colSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: colSlider
                    anchors.fill: parent
                    from: 2
                    to: 4
                    value: 3
                    stepSize: 1
                }
            }
        }

        // ---------------------------------------------------------------------
        // Cuadricula principal
        // Mezcla celdas normales (1x1) con celdas que abarcan multiples
        // columnas (columnSpan: 2) o multiples filas (rowSpan: 2).
        // fillWidth hace que cada celda se expanda para llenar su columna.
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            GridLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                columns: colSlider.value
                rowSpacing: Style.resize(6)
                columnSpacing: Style.resize(6)

                // Celda ancha: ocupa 2 columnas (o todas si solo hay 2)
                Rectangle {
                    Layout.columnSpan: Math.min(2, colSlider.value)
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#4A90D9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#00D1A9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                // Celda alta: ocupa 2 filas para crear un layout asimetrico
                Rectangle {
                    Layout.rowSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#FEA601"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "rowSpan\n2"; color: "white"; font.pixelSize: Style.resize(11); horizontalAlignment: Text.AlignHCenter }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#9B59B6"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#E74C3C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#1ABC9C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#FF5900"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                }

                Rectangle {
                    Layout.columnSpan: Math.min(2, colSlider.value)
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(50)
                    color: "#636E72"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                }
            }
        }

        Label {
            text: "GridLayout with columnSpan and rowSpan for complex arrangements"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
