// =============================================================================
// MatrixShear.qml — Transformacion de cizallamiento (shear) con Matrix4x4
// =============================================================================
// Demuestra la transformacion de cizallamiento (shear/skew) que NO tiene
// propiedad nativa en QML. Para lograrla se usa Matrix4x4, que permite
// definir cualquier transformacion afin arbitraria via una matriz 4x4.
//
// QUE ES SHEAR (CIZALLAMIENTO):
//   Desplaza las coordenadas de un eje proporcionalmente al valor del otro.
//   - Shear X: cada fila se desplaza horizontalmente segun su posicion Y.
//     Resultado: un rectangulo se convierte en un paralelogramo inclinado.
//   - Shear Y: cada columna se desplaza verticalmente segun su posicion X.
//
// LA MATRIZ:
//   | 1      shearX  0  -shearX*h/2 |
//   | shearY  1      0  -shearY*w/2 |
//   | 0       0      1   0          |
//   | 0       0      0   1          |
//
//   Los terminos -shearX*h/2 y -shearY*w/2 son compensaciones para que la
//   transformacion se aplique centrada (sin ellos, el objeto se desplazaria
//   lateralmente ademas de deformarse).
//
// MATRIX4X4 EN QML: es la transformacion mas poderosa disponible. Puede
// expresar cualquier combinacion de rotation + scale + translate + shear
// en una sola operacion. Es util cuando las propiedades individuales de
// QML (rotation, scale) no cubren el efecto deseado.
//
// GHOST OUTLINE: el rectangulo fantasma transparente muestra la posicion
// original del objeto, facilitando visualizar cuanto se ha deformado.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "5. Matrix Shear Transform"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Shear X: " + shearXSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: shearXSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
        }
        ColumnLayout {
            spacing: Style.resize(2)
            Label { text: "Shear Y: " + shearYSlider.value.toFixed(2); font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider { id: shearYSlider; from: -0.5; to: 0.5; value: 0; stepSize: 0.01; Layout.preferredWidth: Style.resize(140); }
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "Reset"
            onClicked: { shearXSlider.value = 0; shearYSlider.value = 0 }
        }
    }

    // Visualizacion de la matriz: muestra los valores actuales de la matriz 2x2
    // relevante (la submatriz superior-izquierda). Fuente monoespaciada para
    // que los numeros se alineen como en una matriz matematica real.
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(36)
        color: Style.bgColor
        radius: Style.resize(4)

        Label {
            anchors.centerIn: parent
            text: "Matrix4x4:  [ 1.00, " + shearXSlider.value.toFixed(2) + " ;  " + shearYSlider.value.toFixed(2) + ", 1.00 ]"
            font.pixelSize: Style.resize(12)
            font.family: "Courier"
            color: Style.mainColor
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        // Grilla de fondo: lineas cada 30px que sirven como referencia visual
        // para apreciar la deformacion del objeto respecto a la cuadricula recta.
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = "#2A2D35"
                ctx.lineWidth = 0.5
                var grid = 30
                for (var gx = 0; gx < width; gx += grid) {
                    ctx.beginPath(); ctx.moveTo(gx, 0); ctx.lineTo(gx, height); ctx.stroke()
                }
                for (var gy = 0; gy < height; gy += grid) {
                    ctx.beginPath(); ctx.moveTo(0, gy); ctx.lineTo(width, gy); ctx.stroke()
                }
            }
        }

        Rectangle {
            id: shearRect
            anchors.centerIn: parent
            width: Style.resize(100)
            height: Style.resize(100)
            radius: Style.resize(8)
            color: "#4A90D9"
            border.color: "#6AB0FF"
            border.width: 2

            transform: Matrix4x4 {
                matrix: Qt.matrix4x4(
                    1,                  shearXSlider.value, 0, -shearXSlider.value * shearRect.height / 2,
                    shearYSlider.value, 1,                  0, -shearYSlider.value * shearRect.width / 2,
                    0,                  0,                  1, 0,
                    0,                  0,                  0, 1
                )
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(4)

                Label {
                    text: "SHEAR"
                    font.pixelSize: Style.resize(18)
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Matrix4x4"
                    font.pixelSize: Style.resize(10)
                    color: Qt.rgba(1, 1, 1, 0.6)
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Contorno fantasma: muestra la posicion y forma original del rectangulo.
        // Solo visible cuando hay deformacion activa (shear != 0).
        Rectangle {
            anchors.centerIn: parent
            width: Style.resize(100)
            height: Style.resize(100)
            radius: Style.resize(8)
            color: "transparent"
            border.color: "#4A90D930"
            border.width: 1
            visible: Math.abs(shearXSlider.value) > 0.01 || Math.abs(shearYSlider.value) > 0.01
        }
    }
}
