// ============================================================================
// PulseButton.qml — Boton con efecto de anillo pulsante animado
// ============================================================================
//
// CONCEPTO CLAVE — Efecto de pulso:
//   Se usa un Rectangle separado (pulseCircle) DETRAS del cuerpo del boton
//   que se expande y desvanece continuamente, creando un efecto de "respiracion"
//   o "latido" que atrae la atencion del usuario.
//
// DOS ANIMACIONES SINCRONIZADAS (SequentialAnimation):
//   1. opacity: aparece (fade in 0->1) y desaparece (fade out 1->0)
//   2. scale:   crece (1->1.3) y encoge (1.3->1)
//   Ambas con la misma duracion y ciclo infinito. Al combinarse, crean un
//   anillo que se expande mientras se desvanece — efecto de onda expansiva.
//
// running: root.enabled && !root.pressed
//   - Se detiene cuando el boton esta deshabilitado (no hay accion posible)
//   - Se detiene al presionar (el usuario ya esta interactuando, la animacion
//     de atencion ya no es necesaria)
//
// ORDEN Z EN QML:
//   El rectangulo solido del boton se declara DESPUES de pulseCircle en el
//   codigo QML, por lo tanto tiene mayor z-order (aparece encima). Esto hace
//   que el pulso se vea como un anillo que emana desde DETRAS del boton.
// ============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    property color pulseColor: Style.mainColor
    property int pulseDuration: 1500

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        // Anillo pulsante — se declara PRIMERO, asi queda detras del boton solido.
        // Es transparente con solo borde visible, para crear el efecto de "aro".
        Rectangle {
            id: pulseCircle
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: height / 2
            color: "transparent"
            border.color: root.pulseColor
            border.width: Style.resize(2)
            opacity: 0

            // Animacion de opacidad: fade in (0->1) seguido de fade out (1->0)
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: root.enabled && !root.pressed
                NumberAnimation { to: 1; duration: root.pulseDuration / 2 }
                NumberAnimation { to: 0; duration: root.pulseDuration / 2 }
            }

            // Animacion de escala: crece (1->1.3) y encoge (1.3->1)
            // Sincronizada con la opacidad: crece mientras aparece, encoge al desvanecerse
            SequentialAnimation on scale {
                loops: Animation.Infinite
                running: root.enabled && !root.pressed
                NumberAnimation { from: 1; to: 1.3; duration: root.pulseDuration / 2 }
                NumberAnimation { from: 1.3; to: 1; duration: root.pulseDuration / 2 }
            }
        }

        // Cuerpo solido del boton — declarado despues de pulseCircle = z-order superior.
        // El pulso queda visible solo como anillo que "sale" por detras de este rectangulo.
        Rectangle {
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.pressed ? Qt.darker(root.pulseColor, 1.2) : root.pulseColor
        }
    }

    contentItem: Text {
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        font.family: Style.fontFamilyRegular
        font.pixelSize: Style.fontSizeM
    }
}
