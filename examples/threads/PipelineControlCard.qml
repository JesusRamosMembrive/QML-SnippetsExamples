// =============================================================================
// PipelineControlCard.qml — Controles del pipeline de hilos
// =============================================================================
// Panel de control para el pipeline de 3 hilos: botones start/stop/clear,
// slider de velocidad de generacion y selector de patron de filtrado.
//
// Conexion QML <-> C++:
//   - ThreadPipeline (C++) expone:
//     - start() / stop() (Q_INVOKABLEs): inician o detienen los 3 hilos.
//     - running (Q_PROPERTY bool): estado actual del pipeline.
//     - generationInterval (Q_PROPERTY int): intervalo del QTimer del
//       Generator en milisegundos. Al cambiar desde QML, se llama
//       setInterval() en el hilo del Generator via QueuedConnection.
//     - setFilterPattern(QVariantList) (Q_INVOKABLE): cambia el patron de
//       bytes que busca el Filter. Se convierte de array JS a QByteArray.
//     - filterPatternHex (Q_PROPERTY string): representacion hex del patron
//       activo para mostrar en la UI.
//     - clear() (Q_INVOKABLE): resetea contadores y limpia registros.
//
// Patrones clave:
//   - Indicador de estado con punto coloreado: un circulo verde/rojo con
//     Behavior on color que cambia suavemente al iniciar/detener el pipeline.
//   - Slider de velocidad con calculo inverso: muestra "~N/s" (operaciones
//     por segundo) calculando 1000 / interval. Valores bajos = mas rapido.
//   - ComboBox con arrays de bytes: el modelo del ComboBox muestra descripciones
//     legibles, pero onActivated accede a un array paralelo de patrones binarios.
//     Esto desacopla la presentacion de los datos tecnicos.
//   - Cross-thread property change: al cambiar generationInterval desde QML
//     (hilo GUI), Qt envia el cambio al hilo del Generator via
//     QueuedConnection automaticamente porque los objetos viven en hilos
//     diferentes.
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

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Pipeline Controls"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Rectangle {
                width: Style.resize(12)
                height: Style.resize(12)
                radius: width / 2
                color: root.pipeline.running ? "#4CAF50" : "#F44336"
                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }

        // Start / Stop / Clear
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Button {
                text: root.pipeline.running ? "Stop" : "Start"
                highlighted: root.pipeline.running
                onClicked: root.pipeline.running ? root.pipeline.stop() : root.pipeline.start()
                Layout.preferredWidth: Style.resize(100)
            }
            Button {
                text: "Clear"
                onClicked: root.pipeline.clear()
                Layout.preferredWidth: Style.resize(80)
            }
            Item { Layout.fillWidth: true }
        }

        // Generation speed
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Speed: " + speedSlider.value.toFixed(0) + "ms (~" + Math.round(1000 / speedSlider.value) + "/s)"
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(170)
            }
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(28)
                Slider {
                    id: speedSlider
                    anchors.fill: parent
                    from: 1; to: 200; value: 10; stepSize: 1
                    onMoved: root.pipeline.generationInterval = value
                }
            }
        }

        // Filter pattern selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Filter:"
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            ComboBox {
                id: patternCombo
                Layout.fillWidth: true
                model: [
                    "{00 01 02}  default",
                    "{FF FF}  frequent",
                    "{DE AD BE EF}  rare",
                    "{00}  very frequent"
                ]
                onActivated: {
                    var patterns = [
                        [0x00, 0x01, 0x02],
                        [0xFF, 0xFF],
                        [0xDE, 0xAD, 0xBE, 0xEF],
                        [0x00]
                    ]
                    root.pipeline.setFilterPattern(patterns[currentIndex])
                }
            }
        }

        // Current pattern display
        Label {
            text: "Active pattern: " + root.pipeline.filterPatternHex
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            font.family: "Consolas, monospace"
        }

        Item { Layout.fillHeight: true }

        Label {
            text: "QTimer drives generation rate. setInterval() is called cross-thread via QueuedConnection."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
