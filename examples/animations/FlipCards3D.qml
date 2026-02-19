// =============================================================================
// FlipCards3D.qml — Efecto de volteo 3D con Rotation y Behavior
// =============================================================================
// Simula tarjetas que giran en 3D al hacer clic, mostrando una cara frontal
// y una trasera. Aunque QML no tiene un motor 3D completo, el elemento
// Rotation con axis { y: 1 } crea una perspectiva convincente de giro
// sobre el eje Y.
//
// TRUCO CLAVE - Simular dos caras:
//   Se usan dos Rectangles superpuestos (front y back). La visibilidad
//   se controla con el angulo de rotacion:
//   - Front visible cuando flipAngle < 90 (cara hacia el usuario)
//   - Back visible cuando flipAngle >= 90 (cara opuesta)
//   El back se rota flipAngle - 180 para que el texto NO aparezca espejado.
//
// Behavior on flipAngle anima la transicion entre 0 y 180 grados con
// easing InOutQuad, creando un movimiento natural de volteo.
//
// El Repeater genera las 4 tarjetas a partir de un array de objetos JS,
// lo cual demuestra como usar modelos inline con delegates personalizados.
// 'required property var modelData' y 'required property int index' son
// obligatorios para acceder a los datos dentro del delegate.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    Label {
        text: "3D Flip Cards"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(20)
        Layout.alignment: Qt.AlignHCenter

        Repeater {
            model: [
                { front: "Click Me", back: "Hello!", clr: "#00D1A9" },
                { front: "Hover", back: "Surprise!", clr: "#5B8DEF" },
                { front: "Flip", back: "Magic!", clr: "#FF9500" },
                { front: "Touch", back: "Nice!", clr: "#FF3B30" }
            ]

            delegate: Item {
                id: flipCard
                Layout.preferredWidth: Style.resize(140)
                Layout.preferredHeight: Style.resize(180)

                required property var modelData
                required property int index

                property bool flipped: false
                property real flipAngle: 0

                // Behavior automatiza la animacion: al asignar flipAngle = 180,
                // el valor interpola suavemente de 0 a 180 en 600ms.
                Behavior on flipAngle {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                }

                // Cara frontal: visible solo cuando el angulo < 90 grados.
                // La Rotation transforma visualmente el rectangulo sin moverlo
                // de su posicion en el layout. origin define el centro de giro.
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: flipCard.modelData.clr
                    visible: flipCard.flipAngle < 90
                    opacity: visible ? 1 : 0

                    transform: Rotation {
                        origin.x: flipCard.width / 2
                        origin.y: flipCard.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: flipCard.flipAngle
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "\u25B6"
                            font.pixelSize: Style.resize(30)
                            color: "#FFFFFF"
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: flipCard.modelData.front
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }

                // Cara trasera: visible cuando flipAngle >= 90. Se rota
                // flipAngle - 180 para compensar y que el texto sea legible
                // (sin esto, el texto apareceria espejado horizontalmente).
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: Style.surfaceColor
                    border.color: flipCard.modelData.clr
                    border.width: Style.resize(2)
                    visible: flipCard.flipAngle >= 90
                    opacity: visible ? 1 : 0

                    transform: Rotation {
                        origin.x: flipCard.width / 2
                        origin.y: flipCard.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: flipCard.flipAngle - 180
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "\u2726"
                            font.pixelSize: Style.resize(30)
                            color: flipCard.modelData.clr
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: flipCard.modelData.back
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: flipCard.modelData.clr
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        flipCard.flipped = !flipCard.flipped
                        flipCard.flipAngle = flipCard.flipped ? 180 : 0
                    }
                }
            }
        }
    }
}
