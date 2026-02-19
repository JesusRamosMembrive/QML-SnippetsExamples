// =============================================================================
// BaseCard.qml — Tarjeta base reutilizable con bordes 9-patch
// =============================================================================
// Proporciona un fondo de tarjeta (card) con bordes redondeados y sombra
// usando la técnica 9-patch (BorderImage) en vez de un Rectangle con radius.
//
// ¿Por qué BorderImage en vez de Rectangle { radius: 8 }?
// Rectangle con radius solo ofrece esquinas redondeadas simples. BorderImage
// permite usar una imagen PNG con sombras, gradientes y bordes complejos
// que se estiran sin deformarse. Es la misma técnica "9-patch" de Android.
//
// Cómo funciona 9-patch:
// La imagen se divide en 9 zonas usando border.left/right/top/bottom:
//
//   ┌─────┬───────────────┬─────┐
//   │  1  │       2       │  3  │  ← esquinas (1,3,7,9): no se estiran
//   ├─────┼───────────────┼─────┤
//   │  4  │       5       │  6  │  ← bordes (2,4,6,8): se estiran en 1 eje
//   ├─────┼───────────────┼─────┤
//   │  7  │       8       │  9  │  ← centro (5): se estira en ambos ejes
//   └─────┴───────────────┴─────┘
//
// Las esquinas mantienen su tamaño original (preservando el radio y la sombra),
// los bordes se estiran en un eje, y el centro rellena el espacio restante.
//
// Uso típico:
//   BaseCard {
//       width: 300; height: 200
//       // Contenido de la tarjeta va aquí como hijo del BaseCard
//   }
//
// property alias borderImage: permite al componente padre personalizar
// propiedades del BorderImage (ej: opacity, visible) sin exponer toda
// la implementación interna.
// =============================================================================

import QtQuick

import utils

Item {
    id: root

    // Alias: expone el BorderImage interno como propiedad pública.
    // Un alias no crea una nueva propiedad, sino que es una referencia
    // directa al objeto interno. Modificar root.borderImage.opacity
    // modifica directamente borderImage.opacity.
    property alias borderImage: borderImage

    BorderImage {
        id: borderImage
        anchors.fill: parent
        source: Style.gfx("card")   // Carga la imagen PNG de la tarjeta
        // Los valores de border definen dónde cortar la imagen para el 9-patch.
        // Con 100px en cada lado, las esquinas de la imagen (100x100px) se
        // preservan intactas, y el resto se estira para adaptarse al tamaño
        // del componente.
        border.left: Style.resize(100)
        border.right: Style.resize(100)
        border.top: Style.resize(100)
        border.bottom: Style.resize(100)
    }
}
