// =============================================================================
// RowColumnLayoutCard.qml — Demo interactiva de RowLayout y ColumnLayout
// =============================================================================
// Muestra los dos layouts lineales fundamentales de Qt Quick Layouts:
//
// - RowLayout: distribuye hijos horizontalmente (izquierda a derecha).
// - ColumnLayout: distribuye hijos verticalmente (arriba a abajo).
//
// Conceptos clave que se ensenan aqui:
// 1. Layout.preferredWidth/Height vs Layout.fillWidth/fillHeight:
//    los elementos "Fixed" tienen un tamano preferido fijo, mientras que
//    los elementos "fillWidth" se expanden para ocupar el espacio sobrante.
//    Cuando hay multiples fillWidth, el espacio se reparte equitativamente.
//
// 2. spacing reactivo: un Slider controla el spacing del layout en tiempo
//    real, permitiendo al usuario ver como el espaciado afecta la
//    distribucion sin cambiar el codigo.
//
// 3. Patron de contenedor: Rectangle con bgColor envuelve cada layout
//    para dar contexto visual (simula un area de trabajo).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Row & Column Layout"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // Control interactivo de spacing
        // El slider esta vinculado (binding) al spacing de ambos layouts.
        // Esto demuestra la reactividad de QML: al cambiar el valor del
        // slider, ambos layouts se redistribuyen automaticamente.
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Spacing: " + spacingSlider.value.toFixed(0) + "px"
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: spacingSlider
                    anchors.fill: parent
                    from: 0
                    to: 30
                    value: 8
                    stepSize: 1
                }
            }
        }

        // ---------------------------------------------------------------------
        // Demo de RowLayout (disposicion horizontal)
        // Mezcla elementos de ancho fijo (preferredWidth) con elementos que
        // se expanden (fillWidth). Los dos elementos "fillWidth" se reparten
        // el espacio restante despues de reservar los anchos fijos.
        // ---------------------------------------------------------------------
        Label {
            text: "RowLayout"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(50)
            color: Style.bgColor
            radius: Style.resize(4)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                spacing: spacingSlider.value

                Rectangle {
                    Layout.preferredWidth: Style.resize(60)
                    Layout.fillHeight: true
                    color: "#4A90D9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#00D1A9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.preferredWidth: Style.resize(80)
                    Layout.fillHeight: true
                    color: "#FEA601"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#9B59B6"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Demo de ColumnLayout (disposicion vertical)
        // Misma logica pero en eje vertical: preferredHeight fija la altura
        // de algunos hijos, mientras que fillHeight expande el hijo restante
        // para llenar el espacio vertical sobrante.
        // ---------------------------------------------------------------------
        Label {
            text: "ColumnLayout"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                spacing: spacingSlider.value

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(30)
                    color: "#E74C3C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "preferredHeight: 30"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#1ABC9C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillHeight"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(25)
                    color: "#FF5900"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "preferredHeight: 25"; color: "white"; font.pixelSize: Style.resize(10) }
                }
            }
        }

        Label {
            text: "RowLayout arranges horizontally, ColumnLayout vertically. fillWidth/fillHeight expand to fill"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
