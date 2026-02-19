// =============================================================================
// Main.qml — Pagina principal del modulo TabBar Examples
// =============================================================================
// Este archivo es el punto de entrada del modulo de ejemplo "tabbar".
// Sigue el patron estandar del proyecto: un Item raiz con la propiedad
// 'fullSize' que controla la visibilidad mediante una animacion de opacidad.
//
// La pagina organiza cuatro tarjetas de ejemplo en un GridLayout 2x2 dentro
// de un ScrollView, permitiendo que el contenido sea desplazable si excede
// el area visible. Cada tarjeta es un componente autocontenido que demuestra
// un uso diferente de TabBar.
//
// Aprendizaje clave: como estructurar una pagina de ejemplos con GridLayout
// y el patron de navegacion fullSize/opacity del proyecto.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: Dashboard.qml asigna fullSize=true
    // cuando esta pagina es la activa. La animacion de opacidad crea una
    // transicion suave de 200ms al entrar/salir. 'visible: opacity > 0.0'
    // evita que el Item consuma eventos de raton cuando esta oculto.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // -------------------------------------------------------------------------
    // Fondo de la pagina y area de desplazamiento
    // El Rectangle provee el color de fondo uniforme. El ScrollView permite
    // hacer scroll vertical cuando las tarjetas exceden el alto disponible.
    // contentWidth: availableWidth fuerza que el contenido ocupe todo el ancho
    // sin generar scroll horizontal.
    // -------------------------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Titulo de la seccion
                Label {
                    text: "TabBar Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // GridLayout 2x2: cada celda contiene una tarjeta de ejemplo.
                // Todas las tarjetas usan Layout.fillWidth/fillHeight para
                // distribuirse equitativamente. Layout.minimumHeight garantiza
                // que cada tarjeta tenga suficiente espacio vertical para
                // mostrar su contenido (TabBar + StackLayout + controles).
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicTabBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    IconTabBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    DynamicTabBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    InteractiveTabBarCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
