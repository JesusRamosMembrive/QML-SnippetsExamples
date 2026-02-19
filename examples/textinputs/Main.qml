// =============================================================================
// Main.qml — Pagina principal de ejemplos de entrada de texto
// =============================================================================
// Este archivo es el punto de entrada de la seccion "Text Inputs". Organiza
// todas las tarjetas de ejemplo en un layout con scroll vertical. Sigue el
// patron estandar del proyecto: un Item raiz con la propiedad `fullSize` que
// controla la visibilidad mediante una animacion de opacidad (200ms).
//
// La estructura visual es:
//   - Un titulo de seccion
//   - Un GridLayout 2x2 con las 4 tarjetas principales (TextField, TextArea,
//     ComboBox/SpinBox, Form Builder)
//   - Un bloque grande tipo tarjeta con controles de entrada personalizados
//     (SearchBar, PinInput, TagInput, etc.) separados por lineas divisoras
//
// Patron clave: cada tarjeta es un componente QML autocontenido. Main.qml
// solo se encarga de la composicion y el layout, no de la logica interna.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: el Dashboard controla `fullSize`
    // para mostrar/ocultar esta pagina. La opacidad se anima y `visible`
    // se desactiva cuando la opacidad llega a 0, evitando que el motor
    // QML procese un arbol visual completamente transparente.
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

        // ScrollView envuelve todo el contenido para permitir scroll vertical.
        // contentWidth: availableWidth asegura que el contenido se ajuste
        // al ancho disponible sin generar scroll horizontal.
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
                    text: "Text Input Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -----------------------------------------------------------------
                // Grid principal: 4 tarjetas en formato 2x2. Cada tarjeta usa
                // Layout.fillWidth + Layout.fillHeight para repartir el espacio
                // equitativamente. Layout.minimumHeight garantiza que no colapsen
                // cuando el contenido interno es menor al espacio disponible.
                // -----------------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    TextFieldCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    TextAreaCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ComboSpinCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    FormBuilderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }

                // -----------------------------------------------------------------
                // Tarjeta de controles personalizados: a diferencia de las tarjetas
                // de arriba (que usan controles nativos de Qt Quick Controls),
                // esta seccion muestra componentes construidos "desde cero" con
                // Rectangle + TextInput + animaciones. Cada sub-componente esta
                // separado por un Rectangle delgado que actua como divisor visual.
                // -----------------------------------------------------------------
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customInputsCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customInputsCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Input Controls"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted input components built from scratch with Rectangle, TextInput, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        // Cada componente personalizado seguido de un separador
                        SearchBar {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        PinInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        TagInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        EditableLabels {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        StarRating {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        CharLimitInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        ColorPicker {}
                    }
                }
            }
        }
    }
}
