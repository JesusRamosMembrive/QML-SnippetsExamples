// ============================================================================
// NeumorphicButton.qml — Boton con diseno neumorfico (soft UI / neumorfismo)
// ============================================================================
//
// QUE ES EL NEUMORFISMO:
//   Una tendencia de diseno donde los elementos parecen extruirse o hundirse
//   en la superficie del fondo, usando sombras duales (clara + oscura) para
//   simular profundidad 3D. El efecto depende de que el color del elemento
//   sea MUY SIMILAR al color del fondo — por eso baseColor debe coincidir
//   con el fondo del contenedor padre.
//
// EFECTO DE EXTRUSION (estado normal — no presionado):
//   Dos DropShadow externos crean la ilusion de relieve:
//   1. Sombra clara (Qt.lighter) arriba-izquierda: simula la fuente de luz
//   2. Sombra oscura (Qt.darker) abajo-derecha: simula la sombra proyectada
//   Juntas dan la ilusion de que el boton esta ELEVADO sobre la superficie.
//
// EFECTO DE HUNDIMIENTO (estado presionado):
//   Ambas sombras externas se ocultan (visible: !root.pressed) y aparece un
//   InnerShadow, creando la ilusion de que el boton se HUNDE en la superficie.
//
// InnerShadow (de Qt5Compat.GraphicalEffects):
//   Dibuja la sombra DENTRO de los limites del elemento (a diferencia de
//   DropShadow que dibuja fuera). Esto simula una cavidad o depresion.
//
// IMPORTANTE: baseColor debe coincidir con el color de fondo del contenedor
//   padre para que la ilusion neumorfica funcione correctamente. Si los colores
//   no coinciden, las sombras se veran como manchas desconectadas.
// ============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    // baseColor: DEBE coincidir con el fondo del contenedor para la ilusion neumorfica
    property color baseColor: Style.bgColor
    property real shadowDistance: 10
    property real shadowBlur: 20

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        // Sombra clara arriba-izquierda: simula luz viniendo desde esa direccion.
        // Qt.lighter(baseColor, 1.3) genera un tono mas claro del color base.
        // Offset negativo = desplaza la sombra hacia arriba-izquierda.
        // Se oculta al presionar para dar paso al efecto de hundimiento.
        DropShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: -Style.resize(root.shadowDistance)
            verticalOffset: -Style.resize(root.shadowDistance)
            radius: Style.resize(root.shadowBlur)
            samples: 17
            color: Qt.lighter(root.baseColor, 1.3)
            visible: !root.pressed
        }

        // Sombra oscura abajo-derecha: simula la sombra proyectada por la "luz".
        // Qt.darker(baseColor, 1.3) genera un tono mas oscuro del color base.
        // Offset positivo = desplaza la sombra hacia abajo-derecha.
        DropShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: Style.resize(root.shadowDistance)
            verticalOffset: Style.resize(root.shadowDistance)
            radius: Style.resize(root.shadowBlur)
            samples: 17
            color: Qt.darker(root.baseColor, 1.3)
            visible: !root.pressed
        }

        // Cuerpo del boton — mismo color que el fondo (clave del neumorfismo)
        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.baseColor
        }

        // InnerShadow: sombra INTERNA que aparece solo al presionar.
        // Crea la ilusion de que el boton se hunde en la superficie.
        // A diferencia de DropShadow (sombra exterior), InnerShadow dibuja
        // la sombra dentro de los limites del elemento.
        InnerShadow {
            anchors.fill: backgroundRect
            source: backgroundRect
            horizontalOffset: Style.resize(root.shadowDistance / 2)
            verticalOffset: Style.resize(root.shadowDistance / 2)
            radius: Style.resize(root.shadowBlur / 2)
            samples: 17
            color: Qt.darker(root.baseColor, 1.5)
            visible: root.pressed
        }
    }

    contentItem: Text {
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Style.mainColor
        font.family: Style.fontFamilyRegular
        font.pixelSize: Style.fontSizeM
    }
}
