// =============================================================================
// PipelineFlowCard.qml — Diagrama visual del flujo del pipeline
// =============================================================================
// Muestra una representacion grafica del pipeline de 3 hilos con cajas
// conectadas por flechas animadas. Cada caja muestra el nombre del worker,
// su conteo de datos procesados y el numero de hilo.
//
// Conexion QML <-> C++:
//   - ThreadPipeline expone los contadores como Q_PROPERTYs reactivas:
//     - generatedCount: arrays producidos por el Generator.
//     - processedCount: arrays analizados por el Filter.
//     - matchedCount: coincidencias encontradas por el Collector.
//     - running: controla si las animaciones deben correr.
//   - Los contadores se actualizan via señales que cruzan hilos. Los workers
//     emiten señales en su hilo, ThreadPipeline las recibe en el hilo GUI
//     via QueuedConnection, actualiza las Q_PROPERTYs y QML reacciona.
//
// Patrones clave:
//   - SequentialAnimation on x: anima un circulo ("packet") de izquierda a
//     derecha entre las cajas, simulando el flujo de datos. PauseAnimation
//     agrega una pausa al final antes de repetir, dando ritmo visual.
//   - Easing.InOutQuad: aceleracion y desaceleracion suave que hace que
//     el "paquete" parezca moverse fisicamente entre las etapas.
//   - Animaciones condicionadas a running: las animaciones solo corren
//     cuando el pipeline esta activo. opacity: 0 oculta los paquetes
//     cuando esta detenido.
//   - Hit rate calculado: matchedCount / processedCount * 100 muestra el
//     porcentaje de coincidencias. Math.max(1, ...) evita division por cero.
//   - toLocaleString(): formatea numeros grandes con separadores de miles
//     (ej: 1,234,567) para mejorar la legibilidad.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var pipeline

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Pipeline Flow"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Visual pipeline diagram
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Style.resize(160)

            RowLayout {
                anchors.centerIn: parent
                spacing: 0

                // Generator stage
                Rectangle {
                    id: genBox
                    Layout.preferredWidth: Style.resize(130)
                    Layout.preferredHeight: Style.resize(110)
                    radius: Style.resize(10)
                    color: "#1a3d35"
                    border.color: "#00D1A9"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)
                        Label {
                            text: "⚡"
                            font.pixelSize: Style.resize(24)
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Generator"
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: "#00D1A9"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: root.pipeline.generatedCount.toLocaleString()
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#00D1A9"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Thread 1"
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Arrow 1: Generator → Filter
                Item {
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(110)

                    // Static arrow line
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - Style.resize(10)
                        height: 2
                        color: Style.fontSecondaryColor
                    }

                    // Arrow head
                    Label {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: parent.width / 2 - Style.resize(8)
                        text: "▶"
                        font.pixelSize: Style.resize(10)
                        color: root.pipeline.running ? "#00D1A9" : Style.fontSecondaryColor
                    }

                    // Animated packet
                    Rectangle {
                        id: packet1
                        width: Style.resize(8)
                        height: Style.resize(8)
                        radius: width / 2
                        color: "#00D1A9"
                        opacity: root.pipeline.running ? 1.0 : 0.0
                        y: parent.height / 2 - height / 2

                        SequentialAnimation on x {
                            loops: Animation.Infinite
                            running: root.pipeline.running
                            NumberAnimation {
                                from: 0
                                to: packet1.parent ? packet1.parent.width - packet1.width : 0
                                duration: 800
                                easing.type: Easing.InOutQuad
                            }
                            PauseAnimation { duration: 200 }
                        }
                    }
                }

                // Filter stage
                Rectangle {
                    id: filterBox
                    Layout.preferredWidth: Style.resize(130)
                    Layout.preferredHeight: Style.resize(110)
                    radius: Style.resize(10)
                    color: "#1a2a3d"
                    border.color: "#4A90D9"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)
                        Label {
                            text: "🔍"
                            font.pixelSize: Style.resize(24)
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Filter"
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: "#4A90D9"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: root.pipeline.processedCount.toLocaleString()
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#4A90D9"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Thread 2"
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Arrow 2: Filter → Collector
                Item {
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(110)

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - Style.resize(10)
                        height: 2
                        color: Style.fontSecondaryColor
                    }

                    Label {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: parent.width / 2 - Style.resize(8)
                        text: "▶"
                        font.pixelSize: Style.resize(10)
                        color: root.pipeline.running ? "#FEA601" : Style.fontSecondaryColor
                    }

                    Rectangle {
                        id: packet2
                        width: Style.resize(8)
                        height: Style.resize(8)
                        radius: width / 2
                        color: "#FEA601"
                        opacity: root.pipeline.running ? 1.0 : 0.0
                        y: parent.height / 2 - height / 2

                        SequentialAnimation on x {
                            loops: Animation.Infinite
                            running: root.pipeline.running
                            NumberAnimation {
                                from: 0
                                to: packet2.parent ? packet2.parent.width - packet2.width : 0
                                duration: 1200
                                easing.type: Easing.InOutQuad
                            }
                            PauseAnimation { duration: 400 }
                        }
                    }
                }

                // Collector stage
                Rectangle {
                    id: collectBox
                    Layout.preferredWidth: Style.resize(130)
                    Layout.preferredHeight: Style.resize(110)
                    radius: Style.resize(10)
                    color: "#3d2a1a"
                    border.color: "#FEA601"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)
                        Label {
                            text: "📦"
                            font.pixelSize: Style.resize(24)
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Collector"
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: "#FEA601"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: root.pipeline.matchedCount.toLocaleString()
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: "#FEA601"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Thread 3"
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // Summary stats
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Generated: " + root.pipeline.generatedCount.toLocaleString()
                font.pixelSize: Style.resize(11)
                color: "#00D1A9"
            }
            Label {
                text: "Processed: " + root.pipeline.processedCount.toLocaleString()
                font.pixelSize: Style.resize(11)
                color: "#4A90D9"
            }
            Label {
                text: "Matched: " + root.pipeline.matchedCount.toLocaleString()
                font.pixelSize: Style.resize(11)
                color: "#FEA601"
            }
            Item { Layout.fillWidth: true }
            Label {
                visible: root.pipeline.processedCount > 0
                text: {
                    var ratio = root.pipeline.matchedCount / Math.max(1, root.pipeline.processedCount) * 100
                    return "Hit rate: " + ratio.toFixed(2) + "%"
                }
                font.pixelSize: Style.resize(11)
                color: Style.fontPrimaryColor
            }
        }

        Label {
            text: "Cross-thread signal/slot connections replace the Actia SafeQueue pattern"
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
