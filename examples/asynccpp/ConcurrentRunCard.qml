// =============================================================================
// ConcurrentRunCard.qml — Tarjeta de ejemplo: QtConcurrent::run
// =============================================================================
// Muestra como ejecutar operaciones CPU-intensivas (contar primos, Fibonacci,
// ordenar arreglos) en un hilo secundario usando QtConcurrent::run, sin
// bloquear la interfaz de usuario.
//
// La clase C++ AsyncComputer (registrada con QML_ELEMENT) expone metodos
// Q_INVOKABLE y propiedades Q_PROPERTY (running, result, elapsedMs). QML
// simplemente vincula la UI a esas propiedades — el sistema de bindings
// reactivos actualiza la interfaz automaticamente cuando C++ emite senales.
//
// Aprendizaje clave: la UI nunca se congela porque el trabajo pesado ocurre
// en otro hilo. El patron enabled: !computer.running previene multiples
// invocaciones simultaneas.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // AsyncComputer es la clase C++ expuesta via QML_ELEMENT.
    // Sus propiedades (running, result, elapsedMs) se usan como bindings
    // declarativos en toda esta tarjeta.
    AsyncComputer { id: computer }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "QtConcurrent::run"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Run heavy computations off the main thread"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Grilla de botones de accion: cada boton invoca un metodo diferente
        // de AsyncComputer. Todos se deshabilitan mientras computer.running
        // es true, evitando que el usuario lance multiples tareas a la vez.
        // GridLayout de 3 columnas distribuye los botones uniformemente.
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            columnSpacing: Style.resize(6)
            rowSpacing: Style.resize(6)

            Button {
                text: "Primes 100K"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(100000)
            }
            Button {
                text: "Primes 1M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(1000000)
            }
            Button {
                text: "Primes 5M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(5000000)
            }
            Button {
                text: "Fib(40)"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.computeFibonacci(40)
            }
            Button {
                text: "Sort 1M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.sortRandom(1000000)
            }
            Button {
                text: "Sort 10M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.sortRandom(10000000)
            }
        }

        // BusyIndicator nativo de Qt Quick Controls: gira mientras
        // computer.running sea true. Se oculta completamente cuando
        // no hay tarea activa para no ocupar espacio visual.
        BusyIndicator {
            running: computer.running
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Style.resize(40)
            Layout.preferredHeight: Style.resize(40)
            visible: computer.running
        }

        // Panel de resultados: muestra el resultado de la ultima operacion
        // y el tiempo transcurrido. Layout.fillHeight hace que ocupe todo
        // el espacio restante de la tarjeta, centrado visualmente.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)

                Label {
                    text: computer.result || "Click a button to start"
                    font.pixelSize: Style.resize(13)
                    color: computer.result !== "" ? Style.mainColor : "#FFFFFF30"
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: computer.elapsedMs > 0
                          ? "Completed in " + computer.elapsedMs + " ms" : ""
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                    visible: computer.elapsedMs > 0
                }
            }
        }
    }
}
