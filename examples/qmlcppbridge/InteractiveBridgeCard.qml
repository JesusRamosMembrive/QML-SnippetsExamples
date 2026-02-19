// =============================================================================
// InteractiveBridgeCard.qml — Los tres mecanismos C++ <-> QML combinados
// =============================================================================
// Tarjeta resumen que usa PropertyBridge, MethodBridge y SignalBridge
// simultaneamente, demostrando como los tres mecanismos de comunicacion
// C++ <-> QML trabajan juntos en una aplicacion real.
//
// Integracion C++ <-> QML:
//   - PropertyBridge (props): Q_PROPERTY para datos reactivos.
//     userName, counter y summary se leen/escriben directamente.
//   - MethodBridge (methods): Q_INVOKABLE para logica de negocio.
//     transformText() y fibonacci() se llaman desde bindings y handlers.
//   - SignalBridge (sigs): signals para eventos asincronos.
//     onDataReceived/onTaskCompleted/onErrorOccurred actualizan lastSignal.
//
// Arquitectura de la tarjeta:
//   Tres secciones visuales (rectangulos con color de acento diferente),
//   cada una demostrando un mecanismo. La seccion de signals incluye un
//   ProgressBar vinculado a sigs.progress (Q_PROPERTY de solo lectura)
//   y un area de texto que muestra la ultima signal recibida.
//
// Aprendizaje: en una aplicacion real, estos tres QObjects serian
// probablemente uno solo (o un modelo mas complejo), pero aqui estan
// separados para que cada tarjeta del ejemplo pueda ensenar un mecanismo
// de forma aislada.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Estado local: almacena la ultima signal recibida para mostrarla.
    property string lastSignal: ""

    // -- Tres instancias de QObjects C++ trabajando juntas.
    //    Cada una aporta un mecanismo diferente de comunicacion.
    PropertyBridge { id: props }
    MethodBridge { id: methods }
    SignalBridge {
        id: sigs
        // -- Handlers de signals: actualizan lastSignal con cada evento.
        onDataReceived: function(data) { root.lastSignal = data }
        onTaskCompleted: function(result) { root.lastSignal = result }
        onErrorOccurred: function(error) { root.lastSignal = error }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Combined Bridge"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Properties + Methods + Signals working together"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Seccion Q_PROPERTY: binding bidireccional con TextField
        //    y botones que llaman Q_INVOKABLE increment()/decrement().
        //    props.summary es una propiedad computada que se actualiza
        //    automaticamente cuando counter o userName cambian.
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: propCol.implicitHeight + Style.resize(16)
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                id: propCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "Q_PROPERTY"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#4FC3F7"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(8)

                    TextField {
                        id: nameField
                        Layout.fillWidth: true
                        text: props.userName
                        font.pixelSize: Style.resize(11)
                        placeholderText: "userName"
                        onTextChanged: props.userName = text
                    }

                    Button {
                        text: "-"
                        implicitWidth: Style.resize(30)
                        implicitHeight: Style.resize(28)
                        onClicked: props.decrement()
                    }

                    Label {
                        text: props.counter.toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: Style.mainColor
                        Layout.preferredWidth: Style.resize(30)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        text: "+"
                        implicitWidth: Style.resize(30)
                        implicitHeight: Style.resize(28)
                        onClicked: props.increment()
                    }
                }

                Label {
                    text: props.summary
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // -- Seccion Q_INVOKABLE + Q_ENUM: transformacion de texto y
        //    calculo de Fibonacci. Los botones "UC", "lc", "Tc", "Rev"
        //    corresponden a los valores del enum TextTransform (0-3).
        //    El Repeater genera botones para cada valor del enum, y el
        //    index del Repeater coincide con el valor del enum.
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: methCol.implicitHeight + Style.resize(16)
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                id: methCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "Q_INVOKABLE + Q_ENUM"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#C084FC"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    TextField {
                        id: methodInput
                        Layout.fillWidth: true
                        text: "hello world"
                        font.pixelSize: Style.resize(11)
                    }

                    // -- Repeater genera un boton por cada transformacion.
                    //    index del Repeater = valor del Q_ENUM TextTransform.
                    Repeater {
                        model: ["UC", "lc", "Tc", "Rev"]

                        Button {
                            required property string modelData
                            required property int index
                            text: modelData
                            implicitWidth: Style.resize(36)
                            implicitHeight: Style.resize(28)
                            onClicked: methodResult.text = methods.transformText(
                                           methodInput.text, index)
                        }
                    }
                }

                Label {
                    id: methodResult
                    text: methods.transformText(methodInput.text, 2)
                    font.pixelSize: Style.resize(11)
                    color: Style.mainColor
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                // -- Fibonacci: binding declarativo que llama a C++ cada
                //    vez que fibInput.value cambia. QML re-evalua el
                //    binding automaticamente.
                RowLayout {
                    spacing: Style.resize(8)

                    Label {
                        text: "fib(" + fibInput.value.toFixed(0) + ") = " +
                              methods.fibonacci(fibInput.value)
                        font.pixelSize: Style.resize(11)
                        color: Style.fontPrimaryColor
                    }

                    Slider {
                        id: fibInput
                        Layout.fillWidth: true
                        from: 0; to: 20; value: 10; stepSize: 1
                    }
                }
            }
        }

        // -- Seccion SIGNALS: tarea asincrona con barra de progreso.
        //    Al presionar "Run", QML llama startTask() (Q_INVOKABLE) que
        //    inicia un QTimer en C++. El Timer emite signals periodicamente
        //    (dataReceived, taskCompleted, errorOccurred) que llegan a los
        //    handlers de sigs. El ultimo mensaje se muestra en el area de texto.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "SIGNALS"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#FF6B6B"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    Button {
                        text: sigs.running ? "Stop" : "Run"
                        implicitHeight: Style.resize(28)
                        onClicked: sigs.running ? sigs.stopTask() : sigs.startTask()
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        value: sigs.progress
                    }

                    Label {
                        text: (sigs.progress * 100).toFixed(0) + "%"
                        font.pixelSize: Style.resize(10)
                        color: Style.mainColor
                    }
                }

                // -- Area de texto que muestra la ultima signal recibida.
                //    lastSignal se actualiza en los handlers de signals.
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Style.resize(4)
                    color: "#1A000000"

                    Label {
                        anchors.fill: parent
                        anchors.margins: Style.resize(6)
                        text: root.lastSignal || "Waiting for signals..."
                        font.pixelSize: Style.resize(11)
                        color: root.lastSignal ? "#00D1A9" : "#FFFFFF30"
                        wrapMode: Text.WordWrap
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
