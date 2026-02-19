// =============================================================================
// Style.qml — Singleton de estilo global (Design Tokens)
// =============================================================================
// Centraliza TODOS los valores de diseño de la aplicación: colores, fuentes,
// dimensiones y rutas de assets. Cualquier archivo QML del proyecto accede
// a estos valores con: import utils → Style.propiedad
//
// ¿Por qué un Singleton?
// Sin Singleton, cada archivo que hiciera "Style {}" crearía una instancia
// independiente con sus propias propiedades. Con pragma Singleton, existe
// UNA SOLA instancia compartida por toda la aplicación. Cambiar Style.theme
// en un sitio afecta a TODOS los componentes que lo usan, lo cual es
// exactamente lo que queremos para un sistema de temas.
//
// ¿Cómo se registra como Singleton?
// Se necesitan dos cosas:
//   1. Este pragma en la primera línea del archivo
//   2. Una entrada "singleton Style 1.0 Style.qml" en el qmldir del módulo
//   Sin el qmldir, Qt no sabe que es Singleton y da error en tiempo de carga.
//
// ¿Por qué QtObject y no Item?
// QtObject es la clase base más ligera de Qt: no tiene propiedades visuales
// (x, y, width, height, opacity, etc.). Como Style solo almacena datos y
// funciones (no se renderiza), usar Item desperdiciaría memoria en propiedades
// visuales innecesarias. Regla: si no se ve en pantalla, usa QtObject.
// =============================================================================

pragma Singleton
import QtQuick

QtObject {
    id: root

    // --- Dimensiones de la ventana ---
    // Valores por defecto para la ventana principal.
    // Se usan en Main.qml como width/height del ApplicationWindow.
    property int screenWidth: 1920
    property int screenHeight: 1080

    // --- Sistema de temas ---
    // La propiedad "theme" actúa como selector de tema. Gracias al sistema
    // reactivo de QML (property bindings), cuando theme cambia de "green"
    // a "orange", TODAS las propiedades que dependen de theme se recalculan
    // automáticamente y la UI se actualiza sin código adicional.
    //
    // Ejemplo de la cadena reactiva:
    //   theme cambia → mainColor se recalcula → todos los Label/Rectangle
    //   que usan Style.mainColor se repintan automáticamente
    //
    // Este es uno de los superpoderes de QML: los bindings son declarativos
    // y el motor gestiona la propagación de cambios.
    property string theme: "green"

    // --- Paleta de colores ---
    // bgColor: fondo principal de la app (gris muy oscuro, casi negro)
    // bgColorDark: fondo aún más oscuro (para áreas secundarias)
    // mainColor: color de acento. Usa un binding ternario que reacciona a theme.
    //   "green" → teal (#00D1A9), otro valor → naranja (#FEA601)
    // inactiveColor: texto deshabilitado o de baja prioridad
    property string bgColor: "#1A1D23"
    property string bgColorDark: "#14171C"
    property string mainColor: (theme === "green") ? "#00D1A9" : "#FEA601"
    property string bgColorDashBoradMenu: "#14171C"
    property string inactiveColor: "#999999"

    // cardColor y surfaceColor: fondos para tarjetas y superficies elevadas.
    // Se usa "color" en vez de "string" como tipo. Ambos funcionan para colores
    // en QML, pero "color" permite operaciones como Qt.lighter(), Qt.darker()
    // y comparaciones tipadas. "string" es más permisivo pero menos seguro.
    property color cardColor: "#252830"
    property color surfaceColor: "#2A2D35"

    // --- Rutas de assets ---
    // Rutas relativas dentro del sistema de recursos Qt (qrc).
    // Se usan como base para las funciones helper icon(), gfx() y mesh().
    // La ruta "/assets/..." corresponde al PREFIX definido en el CMakeLists.txt
    // del módulo de assets.
    property string iconPath: "/assets/icons/"
    property string imagePath: "/assets/images/"
    property string meshPath: "/assets/mesh/"

    // --- Funciones helper para assets ---
    // Simplifican el acceso a recursos. En vez de escribir:
    //   Qt.resolvedUrl("/assets/icons/buttons.png")
    // Se escribe:
    //   Style.icon("buttons")
    //
    // Qt.resolvedUrl() convierte una ruta relativa en una URL absoluta
    // resuelta desde el contexto del archivo QML actual. Esto es necesario
    // porque las rutas de recursos qrc necesitan el prefijo completo para
    // funcionar correctamente desde cualquier módulo.

    // Devuelve la URL completa de un icono PNG por nombre (sin extensión).
    function icon(name) {
        return Qt.resolvedUrl(iconPath + name + ".png");
    }

    // Devuelve la URL completa de una imagen PNG por nombre (sin extensión).
    function gfx(name) {
        return Qt.resolvedUrl(imagePath + name + ".png");
    }

    // Devuelve la URL completa de un modelo 3D. El formato es configurable
    // (por defecto .obj). La sintaxis "format = '.obj'" es un parámetro
    // con valor por defecto de JavaScript ES6, soportado en QML.
    function mesh(name, format = ".obj") {
        return Qt.resolvedUrl(meshPath + name + format);
    }

    // --- Función de escalado ---
    // resize() es un punto de inyección para escalado responsivo.
    // Actualmente devuelve el valor sin modificar (escala 1:1), pero está
    // diseñada para que en el futuro se pueda implementar escalado basado
    // en DPI o resolución de pantalla. Por ejemplo:
    //   return value * (Screen.width / 1920)
    //
    // Se usa en TODA la aplicación: Style.resize(40) en vez de hardcodear 40.
    // Esto permite cambiar la escala globalmente modificando solo esta función,
    // sin tocar los ~200 archivos QML que la llaman.
    function resize(value) {
        return (value);
    }

    // --- Colores de texto ---
    // Tres niveles de contraste para jerarquía visual:
    //   fontContrastColor: máximo contraste (blanco puro) — títulos principales
    //   fontPrimaryColor: texto principal — labels y contenido
    //   fontSecondaryColor: texto secundario — descripciones, subtítulos
    property color grey: "#2A2D35"
    property color fontContrastColor: "#FFFFFF"
    property color fontPrimaryColor: "#FFFFFF"
    property color fontSecondaryColor: "#CCCCCC"

    // --- Tamaños de fuente predefinidos ---
    // Se pasan por resize() para que escalen con el resto de la UI.
    // S/M/L proporcionan consistencia: en vez de inventar tamaños ad-hoc,
    // todos los componentes usan estos tres niveles.
    property int fontSizeS: root.resize(15)
    property int fontSizeM: root.resize(19)
    property int fontSizeL: root.resize(26)

    // --- Carga de fuentes personalizadas ---
    // fontFamilyRegular/Bold: exponen el nombre de la fuente como string.
    // Los componentes usan: font.family: Style.fontFamilyRegular
    //
    // FontLoader carga un archivo de fuente (.otf/.ttf) en el motor de Qt.
    // Una vez cargada, la propiedad .name contiene el nombre de familia de
    // la fuente (ej: "Quicksand") que se puede usar en font.family.
    //
    // Las fuentes se cargan desde recursos Qt (ruta qrc). Se declaran como
    // propiedades del Singleton para que se carguen UNA sola vez al inicio
    // y estén disponibles globalmente. Si se pusieran en cada componente,
    // se cargarían múltiples veces innecesariamente.
    property string fontFamilyRegular: quicksandBook.name
    property string fontFamilyBold: quicksandBold.name

    property FontLoader quicksandBook: FontLoader {
        source: "/assets/fonts/Quicksand_Book.otf"
    }

    property FontLoader quicksandBold: FontLoader {
        source: "/assets/fonts/Quicksand_Bold.otf"
    }

    // --- Funciones de cambio de tema ---
    // Funciones públicas para cambiar el tema desde cualquier punto de la app.
    // Al cambiar "theme", el binding reactivo de mainColor se recalcula
    // automáticamente y todos los componentes que usan Style.mainColor
    // se actualizan en cascada.
    function setGreenTheme() {
        theme = "green";
    }
    function setOrangeTheme() {
        theme = "orange";
    }
}
