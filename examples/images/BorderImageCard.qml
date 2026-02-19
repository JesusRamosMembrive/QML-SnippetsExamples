// =============================================================================
// BorderImageCard.qml — Ejemplo de BorderImage (9-patch) en QML
// =============================================================================
// BorderImage divide una imagen en 9 regiones: 4 esquinas que no se escalan,
// 4 bordes que se estiran en una sola direccion, y un centro que se estira
// en ambas. Es el mismo concepto que "9-patch" en Android.
//
// Este ejemplo muestra la misma imagen 9-patch en tres tamanos diferentes
// (Original, Wide, Tall) para que el usuario vea como las esquinas se
// mantienen intactas mientras los bordes y el centro se adaptan.
// Un Slider permite ajustar el grosor del borde en tiempo real.
//
// Caso de uso real: marcos de botones, burbujas de chat, paneles que
// necesitan esquinas redondeadas que no se deformen al redimensionar.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Grosor del borde en pixeles. Controla cuanto de la imagen se
    // considera "esquina" (no escalable) vs "centro" (escalable).
    property int borderSize: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "BorderImage (9-patch)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Corners stay fixed, edges stretch"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Tres variantes lado a lado para comparar visualmente
            // como BorderImage adapta la misma imagen a distintas proporciones.
            Row {
                anchors.centerIn: parent
                spacing: Style.resize(15)

                Repeater {
                    model: [
                        { w: 60, h: 60, lbl: "Original" },
                        { w: 140, h: 80, lbl: "Wide" },
                        { w: 80, h: 130, lbl: "Tall" }
                    ]

                    ColumnLayout {
                        required property var modelData
                        spacing: Style.resize(4)

                        // border.left/right/top/bottom definen cuantos pixeles
                        // desde cada borde se consideran zona fija (esquinas).
                        // Valores iguales en los 4 lados = esquinas simetricas.
                        BorderImage {
                            source: "qrc:/assets/images/ninepatch.png"
                            width: Style.resize(modelData.w)
                            height: Style.resize(modelData.h)
                            border.left: root.borderSize
                            border.right: root.borderSize
                            border.top: root.borderSize
                            border.bottom: root.borderSize
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.lbl
                            font.pixelSize: Style.resize(11)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // Slider para experimentar: valores muy bajos deforman las esquinas,
        // valores muy altos hacen que casi toda la imagen sea "esquina".
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Border: " + root.borderSize + "px"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                Layout.fillWidth: true
                from: 5; to: 28; value: root.borderSize; stepSize: 1
                onValueChanged: root.borderSize = value
            }
        }
    }
}
