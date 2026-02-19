// =============================================================================
// Main.qml — Punto de entrada de la pagina de ejemplos de Shaders y Efectos
// =============================================================================
// Pagina principal del modulo "shaders". Muestra cuatro tarjetas de ejemplo
// que demuestran los efectos graficos de Qt5Compat.GraphicalEffects:
//   - BlurEffectCard: desenfoque gaussiano controlable
//   - GlowShadowCard: brillo, sombra proyectada y sombra interior
//   - ColorEffectCard: superposicion de color y desaturacion
//   - InteractiveEffectsCard: combinacion de multiples efectos en cadena
//
// Todos estos efectos provienen del modulo Qt5Compat.GraphicalEffects, que
// es la version retrocompatible de los efectos graficos de Qt 5 para Qt 6.
// En produccion, estos efectos pueden ser costosos en rendimiento porque
// implican pases de renderizado extra (offscreen rendering). Para este
// proyecto educativo son ideales para entender el pipeline grafico de Qt.
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
    // esta activa. Dashboard.qml enlaza esta propiedad al estado del menu.
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

        // ScrollView para scroll vertical si el contenido excede la ventana
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
                    text: "Shaders & Effects"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // GridLayout 2x2 con las cuatro tarjetas de efectos.
                // Cada tarjeta es un componente autocontenido con su propia
                // escena fuente (source) y controles interactivos.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BlurEffectCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    GlowShadowCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    ColorEffectCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveEffectsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
