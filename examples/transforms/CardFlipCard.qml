// =============================================================================
// CardFlipCard.qml — Efecto de volteo de tarjeta con rotacion 3D en eje Y
// =============================================================================
// Implementa el clasico efecto "card flip" usando rotacion 3D alrededor del
// eje Y. Este patron es muy comun en UIs para mostrar informacion de dos
// caras (credenciales, tarjetas de credito, flashcards educativas, etc.).
//
// COMO FUNCIONA:
//   1. transform: Rotation con axis { y: 1 } rota el item en 3D.
//   2. flipAngle va de 0 a 180 grados con Behavior animado (600ms).
//   3. La cara frontal es visible cuando flipAngle < 90 o > 270.
//   4. La cara trasera es visible cuando flipAngle >= 90 y <= 270.
//   5. La cara trasera tiene 'transform: Scale { xScale: -1 }' para
//      contrarrestar el efecto espejo de la rotacion Y (sin esto, el
//      texto se veria al reves cuando la tarjeta esta girada).
//
// POR QUE SCALE -1 EN LA CARA TRASERA: cuando un item se rota 180 grados
// en Y, se ve reflejado horizontalmente (como un espejo). Aplicar
// Scale { xScale: -1 } sobre la cara trasera cancela este reflejo,
// haciendo que el texto se lea correctamente.
//
// BEHAVIOR VS ANIMATION: aqui se usa 'Behavior on flipAngle' en lugar de
// una animacion explicita. Behavior se activa automaticamente cada vez que
// la propiedad cambia, lo cual es ideal para transiciones toggle (on/off).
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
            text: "Card Flip"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: flipCard.flipped ? "Showing: Back" : "Showing: Front"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.fontSecondaryColor
        }

        // Area de flip: contiene el item flipCard que aloja ambas caras.
        // Las dos caras se apilan (anchors.fill: parent) y se alternan
        // con 'visible' segun el angulo actual de rotacion.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(6)
            }

            Item {
                id: flipCard
                anchors.centerIn: parent
                width: Style.resize(180)
                height: Style.resize(220)

                property bool flipped: false
                property real flipAngle: 0

                Behavior on flipAngle {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                }

                transform: Rotation {
                    origin.x: flipCard.width / 2
                    origin.y: flipCard.height / 2
                    axis { x: 0; y: 1; z: 0 }
                    angle: flipCard.flipAngle
                }

                // Cara frontal (teal): visible cuando la tarjeta esta de frente
                // (angulo < 90) o casi completando el giro (> 270).
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: Style.mainColor
                    visible: flipCard.flipAngle < 90 || flipCard.flipAngle > 270

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Rectangle {
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: width / 2
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                anchors.centerIn: parent
                                text: "Qt"
                                font.pixelSize: Style.resize(24)
                                font.bold: true
                                color: Style.mainColor
                            }
                        }

                        Label {
                            text: "FRONT"
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Click to flip"
                            font.pixelSize: Style.resize(13)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Cara trasera (ambar): visible solo durante la mitad "girada".
                // Scale { xScale: -1 } compensa el efecto espejo de la rotacion Y
                // para que el contenido se lea correctamente.
                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(12)
                    color: "#FEA601"
                    visible: flipCard.flipAngle >= 90 && flipCard.flipAngle <= 270

                    // Mirror to counteract the Y rotation
                    transform: Scale {
                        origin.x: flipCard.width / 2
                        xScale: -1
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Rectangle {
                            width: Style.resize(60)
                            height: Style.resize(60)
                            radius: Style.resize(8)
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter

                            Label {
                                anchors.centerIn: parent
                                text: "QML"
                                font.pixelSize: Style.resize(18)
                                font.bold: true
                                color: "#FEA601"
                            }
                        }

                        Label {
                            text: "BACK"
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: "Click to flip back"
                            font.pixelSize: Style.resize(13)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flipCard.flipped = !flipCard.flipped
                        flipCard.flipAngle = flipCard.flipped ? 180 : 0
                    }
                }
            }
        }

        Label {
            text: "3D Y-axis Rotation to create a card flip. Click to toggle front/back"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
