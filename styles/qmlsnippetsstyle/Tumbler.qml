// =============================================================================
// Tumbler.qml — Override de estilo para Tumbler (selector tipo tambor rotativo)
// =============================================================================
//
// Tumbler es un selector de tipo "tambor giratorio" similar a los selectores
// de fecha en iOS. Los elementos giran verticalmente y el usuario desliza
// para seleccionar.
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.Tumbler con la logica (model, currentIndex, etc.) sin visual.
//
// ---- QtQuick.Controls.impl ----
// Importa helpers internos de implementacion de Qt. TumblerView es un tipo
// PRIVADO de Qt que maneja el renderizado basado en PathView (el "tambor").
// Esta es una excepcion a la regla de "no usar .impl" — Tumbler lo necesita
// para funcionar correctamente.
//
// ---- Tumbler.displacement (propiedad attached) ----
// Cada delegate recibe Tumbler.displacement: indica la distancia al centro.
//   - 0.0 = centrado (seleccionado)
//   - Aumenta conforme el elemento se aleja del centro
// Se usa para el efecto "ojo de pez":
//   - font.pixelSize: mas grande en el centro, mas chico en los bordes
//   - font.bold: solo negrita cerca del centro (displacement < 0.5)
//   - color: color primario en el centro, inactivo en los bordes
//   - opacity: se desvanece hacia los extremos
//
// ---- contentItem: TumblerView con Path ----
// TumblerView usa un Path vertical por donde viajan los delegates.
// __delegateHeight = availableHeight / visibleItemCount asegura espaciado uniforme.
//
// ---- Banda de resaltado (highlight) ----
// Un rectangulo semitransparente centrado verticalmente en el background,
// con lineas separadoras arriba y abajo. Usa "parent: control.background"
// para reparentarse dentro del fondo.
//
// ---- Qt.rgba() con .r/.g/.b ----
// Descompone un color existente para crear una version transparente de el:
//   Qt.rgba(Style.mainColor.r, Style.mainColor.g, Style.mainColor.b, 0.12)
// Esto mantiene el tono del color pero ajusta solo la opacidad.
// =============================================================================

import QtQuick
import QtQuick.Templates as T
// QtQuick.Controls.impl: helpers internos de Qt. TumblerView es un tipo privado
// necesario para el renderizado del tambor basado en PathView.
import QtQuick.Controls.impl

import utils

T.Tumbler {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    // Altura de cada delegate: divide el espacio entre los items visibles
    readonly property real __delegateHeight: availableHeight / visibleItemCount

    // --- Delegate: apariencia de cada elemento en el tambor ---
    // Tumbler.displacement controla el efecto "ojo de pez":
    // tamano, negrita, color y opacidad varian segun la distancia al centro
    delegate: Text {
        text: modelData
        // Tamano de fuente: mas grande en el centro, se reduce un 30% en los bordes
        font.pixelSize: Style.resize(18) * (1.0 - 0.3 * Math.abs(Tumbler.displacement))
        font.family: Style.fontFamilyRegular
        // Solo negrita cuando esta cerca del centro (displacement < 0.5)
        font.bold: Math.abs(Tumbler.displacement) < 0.5
        // Color primario en el centro, inactivo en los bordes
        color: Math.abs(Tumbler.displacement) < 0.5
               ? Style.fontPrimaryColor
               : Style.inactiveColor
        // Opacidad: se desvanece hacia los extremos del tambor
        opacity: 1.0 - Math.abs(Tumbler.displacement) / (control.visibleItemCount / 2)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        required property var modelData
        required property int index
    }

    // --- contentItem: TumblerView (tipo privado de Qt) ---
    // Usa un Path vertical para renderizar el tambor rotativo
    contentItem: TumblerView {
        implicitWidth: Style.resize(80)
        implicitHeight: Style.resize(200)
        model: control.model
        delegate: control.delegate
        // Path vertical: los delegates viajan de arriba a abajo
        path: Path {
            startX: control.contentItem.width / 2
            startY: -control.__delegateHeight / 2
            PathLine {
                x: control.contentItem.width / 2
                y: (control.visibleItemCount + 1) * control.__delegateHeight
                   - control.__delegateHeight / 2
            }
        }
    }

    background: Rectangle {
        implicitWidth: Style.resize(80)
        implicitHeight: Style.resize(200)
        color: "transparent"
        radius: Style.resize(8)
        border.width: 1
        // Qt.rgba con .r/.g/.b: descompone el color para crear version transparente
        border.color: Qt.rgba(Style.inactiveColor.r, Style.inactiveColor.g,
                              Style.inactiveColor.b, 0.4)
    }

    // --- Banda de resaltado central ---
    // parent: control.background — se reparenta dentro del fondo
    // Resalta el elemento seleccionado con un rectangulo semitransparente
    Rectangle {
        parent: control.background
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - height / 2
        width: parent.width - Style.resize(4)
        height: control.__delegateHeight
        color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                       Style.mainColor.b, 0.12)
        radius: Style.resize(6)

        // Separador superior
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                           Style.mainColor.b, 0.3)
        }

        // Separador inferior
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                           Style.mainColor.b, 0.3)
        }
    }
}
