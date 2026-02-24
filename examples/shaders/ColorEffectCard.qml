// =============================================================================
// ColorEffectCard.qml — Efectos de color: overlay y desaturacion
// =============================================================================
// Demuestra dos efectos de manipulacion de color encadenados:
//   1. Desaturate: reduce la saturacion de la imagen (hacia escala de grises)
//   2. ColorOverlay: superpone un tinte de color sobre el resultado
//
// Conceptos clave para el aprendiz:
//   - Encadenamiento de efectos: un efecto puede usar otro efecto como
//     source, creando un pipeline de procesamiento. Aqui, Desaturate procesa
//     el source original y ColorOverlay procesa la salida de Desaturate.
//   - visible: false en efectos intermedios: el Desaturate esta oculto
//     porque no es el resultado final — solo alimenta al ColorOverlay.
//   - ColorOverlay.color con alfa: el componente alfa controla la intensidad
//     del tinte. Qt.rgba() construye el color usando los canales RGB del
//     color seleccionado y el alfa del slider de opacidad.
//   - Desaturate.desaturation: 0.0 = colores originales, 1.0 = escala de
//     grises completa. Combinar desaturacion parcial con overlay de color
//     es una tecnica comun para crear filtros tipo Instagram.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Propiedades a nivel de componente para que los controles de abajo
    // y los efectos de arriba compartan estado limpiamente
    property color overlayColor: "#00D1A9"
    property real desatAmount: 0.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Color Effects"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ---------------------------------------------------------------
            // Escena fuente: fila de iconos coloridos. visible: false porque
            // este Item solo sirve como entrada para la cadena de efectos.
            // ---------------------------------------------------------------
            Item {
                id: colorSource
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: Style.surfaceColor
                    radius: Style.resize(8)

                    Row {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Repeater {
                            model: [
                                { icon: "\u2605", clr: "#FF7043" },
                                { icon: "\u2665", clr: "#4FC3F7" },
                                { icon: "\u266B", clr: "#66BB6A" },
                                { icon: "\u2600", clr: "#FEA601" }
                            ]

                            Rectangle {
                                required property var modelData
                                width: Style.resize(60)
                                height: Style.resize(80)
                                radius: Style.resize(8)
                                color: modelData.clr

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.modelData.icon
                                    font.pixelSize: Style.resize(28)
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // Cadena de efectos:
            //   colorSource -> Desaturate -> ColorOverlay (visible)
            //
            // El Desaturate es un paso intermedio (visible: false) que
            // alimenta al ColorOverlay. Solo el ultimo efecto de la cadena
            // es visible. Este patron se puede extender a N efectos
            // encadenandolos secuencialmente.
            // ---------------------------------------------------------------
            Desaturate {
                id: desatEffect
                anchors.fill: colorSource
                source: colorSource
                desaturation: root.desatAmount
                visible: false
            }

            ColorOverlay {
                anchors.fill: desatEffect
                source: desatEffect
                // Qt.rgba() construye el color final: toma RGB del color
                // seleccionado y usa el slider como canal alfa para
                // controlar la intensidad del overlay
                color: Qt.rgba(root.overlayColor.r, root.overlayColor.g, root.overlayColor.b, overlaySlider.value)
            }
        }

        // -------------------------------------------------------------------
        // Panel de controles con tres secciones:
        //   1. Selector de color (circulos clickeables)
        //   2. Slider de opacidad del overlay
        //   3. Slider de desaturacion
        // -------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            // Selector de color: circulos con borde blanco para indicar
            // el color activo. Usa MouseArea en lugar de TapHandler por
            // simplicidad en elementos no-Control.
            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Overlay:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(60)
                }
                Repeater {
                    model: ["#00D1A9", "#FF7043", "#AB47BC", "#FEA601", "#4FC3F7", "#FFFFFF"]

                    Rectangle {
                        required property string modelData
                        width: Style.resize(22)
                        height: Style.resize(22)
                        radius: Style.resize(11)
                        color: modelData
                        border.color: root.overlayColor === modelData ? "#FFFFFF" : "transparent"
                        border.width: Style.resize(2)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.overlayColor = parent.modelData
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Opacity: " + overlaySlider.value.toFixed(2)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    id: overlaySlider
                    Layout.fillWidth: true
                    from: 0.0; to: 0.8; value: 0.0
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Desaturate: " + root.desatAmount.toFixed(2)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: 0.0
                    onMoved: root.desatAmount = value
                }
            }
        }
    }
}
