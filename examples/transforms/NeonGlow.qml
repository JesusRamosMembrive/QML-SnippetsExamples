// =============================================================================
// NeonGlow.qml — Texto neon pulsante con efecto Glow de GraphicalEffects
// =============================================================================
// Simula letreros de neon pulsantes usando el efecto Glow del modulo
// Qt5Compat.GraphicalEffects. Tres "carteles" con colores diferentes
// (rosa, cyan, verde) pulsan con desfase temporal, creando un efecto
// de secuencia como carteles de neon reales que parpadean alternadamente.
//
// EFECTO GLOW:
//   - 'source': el item al que se aplica el resplandor (Label con texto).
//   - 'radius': tamano del halo. Se anima con sin() para el efecto pulsante.
//     Rango: 6 (minimo, casi sin halo) a 18 (maximo, halo extendido).
//   - 'samples': calidad del desenfoque del halo (25 es suficiente).
//   - 'color': color del halo, igual al color del texto para efecto neon.
//
// PATRON SOURCE INVISIBLE:
//   El Label fuente tiene 'visible: false' porque Glow lo renderiza por
//   completo (texto + halo). Si el Label fuera visible, se dibujaria dos
//   veces (una el Label, otra el Glow), causando un texto mas brillante
//   de lo esperado. Este patron es comun en todos los GraphicalEffects.
//
// DESFASE TEMPORAL: cada cartel usa sin(time + offset) con offsets
// diferentes (0, 2.1, 4.2 radianes). Esto hace que los picos de brillo
// no coincidan, creando un efecto de "ola" entre los tres carteles.
// Math.max(0, sin(...)) recorta la parte negativa para que el radio
// minimo sea 6 (nunca negativo), creando un "apagado" parcial.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool neonActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "4. Neon Glow"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.neonActive ? "Pause" : "Start"
            onClicked: root.neonActive = !root.neonActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(130)
        color: "#0A0A14"
        radius: Style.resize(6)

        Item {
            id: neonContainer
            anchors.fill: parent

            property real neonTime: 0

            Timer {
                interval: 50
                repeat: true
                running: root.active && root.neonActive
                onTriggered: neonContainer.neonTime += 0.06
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: Style.resize(40)

                // Sign 1: NEON
                Item {
                    Layout.preferredWidth: Style.resize(110)
                    Layout.preferredHeight: Style.resize(60)

                    Label {
                        id: neon1Label
                        anchors.centerIn: parent
                        text: "NEON"
                        font.pixelSize: Style.resize(32)
                        font.bold: true
                        color: "#FF1493"
                        visible: false
                    }

                    Glow {
                        anchors.fill: neon1Label
                        source: neon1Label
                        radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime))
                        samples: 25
                        color: "#FF1493"
                    }
                }

                // Sign 2: GLOW
                Item {
                    Layout.preferredWidth: Style.resize(110)
                    Layout.preferredHeight: Style.resize(60)

                    Label {
                        id: neon2Label
                        anchors.centerIn: parent
                        text: "GLOW"
                        font.pixelSize: Style.resize(32)
                        font.bold: true
                        color: "#00BFFF"
                        visible: false
                    }

                    Glow {
                        anchors.fill: neon2Label
                        source: neon2Label
                        radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime + 2.1))
                        samples: 25
                        color: "#00BFFF"
                    }
                }

                // Sign 3: QML
                Item {
                    Layout.preferredWidth: Style.resize(110)
                    Layout.preferredHeight: Style.resize(60)

                    Label {
                        id: neon3Label
                        anchors.centerIn: parent
                        text: "QML"
                        font.pixelSize: Style.resize(32)
                        font.bold: true
                        color: "#39FF14"
                        visible: false
                    }

                    Glow {
                        anchors.fill: neon3Label
                        source: neon3Label
                        radius: 6 + 12 * Math.max(0, Math.sin(neonContainer.neonTime + 4.2))
                        samples: 25
                        color: "#39FF14"
                    }
                }
            }
        }
    }
}
