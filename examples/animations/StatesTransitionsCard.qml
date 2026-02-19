// ============================================================================
// StatesTransitionsCard.qml
// Concepto: States (estados) y Transitions (transiciones) en QML.
//
// El sistema de estados es una de las herramientas mas poderosas de QML para
// gestionar interfaces complejas de forma declarativa:
//
//   - State: define un conjunto de valores de propiedades que representan una
//     "configuracion" del componente (ej: cuadrado, circulo, rectangulo ancho).
//     Cada estado tiene un nombre unico y usa PropertyChanges para definir
//     que propiedades cambian y a que valores.
//
//   - Transition: define COMO se anima el cambio entre estados. Sin transitions,
//     los cambios de estado son instantaneos. Con transitions, QML interpola
//     automaticamente entre los valores del estado anterior y el nuevo.
//
// La ventaja clave es la SEPARACION DE RESPONSABILIDADES:
//   - Los States definen el QUE (configuraciones validas)
//   - Las Transitions definen el COMO (animaciones entre configuraciones)
//   - La logica solo necesita cambiar 'state' a un nombre y todo se resuelve
//
// Este patron es ideal para botones con multiples estados, menus que se
// expanden/colapsan, formularios con pasos, etc.
// ============================================================================

pragma ComponentBehavior: Bound
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
        spacing: Style.resize(15)

        Label {
            text: "States & Transitions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // morphRect.state es reactivo: este binding se actualiza automaticamente
        // cada vez que cambia el estado del rectangulo.
        Label {
            text: "Current: " + morphRect.state
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        // Area de morph
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(8)
            }

            Rectangle {
                id: morphRect
                anchors.centerIn: parent
                width: Style.resize(100)
                height: Style.resize(100)
                radius: 0
                color: "#4A90D9"
                state: "square"

                // states: lista de configuraciones posibles del componente.
                // Cada State tiene un 'name' unico y un bloque PropertyChanges
                // que especifica los valores de las propiedades en ese estado.
                states: [
                    State {
                        name: "square"
                        PropertyChanges {
                            morphRect.width: Style.resize(100)
                            morphRect.height: Style.resize(100)
                            morphRect.radius: 0
                            morphRect.color: "#4A90D9"
                        }
                    },
                    State {
                        name: "circle"
                        // radius = width/2 convierte el rectangulo en circulo
                        PropertyChanges {
                            morphRect.width: Style.resize(100)
                            morphRect.height: Style.resize(100)
                            morphRect.radius: Style.resize(50)
                            morphRect.color: "#00D1A9"
                        }
                    },
                    State {
                        name: "wide"
                        PropertyChanges {
                            morphRect.width: Style.resize(200)
                            morphRect.height: Style.resize(80)
                            morphRect.radius: Style.resize(10)
                            morphRect.color: "#FEA601"
                        }
                    }
                ]

                // transitions: define como se animan los cambios entre CUALQUIER par
                // de estados. Sin 'from'/'to' explicitos, esta Transition se aplica
                // a todas las combinaciones de estado.
                // NumberAnimation interpola width, height y radius.
                // ColorAnimation interpola el color (requiere su propia animacion
                // porque el color no es un numero simple).
                transitions: [
                    Transition {
                        NumberAnimation {
                            properties: "width,height,radius"
                            duration: 500
                            easing.type: Easing.OutBounce
                        }
                        ColorAnimation {
                            duration: 500
                        }
                    }
                ]
            }
        }

        // Botones de estado: al hacer clic, solo cambian morphRect.state.
        // Las Transitions se encargan automaticamente de la animacion.
        // 'highlighted' refleja visualmente cual estado esta activo.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: "Square"
                onClicked: morphRect.state = "square"
                highlighted: morphRect.state === "square"
            }

            Button {
                text: "Circle"
                onClicked: morphRect.state = "circle"
                highlighted: morphRect.state === "circle"
            }

            Button {
                text: "Wide"
                onClicked: morphRect.state = "wide"
                highlighted: morphRect.state === "wide"
            }
        }

        Label {
            text: "States define property sets. Transitions animate between them automatically"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
