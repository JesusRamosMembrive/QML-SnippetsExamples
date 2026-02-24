// =============================================================================
// InteractiveRangeCard.qml — Tarjeta: Demo interactivo con gradientes y opacidad
// =============================================================================
// Muestra usos creativos del RangeSlider mas alla de seleccionar numeros:
//   1. Control de gradiente: los handles definen las posiciones de los
//      GradientStops, cambiando la visualizacion del degradado en tiempo real.
//   2. Ventana de opacidad: el rango define que bloques de un Repeater se
//      muestran opacos vs transparentes, creando un efecto de "spotlight".
//
// Esto demuestra que el valor de un RangeSlider no tiene que mostrarse
// como texto — puede controlar CUALQUIER propiedad visual gracias a los
// bindings declarativos de QML.
//
// Aprendizaje clave: los GradientStops usan "position" (0.0-1.0), asi que
// dividimos el valor del slider (0-100) entre 100. El Repeater calcula la
// posicion central de cada bloque para determinar si esta dentro del rango.
// =============================================================================
pragma ComponentBehavior: Bound

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
        spacing: Style.resize(20)

        Label {
            text: "Interactive Gradient Demo"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Control the gradient stops with the range slider"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Preview del gradiente: 4 GradientStops crean un efecto de
        // "foco de luz" donde el color emerge del fondo oscuro (#1A1D23)
        // y vuelve a desvanecerse. Los stops centrales se vinculan a
        // los valores del RangeSlider, asi que mover los handles
        // desplaza las zonas de color en tiempo real.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            radius: Style.resize(8)

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#1A1D23" }
                GradientStop { position: gradientRange.first.value / 100; color: Style.mainColor }
                GradientStop { position: gradientRange.second.value / 100; color: "#FEA601" }
                GradientStop { position: 1.0; color: "#1A1D23" }
            }
        }

        // Control del gradiente: slider continuo (sin stepSize) para
        // posicionamiento suave de los GradientStops.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Gradient Stops"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: gradientRange.first.value.toFixed(0) + "% — " + gradientRange.second.value.toFixed(0) + "%"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: gradientRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 25
                    second.value: 75
                }
            }
        }

        // Control de opacidad: define una "ventana" de visibilidad.
        // Los bloques cuya posicion central cae dentro del rango se
        // muestran completamente opacos; los demas se atenuan a 0.15.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Opacity Window"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: opacityRange.first.value.toFixed(0) + "% — " + opacityRange.second.value.toFixed(0) + "%"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: opacityRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 30
                    second.value: 90
                }
            }

            // Visualizacion de la ventana de opacidad: 10 rectangulos
            // representan segmentos del 0% al 100%. Cada uno calcula su
            // posicion central (index + 0.5) * 10 y compara contra el rango
            // del slider para decidir si esta "iluminado" (opacity 1.0)
            // o "apagado" (opacity 0.15). Esto crea un efecto visual de
            // spotlight que responde en tiempo real al slider.
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(4)

                Repeater {
                    model: 10
                    Rectangle {
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(30)
                        radius: Style.resize(4)
                        color: Style.mainColor
                        opacity: {
                            var pos = (index + 0.5) * 10
                            var lo = opacityRange.first.value
                            var hi = opacityRange.second.value
                            if (pos >= lo && pos <= hi) return 1.0
                            return 0.15
                        }
                    }
                }
            }
        }
    }
}
