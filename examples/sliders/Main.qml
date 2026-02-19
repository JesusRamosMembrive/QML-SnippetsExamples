// ============================================================================
// Main.qml — Pagina principal del modulo de ejemplos de Sliders.
//
// Concepto: Estructura de pagina de ejemplo con navegacion y layout responsivo.
//
// Cada modulo de ejemplo sigue el mismo patron:
//   1. Propiedad 'fullSize' controlada por Dashboard.qml para mostrar/ocultar
//   2. Animacion de opacidad con Behavior para transiciones suaves
//   3. ScrollView como contenedor principal para contenido que puede desbordar
//   4. GridLayout para organizar tarjetas (cards) en cuadricula
//
// Este archivo actua como "orquestador": no contiene logica de negocio,
// solo organiza y dimensiona las tarjetas individuales que demuestran
// cada concepto de slider.
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // fullSize es controlada externamente por Dashboard.qml.
    // Cuando la pagina esta activa, fullSize = true y se muestra con animacion.
    property bool fullSize: false

    // Patron de visibilidad animada: opacity controla la transicion visual,
    // visible evita que el elemento reciba eventos cuando esta oculto.
    // Behavior aplica una NumberAnimation automatica cada vez que opacity cambia.
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

        // ScrollView envuelve el contenido para permitir scroll vertical
        // cuando las tarjetas exceden el alto disponible.
        // contentWidth: availableWidth fuerza que el contenido ocupe todo
        // el ancho sin scroll horizontal.
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
                    text: "Slider Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // GridLayout organiza las tarjetas en una cuadricula de 2 columnas.
                // Cada tarjeta es un componente QML independiente (definido en su
                // propio archivo .qml dentro de este modulo).
                // Layout.columnSpan permite que una tarjeta ocupe varias columnas.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicSlidersCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    VerticalSlidersCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(80)
                    }

                    GlowDemoCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    VolumeActionsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(220)
                    }

                    // columnSpan: 2 hace que DialCard ocupe las dos columnas,
                    // creando una tarjeta de ancho completo en la fila inferior.
                    DialCard {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(380)
                    }
                }
            }
        }
    }
}
