// =============================================================================
// Main.qml — Pagina principal del ejemplo Async C++
// =============================================================================
// Demuestra la integracion entre QML y operaciones asincronas de C++ usando
// QFuture, QPromise y QtConcurrent. Cada tarjeta (card) ilustra un patron
// diferente: ejecucion concurrente, reporte de progreso, cancelacion de
// tareas y procesamiento paralelo con mapped().
//
// Aprendizaje clave: como estructurar una pagina de ejemplos con GridLayout
// responsive y como delegar la logica pesada a C++ sin bloquear el hilo de UI.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del Dashboard: fullSize controla si esta pagina
    // esta activa. La animacion de opacidad (200ms) da una transicion suave
    // al cambiar entre paginas. visible se vincula a opacity para que el
    // item no consuma eventos de raton cuando esta oculto.
    // -------------------------------------------------------------------------
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // ScrollView envuelve todo el contenido para permitir scroll cuando
        // las tarjetas exceden el alto de la ventana.
        // contentWidth: availableWidth fuerza que el contenido use todo el
        // ancho disponible, evitando scroll horizontal innecesario.
        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "Async C++ Showcase"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // GridLayout responsive: 2 columnas en pantallas anchas,
                // 1 columna en pantallas estrechas. Esto permite que las
                // tarjetas se adapten al espacio disponible sin necesidad
                // de Flickable o Flow.
                GridLayout {
                    columns: width >= Style.resize(1100) ? 2 : 1
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // Tarjeta 1: QtConcurrent::run — ejecutar funciones pesadas
                    // en un hilo secundario
                    ConcurrentRunCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    // Tarjeta 2: QPromise::setProgressValue — reportar progreso
                    // desde el hilo de trabajo hacia QML
                    ProgressTaskCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    // Tarjeta 3: QFuture::cancel — cancelar tareas en ejecucion
                    // de forma cooperativa
                    CancelTaskCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    // Tarjeta 4: QtConcurrent::mapped — comparar procesamiento
                    // secuencial vs paralelo
                    ParallelMapCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
