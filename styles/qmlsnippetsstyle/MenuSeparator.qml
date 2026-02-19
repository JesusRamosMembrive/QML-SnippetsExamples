// ============================================================================
// MenuSeparator.qml — Override de estilo para MenuSeparator
// ============================================================================
//
// Este archivo redefine la apariencia visual del control MenuSeparator.
// Es la línea horizontal que separa grupos de items dentro de un menú.
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del MenuSeparator ---
//   - contentItem:  la línea separadora en sí (un rectángulo de 1px de alto)
//   - background:   (no se define aquí) visual detrás de la línea
//   - indicator:    (no aplica) MenuSeparator no tiene indicator
//
// --- Fórmula estándar de implicitWidth/implicitHeight ---
// La fórmula Math.max(...) es el patrón estándar de Qt para calcular el
// tamaño implícito en overrides de estilo:
//
//   implicitWidth = Math.max(
//       implicitBackgroundWidth + leftInset + rightInset,
//       implicitContentWidth + leftPadding + rightPadding
//   )
//
// Esto asegura que el control sea al menos tan grande como su background
// O su contentItem, el que sea mayor. Los insets son márgenes internos
// del background; los paddings son el espacio entre el borde del control
// y el contentItem. Este patrón garantiza que nada se recorte.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado, pero estos son los
// valores por defecto calculados con la fórmula anterior.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.MenuSeparator {
    id: root

    // --- Tamaño implícito: fórmula estándar de Qt ---
    // Math.max(background + insets, content + padding)
    // Garantiza que el control sea al menos tan grande como su background
    // o su contenido, lo que sea mayor.
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: Style.resize(4)
    leftPadding: Style.resize(12)
    rightPadding: Style.resize(12)

    // --- contentItem: la línea separadora ---
    // Un rectángulo de 1px de alto que actúa como línea divisoria visual.
    contentItem: Rectangle {
        implicitWidth: Style.resize(160)
        implicitHeight: 1
        color: Style.bgColor
    }
}
