// =============================================================================
// FillRulesCard.qml — Comparacion visual de las reglas de relleno (fill rules)
// =============================================================================
// Cuando un camino (ShapePath) se cruza a si mismo — como en una estrella de
// 5 puntas — el motor de renderizado necesita decidir que regiones son
// "interiores" y cuales "exteriores". La propiedad fillRule controla esto:
//
//   - OddEvenFill (por defecto): traza una linea imaginaria desde cualquier
//     punto hacia el infinito. Si cruza un numero IMPAR de bordes, el punto
//     esta "dentro" y se rellena. Resultado: el centro de la estrella queda
//     hueco porque la linea cruza 2 bordes (par) para llegar ahi.
//
//   - WindingFill: cuenta la DIRECCION de cada cruce (horario +1, antihorario
//     -1). Si la suma no es cero, se rellena. Resultado: toda la estrella
//     queda solida porque las direcciones nunca se cancelan.
//
// POR QUE IMPORTA: fill rules son esenciales para formas complejas con agujeros
// (engranajes, letras como "O", logos). SVG y fuentes TrueType usan las mismas
// reglas, asi que entenderlas aplica mas alla de Qt.
//
// NOTA: Ambas estrellas usan exactamente los mismos PathLine. Solo cambia
// fillRule, lo que hace evidente la diferencia visual.
// =============================================================================
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
            text: "Fill Rules"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(30)

            // =============================================
            // OddEvenFill: el centro de la estrella queda hueco.
            // La estrella de 5 puntas se dibuja con 10 PathLine que
            // forman un camino que se auto-intersecta. Con OddEvenFill,
            // el pentagono central (rodeado por un numero par de bordes)
            // se considera "exterior" y no se rellena.
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(140)
                    height: Style.resize(140)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: Style.mainColor
                        fillColor: Style.mainColor
                        fillRule: ShapePath.OddEvenFill

                        // Estrella de 5 puntas: los vertices se conectan
                        // "saltando" un punto (1->3->5->2->4->1), creando
                        // las intersecciones que activan la regla de relleno.
                        startX: 70; startY: 5
                        PathLine { x: 85;  y: 55 }
                        PathLine { x: 135; y: 55 }
                        PathLine { x: 95;  y: 85 }
                        PathLine { x: 110; y: 135 }
                        PathLine { x: 70;  y: 105 }
                        PathLine { x: 30;  y: 135 }
                        PathLine { x: 45;  y: 85 }
                        PathLine { x: 5;   y: 55 }
                        PathLine { x: 55;  y: 55 }
                        PathLine { x: 70;  y: 5 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "OddEvenFill"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Style.resize(-15)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Center is hollow"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            // =============================================
            // WindingFill: la misma estrella, completamente solida.
            // El algoritmo de winding nunca produce suma cero en el
            // centro porque todos los bordes giran en la misma
            // direccion. Resultado: todo se rellena.
            // =============================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(140)
                    height: Style.resize(140)

                    ShapePath {
                        strokeWidth: Style.resize(2)
                        strokeColor: "#7C4DFF"
                        fillColor: "#7C4DFF"
                        fillRule: ShapePath.WindingFill

                        // Mismas coordenadas que la estrella de arriba
                        startX: 70; startY: 5
                        PathLine { x: 85;  y: 55 }
                        PathLine { x: 135; y: 55 }
                        PathLine { x: 95;  y: 85 }
                        PathLine { x: 110; y: 135 }
                        PathLine { x: 70;  y: 105 }
                        PathLine { x: 30;  y: 135 }
                        PathLine { x: 45;  y: 85 }
                        PathLine { x: 5;   y: 55 }
                        PathLine { x: 55;  y: 55 }
                        PathLine { x: 70;  y: 5 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "WindingFill"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Style.resize(-15)
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Fully solid"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
