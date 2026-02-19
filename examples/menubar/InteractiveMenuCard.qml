// =============================================================================
// InteractiveMenuCard.qml — Menus que controlan una figura animada
// =============================================================================
// Ejemplo avanzado donde la MenuBar actua como panel de control de una figura
// geometrica. El usuario selecciona forma, color y tamano desde menus, y la
// figura se actualiza con transiciones animadas.
//
// Conceptos clave:
//   - Behavior on <propiedad>: animacion implicita que se ejecuta cada vez
//     que la propiedad cambia. Permite transiciones suaves sin logica extra.
//   - NumberAnimation vs ColorAnimation: QML necesita el tipo de animacion
//     correcto para cada tipo de propiedad (numeros vs colores).
//   - Truco del diamante: un rectangulo con rotation: 45 se ve como un rombo.
//   - Truco del circulo: radius = width/2 convierte un rectangulo en circulo.
//
// Este ejemplo demuestra como los menus pueden ser algo mas que navegacion:
// pueden servir como controles de configuracion que afectan una vista en
// tiempo real, similar a herramientas de un editor grafico.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Propiedades que definen el estado de la figura.
    //    Cada Menu modifica una de estas propiedades.
    property color shapeColor: Style.mainColor
    property string shapeName: "Rectangle"
    property int shapeSize: 60

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Menu-Driven Drawing"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- MenuBar como panel de control con 3 categorias: forma, color y tamano.
        //    Cada MenuItem simplemente asigna un valor a la propiedad correspondiente.
        MenuBar {
            Layout.fillWidth: true

            Menu {
                title: "Shape"
                MenuItem { text: "Rectangle"; onTriggered: root.shapeName = "Rectangle" }
                MenuItem { text: "Circle"; onTriggered: root.shapeName = "Circle" }
                MenuItem { text: "Diamond"; onTriggered: root.shapeName = "Diamond" }
            }

            Menu {
                title: "Color"
                MenuItem { text: "Teal"; onTriggered: root.shapeColor = "#00D1A9" }
                MenuItem { text: "Orange"; onTriggered: root.shapeColor = "#FEA601" }
                MenuItem { text: "Blue"; onTriggered: root.shapeColor = "#4FC3F7" }
                MenuItem { text: "Red"; onTriggered: root.shapeColor = "#FF7043" }
                MenuItem { text: "Purple"; onTriggered: root.shapeColor = "#AB47BC" }
            }

            Menu {
                title: "Size"
                MenuItem { text: "Small (40)"; onTriggered: root.shapeSize = 40 }
                MenuItem { text: "Medium (60)"; onTriggered: root.shapeSize = 60 }
                MenuItem { text: "Large (90)"; onTriggered: root.shapeSize = 90 }
            }
        }

        // -- Area de dibujo con la figura centrada.
        //    La figura es un solo Rectangle cuyas propiedades (radius, rotation,
        //    width, height, color) se modifican para simular diferentes formas.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            Rectangle {
                anchors.centerIn: parent
                width: Style.resize(root.shapeSize)
                height: Style.resize(root.shapeSize)
                radius: root.shapeName === "Circle" ? width / 2 : 0
                rotation: root.shapeName === "Diamond" ? 45 : 0
                color: root.shapeColor

                // -- Behaviors: cada cambio de propiedad se anima automaticamente.
                //    Esto crea una transicion fluida al cambiar forma/color/tamano.
                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on rotation { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        // -- Barra de estado con la configuracion actual
        Label {
            text: root.shapeName + " | " + root.shapeColor + " | " + root.shapeSize + "px"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
