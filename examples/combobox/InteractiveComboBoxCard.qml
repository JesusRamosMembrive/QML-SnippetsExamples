// =============================================================================
// InteractiveComboBoxCard.qml — Demo interactiva con multiples ComboBox
// =============================================================================
// Tarjeta que combina tres ComboBox (forma, color, tamano) para modificar
// en tiempo real un rectangulo de previsualizacion. Demuestra el poder de
// los bindings declarativos de QML: la figura se actualiza automaticamente
// sin necesidad de codigo imperativo cuando el usuario cambia cualquier
// ComboBox.
//
// Patrones destacados:
//   - Bindings entre ComboBox y propiedades visuales (width, color, radius).
//   - Behavior para animar transiciones suaves al cambiar selecciones.
//   - Uso de currentIndex para logica condicional (forma -> radio/rotacion).
//   - Uso de currentValue con valueRole para obtener valores tipados
//     (colores hex, tamanos numericos) desde modelos estructurados.
//
// Aprendizaje clave: los bindings declarativos eliminan la necesidad de
// callbacks o codigo de sincronizacion manual — la UI se mantiene coherente
// automaticamente.
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
        spacing: Style.resize(20)

        Label {
            text: "Interactive Demo"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Change the shape, color, and size with combo boxes"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // -----------------------------------------------------------------
        // Area de previsualizacion
        // El rectangulo interior (previewShape) esta enlazado directamente
        // a los tres ComboBox. La logica de forma funciona asi:
        //   - Square:  radius=0, rotation=0
        //   - Circle:  radius=width/2 (circulo perfecto)
        //   - Rounded: radius=8 (esquinas redondeadas)
        //   - Diamond: radius=0, rotation=45 (cuadrado rotado)
        //
        // Los Behavior en cada propiedad crean animaciones suaves de 200ms.
        // Nota: ColorAnimation para color, NumberAnimation para el resto.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(120)
            color: Style.bgColor
            radius: Style.resize(8)

            Rectangle {
                id: previewShape
                anchors.centerIn: parent
                width: sizeCombo.currentValue
                height: sizeCombo.currentValue
                radius: shapeCombo.currentIndex === 1 ? width / 2 : (shapeCombo.currentIndex === 2 ? Style.resize(8) : 0)
                color: colorCombo.currentValue
                rotation: shapeCombo.currentIndex === 3 ? 45 : 0

                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on rotation { NumberAnimation { duration: 200 } }
            }
        }

        // -----------------------------------------------------------------
        // Selector de forma (modelo simple de strings)
        // Usa currentIndex para determinar la forma — cada indice mapea
        // a un tipo de forma en la logica del rectangulo de preview.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Shape"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: shapeCombo
                Layout.fillWidth: true
                model: ["Square", "Circle", "Rounded", "Diamond"]
            }
        }

        // -----------------------------------------------------------------
        // Selector de color (ListModel con textRole/valueRole)
        // textRole muestra el nombre del color al usuario ("Teal"), pero
        // valueRole proporciona el valor hex ("#00D1A9") que se enlaza
        // directamente a la propiedad color del rectangulo de preview.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Color"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: colorCombo
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "hex"
                model: ListModel {
                    ListElement { name: "Teal"; hex: "#00D1A9" }
                    ListElement { name: "Orange"; hex: "#FEA601" }
                    ListElement { name: "Blue"; hex: "#4FC3F7" }
                    ListElement { name: "Red"; hex: "#FF7043" }
                    ListElement { name: "Purple"; hex: "#AB47BC" }
                    ListElement { name: "Pink"; hex: "#EC407A" }
                }
            }
        }

        // -----------------------------------------------------------------
        // Selector de tamano (ListModel con valores numericos)
        // valueRole: "size" devuelve un numero que se enlaza al width/height
        // del rectangulo. currentIndex: 1 preselecciona "Medium" (60px).
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Size"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: sizeCombo
                Layout.fillWidth: true
                textRole: "label"
                valueRole: "size"
                currentIndex: 1
                model: ListModel {
                    ListElement { label: "Small"; size: 40 }
                    ListElement { label: "Medium"; size: 60 }
                    ListElement { label: "Large"; size: 80 }
                    ListElement { label: "Extra Large"; size: 100 }
                }
            }
        }

        // Resumen textual de la seleccion actual
        Label {
            text: shapeCombo.currentText + " | " + colorCombo.currentText + " | " + sizeCombo.currentText
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
