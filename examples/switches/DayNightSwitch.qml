// =============================================================================
// DayNightSwitch.qml — Switch tematico dia/noche con animaciones decorativas
// =============================================================================
// Ejemplo avanzado de un switch completamente custom que va mucho mas alla
// de un simple toggle: incluye estrellas, rayos de sol, crateres de luna,
// y transiciones visuales coordinadas entre todos los elementos.
//
// Tecnicas clave demostradas:
//   1. Composicion visual: multiples Rectangles pequenyos simulan estrellas
//      y crateres, posicionados con coordenadas relativas (0.0 a 1.0)
//   2. Transform + Rotation: los rayos del sol usan un Repeater de 8 items
//      con angulos de 45 grados, rotados desde un punto de origen desplazado
//   3. Animaciones coordinadas: todas las propiedades (x, color, opacity)
//      usan la misma duracion (400ms) para que la transicion sea coherente
//   4. Easing.InOutCubic en el movimiento del knob da sensacion de peso
//
// Patron de estado: isNight vive en el Item padre y se accede como
// dayNightTrack.parent.isNight desde los hijos. Un diseno mas limpio
// usaria un id dedicado, pero este patron demuestra la cadena de padres.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Day / Night Switch"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(80)

        property bool isNight: true

        // Track: el fondo del switch cambia entre azul oscuro (noche)
        // y azul cielo (dia) con ColorAnimation de 500ms.
        Rectangle {
            id: dayNightTrack
            anchors.centerIn: parent
            width: Style.resize(160)
            height: Style.resize(60)
            radius: height / 2
            color: parent.isNight ? "#1A237E" : "#42A5F5"

            Behavior on color { ColorAnimation { duration: 500 } }

            // Estrellas: Repeater de 5 Rectangles circulares posicionados con
            // coordenadas relativas (sx, sy). opacity anima a 0 de dia.
            // Este patron de "particulas manuales" es mas ligero que usar
            // el modulo Particles para elementos decorativos simples.
            Repeater {
                model: [
                    { sx: 0.2, sy: 0.25, size: 3 },
                    { sx: 0.35, sy: 0.6, size: 2 },
                    { sx: 0.7, sy: 0.2, size: 2.5 },
                    { sx: 0.8, sy: 0.65, size: 2 },
                    { sx: 0.55, sy: 0.35, size: 1.5 }
                ]

                Rectangle {
                    required property var modelData
                    x: dayNightTrack.width * modelData.sx
                    y: dayNightTrack.height * modelData.sy
                    width: modelData.size
                    height: width
                    radius: width / 2
                    color: "white"
                    opacity: dayNightTrack.parent.isNight ? 0.8 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 400 } }
                }
            }

            // Knob (sol/luna): se desplaza horizontalmente entre los extremos
            // del track. x usa un ternario para la posicion, con Easing.InOutCubic
            // que da sensacion de aceleracion/desaceleracion natural.
            Rectangle {
                id: dayNightKnob
                width: Style.resize(48)
                height: width
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                x: dayNightTrack.parent.isNight
                   ? parent.width - width - Style.resize(6)
                   : Style.resize(6)
                color: dayNightTrack.parent.isNight ? "#ECEFF1" : "#FFD54F"

                Behavior on x {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InOutCubic
                    }
                }
                Behavior on color { ColorAnimation { duration: 400 } }

                // Moon crater (night only)
                Rectangle {
                    x: parent.width * 0.55
                    y: parent.height * 0.2
                    width: parent.width * 0.2
                    height: width
                    radius: width / 2
                    color: Qt.darker(parent.color, 1.15)
                    opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }

                Rectangle {
                    x: parent.width * 0.3
                    y: parent.height * 0.55
                    width: parent.width * 0.15
                    height: width
                    radius: width / 2
                    color: Qt.darker(parent.color, 1.15)
                    opacity: dayNightTrack.parent.isNight ? 1.0 : 0.0

                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }

                // Rayos del sol: 8 rectangulos finos distribuidos cada 45 grados.
                // transform: Rotation rota cada rayo alrededor de un punto de
                // origen desplazado (origin.y = knob.width * 0.55), lo que crea
                // el efecto de rayos emanando del centro del knob.
                // anchors.verticalCenterOffset desplaza el rayo hacia arriba
                // antes de rotar, creando la distancia desde el centro.
                Repeater {
                    model: 8

                    Rectangle {
                        id: sunRay
                        required property int index
                        property real rayAngle: index * 45

                        width: Style.resize(3)
                        height: Style.resize(8)
                        radius: width / 2
                        color: "#FFD54F"
                        opacity: dayNightTrack.parent.isNight ? 0.0 : 0.9
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.width * 0.55

                        transform: Rotation {
                            origin.x: sunRay.width / 2
                            origin.y: dayNightKnob.width * 0.55
                            angle: sunRay.rayAngle
                        }

                        Behavior on opacity { NumberAnimation { duration: 300 } }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: dayNightTrack.parent.isNight ? "\uD83C\uDF19" : "\u2600"
                    font.pixelSize: Style.resize(20)
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: dayNightTrack.parent.isNight = !dayNightTrack.parent.isNight
            }
        }

        // Status text
        Label {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: parent.isNight ? "Night Mode" : "Day Mode"
            font.pixelSize: Style.resize(14)
            color: parent.isNight ? "#90CAF9" : "#FFD54F"
            font.bold: true

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }
}
