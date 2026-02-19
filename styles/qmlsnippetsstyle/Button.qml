// =============================================================================
// Button.qml - Override de estilo para Button
// =============================================================================
//
// Este es el override mas complejo de controles estandar en este proyecto.
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de Button. Si importaramos Controls, Qt intentaria cargar
//   el estilo de Button para crear nuestro Button, causando recursion infinita.
//   Templates provee solo la logica base (señales, propiedades, estados)
//   sin ninguna apariencia visual — nosotros definimos toda la parte visual.
//
// SLOTS VISUALES QUE SOBREESCRIBIMOS:
//   - background: lo que se dibuja detras del boton (sombra + rectangulo)
//   - contentItem: el contenido visible del boton (texto centrado)
//
// PROPIEDAD __bgColor — "binding con bloque JavaScript":
//   La sintaxis { if(...) return ...; } dentro de un binding es un bloque
//   imperativo de JS. QML lo re-evalua automaticamente cada vez que cambia
//   cualquier propiedad referenciada (enabled, flat, pressed, hovered, highlighted).
//   El orden de los if's establece la PRIORIDAD DE ESTADOS:
//     1. disabled (mayor prioridad — siempre gris)
//     2. flat + pressed (semi-transparente, 20% alfa)
//     3. flat + hovered (semi-transparente, 10% alfa)
//     4. flat sin interaccion (transparente)
//     5. pressed (Qt.darker = oscurece el color base)
//     6. hovered (Qt.lighter = aclara el color base)
//     7. highlighted (aun mas claro que hover)
//     8. normal (color base sin modificar)
//
// CONVENCION DEL PREFIJO __:
//   El doble guion bajo indica propiedad privada/interna. No esta pensada
//   para uso externo — es un patron comun en QML para señalar "no tocar".
//
// BOTONES FLAT:
//   Los botones flat usan Qt.rgba() con canal alfa (0.0-1.0) para crear
//   fondos semi-transparentes. Esto permite que el fondo del padre se vea
//   a traves del boton, dando un aspecto mas sutil.
//
// SISTEMA DE PALETTE:
//   palette.button y palette.buttonText son parte del sistema de paleta
//   integrado de Qt. Se pueden sobreescribir por instancia:
//     Button { palette.button: "red" }
//
// Qt.darker() y Qt.lighter():
//   Funciones integradas de Qt para manipular colores.
//   Factor > 1.0 = mas oscuro/claro. Ej: Qt.darker(color, 1.2) = 20% mas oscuro.
//
// BACKGROUND COMO Item (no Rectangle):
//   Usamos un Item como contenedor porque necesitamos DOS elementos:
//   el DropShadow (sombra de profundidad) y el Rectangle de relleno.
//   Un Rectangle no puede contener un DropShadow como hermano facilmente.
//
// DropShadow:
//   Crea ilusion de profundidad. Solo visible en botones no-flat.
//   El estado highlighted aumenta la sombra para dar mas "elevacion".
//
// LABEL EN contentItem:
//   Label aqui es NUESTRO Label.qml del mismo modulo de estilo (no el de
//   Controls). Los tipos definidos en el mismo modulo QML estan en scope
//   automaticamente, sin necesidad de importarlos.
// =============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Button {
    id: root
    implicitWidth: Style.resize(120)
    implicitHeight: Style.resize(40)

    // Paleta por defecto — se puede sobreescribir por instancia
    palette.button: Style.mainColor
    palette.buttonText: Style.fontContrastColor

    // __ prefijo = propiedad privada. Binding con bloque JS: se re-evalua
    // automaticamente cuando cambia enabled, flat, pressed, hovered o highlighted.
    readonly property color __bgColor: {
        if (!root.enabled)
            return Style.inactiveColor
        // Botones flat: fondo semi-transparente usando canal alfa
        if (root.flat) {
            if (root.pressed)
                return Qt.rgba(root.palette.button.r, root.palette.button.g, root.palette.button.b, 0.2)
            if (root.hovered)
                return Qt.rgba(root.palette.button.r, root.palette.button.g, root.palette.button.b, 0.1)
            return "transparent"
        }
        // Botones normales: Qt.darker/lighter manipulan el color base
        if (root.pressed)
            return Qt.darker(root.palette.button, 1.2)
        if (root.hovered)
            return Qt.lighter(root.palette.button, 1.1)
        if (root.highlighted)
            return Qt.lighter(root.palette.button, 1.15)
        return root.palette.button
    }

    // Color del texto: flat usa el color del boton, normal usa el contraste
    readonly property color __textColor: {
        if (!root.enabled)
            return root.flat ? Style.inactiveColor : root.palette.buttonText
        if (root.flat)
            return root.palette.button
        return root.palette.buttonText
    }

    // SLOT background: Item envuelve DropShadow + Rectangle porque
    // necesitamos dos elementos hermanos (sombra y relleno)
    background: Item {
        anchors.fill: parent
        // DropShadow: solo visible en botones no-flat. highlighted = mas sombra
        DropShadow {
            anchors.fill: backgroundFill
            visible: !root.flat
            verticalOffset: root.highlighted ? Style.resize(4) : Style.resize(3)
            radius: root.highlighted ? Style.resize(12) : Style.resize(8)
            samples: 17
            color: root.highlighted ? "#90000000" : "#80000000"
            source: backgroundFill
        }
        Rectangle {
            id: backgroundFill
            anchors.fill: parent
            radius: Style.resize(30)
            color: root.__bgColor
        }
    }

    // SLOT contentItem: Label es NUESTRO Label.qml (mismo modulo, en scope)
    contentItem: Item {
        anchors.fill: parent
        Label {
            anchors.centerIn: parent
            color: root.__textColor
            text: root.text
            font.bold: root.highlighted
        }
    }
}
