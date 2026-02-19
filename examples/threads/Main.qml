// ============================================================================
// Threads (C++ Pipeline) - Pagina principal
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. QThread + moveToThread (patron Worker):
//    - Qt NO recomienda heredar de QThread para logica de negocio.
//    - El patron correcto es: crear un QObject "worker", crear un QThread,
//      llamar worker->moveToThread(thread), conectar senales/slots y
//      llamar thread->start(). El worker ejecuta su logica en el hilo creado.
//    - Esto separa la logica del hilo del ciclo de vida del hilo.
//
// 2. Pipeline de 3 hilos:
//    - Generator (hilo 1): produce arrays de bytes aleatorios a un ritmo
//      configurable y los emite via senal.
//    - Filter (hilo 2): recibe los arrays, busca un patron de bytes
//      especifico y emite solo las coincidencias.
//    - Collector (hilo 3): almacena las coincidencias con timestamps
//      y las expone a QML como modelo.
//
// 3. Comunicacion entre hilos con senales/slots:
//    - Las conexiones signal/slot entre objetos en diferentes hilos son
//      Qt::QueuedConnection por defecto. Esto significa que la senal se
//      encola en el event loop del hilo receptor, garantizando thread-safety
//      sin mutexes manuales.
//    - Los datos emitidos (QByteArray) se copian al cruzar hilos.
//
// 4. Limpieza de recursos:
//    - onFullSizeChanged detiene el pipeline al salir de la pagina.
//    - Esto es CRITICO: si los hilos siguen corriendo en background,
//      consumen CPU innecesariamente y pueden causar crashes al destruir
//      los objetos QML.
//    - En C++, el destructor de ThreadPipeline debe llamar quit() y wait()
//      en cada QThread para asegurar una terminacion limpia.
//
// 5. Actualizacion de UI desde hilos:
//    - QML siempre corre en el hilo principal (GUI thread).
//    - Los workers emiten senales que, via QueuedConnection, llegan al
//      hilo principal donde ThreadPipeline actualiza sus Q_PROPERTYs.
//    - QML reacciona automaticamente a los cambios de propiedades.
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import threads

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // ThreadPipeline: componente C++ que encapsula los 3 hilos del pipeline.
    // Expone propiedades como running, generatedCount, filteredCount,
    // matchedCount y la lista de registros encontrados.
    ThreadPipeline {
        id: pipeline
    }

    // Limpieza al salir de la pagina: detener el pipeline si esta corriendo.
    // Sin esto, los hilos seguirian ejecutandose en background consumiendo
    // recursos e impidiendo una terminacion limpia de la aplicacion.
    onFullSizeChanged: {
        if (!fullSize && pipeline.running)
            pipeline.stop()
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(20)

                Label {
                    text: "Threads (C++ Pipeline)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Demonstrates QThread + moveToThread worker pattern with cross-thread signal/slot communication. " +
                          "Adapted from a 3-thread pipeline: Generator produces random byte arrays, Filter searches for a byte pattern, " +
                          "Collector stores matches with timestamps."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Fila 1: Visualizacion del flujo + Controles del pipeline
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // Card de flujo: muestra visualmente como los datos pasan
                    // de Generator -> Filter -> Collector con animaciones
                    // que representan el movimiento de datos entre hilos.
                    PipelineFlowCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(380)
                        pipeline: pipeline
                    }

                    // Card de controles: botones start/stop, configuracion de
                    // velocidad de generacion y patron de busqueda.
                    PipelineControlCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(380)
                        pipeline: pipeline
                    }
                }

                // Fila 2: Registros encontrados + Info de hilos
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // Card de registros: muestra las coincidencias encontradas
                    // por el Collector con timestamp y datos del match.
                    RecordsCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(400)
                        pipeline: pipeline
                    }

                    // Card de info: muestra el estado de cada hilo (corriendo,
                    // detenido), contadores de datos procesados y estadisticas
                    // de rendimiento del pipeline.
                    ThreadInfoCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(400)
                        pipeline: pipeline
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
