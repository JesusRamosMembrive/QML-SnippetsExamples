// ============================================================================
// CheckBox.qml — Override de estilo para CheckBox
// ============================================================================
//
// Este archivo redefine la apariencia visual del control CheckBox.
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del CheckBox ---
//   - indicator:    el cuadrado visual del checkbox (con tick o guion)
//   - contentItem:  el texto/etiqueta que aparece junto al cuadrado
//   - background:   (no se usa aquí) el visual detrás de todo el control
//
// --- Tres estados del CheckBox ---
//   1. Unchecked (desmarcado):        cuadrado vacío, borde inactivo
//   2. Checked (marcado):             cuadrado relleno con checkmark ✓ (\u2713)
//   3. PartiallyChecked (parcial):    cuadrado relleno con guion — (\u2013)
// El estado parcial (Qt.PartiallyChecked) se usa en checkboxes tri-estado,
// común en vistas de árbol donde un padre está "parcialmente" seleccionado
// cuando solo algunos de sus hijos están marcados.
//
// --- icon.color como color de acento ---
// Se reutiliza la propiedad icon.color como color de acento. Este es un
// patrón común en estilos de Qt: permite que el usuario personalice el
// color de acento por instancia sin crear propiedades nuevas.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado por el usuario, pero estos
// son los valores por defecto.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.CheckBox {
    id: root

    // --- Tamaño implícito: el tamaño "natural" sin width/height explícitos ---
    implicitWidth: Style.resize(120)
    implicitHeight: Style.resize(50)

    // icon.color reutilizado como color de acento del checkbox
    icon.color: Style.mainColor

    // --- indicator: el cuadrado visual del checkbox ---
    // Este es el slot "indicator" — el visual adicional del control.
    // Para CheckBox, es la caja cuadrada que muestra el estado on/off.
    indicator: Rectangle {
        id: indicatorRect
        width: root.height * 0.6
        height: root.height * 0.6
        anchors.verticalCenter: parent.verticalCenter
        radius: Style.resize(4)
        // Fondo relleno con color de acento si está checked o parcialmente checked
        color: root.checked || root.checkState === Qt.PartiallyChecked ? root.icon.color : "transparent"
        border.width: Style.resize(2)
        border.color: root.checked || root.checkState === Qt.PartiallyChecked ? root.icon.color : Style.inactiveColor

        // Símbolo dentro del cuadrado:
        // - PartiallyChecked → guion "\u2013" (—)
        // - Checked          → checkmark "\u2713" (✓)
        Text {
            anchors.centerIn: parent
            text: root.checkState === Qt.PartiallyChecked ? "\u2013" : "\u2713"
            color: "white"
            font.pixelSize: indicatorRect.height * 0.7
            font.bold: true
            visible: root.checked || root.checkState === Qt.PartiallyChecked
        }
    }

    // --- contentItem: el texto/etiqueta junto al indicator ---
    // Este es el slot "contentItem" — el contenido visual principal.
    // Para CheckBox, es la etiqueta de texto al lado de la caja.
    contentItem: Item {
        width: (parent.width - indicatorRect.width - Style.resize(10))
        height: parent.height
        anchors.left: indicatorRect.right
        anchors.leftMargin: Style.resize(10)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            // El color del texto también refleja el estado checked
            color: root.checked ? root.icon.color : Style.inactiveColor
            text: root.text
        }
    }
}
