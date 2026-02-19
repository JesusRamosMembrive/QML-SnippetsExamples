// =============================================================================
// ComboBox.qml - Override de estilo para ComboBox
// =============================================================================
//
// ComboBox es uno de los controles mas complejos. Tiene CUATRO partes visuales:
//   1. indicator:   la flecha desplegable (triangulo ▾)
//   2. contentItem: el texto del elemento seleccionado
//   3. background:  la caja/contenedor con borde
//   4. delegate + popup: la lista desplegable y cada elemento dentro de ella
//
// PATRON "import Templates as T":
//   Importamos QtQuick.Templates (no QtQuick.Controls) porque este archivo
//   ES el estilo de ComboBox. Importar Controls causaria recursion infinita.
//   Templates provee solo la logica (modelo, indice, apertura/cierre) sin visual.
//
// LOGICA DEL TEXTO EN EL DELEGATE:
//   La expresion del text en el delegate maneja tres tipos de modelo:
//     root.textRole ? (Array.isArray(root.model) ? modelData : model[root.textRole]) : modelData
//   Desglosado:
//     - Sin textRole definido   --> usa modelData directamente (array simple)
//     - Con textRole + array JS --> modelData (los arrays JS no usan roles)
//     - Con textRole + ListModel --> model[textRole] (accede al rol del modelo)
//   Esto hace que el ComboBox funcione con cualquier tipo de modelo de Qt.
//
// T.Popup (no Popup):
//   El popup usa T.Popup (de Templates) y T.ItemDelegate para evitar que se
//   aplique recursivamente nuestro propio estilo de Popup/ItemDelegate.
//
// OPTIMIZACION DEL MODELO:
//   "root.popup.visible ? root.delegateModel : null" — solo crea los delegates
//   cuando el popup esta abierto. Esto ahorra memoria y tiempo de creacion
//   cuando el ComboBox esta cerrado.
//
// Behavior on border.color:
//   Anima suavemente la transicion del color del borde cuando el ComboBox
//   recibe/pierde el foco o se abre/cierra. Transicion de 150ms.
//
// DropShadow en popup:
//   Aplicado via layer.effect en el background del popup. Crea profundidad
//   para que la lista desplegable "flote" visualmente sobre el contenido.
// =============================================================================

import QtQuick
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import utils

T.ComboBox {
    id: root

    implicitWidth: Style.resize(200)
    implicitHeight: Style.resize(40)

    font.family: Style.fontFamilyRegular
    font.pixelSize: Style.fontSizeS

    // SLOT indicator: flecha desplegable (triangulo Unicode ▾)
    indicator: Label {
        anchors.right: parent.right
        anchors.rightMargin: Style.resize(12)
        anchors.verticalCenter: parent.verticalCenter
        text: "\u25BE"
        color: Style.mainColor
        font.pixelSize: Style.fontSizeM
    }

    // SLOT contentItem: muestra el texto del elemento seleccionado
    contentItem: Text {
        leftPadding: Style.resize(12)
        rightPadding: Style.resize(30)
        text: root.displayText
        font: root.font
        color: Style.fontPrimaryColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // SLOT background: caja con borde animado
    background: Rectangle {
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.width: Style.resize(2)
        // Borde cambia a mainColor cuando esta presionado o abierto
        border.color: root.pressed || root.popup.visible ? Style.mainColor : Style.inactiveColor

        // Transicion suave del color del borde (150ms)
        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }

    // delegate: como se renderiza CADA elemento de la lista desplegable
    // Usa T.ItemDelegate (Templates) para evitar aplicar nuestro propio estilo
    delegate: T.ItemDelegate {
        width: root.width
        height: Style.resize(36)
        contentItem: Text {
            // Logica de texto adaptativa: maneja array JS, ListModel con textRole,
            // y modelo sin textRole. Ver comentario de cabecera para detalles.
            text: root.textRole ? (Array.isArray(root.model) ? modelData : model[root.textRole]) : modelData
            font.family: Style.fontFamilyRegular
            font.pixelSize: Style.fontSizeS
            color: highlighted ? Style.mainColor : Style.fontPrimaryColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: Style.resize(12)
        }
        highlighted: root.highlightedIndex === index
        background: Rectangle {
            color: highlighted ? Style.bgColor : Style.cardColor
        }
    }

    // popup: la lista desplegable. Usa T.Popup (Templates, no Controls)
    popup: T.Popup {
        y: root.height + Style.resize(4)
        width: root.width
        implicitHeight: contentItem.implicitHeight + Style.resize(4)
        padding: Style.resize(2)

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            // OPTIMIZACION: solo crea delegates cuando el popup esta visible
            model: root.popup.visible ? root.delegateModel : null
        }

        // DropShadow via layer.effect: el popup "flota" sobre el contenido
        background: Rectangle {
            radius: Style.resize(8)
            color: Style.cardColor
            border.width: Style.resize(1)
            border.color: Style.inactiveColor

            layer.enabled: true
            layer.effect: DropShadow {
                verticalOffset: Style.resize(3)
                radius: Style.resize(8)
                samples: 17
                color: "#40000000"
            }
        }
    }
}
