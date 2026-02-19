// =============================================================================
// MainMenu.qml — Contenedor visual del menú lateral (sidebar)
// =============================================================================
//
// Componente "wrapper" (envoltorio) alrededor de MainMenuList que agrega
// el fondo oscuro y los márgenes del sidebar.
//
// -- Patrón wrapper --
// Expone la misma API que el componente interno (currentItemName,
// menuItemClicked) mientras añade decoración visual. Esto permite que
// HomePage interactúe con MainMenu sin conocer los detalles internos
// de MainMenuList.
//
// -- Reenvío de señales (signal forwarding) --
// MainMenuList emite menuItemClicked(name) → el handler onMenuItemClicked
// de este archivo lo captura → re-emite root.menuItemClicked(name) →
// HomePage lo recibe. Esta cadena de comunicación evita el acoplamiento
// directo entre MainMenuList y HomePage, manteniendo cada componente
// enfocado en su responsabilidad.
//
// -- Rectangle como fondo --
// Style.bgColorDashBoradMenu proporciona el color oscuro del sidebar,
// definido en el singleton Style para que cambie automáticamente con el tema.
// =============================================================================

import QtQuick

import utils

Item {
    id: root

    property string currentItemName: mainMenuList.currentItemName
    signal menuItemClicked(var name)

    Rectangle {
        id: mainMenuColorFill
        width: root.width
        height: root.height
        color: Style.bgColorDashBoradMenu

        MainMenuList {
            id: mainMenuList
            anchors.fill: parent
            anchors.topMargin: Style.resize(20)
            anchors.bottomMargin: Style.resize(20)
            onMenuItemClicked: function(name) {
                root.menuItemClicked(name);
            }
        }
    }
}
