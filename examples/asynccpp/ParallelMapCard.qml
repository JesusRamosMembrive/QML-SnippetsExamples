// =============================================================================
// ParallelMapCard.qml — Tarjeta de ejemplo: Secuencial vs Paralelo
// =============================================================================
// Compara dos enfoques para procesar una lista de items:
//   - Secuencial: QtConcurrent::run con un solo hilo procesando todo
//   - Paralelo:   QtConcurrent::mapped distribuyendo items entre hilos
//
// El usuario puede ejecutar ambos modos y ver el speedup real. Esto ensenya
// cuando vale la pena paralelizar: mapped() distribuye automaticamente el
// trabajo en el QThreadPool global, aprovechando todos los nucleos de la CPU.
//
// Aprendizaje clave: pragma ComponentBehavior: Bound exige que el delegate
// del ListView declare explicitamente las propiedades del modelo con
// "required property". Esto es mas seguro y eficiente que el acceso
// implicito a modelData que existia en versiones anteriores de Qt.
// =============================================================================

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    AsyncTask { id: task }

    // Datos de prueba: lista fija de strings que se procesaran tanto
    // de forma secuencial como paralela para poder comparar tiempos.
    readonly property list<string> itemsToProcess: [
        "Apple", "Banana", "Cherry", "Dragon fruit",
        "Elderberry", "Fig", "Grape", "Honeydew"
    ]

    // Estado local para guardar los tiempos de cada modo y poder
    // calcular el speedup. -1 indica que ese modo aun no se ha ejecutado.
    property int lastSequentialMs: -1
    property int lastParallelMs: -1
    property string runMode: ""

    function startSequential() {
        runMode = "sequential"
        task.processItems(itemsToProcess)
    }

    function startParallelMap() {
        runMode = "parallel"
        task.processItemsParallelMap(itemsToProcess)
    }

    // Connections escucha cuando la tarea termina para guardar el tiempo
    // en la variable correspondiente. Se usa onRunningChanged en lugar de
    // un signal dedicado porque AsyncTask ya expone "running" como Q_PROPERTY.
    Connections {
        target: task
        function onRunningChanged() {
            if (task.running || task.status.indexOf("Completed") !== 0)
                return

            if (runMode === "sequential")
                lastSequentialMs = task.elapsedMs
            else if (runMode === "parallel")
                lastParallelMs = task.elapsedMs
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Sequential vs Parallel Map"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Compare QtConcurrent::run (single worker) with QtConcurrent::mapped"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Barra de acciones: los tres botones cubren el flujo completo
        // (ejecutar secuencial, ejecutar paralelo, cancelar).
        // El contador a la derecha muestra el progreso como items/total.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Run Sequential"
                implicitHeight: Style.resize(34)
                enabled: !task.running
                onClicked: startSequential()
            }

            Button {
                text: "Run Parallel Map"
                implicitHeight: Style.resize(34)
                enabled: !task.running
                onClicked: startParallelMap()
            }

            Button {
                text: "Cancel"
                implicitHeight: Style.resize(34)
                enabled: task.running
                onClicked: task.cancel()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: task.results.length + " / " + itemsToProcess.length
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
            }
        }

        // Fila de comparacion de tiempos: muestra los milisegundos de cada
        // modo y calcula el speedup. El operador ternario encadena la logica
        // para mostrar "--" si un modo no se ha ejecutado todavia.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Sequential: " + (lastSequentialMs >= 0 ? lastSequentialMs + " ms" : "--")
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Label {
                text: "Parallel: " + (lastParallelMs >= 0 ? lastParallelMs + " ms" : "--")
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Label {
                text: (lastSequentialMs > 0 && lastParallelMs > 0)
                      ? (lastSequentialMs / lastParallelMs).toFixed(2) + "x speedup"
                      : "Run both modes to compare"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
            }
        }

        ProgressBar {
            Layout.fillWidth: true
            value: task.progress
        }

        Label {
            text: task.status
                  ? task.status + (task.elapsedMs > 0 ? " - " + task.elapsedMs + " ms" : "")
                  : "Choose a mode to start"
            font.pixelSize: Style.resize(11)
            color: task.running ? Style.mainColor : Style.fontSecondaryColor
        }

        // ListView de resultados: muestra cada item procesado conforme
        // va terminando. clip: true en el Rectangle padre evita que los
        // items se dibujen fuera de los bordes redondeados.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            ListView {
                id: resultList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: task.results
                spacing: Style.resize(3)

                // Delegate con required properties (ComponentBehavior: Bound):
                // modelData e index se declaran explicitamente. Esto permite
                // que el motor QML optimice el delegate y detecte errores
                // en tiempo de compilacion.
                delegate: Rectangle {
                    required property string modelData
                    required property int index
                    width: resultList.width
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: "#1A00D1A9"

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Style.resize(8)
                        text: modelData
                        font.pixelSize: Style.resize(11)
                        color: Style.mainColor
                    }
                }
            }

            // Estado vacio: se muestra cuando no hay resultados todavia.
            // Patern comun en UX para que el area no quede en blanco.
            Label {
                anchors.centerIn: parent
                text: "Results will appear here"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: task.results.length === 0
            }
        }
    }
}
