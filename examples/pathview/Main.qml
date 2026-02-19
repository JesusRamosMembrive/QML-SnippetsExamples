// =============================================================================
// Main.qml — Pagina principal del ejemplo PathView
// =============================================================================
// Pagina contenedora que organiza cuatro tarjetas de ejemplo de PathView
// en un grid 2x2. PathView es un componente de Qt Quick que posiciona
// delegados a lo largo de un Path definido matematicamente, creando
// carruseles, listas circulares y efectos tipo "coverflow".
//
// Cada tarjeta demuestra un tipo diferente de trazado (Path):
//   - CircularPathCard: camino circular completo con PathArc
//   - ArcPathCard: arco curvado con PathQuad (curva de Bezier cuadratica)
//   - CoverFlowCard: linea recta con PathAttribute para efecto 3D
//   - InteractivePathCard: curva configurable en tiempo real
//
// Patron de navegacion del proyecto: fullSize controla la visibilidad
// con animacion de opacidad. Dashboard.qml activa fullSize cuando el
// usuario selecciona esta pagina en el menu lateral.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patron de visibilidad del proyecto: fullSize controla si esta
    //    pagina esta activa. La opacidad se anima suavemente y visible
    //    se desactiva cuando la opacidad llega a 0 para no consumir
    //    recursos de renderizado en paginas ocultas.
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // -- ScrollView envuelve todo el contenido para permitir scroll
        //    vertical si las tarjetas no caben en la ventana.
        //    contentWidth: availableWidth asegura que el contenido ocupe
        //    todo el ancho disponible sin generar scroll horizontal.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "PathView Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- GridLayout 2x2 distribuye las cuatro tarjetas.
                //    Layout.minimumHeight garantiza que cada tarjeta tenga
                //    suficiente espacio vertical para mostrar el PathView.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    CircularPathCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(400)
                    }

                    ArcPathCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(400)
                    }

                    CoverFlowCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(400)
                    }

                    InteractivePathCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(400)
                    }
                }
            }
        }
    }
}
