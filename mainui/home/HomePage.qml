// =============================================================================
// HomePage.qml — Shell principal de la aplicación (layout maestro)
// =============================================================================
// Define la estructura visual de la aplicación: menú lateral + cabecera + contenido.
// Actúa como "orquestador" conectando tres componentes independientes:
//
//   ┌──────────────┬──────────────────────────────────────┐
//   │              │           Header                     │
//   │              ├──────────────────────────────────────┤
//   │   MainMenu   │                                      │
//   │  (sidebar)   │         Dashboard (contenido)        │
//   │              │                                      │
//   └──────────────┴──────────────────────────────────────┘
//
// Flujo de navegación:
//   1. El usuario hace clic en un item del MainMenu
//   2. MainMenu emite la señal menuItemClicked(name)
//   3. HomePage recibe la señal y cambia mainContent.state = name
//   4. Dashboard carga la página correspondiente al nuevo estado
//
// ¿Por qué no usar StackView o SwipeView para la navegación?
// Porque este layout es fijo: el menú siempre está visible junto al contenido.
// StackView es para navegación "push/pop" donde las páginas se reemplazan.
// Aquí queremos un sidebar persistente tipo IDE o panel de control.
// =============================================================================

import QtQuick
import utils      // Style singleton
import mainui     // Header, MainMenu, Dashboard

Item {
    id: root

    // --- Cabecera superior ---
    // Se posiciona a la derecha del menú y ocupa el ancho restante.
    // z: 10000 garantiza que quede por encima del contenido si hay
    // solapamiento (ej: si algún popup del Dashboard sube demasiado).
    // menuItemText: muestra el nombre de la página actual en la cabecera.
    // reorderSwitchVisible: solo muestra el botón de reordenar en el Dashboard.
    Header {
        id: header
        width: (parent.width - mainMenu.width)
        height: Style.resize(70)
        anchors.left: mainMenu.right
        z: 10000
        menuItemText: mainMenu.currentItemName
        reorderSwitchVisible: (mainMenu.currentItemName === "Dashboard")
    }

    // --- Menú lateral (sidebar) ---
    // Ancho fijo, ocupa toda la altura. Expone:
    //   - currentItemName: nombre del item seleccionado (para el Header)
    //   - menuItemClicked(name): señal que emite al hacer clic en un item
    //
    // La conexión onMenuItemClicked usa la sintaxis de handler con función:
    //   onSignal: function(params) { ... }
    // Esto es necesario cuando la señal tiene parámetros. La alternativa
    // sin parámetros sería: onSignal: { ... }
    MainMenu {
        id: mainMenu
        width: Style.resize(285)
        height: parent.height
        onMenuItemClicked: function (name) {
            mainContent.state = name;
        }
    }

    // --- Área de contenido principal ---
    // Ocupa el espacio restante (a la derecha del menú, debajo del header).
    // Su propiedad "state" determina qué página de ejemplo se muestra.
    // El estado se cambia desde la señal menuItemClicked del menú.
    //
    // Nota sobre el posicionamiento: no se usa Layout aquí sino anchors
    // manuales porque el layout es fijo y conocido. Los Layouts (RowLayout,
    // ColumnLayout) son más apropiados cuando el número de hijos es dinámico
    // o se necesita distribución automática de espacio.
    Dashboard {
        id: mainContent
        width: (parent.width - mainMenu.width)
        height: (parent.height - header.height)
        anchors.left: mainMenu.right
        anchors.top: header.bottom
    }
}
