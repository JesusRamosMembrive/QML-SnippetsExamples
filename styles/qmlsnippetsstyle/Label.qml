// ============================================================================
// Label.qml — Override de estilo para Label
// ============================================================================
//
// Este archivo redefine la apariencia visual del control Label.
// Label hereda de T.Label, que es esencialmente un Text con integración de
// Control (responde a palette, style, etc.). Es el override de estilo más
// simple posible: solo cambia la fuente y el color por defecto.
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" de un Qt Quick Control ---
// Cada control puede tener hasta tres slots visuales:
//   - background:   el visual detrás del control (ej: rectángulo de fondo)
//   - contentItem:  el contenido visual principal (ej: texto de un botón)
//   - indicator:    visual adicional (ej: tick de un checkbox)
// No todos los controles usan los tres. Label, por ejemplo, no necesita
// ninguno — su contenido es simplemente el texto que hereda de Text.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El usuario puede redimensionar el control, pero estos son los
// valores por defecto. Label no los define aquí porque Text calcula su
// tamaño implícito automáticamente a partir del texto y la fuente.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.Label {
    id: root

    font.family: Style.fontFamilyRegular
    color: Style.fontPrimaryColor
    font.pixelSize: Style.fontSizeM
}
