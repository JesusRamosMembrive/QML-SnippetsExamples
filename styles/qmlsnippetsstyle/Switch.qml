// ============================================================================
// Switch.qml — Override de estilo para Switch
// ============================================================================
//
// Este archivo redefine la apariencia visual del control Switch.
// Un Switch es un toggle on/off con una animación de deslizamiento.
//
// --- ¿Por qué "import QtQuick.Templates as T"? ---
// Los archivos de estilo DEBEN importar desde Templates, NO desde
// QtQuick.Controls. Templates provee las clases base con solo la lógica,
// sin apariencia visual. Si importáramos desde QtQuick.Controls, se
// produciría una recursión infinita: Controls intenta cargar el estilo...
// que es este mismo archivo. Templates rompe ese ciclo.
//
// --- Los tres "slots" visuales del Switch ---
//   - background:   la pista/riel (forma de píldora) sobre la que desliza
//                    el círculo
//   - indicator:    el círculo que se desliza de izquierda a derecha
//   - contentItem:  el texto/etiqueta junto al switch
//
// --- Animación de deslizamiento ---
// La posición x del indicator se vincula al estado checked:
//   - x = 0                               cuando está desmarcado (izquierda)
//   - x = (ancho pista - ancho círculo)    cuando está marcado (derecha)
// "Behavior on x" intercepta cualquier cambio en x y lo anima suavemente
// con una curva InOutQuad en 200ms, creando el efecto de deslizamiento.
//
// --- implicitWidth / implicitHeight ---
// Es el tamaño "natural" del control cuando no se le asigna un width/height
// explícito. El control puede ser redimensionado, pero estos son los
// valores por defecto.
// ============================================================================

import QtQuick
import QtQuick.Templates as T  // Templates, NO Controls — evita recursión infinita

import utils

T.Switch {
    id: root

    // --- Tamaño implícito: el tamaño "natural" sin width/height explícitos ---
    implicitWidth: Style.resize(170)
    implicitHeight: Style.resize(30)

    // --- background: la pista/riel (forma de píldora) ---
    // Este es el slot "background" — el visual detrás del control.
    // Para Switch, es el riel ovalado sobre el que desliza el círculo.
    // Es transparente con borde, creando el efecto de pista hueca.
    background: Rectangle {
        id: background
        width: parent.width / 3
        height: parent.height
        color: "transparent"
        border.color: Style.inactiveColor
        radius: width / 3  // Bordes muy redondeados → forma de píldora
    }

    // --- indicator: el círculo deslizante ---
    // Este es el slot "indicator" — el visual adicional del control.
    // Para Switch, es el círculo que se mueve entre izquierda y derecha.
    indicator: Rectangle {
        id: indicator
        width: background.width / 2
        height: parent.height
        color: Style.mainColor
        radius: width / 2  // Círculo perfecto

        // Posición x vinculada al estado:
        // - Desmarcado (checked=false): x=0 (pegado a la izquierda)
        // - Marcado (checked=true): x=(ancho pista - ancho círculo) (pegado a la derecha)
        x: root.checked ? (background.width - width) : 0

        // Behavior on x: anima automáticamente cualquier cambio en x.
        // Esto convierte el cambio abrupto de posición en un deslizamiento suave.
        Behavior on x {
            NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
        }
    }

    // --- contentItem: el texto/etiqueta junto al switch ---
    contentItem: Item {
        width: (parent.width - background.width - Style.resize(10))
        height: parent.height
        anchors.left: background.right
        anchors.leftMargin: Style.resize(10)
        Label {
            anchors.verticalCenter: parent.verticalCenter
            color: Style.inactiveColor
            text: root.text
        }
    }
}
