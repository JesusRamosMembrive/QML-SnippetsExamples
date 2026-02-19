// =============================================================================
// ToolButton.qml - Override de estilo para ToolButton (boton de barra de herramientas)
// =============================================================================
//
// ToolButton es similar a Button pero diseñado para barras de herramientas.
// En este estilo, soporta icono + texto alineados horizontalmente.
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de ToolButton. Importar Controls causaria recursion infinita.
//   Templates provee solo la logica (click, checked, icon) sin apariencia.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - background: aqui colocamos el icono (atipico — normalmente iria
//     en contentItem, pero en este diseño el icono es parte del "fondo")
//   - contentItem: el texto del boton, desplazado a la derecha del icono
//
// icon.source:
//   Propiedad integrada de AbstractButton. Se configura por instancia:
//     ToolButton { icon.source: "qrc:/icons/save.png" }
//   Qt expone icon.source, icon.color, icon.width, icon.height.
//
// layer.enabled: !!root.icon.color
//   La doble negacion (!!) convierte cualquier valor a booleano:
//     "" (vacio) --> false (no aplicar overlay de color)
//     "#00D1A9"  --> true  (aplicar overlay de color)
//   Si icon.color esta definido, se activa el layer y el ColorOverlay
//   tiñe el icono con ese color. Esto permite tinting opcional.
//
// contentItem con margen adaptativo:
//   leftMargin se ajusta segun si hay icono o no:
//     - Con icono: se desplaza a la derecha (iconImg.width + separacion)
//     - Sin icono: margen 0 (el texto empieza desde la izquierda)
//   Esto hace que el mismo ToolButton funcione con o sin icono.
// =============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.ToolButton {
    id: root

    implicitWidth: Style.resize(140)
    implicitHeight: Style.resize(40)
    icon.color: Style.mainColor

    // SLOT background: contiene el icono (diseño atipico para este componente)
    background: Item {
        id: background
        anchors.fill: parent
        Image {
            id: iconImg
            width: Style.resize(sourceSize.width)
            height: Style.resize(sourceSize.height)
            anchors.verticalCenter: parent.verticalCenter
            // icon.source viene de la propiedad integrada de AbstractButton
            source: icon.source
            // !!icon.color: doble negacion convierte a bool.
            // Si hay color definido, activa el overlay para teñir el icono
            layer.enabled: !!root.icon.color
            layer.effect: ColorOverlay {
                color: root.icon.color
            }
        }
    }

    // SLOT contentItem: texto con margen adaptativo segun presencia de icono
    contentItem: Item {
        width: (parent.width - iconImg.width)
        height: parent.height
        anchors.left: parent.left
        // Si hay icono, desplazar texto a la derecha; si no, margen 0
        anchors.leftMargin: (iconImg.width > 0) ? (iconImg.width + Style.resize(10)) : 0
        Label {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            text: root.text
            color: root.pressed ? Style.mainColor : Style.inactiveColor
        }
    }
}
