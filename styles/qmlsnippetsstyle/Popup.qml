// =============================================================================
// Popup.qml — Override de estilo para Popup (componente base de superposicion)
// =============================================================================
//
// Popup es el componente base para cualquier contenido que se muestra encima
// del resto de la interfaz (dialogos, menus, tooltips, etc.).
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.Popup con la logica (open, close, modal, etc.) sin visual.
// NOTA: tambien importamos QtQuick.Controls aqui para acceder a Overlay.overlay.
//
// ---- parent: Overlay.overlay ----
// Posiciona el popup en la capa de superposicion de Qt (por encima de todo
// el contenido). Sin esto, el popup quedaria limitado a los limites de su
// item padre y podria quedar recortado o tapado.
//
// ---- modal: true ----
// Bloquea la interaccion con el contenido detras del popup. El usuario
// no puede hacer clic en nada mas hasta que cierre el popup.
//
// ---- Overlay.modal: Rectangle ----
// Define el fondo oscurecido (dimming) que aparece detras del popup modal.
// Es el rectangulo semitransparente que cubre toda la pantalla.
//
// ---- closePolicy: Popup.NoAutoClose ----
// El popup NO se cierra al hacer clic afuera ni al presionar Escape.
// El codigo del usuario debe cerrarlo explicitamente (popup.close()).
//
// ---- background: BaseCard ----
// Usa nuestro componente custom de tarjeta (imagen de borde 9-patch)
// del modulo controls para el fondo del popup.
//
// ---- enter/exit Transitions ----
// Transiciones de opacidad para un efecto suave de apertura/cierre.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T

import controls
import utils

T.Popup {
    id: root
    implicitWidth: Style.resize(378)
    implicitHeight: Style.resize(366)
    // Overlay.overlay: capa de superposicion de Qt, por encima de todo el contenido
    parent: Overlay.overlay
    // NoAutoClose: no se cierra con clic afuera ni con Escape
    closePolicy: Popup.NoAutoClose
    // BaseCard: componente custom de tarjeta (borde 9-patch) del modulo controls
    background: BaseCard { }
    // modal: bloquea la interaccion con el contenido detras
    modal: true
    // Fondo oscurecido detras del popup modal
    Overlay.modal: Rectangle {
        color: Qt.rgba(255, 255, 255, 0.6)
    }
    // Transicion de entrada: desvanecimiento de transparente a opaco
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 100 }
    }
    // Transicion de salida: desvanecimiento de opaco a transparente
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }
}
