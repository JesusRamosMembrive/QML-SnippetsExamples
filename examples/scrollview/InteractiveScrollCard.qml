// =============================================================================
// InteractiveScrollCard.qml — Scroll programático y carga dinámica
// =============================================================================
// Demuestra dos patrones avanzados de scroll:
// 1. Navegación programática: botones que mueven la vista al inicio/fin
//    usando positionViewAtBeginning() y positionViewAtEnd() de ListView
// 2. "Infinite scroll" (carga incremental): al llegar al final de la lista
//    se agregan más elementos automáticamente (patrón común en apps móviles)
//
// Usa ListView en vez de ScrollView porque ListView virtualiza los delegates:
// solo crea instancias para los elementos visibles, lo que es mucho más
// eficiente con listas largas que un Repeater dentro de ScrollView.
//
// Aprendizaje clave:
// - onAtYEndChanged detecta cuándo el usuario llega al final de la lista
// - positionViewAtBeginning/End() permite navegación programática
// - ListView es preferible a ScrollView+Repeater para listas de datos
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Propiedad reactiva: al cambiar itemCount, ListView actualiza
    // automáticamente su modelo y muestra los nuevos elementos.
    property int itemCount: 10

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Scroll-to & Load More"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Barra de controles: botones de navegación programática y contador
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "\u2191 Top"
                onClicked: scrollListView.positionViewAtBeginning()
            }
            Button {
                text: "\u2193 Bottom"
                onClicked: scrollListView.positionViewAtEnd()
            }

            // Item vacío como espaciador flexible (empuja el Label a la derecha)
            Item { Layout.fillWidth: true }

            Label {
                text: root.itemCount + " items"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // ListView con virtualización: a diferencia de Repeater (que crea
            // todos los elementos), ListView solo instancia los delegates
            // visibles en pantalla, reciclándolos al hacer scroll.
            ListView {
                id: scrollListView
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: root.itemCount
                spacing: Style.resize(4)
                clip: true

                delegate: Rectangle {
                    required property int index
                    width: scrollListView.width
                    height: Style.resize(36)
                    radius: Style.resize(4)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(10)
                        anchors.rightMargin: Style.resize(10)

                        // Círculo con número: radio = mitad del tamaño
                        // para crear un círculo perfecto
                        Rectangle {
                            width: Style.resize(24)
                            height: Style.resize(24)
                            radius: Style.resize(12)
                            color: Qt.hsla(index * 0.08, 0.6, 0.5, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                font.pixelSize: Style.resize(10)
                                color: "#FFFFFF"
                            }
                        }

                        Label {
                            text: "Item " + (index + 1)
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }
                    }
                }

                // Patrón "infinite scroll": atYEnd se vuelve true cuando
                // el usuario llega al final. Agregamos 5 elementos más
                // hasta un máximo de 50 para evitar crecimiento infinito.
                onAtYEndChanged: {
                    if (atYEnd && root.itemCount < 50) {
                        root.itemCount += 5
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AsNeeded
                }
            }

            // Indicador flotante de "carga": se posiciona con anchors sobre
            // el ListView (no dentro de él) para que no se desplace con el
            // contenido. Desaparece al alcanzar el límite de 50 items.
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: Style.resize(8)
                width: Style.resize(120)
                height: Style.resize(28)
                radius: Style.resize(14)
                color: Style.cardColor
                visible: root.itemCount < 50

                Label {
                    anchors.centerIn: parent
                    text: "Scroll for more..."
                    font.pixelSize: Style.resize(11)
                    color: Style.mainColor
                }
            }
        }
    }
}
