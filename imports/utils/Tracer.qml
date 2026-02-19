// =============================================================================
// Tracer.qml — Herramienta de depuracion visual para layouts
// =============================================================================
//
// Tracer es una utilidad de desarrollo. Colocalo dentro de cualquier Item
// para ver sus limites con un borde de color aleatorio:
//
//   Rectangle {
//       width: 200; height: 100
//       Tracer {}   // ← muestra un borde de color random alrededor
//   }
//
// Cada instancia recibe un color aleatorio (Qt.rgba con Math.random()) para
// poder distinguir items que se superponen o son adyacentes.
//
// El rectangulo tiene relleno transparente (color: "transparent") para no
// ocultar el contenido del Item padre. Solo el borde es visible.
//
// Es similar a la tecnica CSS "* { border: 1px solid red }" para depurar
// layouts, pero con colores aleatorios para mayor claridad.
//
// Uso: import utils → Tracer {} dentro de cualquier Item
// NOTA: Eliminar antes de produccion/release.
// =============================================================================

import QtQuick

Rectangle {
    anchors.fill: parent
    color: "transparent"
    border.color: Qt.rgba(Math.random(), Math.random(), Math.random(), 255)
}
