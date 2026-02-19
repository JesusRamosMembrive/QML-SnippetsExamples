// ============================================================================
// Rotation3DCard.qml
// Demuestra rotaciones 3D usando la propiedad 'transform' de QML.
//
// CONCEPTO CLAVE: Aunque QML es un framework 2D, soporta transformaciones
// 3D a traves del tipo Rotation con la propiedad 'axis'. Esto permite crear
// efectos de perspectiva como voltear tarjetas, carruseles, o cubos giratorios
// sin necesitar Qt Quick 3D (que es un modulo separado para escenas 3D reales).
//
// COMO FUNCIONA:
//   - 'axis { x: 1; y: 0; z: 0 }' rota alrededor del eje X (como abrir una
//     tapa de laptop hacia atras).
//   - 'axis { x: 0; y: 1; z: 0 }' rota alrededor del eje Y (como abrir una
//     puerta giratoria).
//   - 'axis { x: 0; y: 0; z: 1 }' rota alrededor del eje Z (rotacion plana
//     normal, como las agujas de un reloj).
//
// PROPIEDAD 'transform': acepta una LISTA de Transform (Rotation, Scale,
// Translate). Se aplican en ORDEN, lo cual importa porque las transformaciones
// 3D NO son conmutativas (rotar X luego Y != rotar Y luego X).
//
// 'origin': punto alrededor del cual se realiza la rotacion. Si no se
// establece, rota alrededor de (0,0) del item (esquina superior izquierda),
// lo cual generalmente no es el efecto deseado. Centrar el origin da un
// giro "en su sitio".
// ============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        Label {
            text: "3D Rotation"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Controles por eje ---
        // Cada slider controla un eje de rotacion (0-360 grados).
        // Los colores (rojo=X, verde/teal=Y, azul=Z) siguen la convencion
        // comun en herramientas 3D (XYZ = RGB).

        // Eje X (rojo): inclinacion adelante/atras
        RowLayout {
            Layout.fillWidth: true
            Label { text: "X: " + xRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#E74C3C"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: xRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        // Eje Y (teal): giro lateral izquierda/derecha
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Y: " + yRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#00D1A9"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: yRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        // Eje Z (azul): rotacion plana (como rotation normal de QML)
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Z: " + zRotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: "#4A90D9"; Layout.preferredWidth: Style.resize(60) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: zRotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        Button {
            text: "Reset"
            onClicked: { xRotSlider.value = 0; yRotSlider.value = 0; zRotSlider.value = 0 }
        }

        // --- Vista previa 3D ---
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(6)
            }

            Rectangle {
                id: rect3d
                anchors.centerIn: parent
                width: Style.resize(100)
                height: Style.resize(100)
                radius: Style.resize(10)
                color: "#4A90D9"

                // Lista de transformaciones aplicadas en secuencia.
                // ORDEN IMPORTANTE: primero X, luego Y, luego Z.
                // Cambiar este orden produciria un resultado visual diferente.
                // Cada Rotation tiene:
                //   - origin: centro de rotacion (aqui, centro del rectangulo).
                //   - axis: vector unitario que define el eje de giro.
                //   - angle: angulo de rotacion en grados.
                transform: [
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 1; y: 0; z: 0 }
                        angle: xRotSlider.value
                    },
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 0; y: 1; z: 0 }
                        angle: yRotSlider.value
                    },
                    Rotation {
                        origin.x: rect3d.width / 2
                        origin.y: rect3d.height / 2
                        axis { x: 0; y: 0; z: 1 }
                        angle: zRotSlider.value
                    }
                ]

                Label {
                    anchors.centerIn: parent
                    text: "3D"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: "white"
                }
            }
        }

        Label {
            text: "Rotation with axis { x; y; z } creates 3D perspective effects"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
