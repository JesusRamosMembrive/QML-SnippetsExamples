// =============================================================================
// InteractiveSwipeCard.qml — Asistente paso a paso (Wizard) con SwipeView
// =============================================================================
// Demuestra un caso de uso real y frecuente: un asistente de configuracion
// (wizard/onboarding) donde el usuario avanza paso a paso con botones
// Back/Next. El SwipeView tiene interactive: false para deshabilitar el
// gesto de deslizar — la navegacion es SOLO mediante botones.
//
// Este patron es ideal cuando se necesita control estricto del flujo:
// validar datos antes de avanzar, forzar un orden secuencial, o impedir
// que el usuario salte pasos. La ProgressBar muestra el progreso global.
//
// Al llegar al ultimo paso, el boton cambia de "Next" a "Finish" y al
// pulsarlo reinicia el wizard al paso 1 (comportamiento circular).
//
// Aprendizaje clave: interactive: false desactiva gestos en SwipeView,
// forzando navegacion programatica. ProgressBar.value se calcula como
// fraccion (paso_actual / total_pasos) para llenar proporcionalmente.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Onboarding Wizard"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // SwipeView con interactive: false.
        // Esta es la diferencia clave respecto a los otros ejemplos: el usuario
        // NO puede deslizar con el dedo/raton. Solo los botones Back/Next
        // pueden cambiar currentIndex. Esto garantiza un flujo controlado.
        // ---------------------------------------------------------------------
        SwipeView {
            id: wizardSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: false

            // Paso 1: Bienvenida
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2460"; font.pixelSize: Style.resize(36); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Welcome"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Get started with the setup wizard"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Paso 2: Configuracion
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2461"; font.pixelSize: Style.resize(36); color: "#FEA601"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Configure"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Set your preferences"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Paso 3: Revision
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2462"; font.pixelSize: Style.resize(36); color: "#4FC3F7"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Review"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Check everything is correct"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            // Paso 4: Completado
            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(10)
                    Label { text: "\u2714"; font.pixelSize: Style.resize(36); color: "#66BB6A"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Done!"; font.pixelSize: Style.resize(18); font.bold: true; color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "You are all set"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Barra de progreso: muestra el avance global del wizard.
        // El valor se calcula como fraccion: (paso_actual + 1) / total_pasos.
        // Se suma 1 porque currentIndex es base-0 pero el progreso debe
        // mostrar "paso 1 de 4" como 25%, no 0%.
        // ---------------------------------------------------------------------
        ProgressBar {
            Layout.fillWidth: true
            value: (wizardSwipe.currentIndex + 1) / wizardSwipe.count
        }

        // ---------------------------------------------------------------------
        // Navegacion del wizard: Back, indicador de paso, y Next/Finish.
        // - Back solo es visible cuando no estamos en el primer paso.
        // - El boton derecho cambia su texto: "Next" durante el wizard,
        //   "Finish" en el ultimo paso. Al pulsar Finish, reinicia al paso 0
        //   creando un ciclo (util para demos; en produccion se emitiria
        //   una signal de finalizacion).
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Back"
                visible: wizardSwipe.currentIndex > 0
                onClicked: wizardSwipe.currentIndex--
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Step " + (wizardSwipe.currentIndex + 1) + " of " + wizardSwipe.count
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: wizardSwipe.currentIndex === wizardSwipe.count - 1 ? "Finish" : "Next"
                onClicked: {
                    if (wizardSwipe.currentIndex < wizardSwipe.count - 1)
                        wizardSwipe.currentIndex++
                    else
                        wizardSwipe.currentIndex = 0
                }
            }
        }
    }
}
