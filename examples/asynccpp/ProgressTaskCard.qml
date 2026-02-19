// =============================================================================
// ProgressTaskCard.qml — Tarjeta de ejemplo: Reporte de progreso con QPromise
// =============================================================================
// Demuestra como un hilo de trabajo en C++ puede reportar progreso
// incremental a QML usando QPromise::setProgressValue(). La clase AsyncTask
// expone una propiedad "progress" (0.0 a 1.0) que se actualiza en cada paso,
// y QML reacciona automaticamente gracias a los bindings declarativos.
//
// El Slider permite al usuario elegir cuantos pasos tendra la tarea,
// mostrando como parametrizar operaciones asincronas desde QML.
//
// Aprendizaje clave: la comunicacion hilo_trabajo -> UI es unidireccional
// y segura gracias al mecanismo de senales de Qt. QML nunca necesita
// hacer polling — simplemente se vincula a las propiedades.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // AsyncTask expone: running (bool), progress (real 0-1), status (string).
    // Cada vez que el hilo en C++ llama setProgressValue(), la propiedad
    // progress cambia y todos los bindings se re-evaluan automaticamente.
    AsyncTask { id: task }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Progress Reporting"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QPromise::setProgressValue from background thread"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Control de parametro: el Slider permite configurar la cantidad
        // de pasos antes de iniciar la tarea. Esto muestra como pasar
        // datos de QML a C++ a traves de metodos Q_INVOKABLE.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Steps:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: stepSlider
                Layout.fillWidth: true
                from: 3; to: 10; value: 6; stepSize: 1
            }

            Label {
                text: stepSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(25)
            }
        }

        Button {
            text: "Start Task"
            Layout.fillWidth: true
            implicitHeight: Style.resize(38)
            enabled: !task.running
            onClicked: task.runSteps(stepSlider.value)
        }

        // ProgressBar vinculada directamente a task.progress (0.0-1.0).
        // No hace falta logica adicional: el binding reactivo se encarga
        // de actualizar la barra cada vez que C++ emite progressChanged().
        ProgressBar {
            Layout.fillWidth: true
            value: task.progress
        }

        Label {
            text: (task.progress * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(22)
            font.bold: true
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }

        // Panel de estado con color condicional: verde para completado,
        // rojo para cancelado, teal para en progreso, y semitransparente
        // para estado inicial. Este patron de coloreo por estado es
        // comun en interfaces que muestran el ciclo de vida de una tarea.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            Label {
                anchors.centerIn: parent
                width: parent.width - Style.resize(20)
                text: task.status || "Press Start to begin"
                font.pixelSize: Style.resize(14)
                color: {
                    if (task.status === "Completed") return "#4CAF50"
                    if (task.status === "Cancelled") return "#FF6B6B"
                    if (task.running) return Style.mainColor
                    return "#FFFFFF30"
                }
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
