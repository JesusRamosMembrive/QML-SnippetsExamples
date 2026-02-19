// =============================================================================
// Main.qml — Pagina principal del modulo Images
// =============================================================================
// Punto de entrada para los ejemplos de imagenes en QML. Organiza cuatro
// tarjetas en un grid 2x2 dentro de un ScrollView, cada una demostrando un
// aspecto diferente del manejo de imagenes: FillMode, BorderImage (9-patch),
// mascaras con OpacityMask, y propiedades interactivas (rotacion, escala, espejo).
//
// Patron clave: fullSize controla la visibilidad con animacion de opacidad.
// Dashboard.qml asigna fullSize=true solo a la pagina activa, logrando
// transiciones suaves sin destruir/recrear componentes.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad: fullSize lo controla Dashboard.qml.
    // La opacidad se anima con Behavior, y visible se desactiva cuando
    // opacity llega a 0 para que el Item no consuma eventos de raton.
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

        // ScrollView envuelve todo el contenido para que sea desplazable
        // si las tarjetas exceden la altura disponible.
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

                Label {
                    text: "Image Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 con las cuatro tarjetas de ejemplo.
                // Cada tarjeta es un componente independiente que demuestra
                // una funcionalidad especifica de Image en QML.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    FillModeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    BorderImageCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    MaskImageCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }

                    InteractiveImageCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(450)
                    }
                }
            }
        }
    }
}
