// =============================================================================
// SwipeToActionList.qml — Lista con gesto swipe para revelar acciones
// =============================================================================
// Implementa el patron "swipe to reveal" comun en apps moviles (iOS Mail,
// Android notificaciones): al deslizar un item hacia la izquierda, se
// revelan botones de accion (favorito y eliminar) debajo.
//
// Tecnica clave — capas superpuestas:
// Cada delegate tiene dos capas: una capa de fondo (background) con los
// botones de accion, y una capa frontal (foreground) con el contenido.
// El swipe se implementa moviendo la capa frontal en X con MouseArea:
//   - onPressed: guarda la posicion inicial del toque
//   - onPositionChanged: calcula el delta X y mueve la capa (solo izquierda)
//   - onReleased: si el desplazamiento supera un umbral, "engancha" la
//     posicion; si no, vuelve a X=0 con animacion
//
// swipeModel.remove(index) en el boton eliminar quita el item del modelo,
// lo que automaticamente destruye el delegate (QML gestiona el ciclo de vida).
//
// Este patron NO usa SwipeDelegate de Qt Controls (que seria mas simple)
// para demostrar como construirlo manualmente con MouseArea y animaciones.
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
        text: "Swipe-to-Action List"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(300)
        color: Style.bgColor
        radius: Style.resize(8)
        clip: true

        ListModel {
            id: swipeModel
            ListElement { msg: "Flight MH370 departed on time"; from: "ATC Tower"; time: "09:41"; clr: "#5B8DEF" }
            ListElement { msg: "Runway 27L cleared for landing"; from: "Ground Control"; time: "09:38"; clr: "#00D1A9" }
            ListElement { msg: "Weather advisory: crosswind 15kt"; from: "METAR"; time: "09:35"; clr: "#FF9500" }
            ListElement { msg: "Fuel report submitted"; from: "Dispatch"; time: "09:30"; clr: "#34C759" }
            ListElement { msg: "Gate B12 reassigned to flight IB3214"; from: "Ops Center"; time: "09:22"; clr: "#AF52DE" }
            ListElement { msg: "Passenger count confirmed: 186 PAX"; from: "Check-in"; time: "09:15"; clr: "#FF3B30" }
            ListElement { msg: "Catering loaded on stand"; from: "Ground Handling"; time: "09:10"; clr: "#FEA601" }
        }

        ListView {
            id: swipeListView
            anchors.fill: parent
            anchors.margins: Style.resize(6)
            model: swipeModel
            clip: true
            spacing: Style.resize(4)

            delegate: Item {
                id: swipeDelegate
                width: swipeListView.width
                height: Style.resize(60)

                required property int index
                required property string msg
                required property string from
                required property string time
                required property string clr

                property real swipeX: 0
                property bool swiped: false

                // Capa de fondo: siempre presente pero oculta debajo de la
                // capa frontal. Solo se ve cuando swipeX < 0 (desplazamiento).
                // Contiene los botones de accion alineados a la derecha.
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(8)
                    color: "#2D1A1A"

                    RowLayout {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: Style.resize(15)
                        spacing: Style.resize(12)

                        Rectangle {
                            width: Style.resize(36)
                            height: Style.resize(36)
                            radius: width / 2
                            color: "#FF9500"

                            Label {
                                anchors.centerIn: parent
                                text: "★"
                                font.pixelSize: Style.resize(16)
                                color: "#FFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    swipeDelegate.swipeX = 0
                                    swipeDelegate.swiped = false
                                }
                            }
                        }

                        Rectangle {
                            width: Style.resize(36)
                            height: Style.resize(36)
                            radius: width / 2
                            color: "#FF3B30"

                            Label {
                                anchors.centerIn: parent
                                text: "✕"
                                font.pixelSize: Style.resize(16)
                                font.bold: true
                                color: "#FFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: swipeModel.remove(swipeDelegate.index)
                            }
                        }
                    }
                }

                // Capa frontal: se desplaza en X segun el gesto del usuario.
                // Behavior on x anima el "enganche" y el retorno a la posicion.
                Rectangle {
                    id: swipeFg
                    width: parent.width
                    height: parent.height
                    radius: Style.resize(8)
                    color: Style.surfaceColor
                    x: swipeDelegate.swipeX

                    Behavior on x {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(10)
                        spacing: Style.resize(10)

                        Rectangle {
                            width: Style.resize(4)
                            height: Style.resize(36)
                            radius: Style.resize(2)
                            color: swipeDelegate.clr
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(2)

                            Label {
                                text: swipeDelegate.msg
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Label {
                                text: swipeDelegate.from
                                font.pixelSize: Style.resize(11)
                                color: Style.fontSecondaryColor
                            }
                        }

                        Label {
                            text: swipeDelegate.time
                            font.pixelSize: Style.resize(11)
                            color: Style.inactiveColor
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        property real startX: 0

                        onPressed: function(mouse) { startX = mouse.x }
                        onPositionChanged: function(mouse) {
                            var dx = mouse.x - startX
                            if (dx < 0)
                                swipeDelegate.swipeX = Math.max(-Style.resize(110), dx)
                        }
                        onReleased: {
                            if (swipeDelegate.swipeX < -Style.resize(50)) {
                                swipeDelegate.swipeX = -Style.resize(110)
                                swipeDelegate.swiped = true
                            } else {
                                swipeDelegate.swipeX = 0
                                swipeDelegate.swiped = false
                            }
                        }
                    }
                }
            }
        }
    }

    Label {
        text: "← Swipe left to reveal Star and Delete actions"
        font.pixelSize: Style.resize(12)
        color: Style.fontSecondaryColor
    }
}
