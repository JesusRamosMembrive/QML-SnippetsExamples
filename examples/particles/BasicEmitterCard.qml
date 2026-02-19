// ============================================================================
// BasicEmitterCard.qml
// Demuestra los tres componentes fundamentales del sistema de particulas de Qt:
//   - ParticleSystem: el "motor" que coordina todos los elementos de particulas.
//   - Emitter: define DONDE y COMO se generan las particulas (tasa, tiempo de
//     vida, tamano, velocidad inicial).
//   - ImageParticle: renderiza cada particula usando una imagen (textura).
//
// CONCEPTO CLAVE: El sistema de particulas en Qt Quick funciona como una
// tuberia (pipeline): el ParticleSystem orquesta, el Emitter crea particulas,
// y el ImageParticle las dibuja. Sin alguno de estos tres, no se ve nada.
//
// NOTA: El modulo QtQuick.Particles solo funciona con renderizado por GPU
// (no software). Requiere "import QtQuick.Particles".
// ============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // 'active' controla si el sistema de particulas esta corriendo.
    // Esto permite pausar las particulas cuando la tarjeta no es visible,
    // ahorrando recursos de GPU.
    property bool active: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        Label {
            text: "Basic Emitter"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Controles interactivos ---
        // Estos sliders permiten experimentar con los parametros del Emitter
        // en tiempo real para entender como afecta cada propiedad.

        // Rate: cantidad de particulas emitidas por segundo
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Rate: " + rateSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: rateSlider; anchors.fill: parent; from: 5; to: 200; value: 50; stepSize: 5 }
            }
        }

        // Lifespan: tiempo de vida de cada particula en milisegundos.
        // Valores altos = particulas mas duraderas = mas particulas visibles a la vez.
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Life: " + lifeSlider.value.toFixed(0) + "ms"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: lifeSlider; anchors.fill: parent; from: 500; to: 5000; value: 2000; stepSize: 100 }
            }
        }

        // Size: tamano base de cada particula en pixeles
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Size: " + sizeSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: sizeSlider; anchors.fill: parent; from: 4; to: 40; value: 16; stepSize: 2 }
            }
        }

        // --- Area de visualizacion de particulas ---
        // clip: true es IMPORTANTE para evitar que las particulas se dibujen
        // fuera del area delimitada.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            // ParticleSystem: el componente central que sincroniza todos los
            // elementos del sistema (emitters, particulas, affectors).
            // La propiedad 'running' permite activar/desactivar el sistema completo.
            ParticleSystem {
                id: basicSystem
                anchors.fill: parent
                running: root.active

                // ImageParticle: renderiza las particulas usando una textura PNG.
                // - source: imagen que representa cada particula (tipicamente un
                //   circulo difuso blanco para efectos de brillo).
                // - colorVariation: agrega variacion aleatoria al color (0-1),
                //   creando un efecto mas natural y menos uniforme.
                // - alpha: transparencia base de cada particula.
                ImageParticle {
                    source: "qrc:/assets/images/particle.png"
                    colorVariation: 0.6
                    color: Style.mainColor
                    alpha: 0.8
                }

                // Emitter: genera particulas desde una posicion especifica.
                // - emitRate: particulas por segundo.
                // - lifeSpan: cuanto vive cada particula (ms).
                // - size/sizeVariation: tamano base +/- variacion aleatoria.
                // - velocity: direccion y velocidad inicial de las particulas.
                Emitter {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: Style.resize(40)
                    emitRate: rateSlider.value
                    lifeSpan: lifeSlider.value
                    size: sizeSlider.value
                    sizeVariation: sizeSlider.value / 3
                    // AngleDirection: define velocidad en coordenadas polares.
                    // - angle: 270 = hacia arriba (0=derecha, 90=abajo, 270=arriba).
                    // - angleVariation: dispersion angular (+/- 30 grados).
                    // - magnitude: velocidad en pixeles/segundo.
                    // - magnitudeVariation: variacion aleatoria de velocidad.
                    velocity: AngleDirection {
                        angle: 270
                        angleVariation: 30
                        magnitude: 100
                        magnitudeVariation: 40
                    }
                }
            }
        }

        Label {
            text: "ParticleSystem + Emitter + ImageParticle for basic effects"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
