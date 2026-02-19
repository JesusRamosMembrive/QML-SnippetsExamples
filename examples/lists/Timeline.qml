// =============================================================================
// Timeline.qml — Lista vertical con apariencia de linea de tiempo
// =============================================================================
// Implementa una linea de tiempo vertical (timeline) con puntos, linea
// conectora y contenido a la derecha. Cada item muestra una fecha a la
// izquierda, un indicador circular en el centro, y titulo + descripcion
// a la derecha.
//
// Tecnicas clave:
//   1. Linea conectora continua: un Rectangle vertical de 2px de alto
//      se extiende de arriba a abajo del delegate (anchors.top/bottom).
//      Al tener spacing: 0 en el ListView, las lineas se conectan
//      visualmente entre delegates consecutivos.
//   2. Estado completado vs pendiente: el rol 'done' controla si el
//      punto esta relleno (color solido) o vacio (solo borde), y si
//      el texto usa colores activos o atenuados (Style.inactiveColor).
//   3. Punto interno: un circulo blanco mas pequenyo dentro del punto
//      coloreado crea el clasico indicador de "completado".
//   4. Layout hibrido: en vez de usar RowLayout, se usan anchors
//      manuales (anchors.left: timelineDot.right) para posicionar
//      los elementos respecto al punto central, dando mas control.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Timeline"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(420)
        color: Style.bgColor
        radius: Style.resize(8)
        clip: true

        // spacing: 0 es critico para que las lineas verticales de cada
        // delegate se conecten sin huecos entre items.
        ListView {
            id: timelineList
            anchors.fill: parent
            anchors.margins: Style.resize(10)
            clip: true
            spacing: 0

            model: ListModel {
                ListElement { title: "Project Kickoff"; desc: "Initial requirements gathered and team assembled"; date: "Jan 5"; clr: "#5B8DEF"; done: true }
                ListElement { title: "Architecture Design"; desc: "Module system, style engine, and navigation pattern defined"; date: "Jan 18"; clr: "#00D1A9"; done: true }
                ListElement { title: "Core Components"; desc: "Buttons, sliders, dials, indicators, and text inputs completed"; date: "Feb 3"; clr: "#34C759"; done: true }
                ListElement { title: "Advanced Pages"; desc: "Canvas, shapes, particles, transforms, and animations added"; date: "Feb 14"; clr: "#FF9500"; done: true }
                ListElement { title: "Maps & Navigation"; desc: "OpenStreetMap integration with GPS simulation and compass"; date: "Feb 17"; clr: "#AF52DE"; done: false }
                ListElement { title: "Testing & Polish"; desc: "Performance optimization, dark theme, and contrast fixes"; date: "Mar 1"; clr: "#FF3B30"; done: false }
                ListElement { title: "Release v1.0"; desc: "Final build, documentation, and deployment"; date: "Mar 15"; clr: "#FEA601"; done: false }
            }

            delegate: Item {
                id: timelineDelegate
                width: timelineList.width
                height: Style.resize(70)

                required property int index
                required property string title
                required property string desc
                required property string date
                required property string clr
                required property bool done

                // Linea vertical conectora: se extiende por toda la altura
                // del delegate. Como spacing=0 en el ListView, las lineas
                // de delegates adyacentes se tocan, creando una linea continua.
                Rectangle {
                    id: timelineLine
                    anchors.horizontalCenter: timelineDot.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Style.resize(2)
                    color: Qt.rgba(1, 1, 1, 0.1)
                }

                // Punto indicador: relleno si done=true, solo borde si pendiente.
                // El circulo blanco interno solo es visible en items completados.
                Rectangle {
                    id: timelineDot
                    x: Style.resize(40)
                    anchors.verticalCenter: parent.verticalCenter
                    width: Style.resize(16)
                    height: Style.resize(16)
                    radius: width / 2
                    color: timelineDelegate.done ? timelineDelegate.clr : "transparent"
                    border.color: timelineDelegate.clr
                    border.width: Style.resize(2)

                    // Inner dot for completed
                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(6)
                        height: Style.resize(6)
                        radius: width / 2
                        color: "#FFF"
                        visible: timelineDelegate.done
                    }
                }

                // Date label (left)
                Label {
                    anchors.right: timelineDot.left
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    text: timelineDelegate.date
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: timelineDelegate.done ? timelineDelegate.clr : Style.inactiveColor
                    horizontalAlignment: Text.AlignRight
                    width: Style.resize(30)
                }

                // Content (right)
                ColumnLayout {
                    anchors.left: timelineDot.right
                    anchors.leftMargin: Style.resize(14)
                    anchors.right: parent.right
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.resize(3)

                    Label {
                        text: timelineDelegate.title
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: timelineDelegate.done ? Style.fontPrimaryColor : Style.inactiveColor
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Label {
                        text: timelineDelegate.desc
                        font.pixelSize: Style.resize(11)
                        color: timelineDelegate.done ? Style.fontSecondaryColor : Qt.rgba(1, 1, 1, 0.25)
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
