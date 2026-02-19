// ============================================================================
// TextArea.qml — Override de estilo para TextArea (entrada de texto multilínea)
// ============================================================================
//
// Este archivo redefine la apariencia visual del control TextArea.
// TextArea es casi idéntico a TextField pero permite múltiples líneas de
// texto. Las diferencias principales son:
//   - wrapMode: TextArea.Wrap → el texto salta de línea automáticamente
//   - padding uniforme en los 4 lados (en vez de solo leftPadding/rightPadding)
//   - Mayor implicitHeight para acomodar varias líneas
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del TextArea ---
//   - background:   el rectángulo de fondo con borde (el único que usamos)
//   - contentItem:  (no se redefine aquí) TextArea ya tiene un TextEdit
//                    interno como contentItem por defecto
//   - indicator:    (no aplica) TextArea no tiene indicator
//
// --- TextArea.Wrap vs Text.WordWrap ---
// Ambos logran el mismo efecto (ajuste de texto por palabras), pero se
// usan desde distinto namespace. Dentro de un TextArea se usa TextArea.Wrap;
// dentro de un Text se usa Text.WordWrap. Son equivalentes en comportamiento.
//
// --- padding vs leftPadding/rightPadding ---
// TextArea usa "padding" (uniforme en los 4 lados) porque el texto puede
// crecer verticalmente y necesita espacio arriba y abajo, no solo a los
// lados como en TextField.
//
// --- activeFocus, hovered, border.color, selectionColor ---
// Misma lógica que TextField: ver los comentarios de ese archivo para
// la explicación detallada de la cadena ternaria y las animaciones.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado, pero estos son los
// valores por defecto.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.TextArea {
    id: root

    // --- Tamaño implícito: el tamaño "natural" sin width/height explícitos ---
    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(120)

    color: Style.fontPrimaryColor
    placeholderTextColor: Style.inactiveColor
    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS

    // Colores de selección de texto (cuando el usuario arrastra con el mouse)
    selectionColor: Style.mainColor
    selectedTextColor: "white"

    // TextArea.Wrap: ajuste de línea automático (equivalente a Text.WordWrap)
    wrapMode: TextArea.Wrap

    // padding uniforme en los 4 lados (arriba, abajo, izquierda, derecha)
    padding: Style.resize(12)

    // --- background: el rectángulo de fondo con borde reactivo ---
    // Misma lógica que TextField: activeFocus → mainColor, hovered → más claro,
    // default → inactivo, con transición animada de 150ms.
    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        border.color: root.activeFocus ? Style.mainColor
                      : root.hovered ? Qt.lighter(Style.inactiveColor, 1.2)
                      : Style.inactiveColor

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }
}
