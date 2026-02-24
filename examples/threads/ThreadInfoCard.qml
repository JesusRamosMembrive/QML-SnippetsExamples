// =============================================================================
// ThreadInfoCard.qml — Identidad de hilos y patron moveToThread()
// =============================================================================
// Muestra los IDs de los 4 hilos del sistema (GUI, Generator, Filter,
// Collector) para demostrar visualmente que cada worker corre en un hilo
// diferente del sistema operativo. Incluye una explicacion del patron
// moveToThread() como referencia educativa.
//
// Conexion QML <-> C++:
//   - ThreadPipeline expone los IDs de hilo como Q_PROPERTYs string:
//     - mainThreadId: el hilo GUI donde corre QML.
//     - generatorThreadId: hilo del worker Generator.
//     - filterThreadId: hilo del worker Filter.
//     - collectorThreadId: hilo del worker Collector.
//   - Estos IDs se obtienen con QThread::currentThreadId() dentro de cada
//     worker y se envian al hilo principal via senal. Son punteros
//     convertidos a string hexadecimal.
//
// Patrones clave:
//   - Acceso dinamico a propiedades: root.pipeline[propName] usa bracket
//     notation de JavaScript para acceder a propiedades de un QObject por
//     nombre string. Esto permite usar un Repeater con un ListModel que
//     tiene el nombre de la propiedad como dato.
//   - SequentialAnimation on opacity: los puntos coloreados de cada hilo
//     parpadean mientras el pipeline esta corriendo, dando feedback visual
//     de actividad. El hilo GUI (mainThreadId) no parpadea porque siempre
//     esta activo.
//   - Panel educativo: el Rectangle inferior con fondo surfaceColor contiene
//     una explicacion paso a paso del patron moveToThread() con formato
//     monospace, sirviendo como referencia rapida para el aprendiz.
// =============================================================================
pragma ComponentBehavior: Bound
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
            text: "Thread Identity"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Thread info rows
        Repeater {
            model: ListModel {
                ListElement { label: "Main (GUI)"; threadColor: "#FFFFFF"; propName: "mainThreadId" }
                ListElement { label: "Generator"; threadColor: "#00D1A9"; propName: "generatorThreadId" }
                ListElement { label: "Filter"; threadColor: "#4A90D9"; propName: "filterThreadId" }
                ListElement { label: "Collector"; threadColor: "#FEA601"; propName: "collectorThreadId" }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(10)

                required property string label
                required property string threadColor
                required property string propName

                // Colored dot with pulse
                Rectangle {
                    width: Style.resize(10)
                    height: Style.resize(10)
                    radius: width / 2
                    color: threadColor

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: root.pipeline.running && propName !== "mainThreadId"
                        NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                        NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
                    }
                }

                Label {
                    text: label + ":"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: threadColor
                    Layout.preferredWidth: Style.resize(110)
                }

                Label {
                    text: {
                        var tid = root.pipeline[propName]
                        return tid ? tid : "—"
                    }
                    font.pixelSize: Style.resize(13)
                    font.family: "Consolas, monospace"
                    color: Style.fontPrimaryColor
                    Layout.fillWidth: true
                }
            }
        }

        Item { Layout.fillHeight: true }

        // Concept explanation
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: conceptCol.implicitHeight + Style.resize(20)
            color: Style.surfaceColor
            radius: Style.resize(6)

            ColumnLayout {
                id: conceptCol
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Label {
                    text: "moveToThread() Pattern"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.mainColor
                }
                Label {
                    text: "1. Create QObject worker (no parent)\n" +
                          "2. worker->moveToThread(&thread)\n" +
                          "3. thread.start()\n" +
                          "4. Connect signals across threads\n" +
                          "5. Qt auto-uses QueuedConnection"
                    font.pixelSize: Style.resize(11)
                    font.family: "Consolas, monospace"
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }

        Label {
            text: "Each thread ID is unique — proof that workers run on separate OS threads."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
