// =============================================================================
// Dialog.qml — Override de estilo para Dialog (dialogo modal con header/footer)
// =============================================================================
//
// Dialog hereda de Popup. Agrega header (barra de titulo), footer (caja de
// botones) y soporte para standardButtons (OK, Cancel, etc.).
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.Dialog con la logica (title, accept, reject, etc.) sin visual.
// NOTA: tambien importamos QtQuick.Controls para acceder a Label, Overlay, etc.
//
// ---- implicitHeight: contenido + header + footer + padding ----
// El dialogo se auto-dimensiona para acomodar todo su contenido.
// La altura implicita suma: contenido + header + footer + padding superior/inferior.
//
// ---- header: barra de titulo personalizada ----
// Un rectangulo transparente con el titulo del dialogo y una linea separadora
// inferior. Label usa nuestro estilo custom (del modulo qmlsnippetsstyle).
//
// ---- footer: DialogButtonBox ----
// Componente integrado de Qt que crea botones OK/Cancel/etc a partir de
// standardButtons. visible: count > 0 lo oculta cuando no hay botones definidos.
//
// ---- Transicion de entrada: opacidad + escala ----
// Combina opacidad Y escala para un efecto "pop-in": comienza en escala 0.9
// y crece a 1.0, creando una aparicion con efecto de acercamiento.
//
// ---- closePolicy: CloseOnEscape | CloseOnPressOutside ----
// Comportamiento estandar de dialogo: se cierra con Escape o clic fuera.
// A diferencia de Popup.qml (NoAutoClose), los dialogos permiten cierre comodo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Layouts

import utils

T.Dialog {
    id: root

    implicitWidth: Style.resize(400)
    // Auto-dimensionado: contenido + header + footer + padding
    implicitHeight: contentHeight + header.implicitHeight + footer.implicitHeight
                    + topPadding + bottomPadding

    padding: Style.resize(20)
    topPadding: Style.resize(10)

    // Overlay.overlay: capa de superposicion de Qt, centrado en pantalla
    parent: Overlay.overlay
    anchors.centerIn: parent

    // modal: bloquea interaccion con el contenido detras
    modal: true
    // Se cierra con Escape o clic fuera (comportamiento estandar de dialogo)
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        color: Style.cardColor
        radius: Style.resize(12)
        border.color: Style.surfaceColor
        border.width: 1
    }

    // --- Header: barra de titulo personalizada ---
    // Muestra el titulo del dialogo con una linea separadora inferior
    header: Rectangle {
        color: "transparent"
        implicitHeight: Style.resize(48)
        radius: Style.resize(12)

        Label {
            anchors.left: parent.left
            anchors.leftMargin: Style.resize(20)
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        // Linea separadora inferior del header
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Style.surfaceColor
        }
    }

    // --- Footer: DialogButtonBox ---
    // Componente de Qt que genera botones (OK, Cancel, etc.) a partir de
    // standardButtons. visible: count > 0 lo oculta si no hay botones.
    footer: DialogButtonBox {
        visible: count > 0
    }

    // Fondo oscurecido detras del dialogo modal
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    // Transicion de entrada: combina opacidad + escala para efecto "pop-in"
    // Comienza en escala 0.9 y crece a 1.0 (efecto de acercamiento)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
    }

    // Transicion de salida: solo desvanecimiento
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }
}
