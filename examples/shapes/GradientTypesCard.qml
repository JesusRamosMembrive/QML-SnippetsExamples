// ============================================================================
// GradientTypesCard.qml
// Demuestra los tres tipos de gradiente disponibles en QtQuick.Shapes:
//   - LinearGradient: transicion de colores en linea recta.
//   - RadialGradient: transicion de colores en circulos concentricos.
//   - ConicalGradient: transicion de colores barriendo un angulo (como reloj).
//
// CONCEPTO CLAVE: Los gradientes en Shape se aplican como 'fillGradient' de
// un ShapePath. Son diferentes a los gradientes de Rectangle (que solo soporta
// Gradient lineal vertical). Los gradientes de Shape son mas potentes porque
// soportan direcciones arbitrarias, puntos focales y barrido angular.
//
// GradientStop: define un color en una posicion (0.0 = inicio, 1.0 = fin).
// Se pueden poner multiples stops para crear transiciones multi-color.
// El gradiente interpola suavemente entre los colores de cada stop.
//
// NOTA: Las formas se construyen con PathLine (lineas rectas) y PathArc
// (arcos elipticos). Para un circulo completo se necesitan 2 PathArc
// (semicirculos), ya que un solo arco no puede cubrir 360 grados.
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
            text: "Gradient Types"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // =============================================
            // LinearGradient: transicion en linea recta
            // x1,y1 -> x2,y2 define la DIRECCION del gradiente.
            // Aqui va de esquina superior-izquierda a inferior-derecha (diagonal).
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        startX: 60; startY: 0
                        fillGradient: LinearGradient {
                            // Direccion diagonal: de (0,0) a (120,120)
                            x1: 0; y1: 0
                            x2: 120; y2: 120
                            // Tres paradas de color: teal -> amarillo -> naranja
                            GradientStop { position: 0; color: Style.mainColor }
                            GradientStop { position: 0.5; color: "#FFE361" }
                            GradientStop { position: 1; color: "#FF5900" }
                        }
                        // Hexagono construido con 6 segmentos PathLine.
                        // Cada PathLine define un vertice del poligono.
                        // El camino se cierra automaticamente al volver al startX/Y.
                        PathLine { x: 105; y: 30 }
                        PathLine { x: 105; y: 90 }
                        PathLine { x: 60;  y: 120 }
                        PathLine { x: 15;  y: 90 }
                        PathLine { x: 15;  y: 30 }
                        PathLine { x: 60;  y: 0 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LinearGradient"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // =============================================
            // RadialGradient: transicion en circulos concentricos
            // - centerX/Y, centerRadius: circulo exterior del gradiente.
            // - focalX/Y, focalRadius: punto focal (donde empieza el color).
            //   Mover el punto focal fuera del centro crea un efecto de
            //   iluminacion lateral (como luz sobre una esfera).
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        fillGradient: RadialGradient {
                            centerX: 60; centerY: 60
                            centerRadius: 60
                            // Punto focal desplazado hacia arriba-izquierda
                            // para simular una fuente de luz
                            focalX: 40; focalY: 40
                            focalRadius: 0
                            GradientStop { position: 0; color: "white" }
                            GradientStop { position: 0.4; color: Style.mainColor }
                            GradientStop { position: 1; color: "#1E272E" }
                        }
                        // Circulo usando 2 PathArc (semicirculos).
                        // Cada PathArc cubre 180 grados. Se necesitan dos porque
                        // un solo arco no puede describir un circulo completo
                        // (ambiguedad matematica en arcos >180 grados).
                        startX: 120; startY: 60
                        PathArc {
                            x: 0; y: 60
                            radiusX: 60; radiusY: 60
                        }
                        PathArc {
                            x: 120; y: 60
                            radiusX: 60; radiusY: 60
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "RadialGradient"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // =============================================
            // ConicalGradient: transicion angular (barrido circular)
            // Los colores rotan alrededor del centro como las agujas de un reloj.
            // La propiedad 'angle' define donde empieza el barrido.
            //
            // Aqui se anima el angulo con NumberAnimation para crear un efecto
            // de rotacion continua. 'NumberAnimation on <propiedad>' es la
            // sintaxis para animacion directa sobre una propiedad (animation-on).
            // =============================================
            Item {
                id: conicalItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Propiedad animada: rota el gradiente continuamente.
                // 'Animation.Infinite' hace que se repita indefinidamente.
                property real conicalAngle: 0
                NumberAnimation on conicalAngle {
                    from: 0; to: 360; duration: 4000
                    loops: Animation.Infinite
                }

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(120)
                    height: Style.resize(120)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#666666"
                        fillGradient: ConicalGradient {
                            centerX: 60; centerY: 60
                            angle: conicalItem.conicalAngle
                            // El primer y ultimo color son iguales para que
                            // la transicion sea continua (sin "costura" visible).
                            GradientStop { position: 0;    color: "#FF5900" }
                            GradientStop { position: 0.33; color: "#FFE361" }
                            GradientStop { position: 0.66; color: Style.mainColor }
                            GradientStop { position: 1;    color: "#FF5900" }
                        }
                        // Circulo con 2 semicirculos (mismo patron que RadialGradient)
                        startX: 120; startY: 60
                        PathArc {
                            x: 0; y: 60
                            radiusX: 60; radiusY: 60
                        }
                        PathArc {
                            x: 120; y: 60
                            radiusX: 60; radiusY: 60
                        }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ConicalGradient (animated)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
