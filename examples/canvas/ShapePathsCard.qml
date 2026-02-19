// =============================================================================
// ShapePathsCard.qml — Formas vectoriales declarativas con Shape y ShapePath
// =============================================================================
// Demuestra el modulo QtQuick.Shapes, la alternativa DECLARATIVA a Canvas
// para dibujar graficos vectoriales en QML.
//
// SHAPE vs CANVAS:
//   - Shape se define declarativamente (como cualquier Item QML), se renderiza
//     con GPU, y se puede animar con las herramientas estandar de QML.
//   - Canvas es imperativo (codigo JS en onPaint), mas flexible pero mas
//     costoso y sin aceleracion GPU por defecto.
//   Para formas estaticas o animaciones simples, Shape es preferible.
//
// ELEMENTOS DE TRAZADO (Path elements):
//   - PathLine: segmento recto entre dos puntos. Basico para poligonos.
//   - PathArc: arco de elipse definido por punto destino y radios.
//     useLargeArc controla si se dibuja el arco mayor o menor.
//   - PathQuad: curva cuadratica de Bezier con un punto de control.
//     Ideal para formas organicas (corazones, hojas, ondas).
//
// ShapePath define el trazo completo: strokeWidth/strokeColor para el borde,
// fillColor para el relleno (sufijo hex "30" = ~19% alpha para transparencia).
// startX/startY establece el punto inicial del trazado.
//
// Las cuatro figuras (triangulo, estrella, rectangulo redondeado, corazon)
// muestran progresivamente elementos mas complejos de trazado.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Shape & Paths"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Area de formas: cuatro columnas con Shape + PathElements distintos
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(10)

                // Triangulo: tres PathLine forman un poligono cerrado.
                // El ultimo PathLine vuelve al punto de inicio para cerrar la forma.
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(80)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#4A90D9"
                                fillColor: "#4A90D930"
                                startX: 40; startY: 5

                                PathLine { x: 75; y: 70 }
                                PathLine { x: 5; y: 70 }
                                PathLine { x: 40; y: 5 }
                            }
                        }
                    }

                    Label {
                        text: "Triangle"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Estrella de 5 puntas: 10 PathLine alternando entre puntos
                // exteriores e interiores. Las coordenadas estan precalculadas
                // para simplificar el codigo (vs calcularlas con trigonometria).
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(80)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#FEA601"
                                fillColor: "#FEA60130"
                                // 5-pointed star
                                startX: 40; startY: 2

                                PathLine { x: 49; y: 28 }
                                PathLine { x: 77; y: 28 }
                                PathLine { x: 54; y: 46 }
                                PathLine { x: 63; y: 74 }
                                PathLine { x: 40; y: 56 }
                                PathLine { x: 17; y: 74 }
                                PathLine { x: 26; y: 46 }
                                PathLine { x: 3; y: 28 }
                                PathLine { x: 31; y: 28 }
                                PathLine { x: 40; y: 2 }
                            }
                        }
                    }

                    Label {
                        text: "Star"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Rectangulo redondeado con PathArc: demuestra como combinar
                // PathLine (lados rectos) con PathArc (esquinas curvas).
                // Cada arco tiene radiusX/radiusY de 10, creando esquinas suaves.
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(80)
                            height: Style.resize(60)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#00D1A9"
                                fillColor: "#00D1A930"

                                startX: 10; startY: 0

                                PathLine { x: 70; y: 0 }
                                PathArc { x: 80; y: 10; radiusX: 10; radiusY: 10 }
                                PathLine { x: 80; y: 50 }
                                PathArc { x: 70; y: 60; radiusX: 10; radiusY: 10 }
                                PathLine { x: 10; y: 60 }
                                PathArc { x: 0; y: 50; radiusX: 10; radiusY: 10 }
                                PathLine { x: 0; y: 10 }
                                PathArc { x: 10; y: 0; radiusX: 10; radiusY: 10 }
                            }
                        }
                    }

                    Label {
                        text: "Rounded Rect"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Corazon con PathQuad: 4 curvas cuadraticas de Bezier.
                // Cada PathQuad tiene un punto de control (controlX/controlY)
                // que "atrae" la curva. Los puntos de control en las esquinas
                // exteriores crean los lobulos superiores del corazon.
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Shape {
                            anchors.centerIn: parent
                            width: Style.resize(70)
                            height: Style.resize(70)

                            ShapePath {
                                strokeWidth: 2
                                strokeColor: "#E74C3C"
                                fillColor: "#E74C3C30"

                                startX: 35; startY: 60

                                PathQuad { x: 0; y: 25; controlX: 0; controlY: 60 }
                                PathQuad { x: 35; y: 15; controlX: 0; controlY: 0 }
                                PathQuad { x: 70; y: 25; controlX: 70; controlY: 0 }
                                PathQuad { x: 35; y: 60; controlX: 70; controlY: 60 }
                            }
                        }
                    }

                    Label {
                        text: "Heart"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Label {
            text: "Declarative Shape with PathLine, PathArc, and PathQuad elements"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
