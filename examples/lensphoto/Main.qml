// =============================================================================
// Main.qml — Página LensPhoto: lente óptica GPU sobre fotografía
// =============================================================================
// Demuestra ShaderEffect con shaders GLSL compilados (QSB) para aplicar
// efectos ópticos en tiempo real sobre una imagen fotográfica.
//
// Técnica:
//   - Image con visible:false actúa como textura fuente
//   - LensEffect (ShaderEffect) cubre el mismo área y aplica el shader
//   - Un MouseArea actualiza lensX/lensY al arrastrar el ratón
//   - Un Rectangle decorativo dibuja el anillo de la lente en QML puro
// =============================================================================

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(12)

            // ── Cabecera ──────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(12)

                ColumnLayout {
                    spacing: Style.resize(4)

                    Text {
                        text: "Lens Photo"
                        font.family: Style.fontFamilyBold
                        font.pixelSize: Style.resize(28)
                        font.bold: true
                        color: Style.mainColor
                    }

                    Text {
                        text: "GPU optical lens — ShaderEffect + compiled GLSL (magnification, chromatic aberration, barrel distortion)"
                        font.pixelSize: Style.resize(13)
                        color: Style.fontSecondaryColor
                    }
                }

                Item { Layout.fillWidth: true }
            }

            // ── Área principal: foto + lente ──────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(16)

                // ── Contenedor de la foto ─────────────────────────────────
                Item {
                    id: photoContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    // Imagen fuente — visible:false evita doble renderizado.
                    // El ShaderEffect la captura internamente mediante
                    // ShaderEffectSource aunque no sea visible en pantalla.
                    Image {
                        id: photoImage
                        anchors.fill: parent
                        source: "qrc:/assets/images/piedad.jpg"
                        fillMode: Image.PreserveAspectCrop
                        visible: false
                        smooth: true
                        mipmap: true
                    }

                    // El ShaderEffect cubre exactamente el mismo área.
                    // "source: photoImage" hace que Qt cree un
                    // ShaderEffectSource interno apuntando a photoImage.
                    LensEffect {
                        id: lensEffect
                        anchors.fill: parent
                        source:        photoImage
                        magnification: magSlider.value
                        aberration:    aberSlider.value
                        lensRadius:    radiusSlider.value / height
                        rimBrightness: rimSlider.value
                    }

                    // MouseArea que actualiza la posición de la lente.
                    // hoverEnabled:true permite mover la lente sin pulsar.
                    MouseArea {
                        id: photoMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.CrossCursor

                        onPressed: (mouse) => {
                            lensEffect.lensX = mouse.x / width
                            lensEffect.lensY = mouse.y / height
                        }
                        onPositionChanged: (mouse) => {
                            lensEffect.lensX = mouse.x / width
                            lensEffect.lensY = mouse.y / height
                        }
                    }

                    // Anillo visual de vidrio (QML puro, sin shader).
                    // Proporciona feedback visual de posición y radio.
                    // Se posiciona reactivamente desde lensEffect.lensX/Y.
                    Item {
                        id: lensRing
                        x: lensEffect.lensX * photoContainer.width  - radiusSlider.value
                        y: lensEffect.lensY * photoContainer.height - radiusSlider.value
                        width:  radiusSlider.value * 2
                        height: radiusSlider.value * 2

                        // Sombra exterior
                        Rectangle {
                            anchors.centerIn: parent
                            width:  parent.width  + Style.resize(6)
                            height: parent.height + Style.resize(6)
                            radius: width / 2
                            color: "transparent"
                            border.color: Qt.rgba(0, 0, 0, 0.35)
                            border.width: Style.resize(4)
                        }

                        // Borde principal blanco
                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: "transparent"
                            border.color: Qt.rgba(1, 1, 1, 0.60)
                            border.width: Style.resize(2)
                        }

                        // Anillo interior sutil
                        Rectangle {
                            anchors.centerIn: parent
                            width:  parent.width  - Style.resize(5)
                            height: parent.height - Style.resize(5)
                            radius: width / 2
                            color: "transparent"
                            border.color: Qt.rgba(0, 0, 0, 0.18)
                            border.width: Style.resize(2)
                        }
                    }
                }

                // ── Panel de control ──────────────────────────────────────
                Rectangle {
                    Layout.preferredWidth: Style.resize(220)
                    Layout.fillHeight: true
                    color: Style.cardColor
                    radius: Style.resize(10)
                    border.color: "#343842"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(16)
                        spacing: Style.resize(14)

                        Text {
                            text: "Controls"
                            font.family: Style.fontFamilyBold
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // Magnification
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(4)

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: "Magnification"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: magSlider.value.toFixed(1) + "×"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                            }

                            Slider {
                                id: magSlider
                                Layout.fillWidth: true
                                from: 1.5; to: 4.0; value: 2.5
                                stepSize: 0.1
                            }
                        }

                        // Lens Radius
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(4)

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: "Lens Radius"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: Math.round(radiusSlider.value) + " px"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                            }

                            Slider {
                                id: radiusSlider
                                Layout.fillWidth: true
                                from: 60; to: 200; value: 110
                                stepSize: 1
                            }
                        }

                        // Chromatic Aberration
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(4)

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: "Chromatic Ab."
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: aberSlider.value.toFixed(3)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                            }

                            Slider {
                                id: aberSlider
                                Layout.fillWidth: true
                                from: 0.0; to: 0.04; value: 0.012
                                stepSize: 0.001
                            }
                        }

                        // Rim Brightness
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(4)

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: "Rim Brightness"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: rimSlider.value.toFixed(2)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }
                            }

                            Slider {
                                id: rimSlider
                                Layout.fillWidth: true
                                from: 0.0; to: 1.0; value: 0.50
                                stepSize: 0.01
                            }
                        }

                        // Reset
                        Button {
                            Layout.fillWidth: true
                            text: "Reset"
                            onClicked: {
                                magSlider.value    = 2.5
                                radiusSlider.value = 110
                                aberSlider.value   = 0.012
                                rimSlider.value    = 0.50
                                lensEffect.lensX   = 0.5
                                lensEffect.lensY   = 0.5
                            }
                        }

                        // Info box
                        Rectangle {
                            Layout.fillWidth: true
                            height: infoCol.implicitHeight + Style.resize(14)
                            color: Style.surfaceColor
                            radius: Style.resize(6)
                            border.color: "#323641"
                            border.width: 1

                            ColumnLayout {
                                id: infoCol
                                anchors { left: parent.left; right: parent.right; top: parent.top }
                                anchors.margins: Style.resize(10)
                                spacing: Style.resize(5)

                                Text {
                                    text: "How it works"
                                    font.pixelSize: Style.resize(11)
                                    font.bold: true
                                    color: Style.mainColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    text: "One GLSL fragment shader runs per-pixel on the GPU:\n\n" +
                                          "• Barrel warp distorts UV coords\n" +
                                          "• R/G/B channels sample different offsets\n" +
                                          "• Quadratic falloff → aberration zero at center, max at rim\n" +
                                          "• smoothstep blends the edge seamlessly"
                                    color: Style.fontSecondaryColor
                                    font.pixelSize: Style.resize(10)
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }
}
