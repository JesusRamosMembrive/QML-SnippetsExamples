// =============================================================================
// Main.qml — Pagina principal del ejemplo RangeSlider
// =============================================================================
// Presenta cuatro tarjetas que cubren las variaciones principales del control
// RangeSlider de Qt Quick Controls:
//   - BasicRangeSliderCard: horizontal, con pasos y deshabilitado
//   - VerticalRangeSliderCard: orientacion vertical
//   - LabelsRangeSliderCard: rangos con formato (precio, edad, temperatura)
//   - InteractiveRangeCard: uso creativo con gradientes y opacidad
//
// A diferencia de la pagina asynccpp (que usa columnas responsive), aqui
// se usa un GridLayout fijo de 2x2. Esto funciona bien cuando el numero
// de tarjetas es predecible y siempre se muestran en pares.
//
// Aprendizaje clave: RangeSlider tiene dos "handles" (first y second)
// que definen un rango. Cada handle es un sub-objeto con su propia
// propiedad value, lo que permite bindings independientes a cada extremo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del Dashboard: la pagina aparece/desaparece con
    // una animacion de opacidad de 200ms cuando se navega entre secciones.
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
                    text: "RangeSlider Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Grid 2x2 fijo: cada tarjeta usa Layout.fillWidth y
                // Layout.fillHeight para ocupar su celda equitativamente.
                // minimumHeight asegura que las tarjetas no se compriman
                // demasiado en pantallas pequenas.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicRangeSliderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    VerticalRangeSliderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    LabelsRangeSliderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    InteractiveRangeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }
                }
            }
        }
    }
}
