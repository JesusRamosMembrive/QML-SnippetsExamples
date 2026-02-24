// =============================================================================
// Carousel3D.qml — Carrusel 3D simulado con trigonometria y z-order
// =============================================================================
// Crea la ilusion de un carrusel 3D usando solo transformaciones 2D.
// 5 tarjetas orbitan en un circulo "visto de lado" (perspectiva).
//
// TECNICA DE PERSPECTIVA FALSA:
//   - Posicion X: Math.sin(angle) * radio. Mueve las tarjetas izquierda-derecha.
//   - Profundidad: Math.cos(angle) normalizado a 0..1. Cuando cos=1 la tarjeta
//     esta "al frente", cuando cos=-1 esta "atras".
//   - La profundidad controla: scale (0.55 a 1.0), opacity (0.3 a 1.0),
//     y posicion Y levemente (tarjetas traseras un poco mas abajo).
//   - CLAVE: 'z: depth * 10' asegura que las tarjetas frontales se dibujen
//     encima de las traseras. Sin esto, el orden de dibujado seria el del
//     Repeater (indice 0,1,2...) y la ilusion 3D se romperia.
//
// REPEATER CON MODELO LITERAL: el model es un array de objetos JS.
// Cada objeto se accede via 'modelData' en el delegate. Los 5 items
// se distribuyen equidistantemente (72 grados = 360/5 entre cada uno).
//
// PATRON ACTIVE/SECTIONACTIVE: Timer solo corre si la pagina esta visible
// (active) Y el usuario ha presionado Start (carouselActive).
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool carouselActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "1. 3D Carousel"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.carouselActive ? "Pause" : "Start"
            onClicked: root.carouselActive = !root.carouselActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: carouselArea
            anchors.fill: parent

            property real carouselAngle: 0

            Timer {
                interval: 50
                repeat: true
                running: root.active && root.carouselActive
                onTriggered: carouselArea.carouselAngle += 0.8
            }

            // Cada tarjeta calcula su posicion orbital usando su indice (idx * 72 grados)
            // mas el angulo global rotante (carouselAngle). La propiedad 'depth'
            // (derivada de cos) determina escala, opacidad y z-order.
            Repeater {
                model: [
                    { color: "#00D1A9", label: "Qt", idx: 0 },
                    { color: "#FF5900", label: "QML", idx: 1 },
                    { color: "#4A90D9", label: "C++", idx: 2 },
                    { color: "#9B59B6", label: "JS", idx: 3 },
                    { color: "#FEA601", label: "UI", idx: 4 }
                ]

                Rectangle {
                    property real itemAngle: (carouselArea.carouselAngle + modelData.idx * 72) * Math.PI / 180
                    property real depth: (Math.cos(itemAngle) + 1) / 2

                    x: carouselArea.width / 2 + Math.sin(itemAngle) * carouselArea.width * 0.28 - width / 2
                    y: carouselArea.height / 2 - height / 2 + (1 - depth) * Style.resize(12)
                    z: depth * 10
                    width: Style.resize(90)
                    height: Style.resize(120)
                    radius: Style.resize(10)
                    color: modelData.color
                    scale: 0.55 + 0.45 * depth
                    opacity: 0.3 + 0.7 * depth

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(6)

                        Label {
                            text: modelData.label
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Card " + (modelData.idx + 1)
                            font.pixelSize: Style.resize(11)
                            color: Qt.rgba(1, 1, 1, 0.7)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
