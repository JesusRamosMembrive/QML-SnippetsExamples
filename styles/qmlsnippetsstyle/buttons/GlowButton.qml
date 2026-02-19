// ============================================================================
// GlowButton.qml — Boton con efecto de resplandor exterior (neon/glow)
// ============================================================================
//
// NOTA: Este archivo NO es un override de estilo Qt (no se llama Button.qml).
// Es un componente personalizado que vive dentro del modulo de estilo por
// conveniencia organizativa. Se usa directamente por nombre: GlowButton { }
//
// CONCEPTO CLAVE — Glow (de Qt5Compat.GraphicalEffects):
//   Crea un halo de color alrededor de un item. Funciona como DropShadow pero
//   irradia en todas las direcciones de forma uniforme, generando un efecto
//   de "luz neon" o "resplandor".
//
// PROPIEDADES CONFIGURABLES (permiten ajuste por instancia):
//   - glowColor:     color del resplandor (por defecto, el color principal)
//   - glowIntensity: opacidad del halo (0.0 = invisible, 1.0 = maximo)
//   - glowRadius:    radio del difuminado — mayor = resplandor mas suave/amplio
//
// source: backgroundRect — el Glow muestrea la forma desde este rectangulo.
// visible: root.enabled — oculta el resplandor cuando el boton esta deshabilitado,
//   dando feedback visual de que el boton no es interactivo.
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects
import utils

T.Button {
    id: root

    // Propiedades personalizables: color, intensidad y radio del resplandor
    property color glowColor: Style.mainColor
    property real glowIntensity: 0.6
    property real glowRadius: 20

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Item {
        anchors.fill: parent

        // Efecto glow: halo neon que rodea al rectangulo de fondo.
        // 'source' indica de que item se toma la silueta para generar el brillo.
        // 'radius' controla que tan lejos se expande el resplandor.
        // 'samples' debe ser >= 2*radius+1 para buena calidad (17 es buen valor).
        Glow {
            anchors.fill: backgroundRect
            source: backgroundRect
            radius: Style.resize(root.glowRadius)
            samples: 17
            color: root.glowColor
            opacity: root.glowIntensity
            visible: root.enabled
        }

        // Cuerpo solido del boton — se oscurece al presionar (Qt.darker)
        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            radius: Style.resize(20)
            color: root.pressed ? Qt.darker(root.glowColor, 1.2) : root.glowColor
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
