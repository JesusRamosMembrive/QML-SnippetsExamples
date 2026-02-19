// =============================================================================
// Main.qml — Punto de entrada de la pagina de ejemplos de Flickable
// =============================================================================
// Este archivo es la pagina principal del modulo "flickable". Sigue el patron
// estandar del proyecto: un Item raiz con la propiedad fullSize que controla
// la visibilidad mediante una animacion de opacidad.
//
// Dentro contiene un ScrollView con un GridLayout de 2x2 donde se colocan las
// cuatro tarjetas de ejemplo. Cada tarjeta es un componente autocontenido que
// demuestra un aspecto diferente de Flickable:
//   - BasicFlickableCard: scroll vertical basico
//   - PinchZoomCard: zoom con escala y desplazamiento
//   - SnapFlickableCard: paginacion horizontal con snap
//   - InteractiveFlickableCard: control de propiedades en tiempo real
//
// El Layout.minimumHeight garantiza que las tarjetas tengan suficiente espacio
// vertical para mostrar su contenido interactivo sin recortarse.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: fullSize controla si esta pagina
    // esta activa. Dashboard.qml enlaza esta propiedad al estado actual del
    // menu. La animacion de opacidad da una transicion suave entre paginas,
    // y visible: opacity > 0 libera recursos de renderizado cuando esta oculta.
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

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView envuelve todo el contenido para permitir scroll vertical
        // si las tarjetas exceden el alto disponible de la ventana.
        // contentWidth: availableWidth evita scroll horizontal innecesario.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Titulo de la pagina — usa Style.mainColor para coherencia visual
                Label {
                    text: "Flickable Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // GridLayout 2x2: cada tarjeta ocupa una celda con fillWidth/
                // fillHeight para distribuir el espacio equitativamente.
                // minimumHeight asegura espacio suficiente para las areas
                // interactivas (Flickable, Canvas, etc.) dentro de cada tarjeta.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicFlickableCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    PinchZoomCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    SnapFlickableCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveFlickableCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
