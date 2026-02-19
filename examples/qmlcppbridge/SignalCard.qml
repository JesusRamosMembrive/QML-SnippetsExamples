// =============================================================================
// SignalCard.qml — Signals de C++ manejadas en QML
// =============================================================================
// Demuestra el mecanismo de signals: la forma en que C++ notifica a QML
// sobre eventos asincronos. A diferencia de Q_PROPERTY (que es para datos
// que cambian) y Q_INVOKABLE (que QML llama a C++), las signals permiten
// que C++ "empuje" eventos hacia QML sin que QML los solicite.
//
// Integracion C++ <-> QML:
//   - SignalBridge emite 4 signals desde C++:
//       dataReceived(data)    -> onDataReceived: function(data) { ... }
//       taskCompleted(result) -> onTaskCompleted: function(result) { ... }
//       errorOccurred(error)  -> onErrorOccurred: function(error) { ... }
//       customSignal(message) -> onCustomSignal: function(message) { ... }
//
//   - Convencion de nombres: la signal "dataReceived" se conecta con el
//     handler "onDataReceived" (prefijo "on" + primera letra mayuscula).
//     Qt hace la conexion automaticamente cuando el handler esta dentro
//     de la declaracion del componente SignalBridge { onDataReceived: ... }.
//
//   - Q_INVOKABLE startTask()/stopTask(): QML inicia una tarea simulada
//     en C++ que usa QTimer para emitir signals periodicamente.
//   - Q_INVOKABLE emitCustom(msg): QML pide a C++ que emita customSignal.
//   - Q_PROPERTY running/progress: propiedades de solo lectura que QML
//     observa para actualizar el boton y la barra de progreso.
//
// pragma ComponentBehavior: Bound: directiva de Qt 6.5+ que refuerza el
// scope de las propiedades en delegados. Con "Bound", las required properties
// del delegado DEBEN declararse explicitamente (mejor seguridad de tipos).
//
// Patron de log visual: un ListModel acumula mensajes de las signals.
// insert(0, ...) agrega al inicio para que los mas recientes aparezcan
// primero. Cada tipo de signal tiene un color diferente para facilitar
// la identificacion visual.
// =============================================================================

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Instancia de SignalBridge con handlers de signals.
    //    Cada handler recibe el parametro de la signal (string) y lo
    //    inserta en el modelo del log con su tipo para colorear.
    SignalBridge {
        id: signals

        onDataReceived: function(data) {
            logModel.insert(0, { msg: data, type: "data" })
        }
        onTaskCompleted: function(result) {
            logModel.insert(0, { msg: result, type: "success" })
        }
        onErrorOccurred: function(error) {
            logModel.insert(0, { msg: error, type: "error" })
        }
        onCustomSignal: function(message) {
            logModel.insert(0, { msg: "Custom: " + message, type: "custom" })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "C++ Signals"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Signals emitted from C++ handled in QML Connections"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Control de tarea: el boton llama startTask()/stopTask()
        //    (Q_INVOKABLE) que inician/detienen un QTimer en C++.
        //    El Timer emite signals periodicamente que llegan a los
        //    handlers de arriba. ProgressBar se vincula a signals.progress
        //    (Q_PROPERTY de solo lectura).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: signals.running ? "Stop" : "Start Task"
                implicitHeight: Style.resize(34)
                onClicked: signals.running ? signals.stopTask() : signals.startTask()
            }

            ProgressBar {
                Layout.fillWidth: true
                value: signals.progress
            }

            Label {
                text: (signals.progress * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        // -- Signal personalizada: el usuario escribe un mensaje y QML
        //    llama emitCustom() (Q_INVOKABLE) que hace emit customSignal()
        //    en C++. La signal viaja de C++ a QML y aparece en el log.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: customMsg
                Layout.fillWidth: true
                placeholderText: "Custom signal message..."
                font.pixelSize: Style.resize(11)
            }

            Button {
                text: "Emit"
                implicitHeight: Style.resize(34)
                onClicked: {
                    if (customMsg.text !== "") {
                        signals.emitCustom(customMsg.text)
                        customMsg.text = ""
                    }
                }
            }
        }

        // -- Log de eventos: ListView con ListModel que acumula los
        //    mensajes de las signals. Cada delegado se colorea segun
        //    el tipo de signal (data=teal, success=verde, error=rojo,
        //    custom=azul). Esto visualiza la comunicacion C++ -> QML.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            ListView {
                id: logList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: ListModel { id: logModel }
                spacing: Style.resize(2)

                delegate: Rectangle {
                    id: logDelegate
                    required property string msg
                    required property string type
                    required property int index
                    width: logList.width
                    height: logText.implicitHeight + Style.resize(8)
                    radius: Style.resize(3)

                    // -- Color de fondo segun tipo de signal.
                    color: {
                        switch (logDelegate.type) {
                        case "data": return "#1A00D1A9"
                        case "success": return "#1A4CAF50"
                        case "error": return "#1AFF6B6B"
                        case "custom": return "#1A4FC3F7"
                        default: return "transparent"
                        }
                    }

                    Label {
                        id: logText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: Style.resize(6)
                        text: logDelegate.msg
                        font.pixelSize: Style.resize(11)
                        wrapMode: Text.WordWrap
                        color: {
                            switch (logDelegate.type) {
                            case "data": return "#00D1A9"
                            case "success": return "#4CAF50"
                            case "error": return "#FF6B6B"
                            case "custom": return "#4FC3F7"
                            default: return Style.fontPrimaryColor
                            }
                        }
                    }
                }
            }

            // -- Texto de ayuda cuando el log esta vacio.
            Label {
                anchors.centerIn: parent
                text: "Press Start Task or Emit to see signals"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: logModel.count === 0
            }
        }

        // -- Pie del log: contador de eventos y boton para limpiar.
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: logModel.count + " events"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Clear Log"
                implicitHeight: Style.resize(30)
                onClicked: logModel.clear()
            }
        }
    }
}
