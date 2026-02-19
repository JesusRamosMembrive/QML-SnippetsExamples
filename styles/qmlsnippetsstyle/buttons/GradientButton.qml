// ============================================================================
// GradientButton.qml — Boton con relleno degradado horizontal/vertical
// ============================================================================
//
// CONCEPTO CLAVE — Gradient con GradientStop:
//   Define una transicion de color entre dos (o mas) puntos.
//   - position 0.0 = inicio del degradado (startColor)
//   - position 1.0 = final del degradado (endColor)
//   Los colores intermedios se interpolan automaticamente.
//
// orientation: Gradient.Horizontal | Gradient.Vertical
//   Controla la direccion del degradado. Configurable por instancia mediante
//   la propiedad 'gradientOrientation'.
//
// Qt.lighter(color, 1.3):
//   Genera automaticamente el color final como una version mas clara del color
//   inicial. Factor > 1.0 aclara, < 1.0 oscurece. Esto garantiza que el
//   degradado siempre luzca armonioso sin importar el color base elegido.
//
// opacity al presionar:
//   Feedback visual sencillo — al presionar el boton, la opacidad baja a 0.8,
//   lo que "atenua" ligeramente el degradado indicando la interaccion.
// ============================================================================

import QtQuick
import QtQuick.Templates as T
import utils

T.Button {
    id: root

    property color startColor: Style.mainColor
    // Qt.lighter genera un tono mas claro automaticamente — degradado armonioso
    property color endColor: Qt.lighter(Style.mainColor, 1.3)
    // Gradient.Horizontal = izquierda->derecha, Gradient.Vertical = arriba->abajo
    property int gradientOrientation: Gradient.Horizontal

    implicitWidth: Style.resize(150)
    implicitHeight: Style.resize(40)

    background: Rectangle {
        radius: Style.resize(20)

        // Degradado: transicion suave entre startColor y endColor
        // GradientStop define los puntos de color (position 0.0 a 1.0)
        gradient: Gradient {
            orientation: root.gradientOrientation
            GradientStop { position: 0.0; color: root.startColor }
            GradientStop { position: 1.0; color: root.endColor }
        }

        // Feedback visual: atenuar al presionar (0.8 = ligeramente transparente)
        opacity: root.pressed ? 0.8 : 1.0
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
