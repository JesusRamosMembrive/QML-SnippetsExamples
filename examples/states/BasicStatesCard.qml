// =============================================================================
// BasicStatesCard.qml — Estados basicos con PropertyChanges
// =============================================================================
// Demuestra el concepto fundamental de estados en QML: un Item define una
// lista de State, cada uno con un nombre unico y un conjunto de PropertyChanges
// que modifican propiedades de uno o mas targets cuando ese estado se activa.
//
// Al asignar stateBox.state = "expanded", QML aplica automaticamente todos
// los PropertyChanges definidos en ese State. Si el estado vuelve a "" (vacio),
// las propiedades regresan a sus valores base (los definidos fuera de states).
//
// La Transition define como se animan los cambios entre estados. Aqui se usa
// una sola Transition sin 'from'/'to', lo que la aplica a TODAS las
// transiciones. NumberAnimation anima propiedades numericas, ColorAnimation
// anima colores.
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
        spacing: Style.resize(15)

        Label {
            text: "Basic States"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "PropertyChanges on state switch"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            id: stateArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: stateBox
                width: Style.resize(100)
                height: Style.resize(100)
                radius: Style.resize(8)
                color: "#00D1A9"
                anchors.centerIn: parent

                Label {
                    id: stateLabel
                    anchors.centerIn: parent
                    text: "Default"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: "#FFFFFF"
                }

                // ---------------------------------------------------------
                // Lista de estados: cada State tiene un nombre y uno o mas
                // PropertyChanges. 'target' indica que objeto se modifica.
                // Se pueden cambiar multiples propiedades en un solo
                // PropertyChanges, y afectar multiples targets por estado.
                // ---------------------------------------------------------
                states: [
                    State {
                        name: "expanded"
                        PropertyChanges { target: stateBox; width: Style.resize(200); height: Style.resize(60); color: "#FEA601"; radius: Style.resize(30) }
                        PropertyChanges { target: stateLabel; text: "Expanded" }
                    },
                    State {
                        name: "rotated"
                        PropertyChanges { target: stateBox; rotation: 45; color: "#AB47BC"; width: Style.resize(80); height: Style.resize(80) }
                        PropertyChanges { target: stateLabel; text: "Rotated" }
                    },
                    State {
                        name: "small"
                        PropertyChanges { target: stateBox; width: Style.resize(50); height: Style.resize(50); color: "#FF7043"; radius: Style.resize(25) }
                        PropertyChanges { target: stateLabel; text: "Small"; font.pixelSize: Style.resize(10) }
                    }
                ]

                // Transition sin from/to = se aplica a cualquier cambio de estado.
                // NumberAnimation anima propiedades numericas listadas en 'properties'.
                // ColorAnimation detecta automaticamente propiedades de tipo color.
                transitions: Transition {
                    NumberAnimation { properties: "width,height,rotation,radius"; duration: 400; easing.type: Easing.InOutQuad }
                    ColorAnimation { duration: 400 }
                }
            }
        }

        // Botones para activar cada estado. state = "" vuelve al estado
        // por defecto (sin nombre), restaurando los valores base originales.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: [
                    { label: "Default", st: "" },
                    { label: "Expanded", st: "expanded" },
                    { label: "Rotated", st: "rotated" },
                    { label: "Small", st: "small" }
                ]

                Button {
                    required property var modelData
                    text: modelData.label
                    font.pixelSize: Style.resize(11)
                    highlighted: stateBox.state === modelData.st
                    onClicked: stateBox.state = modelData.st
                    Layout.fillWidth: true
                }
            }
        }

        // Muestra el nombre del estado activo como feedback visual
        Label {
            text: "state: \"" + (stateBox.state || "default") + "\""
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
