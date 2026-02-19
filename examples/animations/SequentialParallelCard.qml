// =============================================================================
// SequentialParallelCard.qml
// Concepto: SequentialAnimation vs ParallelAnimation — composicion de animaciones.
//
// QML permite combinar animaciones simples en secuencias complejas usando dos
// contenedores fundamentales:
//
//   - SequentialAnimation: ejecuta animaciones UNA TRAS OTRA. Ideal para
//     coreografiar pasos donde cada efecto depende del anterior (mover,
//     luego cambiar color, luego escalar). Duracion total = suma de todas.
//
//   - ParallelAnimation: ejecuta animaciones AL MISMO TIEMPO. Ideal para
//     efectos compuestos donde todo ocurre simultaneamente (mover + cambiar
//     color + escalar a la vez). Duracion total = la mas larga.
//
// Ambas se pueden anidar entre si para crear coreografias complejas:
// SequentialAnimation { ParallelAnimation { ... } NumberAnimation { ... } }
//
// En este ejemplo, los tres mismos cambios (posicion, color, escala) se aplican
// a dos rectangulos identicos — uno secuencial, otro paralelo — para que el
// usuario vea y compare visualmente la diferencia entre ambos enfoques.
//
// restart() reinicia la animacion desde el inicio incluso si ya estaba corriendo,
// a diferencia de start() que no hace nada si ya esta activa.
// =============================================================================

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
        spacing: Style.resize(10)

        Label {
            text: "Sequential & Parallel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // El boton resetea manualmente las propiedades antes de reiniciar porque
        // las animaciones standalone (con id) no definen 'from' — solo 'to'.
        // Sin el reset, la segunda ejecucion empezaria desde donde termino la
        // anterior, no desde el estado inicial.
        Button {
            text: "Play"
            onClicked: {
                // Reset positions
                seqRect.x = 0
                seqRect.scale = 1.0
                seqRect.color = "#4A90D9"
                parRect.x = 0
                parRect.scale = 1.0
                parRect.color = "#4A90D9"
                seqAnim.restart()
                parAnim.restart()
            }
        }

        // ── Area de comparacion lado a lado ────────────────────────────────
        // Dos columnas identicas muestran el mismo conjunto de cambios
        // (mover, colorear, escalar) pero con distinta estrategia temporal.
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // ── Columna Sequential ─────────────────────────────────────
            // Las tres animaciones corren en serie: primero el movimiento
            // (600ms), luego el color (400ms), luego la escala (400ms).
            // Duracion total: 600 + 400 + 400 = 1400ms.
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(5)

                Label {
                    text: "Sequential"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: seqRect
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(40)
                        height: Style.resize(40)
                        radius: Style.resize(6)
                        color: "#4A90D9"

                        // SequentialAnimation ejecuta cada hijo en orden.
                        // Cada NumberAnimation/ColorAnimation espera a que
                        // la anterior termine antes de empezar.
                        SequentialAnimation {
                            id: seqAnim

                            // Paso 1: Mover a la derecha con aceleracion natural
                            NumberAnimation {
                                target: seqRect
                                property: "x"
                                to: seqRect.parent.width - seqRect.width
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }

                            // Paso 2: Cambiar color (solo empieza cuando el movimiento termina)
                            ColorAnimation {
                                target: seqRect
                                property: "color"
                                to: Style.mainColor
                                duration: 400
                            }

                            // Paso 3: Escalar con efecto "resorte" (OutBack sobrepasa y vuelve)
                            NumberAnimation {
                                target: seqRect
                                property: "scale"
                                to: 1.5
                                duration: 400
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }

                Label {
                    text: "Move \u2192 Color \u2192 Scale"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Columna Parallel ───────────────────────────────────────
            // Los tres mismos cambios ocurren a la vez en 800ms.
            // El resultado visual es muy distinto: el objeto se transforma
            // de forma fluida y simultanea, en vez de paso a paso.
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(5)

                Label {
                    text: "Parallel"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: parRect
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(40)
                        height: Style.resize(40)
                        radius: Style.resize(6)
                        color: "#4A90D9"

                        // ParallelAnimation ejecuta todos sus hijos simultaneamente.
                        // Todas las animaciones comparten la misma duracion (800ms)
                        // para que terminen sincronizadas, pero podrian tener
                        // duraciones distintas — Parallel termina cuando termina la mas larga.
                        ParallelAnimation {
                            id: parAnim

                            NumberAnimation {
                                target: parRect
                                property: "x"
                                to: parRect.parent.width - parRect.width
                                duration: 800
                                easing.type: Easing.InOutQuad
                            }

                            ColorAnimation {
                                target: parRect
                                property: "color"
                                to: Style.mainColor
                                duration: 800
                            }

                            NumberAnimation {
                                target: parRect
                                property: "scale"
                                to: 1.5
                                duration: 800
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }

                Label {
                    text: "Move + Color + Scale"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Sequential runs animations one after another. Parallel runs them simultaneously"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
