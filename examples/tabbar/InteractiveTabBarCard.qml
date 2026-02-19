// =============================================================================
// InteractiveTabBarCard.qml — TabBar que controla propiedades visuales
// =============================================================================
// Demuestra un caso de uso avanzado donde cada pestana del TabBar presenta
// controles (Sliders) que modifican propiedades de un elemento visual en
// tiempo real. Es un ejemplo de como combinar TabBar + StackLayout con
// controles interactivos para crear un panel de configuracion.
//
// La arquitectura es: un Rectangle de vista previa arriba cuyas propiedades
// (color, opacity, border.width) estan vinculadas a los Sliders de cada
// pestana. Al cambiar de pestana se accede a un control diferente, pero
// todos afectan al mismo Rectangle simultaneamente.
//
// Aprendizaje clave: los bindings de QML permiten que multiples controles
// en distintas pestanas afecten al mismo elemento sin logica imperativa.
// Behavior on color crea transiciones suaves entre valores.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "TabBar + Controls"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Each tab controls a different property"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // ---------------------------------------------------------------------
        // Rectangle de vista previa: refleja en tiempo real los valores de los
        // tres Sliders (color, opacity, border). Se usa una expresion ternaria
        // encadenada para mapear el rango 0-1 del Slider a tres colores
        // discretos. Behavior on color suaviza la transicion al cambiar.
        // ---------------------------------------------------------------------
        Rectangle {
            id: previewRect
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            radius: Style.resize(8)
            color: colorSlider.value < 0.33 ? Style.mainColor
                 : colorSlider.value < 0.66 ? "#FEA601"
                 : "#4FC3F7"
            opacity: opacitySlider.value
            border.width: borderSlider.value
            border.color: "#FFFFFF"

            Behavior on color { ColorAnimation { duration: 200 } }

            Label {
                anchors.centerIn: parent
                text: "Preview"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: "#FFFFFF"
            }
        }

        // ---------------------------------------------------------------------
        // TabBar de controles: cada pestana da acceso a un Slider diferente.
        // Aunque las pestanas muestran un Slider a la vez, todos los Sliders
        // estan siempre instanciados (dentro del StackLayout), por lo que
        // mantienen su valor cuando se cambia de pestana.
        // ---------------------------------------------------------------------
        TabBar {
            id: controlTabBar
            Layout.fillWidth: true

            TabButton { text: "Color" }
            TabButton { text: "Opacity" }
            TabButton { text: "Border" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: controlTabBar.currentIndex

            // Pestana Color: Slider que mapea 0-1 a tres colores
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Slide to change color"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: "Teal"; font.pixelSize: Style.resize(12); color: Style.mainColor }
                        Item { Layout.fillWidth: true }
                        Label { text: "Orange"; font.pixelSize: Style.resize(12); color: "#FEA601" }
                        Item { Layout.fillWidth: true }
                        Label { text: "Blue"; font.pixelSize: Style.resize(12); color: "#4FC3F7" }
                    }

                    Slider {
                        id: colorSlider
                        Layout.fillWidth: true
                        from: 0; to: 1; value: 0
                    }
                }
            }

            // Pestana Opacity: Slider de 10% a 100%
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Opacity: " + (opacitySlider.value * 100).toFixed(0) + "%"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    Slider {
                        id: opacitySlider
                        Layout.fillWidth: true
                        from: 0.1; to: 1.0; value: 1.0
                    }
                }
            }

            // Pestana Border: Slider de 0 a 8px con stepSize de 1
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(10)

                    Label {
                        text: "Border width: " + borderSlider.value.toFixed(0) + " px"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontSecondaryColor
                    }

                    Slider {
                        id: borderSlider
                        Layout.fillWidth: true
                        from: 0; to: 8; value: 0
                        stepSize: 1
                    }
                }
            }
        }
    }
}
