// =============================================================================
// Menu.qml — Override de estilo para Menu (menu contextual / desplegable)
// =============================================================================
//
// Menu es un componente de superposicion que muestra una lista de acciones
// (MenuItems) en un panel flotante con sombra.
//
// ---- POR QUE "import QtQuick.Templates as T" ----
// Los archivos de estilo importan Templates (base logica sin apariencia),
// NO Controls. Si importaramos Controls, se produciria recursion infinita:
// Controls carga nuestro estilo → nuestro estilo carga Controls → bucle.
// Templates provee T.Menu con la logica (contentModel, currentIndex, etc.)
// sin visual.
//
// ---- delegate: MenuItem {} ----
// Establece nuestro MenuItem personalizado como delegate por defecto para
// todos los items del menu. Cada Action o MenuItem agregado al Menu usara
// esta apariencia automaticamente.
//
// ---- contentItem: ListView con model: root.contentModel ----
// contentModel es el modelo interno de Menu que contiene todos los MenuItems.
// El ListView los renderiza en una lista desplazable.
//
// ---- interactive (scroll condicional) ----
// Controla si el ListView permite scroll. Solo habilita el scroll cuando
// el contenido excede la altura de la ventana. Si no, desactiva la
// interaccion de scroll para evitar comportamiento inesperado.
//
// ---- DropShadow en background ----
// Da apariencia flotante al menu. transparentBorder: true previene
// artefactos de sombra en los bordes del rectangulo.
// =============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.Menu {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: Style.resize(4)

    // Delegate por defecto: nuestro MenuItem personalizado para cada item
    delegate: MenuItem {}

    // --- contentItem: lista de MenuItems ---
    // contentModel: modelo interno de Menu con todos los MenuItems agregados
    contentItem: ListView {
        implicitHeight: contentHeight
        model: root.contentModel
        // interactive: solo permite scroll si el contenido excede la ventana
        interactive: Window.window
                     ? contentHeight + root.topPadding + root.bottomPadding > Window.window.height
                     : false
        clip: true
        currentIndex: root.currentIndex
    }

    // --- Background: panel flotante con sombra ---
    background: Rectangle {
        implicitWidth: Style.resize(180)
        color: Style.cardColor
        radius: Style.resize(8)
        border.color: Style.surfaceColor
        border.width: 1

        // DropShadow para apariencia flotante
        // transparentBorder: true previene artefactos de sombra en los bordes
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: Style.resize(4)
            radius: Style.resize(12)
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }

    // Transiciones de apertura/cierre con desvanecimiento
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 100 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 80 }
    }
}
