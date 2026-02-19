// =============================================================================
// CustomScrollBarCard.qml — ScrollBar personalizado con Flickable
// =============================================================================
// Demuestra cómo crear una barra de scroll completamente personalizada usando
// Flickable + ScrollBar independiente, en lugar del ScrollView con barras
// automáticas. Este enfoque da control total sobre la apariencia y el
// comportamiento del indicador de scroll.
//
// Patrón importante: Flickable maneja la física del desplazamiento (inercia,
// rebote, velocidad), mientras que ScrollBar es solo un control visual que
// se sincroniza bidireccionalmente con el Flickable.
//
// Aprendizaje clave:
// - Flickable requiere contentHeight explícito (no lo calcula automáticamente)
// - ScrollBar.size y .position se vinculan a visibleArea del Flickable
// - contentItem y background permiten reemplazar completamente la apariencia
// - Los estados pressed/hovered permiten retroalimentación visual interactiva
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
        spacing: Style.resize(15)

        Label {
            text: "Custom ScrollBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Styled scrollbar with position indicator"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // Flickable en vez de ScrollView: esto nos permite colocar un
            // ScrollBar personalizado fuera del Flickable. El margen derecho
            // reserva espacio para la barra de scroll custom.
            Flickable {
                id: customFlickable
                anchors.fill: parent
                anchors.rightMargin: Style.resize(14)
                anchors.margins: Style.resize(8)
                contentHeight: contentCol.implicitHeight
                clip: true

                ColumnLayout {
                    id: contentCol
                    width: parent.width
                    spacing: Style.resize(8)

                    // Cada fila simula una entrada de datos con una barra de
                    // progreso visual. Math.random() genera variedad visual
                    // (nota: se evalúa una sola vez al crear el componente).
                    Repeater {
                        model: 30
                        Rectangle {
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(28)
                            radius: Style.resize(4)
                            color: Style.surfaceColor

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                anchors.rightMargin: Style.resize(8)

                                Label {
                                    text: "\u2022 Entry " + (index + 1)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                                Rectangle {
                                    width: Style.resize(40 + Math.random() * 60)
                                    height: Style.resize(6)
                                    radius: Style.resize(3)
                                    color: Style.mainColor
                                    opacity: 0.3 + Math.random() * 0.7
                                }
                            }
                        }
                    }
                }
            }

            // ScrollBar personalizado: se posiciona manualmente con anchors
            // en lugar de usar ScrollBar.vertical (que usaría el estilo por
            // defecto). La sincronización bidireccional se logra así:
            // - size/position leen del Flickable (Flickable -> ScrollBar)
            // - onPositionChanged escribe al Flickable (ScrollBar -> Flickable)
            ScrollBar {
                id: customScrollBar
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: Style.resize(2)
                active: true
                policy: ScrollBar.AlwaysOn
                size: customFlickable.visibleArea.heightRatio
                position: customFlickable.visibleArea.yPosition

                // contentItem: el "thumb" (indicador arrastrable). Cambia de
                // color según el estado de interacción para dar feedback visual.
                contentItem: Rectangle {
                    implicitWidth: Style.resize(8)
                    radius: Style.resize(4)
                    color: customScrollBar.pressed ? Style.mainColor
                         : customScrollBar.hovered ? Qt.lighter(Style.mainColor, 1.4)
                         : Style.inactiveColor
                    opacity: customScrollBar.pressed ? 1.0 : 0.7

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // background: la pista (track) sobre la que se mueve el thumb
                background: Rectangle {
                    implicitWidth: Style.resize(8)
                    radius: Style.resize(4)
                    color: Style.bgColor
                    opacity: 0.3
                }

                // Sincronización inversa: cuando el usuario arrastra el
                // ScrollBar, actualizamos la posición del Flickable.
                onPositionChanged: customFlickable.contentY = position * customFlickable.contentHeight
            }
        }

        // Indicador de posición en texto: muestra el porcentaje de scroll
        // actual usando visibleArea.yPosition del Flickable.
        Label {
            text: "Position: " + (customFlickable.visibleArea.yPosition * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
        }
    }
}
