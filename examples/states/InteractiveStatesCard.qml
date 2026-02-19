// =============================================================================
// InteractiveStatesCard.qml — Estados reactivos con clausula 'when'
// =============================================================================
// Demuestra la clausula 'when' en State: en vez de asignar el estado
// manualmente (state = "foo"), cada State define una condicion booleana
// en 'when'. QML activa automaticamente el estado cuya condicion sea true.
//
// Esto es ideal para UIs que reaccionan a datos del modelo (conexion,
// carga, error) sin logica imperativa. El estado se "autodetermina"
// segun las propiedades isConnected, isLoading, hasError.
//
// Ademas se incluye un RotationAnimation "on rotation" que actua como
// spinner de carga, y un Timer que simula una conexion de red con 70%
// de exito y 30% de fallo (Math.random).
//
// Patron clave: los Switches permiten manipular las propiedades directamente
// para experimentar como 'when' reacciona a combinaciones de flags.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Tres propiedades booleanas que actuan como "modelo de datos".
    // Los estados reaccionan a estas mediante 'when'.
    property bool isConnected: false
    property bool isLoading: false
    property bool hasError: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Connection Status"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "States driven by 'when' conditions"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: statusCard
                anchors.centerIn: parent
                width: Style.resize(200)
                height: Style.resize(160)
                radius: Style.resize(16)
                color: Style.surfaceColor
                border.width: Style.resize(2)
                border.color: "#3A3D45"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)

                    // Icono de estado: cambia color y simbolo segun el estado
                    Rectangle {
                        id: statusIcon
                        width: Style.resize(50)
                        height: Style.resize(50)
                        radius: Style.resize(25)
                        color: "#3A3D45"
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            id: iconLabel
                            anchors.centerIn: parent
                            text: "\u25CB"
                            font.pixelSize: Style.resize(24)
                            color: "#FFFFFF"
                        }

                        // RotationAnimation "on rotation": se aplica directamente
                        // a la propiedad rotation. 'running' controla si gira.
                        // Solo gira durante el estado "loading".
                        RotationAnimation on rotation {
                            running: root.isLoading
                            from: 0; to: 360
                            duration: 1000
                            loops: Animation.Infinite
                        }
                    }

                    Label {
                        id: statusText
                        text: "Disconnected"
                        font.pixelSize: Style.resize(16)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        id: statusDesc
                        text: "Tap Connect to start"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // ---------------------------------------------------------
                // Estados con 'when': QML evalua las condiciones y activa
                // automaticamente el estado cuya expresion 'when' sea true.
                // Si varias son true, gana la primera en la lista.
                // Cada estado modifica multiples targets con PropertyChanges.
                // ---------------------------------------------------------
                states: [
                    State {
                        name: "disconnected"
                        when: !root.isConnected && !root.isLoading && !root.hasError
                        PropertyChanges { target: statusCard; border.color: "#3A3D45" }
                        PropertyChanges { target: statusIcon; color: "#3A3D45"; rotation: 0 }
                        PropertyChanges { target: iconLabel; text: "\u25CB" }
                        PropertyChanges { target: statusText; text: "Disconnected" }
                        PropertyChanges { target: statusDesc; text: "Tap Connect to start" }
                    },
                    State {
                        name: "loading"
                        when: root.isLoading
                        PropertyChanges { target: statusCard; border.color: "#FEA601" }
                        PropertyChanges { target: statusIcon; color: "#FEA601" }
                        PropertyChanges { target: iconLabel; text: "\u21BB" }
                        PropertyChanges { target: statusText; text: "Connecting..." }
                        PropertyChanges { target: statusDesc; text: "Please wait" }
                    },
                    State {
                        name: "connected"
                        when: root.isConnected && !root.isLoading && !root.hasError
                        PropertyChanges { target: statusCard; border.color: "#00D1A9" }
                        PropertyChanges { target: statusIcon; color: "#00D1A9"; rotation: 0 }
                        PropertyChanges { target: iconLabel; text: "\u2713" }
                        PropertyChanges { target: statusText; text: "Connected" }
                        PropertyChanges { target: statusDesc; text: "All systems operational" }
                    },
                    State {
                        name: "error"
                        when: root.hasError
                        PropertyChanges { target: statusCard; border.color: "#FF3B30" }
                        PropertyChanges { target: statusIcon; color: "#FF3B30"; rotation: 0 }
                        PropertyChanges { target: iconLabel; text: "\u2715" }
                        PropertyChanges { target: statusText; text: "Error" }
                        PropertyChanges { target: statusDesc; text: "Connection failed" }
                    }
                ]

                transitions: Transition {
                    ColorAnimation { duration: 300 }
                }
            }
        }

        // -----------------------------------------------------------------
        // Panel de control: Switches para manipular las propiedades
        // directamente. Permite experimentar con combinaciones de flags
        // y ver como 'when' reacciona en tiempo real.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            implicitHeight: propsCol.implicitHeight + Style.resize(16)

            ColumnLayout {
                id: propsCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(8)
                spacing: Style.resize(4)

                Label {
                    text: "Properties (drive states via 'when'):"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }

                RowLayout {
                    Layout.fillWidth: true
                    Switch { text: "isLoading"; font.pixelSize: Style.resize(11); checked: root.isLoading; onToggled: root.isLoading = checked }
                    Switch { text: "isConnected"; font.pixelSize: Style.resize(11); checked: root.isConnected; onToggled: root.isConnected = checked }
                    Switch { text: "hasError"; font.pixelSize: Style.resize(11); checked: root.hasError; onToggled: root.hasError = checked }
                }
            }
        }

        // Boton de simulacion: activa isLoading, y tras 1.5s el Timer
        // decide aleatoriamente si la "conexion" fue exitosa (70%) o fallo (30%).
        // Esto demuestra como los estados con 'when' reaccionan automaticamente
        // a cambios de propiedades sin necesidad de asignar el estado manualmente.
        Button {
            text: "Simulate Connection"
            Layout.fillWidth: true
            onClicked: {
                root.isLoading = true
                root.isConnected = false
                root.hasError = false
                connectTimer.start()
            }

            Timer {
                id: connectTimer
                interval: 1500
                onTriggered: {
                    root.isLoading = false
                    if (Math.random() > 0.3) {
                        root.isConnected = true
                    } else {
                        root.hasError = true
                    }
                }
            }
        }

        Label {
            text: "Active state: \"" + statusCard.state + "\""
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
