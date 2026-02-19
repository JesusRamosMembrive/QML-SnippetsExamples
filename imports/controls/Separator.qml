// =============================================================================
// Separator.qml — Línea separadora horizontal reutilizable
// =============================================================================
// Un rectángulo de 1px de alto que actúa como divisor visual entre secciones.
// Se usa a lo largo de la app para separar bloques de contenido.
//
// Uso:
//   Separator {}                          // ancho completo del padre
//   Separator { width: parent.width / 2 } // ancho personalizado
//
// ¿Por qué un componente separado para algo tan simple?
// Porque se usa en decenas de lugares. Si el día de mañana se quiere cambiar
// el color, grosor o estilo (ej: línea punteada), solo se modifica este archivo.
// Además, "Separator {}" es más legible que "Rectangle { width: parent.width;
// height: 1; color: '#2A2D35' }" repetido por todas partes.
//
// Nota: este componente hereda directamente de Rectangle (no de Item).
// En QML, el tipo raíz de un archivo define de qué hereda el componente.
// Esto significa que Separator ES un Rectangle, así que tiene todas sus
// propiedades (color, radius, border, gradient, etc.) disponibles para
// personalización desde el exterior si fuera necesario.
// =============================================================================

import QtQuick

import utils

Rectangle {
    width: parent.width
    height: Style.resize(1)
    color: Style.grey
}
