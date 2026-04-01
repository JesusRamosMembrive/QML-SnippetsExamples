import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import utils

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    // Propiedades expuestas que serán atadas a MultiEffect (fijan el estado inicial)
    property real effectBlur: 0.0
    property real effectShadowBlur: 0.5
    property real effectShadowOffset: 15.0
    property color effectShadowColor: "#000000"
    property real effectSaturation: 0.0
    property real effectBrightness: 0.0
    property real effectContrast: 0.0
    property real effectColorization: 0.0
    property color effectColorizationColor: Style.mainColor
    property real effectDisplace: 0.0
    property real effectZoomBlur: 0.0
    property real effectDirectionalBlur: 0.0
    property real effectGlow: 0.0
    property color effectGlowColor: "#E74C3C"

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // Zona del visualizador de imagen
        Item {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            anchors.rightMargin: controlPanel.width + Style.resize(20)
            
            // Imagen Base Oculta (necesaria como fuente original intacta para MultiEffect)
            Image {
                id: sourceImage
                source: "qrc:/assets/images/Modestia.jpg"
                anchors.centerIn: parent
                width: Math.min(parent.width, sourceSize.width)
                height: Math.min(parent.height, sourceSize.height)
                fillMode: Image.PreserveAspectFit
                visible: false
                smooth: true
                mipmap: true
            }

            // 1.1 Desenfoque Zoom (Radial cinemático)
            ZoomBlur {
                id: zoomEffect
                anchors.fill: sourceImage
                source: sourceImage // Inicio de la cadena
                length: effectZoomBlur * 64
                horizontalOffset: width / 2
                verticalOffset: height / 2
                samples: 24
                visible: false
            }

            // 1.2 Desenfoque Direccional (Motion Blur)
            DirectionalBlur {
                id: directionalEffect
                anchors.fill: sourceImage
                source: zoomEffect // Encadenado
                length: effectDirectionalBlur * 48
                angle: 90
                samples: 24
                visible: false
            }

            // 1.5 Mapa animado generador de olas (Displacement Map)
            Item {
                id: waveMap
                anchors.fill: sourceImage
                visible: false
                
                Rectangle { anchors.fill: parent; color: "#808080" } // Color neutro para el canal de desplazamiento
                
                Image {
                    source: "qrc:/assets/images/dark-texture-background.png"
                    width: parent.width * 2
                    height: parent.height * 2
                    fillMode: Image.Tile
                    NumberAnimation on x { from: 0; to: -100; duration: 5000; loops: Animation.Infinite; running: effectDisplace > 0 }
                    NumberAnimation on y { from: 0; to: -100; duration: 7000; loops: Animation.Infinite; running: effectDisplace > 0 }
                    opacity: 0.15 // Reducido para que la textura solo ondule sutilmente alrededor del gris neutro
                }
            }

            // 1.8 Efecto de perturbación o reflejo por encima del agua
            Displace {
                id: displaceEffect
                anchors.fill: sourceImage
                source: directionalEffect // Encadenado
                displacementSource: waveMap
                displacement: effectDisplace * 5.0
                visible: false
            }

            // 1.9 Efecto Resplandor Exterior (Neon Glow)
            Glow {
                id: glowEffect
                anchors.fill: sourceImage
                source: displaceEffect // Encadenado
                color: root.effectGlowColor
                radius: effectGlow * 32
                samples: 17
                spread: 0.3
                visible: false
                transparentBorder: true
            }

            // Aplicación combinada final via MultiEffect (tinte, sombras integradas y ajustes)
            MultiEffect {
                source: glowEffect // Fin de la cadena pre-computada
                anchors.fill: sourceImage
                
                autoPaddingEnabled: true
                
                // --- Desenfoques ---
                blurEnabled: effectBlur > 0
                blurMax: 64
                blur: effectBlur

                // --- Sombras ---
                shadowEnabled: true
                shadowBlur: effectShadowBlur
                shadowColor: root.effectShadowColor
                shadowHorizontalOffset: effectShadowOffset
                shadowVerticalOffset: effectShadowOffset
                
                // --- Ajustes de Color y Tintes ---
                saturation: effectSaturation
                brightness: effectBrightness
                contrast: effectContrast

                colorization: effectColorization
                colorizationColor: root.effectColorizationColor
            }
        }
        
        // Panel lateral de controles (tipo inspector)
        Rectangle {
            id: controlPanel
            width: Style.resize(320)
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: Style.cardColor
            border.color: Style.surfaceColor
            border.width: 1
            
            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(25)
                contentWidth: availableWidth
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: Style.resize(15)
                    
                    Label {
                        text: "Ajustes del Shader"
                        color: Style.fontPrimaryColor
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        Layout.bottomMargin: Style.resize(10)
                    }
                    
                    // -- Filtros de Fotográficos Básicos --
                    Label { text: "Ajustes de Fotografía"; color: Style.fontPrimaryColor; font.bold: true }

                    Label { text: "Brillo"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: -1.0; to: 1.0; value: effectBrightness
                        onValueChanged: effectBrightness = value
                    }

                    Label { text: "Contraste"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: -1.0; to: 1.0; value: effectContrast
                        onValueChanged: effectContrast = value
                    }

                    Label { text: "Saturación"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: -1.0; to: 1.0; value: effectSaturation
                        onValueChanged: effectSaturation = value
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Style.surfaceColor; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                    // -- Filtros Especiales Avanzados --
                    Label { text: "Filtros Gráficos"; color: Style.fontPrimaryColor; font.bold: true }

                    Label { text: "Distorsión Ondular (Displace)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectDisplace
                        onValueChanged: effectDisplace = value
                    }

                    Label { text: "Desenfoque Cinético Radial (Zoom)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectZoomBlur
                        onValueChanged: effectZoomBlur = value
                    }

                    Label { text: "Desenfoque Movimiento (Directional)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectDirectionalBlur
                        onValueChanged: effectDirectionalBlur = value
                    }

                    Label { text: "Desenfoque Suave (Gaussian Blur)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectBlur
                        onValueChanged: effectBlur = value
                    }

                    Label { text: "Nivel de Tinte (Colorization)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectColorization
                        onValueChanged: effectColorization = value
                    }

                    Label { text: "Color del Tinte"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    RowLayout {
                        spacing: 12
                        Repeater {
                            model: ["#00D1A9", "#E74C3C", "#3498DB", "#9B59B6", "#F1C40F"]
                            Rectangle {
                                width: Style.resize(30); height: width; radius: width/2
                                color: modelData
                                border.color: effectColorizationColor == modelData ? Style.fontPrimaryColor : "transparent"
                                border.width: 2
                                MouseArea { anchors.fill: parent; onClicked: effectColorizationColor = modelData }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Style.surfaceColor; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                    // -- Luces y Sombras --
                    Label { text: "Iluminación Externa"; color: Style.fontPrimaryColor; font.bold: true }

                    Label { text: "Resplandor Neón (Glow)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectGlow
                        onValueChanged: effectGlow = value
                    }

                    Label { text: "Color Libre del Resplandor"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    RowLayout {
                        spacing: 12
                        Repeater {
                            model: ["#E74C3C", "#2ECC71", "#3498DB", "#8E44AD", "#F1C40F"]
                            Rectangle {
                                width: Style.resize(30); height: width; radius: width/2
                                color: modelData
                                border.color: effectGlowColor == modelData ? Style.fontPrimaryColor : "transparent"
                                border.width: 2
                                MouseArea { anchors.fill: parent; onClicked: effectGlowColor = modelData }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "transparent"; Layout.topMargin: 5; Layout.bottomMargin: 5 }

                    Label { text: "Sombra de Proyección Angular"; color: Style.fontPrimaryColor; font.bold: true }

                    Label { text: "Distancia (Offset)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: -50.0; to: 50.0; value: effectShadowOffset
                        onValueChanged: effectShadowOffset = value
                    }

                    Label { text: "Difuminación (Blur)"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    Slider {
                        Layout.fillWidth: true; from: 0.0; to: 1.0; value: effectShadowBlur
                        onValueChanged: effectShadowBlur = value
                    }

                    Label { text: "Color de la Sombra"; color: Style.fontSecondaryColor; font.pixelSize: Style.fontSizeS }
                    RowLayout {
                        spacing: 12
                        Repeater {
                            model: ["#000000", "#E67E22", "#E84393", "#34495E", "#00D1A9"]
                            Rectangle {
                                width: Style.resize(30); height: width; radius: width/2
                                color: modelData
                                border.color: effectShadowColor == modelData ? Style.fontPrimaryColor : "transparent"
                                border.width: 2
                                MouseArea { anchors.fill: parent; onClicked: effectShadowColor = modelData }
                            }
                        }
                    }
                }
            }
        }
    }
}
