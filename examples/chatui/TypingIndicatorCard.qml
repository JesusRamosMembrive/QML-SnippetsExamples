// =============================================================================
// TypingIndicatorCard.qml — Tarjeta de ejemplo: indicadores de escritura
// =============================================================================
// Presenta 4 estilos distintos de animacion "escribiendo..." usados en apps
// de mensajeria: rebote, desvanecimiento, escalado y barras de onda.
//
// Patrones clave para el aprendiz:
// - SequentialAnimation "on <propiedad>" para animaciones declarativas que
//   se vinculan directamente a una propiedad (y, opacity, scale, height).
// - PauseAnimation con duracion basada en `index` para crear el efecto
//   de onda escalonada (cada punto/barra arranca con un retardo diferente).
// - Repeater + index: el truco `index * N` al inicio y `(max - index) * N`
//   al final mantiene la duracion total constante para todos los elementos,
//   evitando que la animacion se desincronice.
// - Switch para activar/desactivar todas las animaciones a la vez mediante
//   la propiedad `running` vinculada a root.showTyping.
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

    // Controla si las animaciones estan activas. El Switch inferior
    // permite al usuario pausarlas para inspeccionar el estado final.
    property bool showTyping: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Typing Indicators"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(25)

                // ---------------------------------------------------------
                // Estilo 1: Puntos con rebote vertical (Bouncing Dots)
                // Anima la propiedad `y` con easing OutQuad/InQuad para
                // simular un rebote suave. Cada punto empieza con un
                // retardo de index * 150 ms para crear el efecto cascada.
                // ---------------------------------------------------------
                ColumnLayout {
                    spacing: Style.resize(6)
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        text: "Bouncing Dots"
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        width: Style.resize(70)
                        height: Style.resize(36)
                        radius: Style.resize(18)
                        color: "#2A2D35"
                        Layout.alignment: Qt.AlignHCenter

                        Row {
                            anchors.centerIn: parent
                            spacing: Style.resize(6)

                            Repeater {
                                model: 3
                                Rectangle {
                                    required property int index
                                    width: Style.resize(10)
                                    height: Style.resize(10)
                                    radius: Style.resize(5)
                                    color: "#00D1A9"

                                    SequentialAnimation on y {
                                        running: root.showTyping
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 150 }
                                        NumberAnimation { from: 0; to: -Style.resize(6); duration: 300; easing.type: Easing.OutQuad }
                                        NumberAnimation { from: -Style.resize(6); to: 0; duration: 300; easing.type: Easing.InQuad }
                                        PauseAnimation { duration: (2 - index) * 150 + 300 }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------------------------------------------------
                // Estilo 2: Puntos con desvanecimiento (Fading Dots)
                // Anima `opacity` entre 0.3 y 1.0. El efecto visual es
                // mas sutil que el rebote, ideal para interfaces minimalistas.
                // ---------------------------------------------------------
                ColumnLayout {
                    spacing: Style.resize(6)
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        text: "Fading Dots"
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        width: Style.resize(70)
                        height: Style.resize(36)
                        radius: Style.resize(18)
                        color: "#2A2D35"
                        Layout.alignment: Qt.AlignHCenter

                        Row {
                            anchors.centerIn: parent
                            spacing: Style.resize(6)

                            Repeater {
                                model: 3
                                Rectangle {
                                    required property int index
                                    width: Style.resize(10)
                                    height: Style.resize(10)
                                    radius: Style.resize(5)
                                    color: "#FEA601"

                                    SequentialAnimation on opacity {
                                        running: root.showTyping
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 200 }
                                        NumberAnimation { from: 0.3; to: 1.0; duration: 400 }
                                        NumberAnimation { from: 1.0; to: 0.3; duration: 400 }
                                        PauseAnimation { duration: (2 - index) * 200 }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------------------------------------------------
                // Estilo 3: Puntos con escalado (Scaling Dots)
                // Anima `scale` con Easing.OutBack que genera un pequeno
                // "rebote" al agrandar, dando sensacion de elasticidad.
                // ---------------------------------------------------------
                ColumnLayout {
                    spacing: Style.resize(6)
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        text: "Scaling Dots"
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        width: Style.resize(70)
                        height: Style.resize(36)
                        radius: Style.resize(18)
                        color: "#2A2D35"
                        Layout.alignment: Qt.AlignHCenter

                        Row {
                            anchors.centerIn: parent
                            spacing: Style.resize(6)

                            Repeater {
                                model: 3
                                Rectangle {
                                    required property int index
                                    width: Style.resize(10)
                                    height: Style.resize(10)
                                    radius: Style.resize(5)
                                    color: "#AB47BC"

                                    SequentialAnimation on scale {
                                        running: root.showTyping
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 180 }
                                        NumberAnimation { from: 0.5; to: 1.3; duration: 300; easing.type: Easing.OutBack }
                                        NumberAnimation { from: 1.3; to: 0.5; duration: 300; easing.type: Easing.InQuad }
                                        PauseAnimation { duration: (2 - index) * 180 + 200 }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------------------------------------------------
                // Estilo 4: Barras de onda (Wave Bars)
                // Usa 5 rectangulos estrechos que animan su `height` en
                // secuencia. El efecto visual recuerda a un ecualizador
                // de audio o las barras de grabacion de voz.
                // ---------------------------------------------------------
                ColumnLayout {
                    spacing: Style.resize(6)
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        text: "Wave Bars"
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        width: Style.resize(70)
                        height: Style.resize(36)
                        radius: Style.resize(18)
                        color: "#2A2D35"
                        Layout.alignment: Qt.AlignHCenter

                        Row {
                            anchors.centerIn: parent
                            spacing: Style.resize(3)

                            Repeater {
                                model: 5
                                Rectangle {
                                    required property int index
                                    width: Style.resize(4)
                                    height: Style.resize(12)
                                    radius: Style.resize(2)
                                    color: "#4FC3F7"
                                    anchors.verticalCenter: parent.verticalCenter

                                    SequentialAnimation on height {
                                        running: root.showTyping
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 100 }
                                        NumberAnimation { from: Style.resize(6); to: Style.resize(20); duration: 250 }
                                        NumberAnimation { from: Style.resize(20); to: Style.resize(6); duration: 250 }
                                        PauseAnimation { duration: (4 - index) * 100 }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Switch global: al desactivarlo, todas las animaciones se detienen
        // porque cada SequentialAnimation tiene `running: root.showTyping`.
        Switch {
            text: "Animate"
            font.pixelSize: Style.resize(12)
            checked: root.showTyping
            onToggled: root.showTyping = checked
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
