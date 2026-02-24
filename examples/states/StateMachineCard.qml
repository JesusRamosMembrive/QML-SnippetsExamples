// =============================================================================
// StateMachineCard.qml — Maquina de estados: semaforo con Timer
// =============================================================================
// Simula un semaforo como ejemplo clasico de maquina de estados finitos.
// Tres estados (red, yellow, green) ciclan automaticamente con un Timer,
// o se pueden activar manualmente con botones.
//
// Conceptos clave:
// - Los estados aqui no usan PropertyChanges; en su lugar, cada luz
//   (Rectangle) usa expresiones ternarias que reaccionan a lightBody.state.
//   Ambos enfoques son validos; este es mas conciso para cambios de color simples.
// - Behavior on color anima el cambio de color de cada luz individualmente.
// - El Timer tiene interval dinamico: amarillo dura menos que rojo/verde,
//   simulando un semaforo real. QML re-evalua 'interval' automaticamente
//   cuando cambia lightBody.state gracias al binding.
// - enabled: !root.autoMode desactiva los botones manuales cuando el
//   ciclo automatico esta activo, evitando conflictos.
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

    property bool autoMode: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Traffic Light"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Cuerpo del semaforo: contiene las tres luces en un ColumnLayout
            Rectangle {
                id: lightBody
                anchors.centerIn: parent
                width: Style.resize(80)
                height: Style.resize(220)
                radius: Style.resize(12)
                color: "#2A2D35"
                border.color: "#3A3D45"
                border.width: Style.resize(2)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(12)

                    // Cada luz usa un ternario para decidir su color:
                    // si el estado coincide, color brillante; si no, color apagado.
                    // Behavior on color anima la transicion suavemente.
                    Rectangle {
                        id: redLight
                        width: Style.resize(50)
                        height: Style.resize(50)
                        radius: Style.resize(25)
                        color: lightBody.state === "red" || lightBody.state === "" ? "#FF3B30" : "#4A1A17"
                        border.color: "#5A2A27"
                        border.width: Style.resize(2)
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    Rectangle {
                        id: yellowLight
                        width: Style.resize(50)
                        height: Style.resize(50)
                        radius: Style.resize(25)
                        color: lightBody.state === "yellow" ? "#FFCC00" : "#4A4017"
                        border.color: "#5A5027"
                        border.width: Style.resize(2)
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    Rectangle {
                        id: greenLight
                        width: Style.resize(50)
                        height: Style.resize(50)
                        radius: Style.resize(25)
                        color: lightBody.state === "green" ? "#34C759" : "#17402A"
                        border.color: "#27503A"
                        border.width: Style.resize(2)
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }

                // Estados minimos: solo definen el nombre, sin PropertyChanges.
                // El color de cada luz se calcula por binding, no por estado.
                states: [
                    State { name: "red" },
                    State { name: "yellow" },
                    State { name: "green" }
                ]

                state: "red"
            }

            // Etiqueta que refleja el estado activo con color correspondiente
            Label {
                anchors.top: lightBody.bottom
                anchors.topMargin: Style.resize(10)
                anchors.horizontalCenter: lightBody.horizontalCenter
                text: (lightBody.state || "red").toUpperCase()
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: lightBody.state === "red" ? "#FF3B30"
                     : lightBody.state === "yellow" ? "#FFCC00"
                     : "#34C759"
            }
        }

        // -----------------------------------------------------------------
        // Timer automatico: simula el ciclo real de un semaforo.
        // 'interval' usa un binding: 1500ms para amarillo, 3000ms para los demas.
        // QML re-evalua el binding cuando cambia lightBody.state.
        // 'running' esta vinculado a autoMode para activar/desactivar el ciclo.
        // -----------------------------------------------------------------
        Timer {
            id: autoTimer
            interval: lightBody.state === "yellow" ? 1500 : 3000
            repeat: true
            running: root.autoMode
            onTriggered: {
                if (lightBody.state === "red") lightBody.state = "green"
                else if (lightBody.state === "green") lightBody.state = "yellow"
                else lightBody.state = "red"
            }
        }

        // Botones manuales: deshabilitados en modo automatico
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: [
                    { label: "Red", st: "red" },
                    { label: "Yellow", st: "yellow" },
                    { label: "Green", st: "green" }
                ]

                Button {
                    required property var modelData
                    text: modelData.label
                    font.pixelSize: Style.resize(11)
                    highlighted: lightBody.state === modelData.st
                    enabled: !root.autoMode
                    onClicked: lightBody.state = modelData.st
                    Layout.fillWidth: true
                }
            }
        }

        Switch {
            text: "Auto cycle"
            font.pixelSize: Style.resize(12)
            checked: root.autoMode
            onToggled: root.autoMode = checked
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
