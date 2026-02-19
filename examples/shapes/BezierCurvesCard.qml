// ============================================================================
// BezierCurvesCard.qml
// Demuestra curvas Bezier interactivas usando QtQuick.Shapes.
//
// CONCEPTO CLAVE: Las curvas Bezier son la base de todo dibujo vectorial
// (SVG, fuentes TrueType, herramientas como Figma/Illustrator). Se definen
// por puntos de anclaje (inicio/fin) y puntos de control que "jalan" la
// curva hacia ellos sin que la curva pase por esos puntos.
//
// TIPOS DE CURVAS BEZIER EN QT:
//   - PathQuad: curva cuadratica con 1 punto de control. Mas simple pero
//     limitada: no puede hacer curvas en "S".
//   - PathCubic: curva cubica con 2 puntos de control. Mas versatil, puede
//     crear cualquier forma suave incluyendo curvas en "S".
//
// Shape vs Canvas: Shape usa el pipeline de renderizado vectorial de Qt
// (acelerado por GPU), mientras que Canvas rasteriza en CPU. Shape es mejor
// para formas que se animan frecuentemente porque Qt puede optimizar el
// renderizado sin redibujar toda la superficie.
//
// DragHandler: handler declarativo de Qt 6 para arrastrar elementos.
// A diferencia de MouseArea + drag, DragHandler es mas limpio, soporta
// multi-touch, y se puede limitar por ejes con xAxis/yAxis.
// ============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(8)

        Label {
            text: "Bezier Curves"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // =============================================
            // PathQuad: curva cuadratica (1 punto de control)
            // La curva se "jala" hacia el punto de control unico.
            // Matematicamente: B(t) = (1-t)^2*P0 + 2(1-t)t*CP + t^2*P1
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Calcula un tamano cuadrado que quepa en el espacio disponible
                property real bSize: Math.min(width, height - Style.resize(20))

                Item {
                    id: quadArea
                    width: parent.bSize
                    height: parent.bSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    Rectangle {
                        anchors.fill: parent
                        color: Style.surfaceColor
                        radius: Style.resize(6)
                        border.color: "#3A3D45"
                        border.width: 1
                    }

                    // Canvas auxiliar para dibujar las lineas guia discontinuas
                    // que conectan los puntos de anclaje con el punto de control.
                    // Estas guias ayudan a visualizar como el punto de control
                    // influye en la forma de la curva.
                    Canvas {
                        id: quadGuides
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()
                            var pad = Style.resize(15)
                            ctx.setLineDash([4, 4])
                            ctx.strokeStyle = "#bbb"
                            ctx.lineWidth = 1
                            ctx.beginPath()
                            ctx.moveTo(pad, quadArea.height - pad)
                            ctx.lineTo(quadCp.x + quadCp.width/2, quadCp.y + quadCp.height/2)
                            ctx.lineTo(quadArea.width - pad, quadArea.height - pad)
                            ctx.stroke()
                        }
                    }

                    // Shape + ShapePath: renderizado vectorial declarativo.
                    // ShapePath define un camino con punto de inicio (startX/Y)
                    // y segmentos (PathQuad, PathLine, PathCubic, PathArc...).
                    // fillColor con alfa bajo crea un relleno semitransparente.
                    Shape {
                        anchors.fill: parent
                        ShapePath {
                            strokeWidth: Style.resize(3)
                            strokeColor: Style.mainColor
                            fillColor: Qt.rgba(Style.mainColor.r,
                                               Style.mainColor.g,
                                               Style.mainColor.b, 0.08)
                            property real pad: Style.resize(15)
                            startX: pad
                            startY: quadArea.height - pad

                            // PathQuad: controlX/Y define el unico punto de control.
                            // x/y es el punto final de la curva.
                            PathQuad {
                                x: quadArea.width - Style.resize(15)
                                y: quadArea.height - Style.resize(15)
                                controlX: quadCp.x + quadCp.width / 2
                                controlY: quadCp.y + quadCp.height / 2
                            }
                        }
                    }

                    // Puntos de anclaje (inicio y fin) - circulos semitransparentes
                    Rectangle {
                        x: Style.resize(15) - width/2
                        y: quadArea.height - Style.resize(15) - height/2
                        width: Style.resize(10); height: width; radius: width/2
                        color: Style.mainColor; opacity: 0.5
                    }
                    Rectangle {
                        x: quadArea.width - Style.resize(15) - width/2
                        y: quadArea.height - Style.resize(15) - height/2
                        width: Style.resize(10); height: width; radius: width/2
                        color: Style.mainColor; opacity: 0.5
                    }

                    // Punto de control arrastrable.
                    // DragHandler permite arrastrarlo dentro del area delimitada.
                    // Al cambiar x/y, se actualizan las guias (Canvas) y la curva
                    // (Shape) automaticamente gracias a los bindings de QML.
                    Rectangle {
                        id: quadCp
                        x: quadArea.width / 2 - width / 2
                        y: Style.resize(20)
                        width: Style.resize(20); height: width
                        radius: width / 2
                        color: "#FF5900"
                        border.color: "white"; border.width: 2

                        DragHandler {
                            xAxis.minimum: 0
                            xAxis.maximum: quadArea.width - quadCp.width
                            yAxis.minimum: 0
                            yAxis.maximum: quadArea.height - quadCp.height
                        }

                        // Solicitar repintado del Canvas de guias cuando se mueve
                        onXChanged: quadGuides.requestPaint()
                        onYChanged: quadGuides.requestPaint()
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PathQuad — drag the point"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // =============================================
            // PathCubic: curva cubica (2 puntos de control)
            // Con dos puntos de control se pueden crear formas mas complejas,
            // incluyendo curvas en "S" y bucles.
            // Matematicamente: B(t) = (1-t)^3*P0 + 3(1-t)^2*t*CP1
            //                         + 3(1-t)*t^2*CP2 + t^3*P1
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                property real bSize: Math.min(width, height - Style.resize(20))

                Item {
                    id: cubicArea
                    width: parent.bSize
                    height: parent.bSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    Rectangle {
                        anchors.fill: parent
                        color: Style.surfaceColor
                        radius: Style.resize(6)
                        border.color: "#3A3D45"
                        border.width: 1
                    }

                    // Guias para ambos puntos de control:
                    // - Linea del punto de inicio al punto de control 1 (CP1)
                    // - Linea del punto final al punto de control 2 (CP2)
                    Canvas {
                        id: cubicGuides
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()
                            var pad = Style.resize(15)
                            ctx.setLineDash([4, 4])
                            ctx.strokeStyle = "#bbb"
                            ctx.lineWidth = 1
                            // Guia: inicio -> CP1
                            ctx.beginPath()
                            ctx.moveTo(pad, cubicArea.height - pad)
                            ctx.lineTo(cubicCp1.x + cubicCp1.width/2, cubicCp1.y + cubicCp1.height/2)
                            ctx.stroke()
                            // Guia: fin -> CP2
                            ctx.beginPath()
                            ctx.moveTo(cubicArea.width - pad, cubicArea.height - pad)
                            ctx.lineTo(cubicCp2.x + cubicCp2.width/2, cubicCp2.y + cubicCp2.height/2)
                            ctx.stroke()
                        }
                    }

                    Shape {
                        anchors.fill: parent
                        ShapePath {
                            strokeWidth: Style.resize(3)
                            strokeColor: "#7C4DFF"
                            fillColor: Qt.rgba(0.49, 0.30, 1, 0.08)
                            property real pad: Style.resize(15)
                            startX: pad
                            startY: cubicArea.height - pad

                            // PathCubic: usa control1X/Y y control2X/Y para los
                            // dos puntos de control. CP1 influye en la salida
                            // desde el punto de inicio, CP2 en la llegada al final.
                            PathCubic {
                                x: cubicArea.width - Style.resize(15)
                                y: cubicArea.height - Style.resize(15)
                                control1X: cubicCp1.x + cubicCp1.width / 2
                                control1Y: cubicCp1.y + cubicCp1.height / 2
                                control2X: cubicCp2.x + cubicCp2.width / 2
                                control2Y: cubicCp2.y + cubicCp2.height / 2
                            }
                        }
                    }

                    // Puntos de anclaje (inicio y fin)
                    Rectangle {
                        x: Style.resize(15) - width/2
                        y: cubicArea.height - Style.resize(15) - height/2
                        width: Style.resize(10); height: width; radius: width/2
                        color: "#7C4DFF"; opacity: 0.5
                    }
                    Rectangle {
                        x: cubicArea.width - Style.resize(15) - width/2
                        y: cubicArea.height - Style.resize(15) - height/2
                        width: Style.resize(10); height: width; radius: width/2
                        color: "#7C4DFF"; opacity: 0.5
                    }

                    // Punto de control 1 (naranja) - controla la curvatura
                    // cerca del punto de inicio
                    Rectangle {
                        id: cubicCp1
                        x: cubicArea.width * 0.25 - width / 2
                        y: Style.resize(15)
                        width: Style.resize(20); height: width
                        radius: width / 2
                        color: "#FF5900"
                        border.color: "white"; border.width: 2
                        DragHandler {
                            xAxis.minimum: 0; xAxis.maximum: cubicArea.width - cubicCp1.width
                            yAxis.minimum: 0; yAxis.maximum: cubicArea.height - cubicCp1.height
                        }
                        onXChanged: cubicGuides.requestPaint()
                        onYChanged: cubicGuides.requestPaint()
                    }

                    // Punto de control 2 (azul) - controla la curvatura
                    // cerca del punto final
                    Rectangle {
                        id: cubicCp2
                        x: cubicArea.width * 0.75 - width / 2
                        y: Style.resize(15)
                        width: Style.resize(20); height: width
                        radius: width / 2
                        color: "#2196F3"
                        border.color: "white"; border.width: 2
                        DragHandler {
                            xAxis.minimum: 0; xAxis.maximum: cubicArea.width - cubicCp2.width
                            yAxis.minimum: 0; yAxis.maximum: cubicArea.height - cubicCp2.height
                        }
                        onXChanged: cubicGuides.requestPaint()
                        onYChanged: cubicGuides.requestPaint()
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PathCubic — 2 control points"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
