// =============================================================================
// ElasticSpring.qml — Animacion de resorte elastico con SpringAnimation
// =============================================================================
// Demuestra SpringAnimation, uno de los tipos de animacion mas naturales de
// QML. Simula la fisica de un resorte: al soltar un objeto desplazado, este
// oscila alrededor de su posicion de equilibrio con amortiguamiento.
//
// SPRINGANIMATION VS NUMBERANIMATION:
//   - NumberAnimation: va del punto A al B en un tiempo fijo (lineal o con
//     easing). Predecible pero mecanico.
//   - SpringAnimation: simula un sistema masa-resorte-amortiguador. El
//     resultado depende de la distancia al destino, no de un tiempo fijo.
//     Se siente mas "fisico" y organico.
//
// PARAMETROS DEL RESORTE:
//   - spring (3): rigidez del resorte. Mayor = oscilaciones mas rapidas.
//   - damping (0.12): amortiguamiento. Mayor = se detiene antes. Si es 0,
//     oscila infinitamente. Si es muy alto, no oscila (overdamped).
//
// PATRON DE ARRASTRE: 'Behavior on x/y' se habilita/deshabilita con
// 'enabled: !isDragging'. Cuando el usuario arrastra, el Behavior se
// desactiva para que la bola siga el mouse directamente. Al soltar,
// se reactiva y la bola "rebota" hacia el centro con SpringAnimation.
//
// GUIAS VISUALES: los circulos concentricos y la cruceta central ayudan
// a percibir la posicion de equilibrio y la amplitud de la oscilacion.
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
        text: "3. Elastic Spring"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: springSection
            anchors.fill: parent
            property bool isDragging: false

            // Cruceta central: marca visual del punto de equilibrio (destino del resorte).
            Rectangle {
                x: springSection.width / 2 - Style.resize(15)
                y: springSection.height / 2 - 0.5
                width: Style.resize(30); height: 1
                color: Style.inactiveColor; opacity: 0.5
            }
            Rectangle {
                x: springSection.width / 2 - 0.5
                y: springSection.height / 2 - Style.resize(15)
                width: 1; height: Style.resize(30)
                color: Style.inactiveColor; opacity: 0.5
            }

            // Circulos de referencia: ayudan a visualizar la amplitud del rebote.
            Rectangle {
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(120); height: width; radius: width / 2
                color: "transparent"
                border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.3
            }
            Rectangle {
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(80); height: width; radius: width / 2
                color: "transparent"
                border.color: Style.inactiveColor; border.width: 0.5; opacity: 0.2
            }

            Rectangle {
                id: springBall
                x: springSection.width / 2 - width / 2
                y: springSection.height / 2 - height / 2
                width: Style.resize(50); height: width; radius: width / 2
                color: Style.mainColor

                Behavior on x {
                    enabled: !springSection.isDragging
                    SpringAnimation { spring: 3; damping: 0.12 }
                }
                Behavior on y {
                    enabled: !springSection.isDragging
                    SpringAnimation { spring: 3; damping: 0.12 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "Drag"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "white"
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: function(mouse) {
                    springSection.isDragging = true
                    springBall.x = mouse.x - springBall.width / 2
                    springBall.y = mouse.y - springBall.height / 2
                }
                onPositionChanged: function(mouse) {
                    if (pressed) {
                        springBall.x = mouse.x - springBall.width / 2
                        springBall.y = mouse.y - springBall.height / 2
                    }
                }
                onReleased: {
                    springSection.isDragging = false
                    springBall.x = springSection.width / 2 - springBall.width / 2
                    springBall.y = springSection.height / 2 - springBall.height / 2
                }
            }
        }
    }
}
