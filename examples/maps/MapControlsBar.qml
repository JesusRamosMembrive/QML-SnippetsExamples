// =============================================================================
// MapControlsBar.qml — Barra de controles de simulacion (overlay inferior)
// =============================================================================
// Barra flotante estilo reproductor multimedia posicionada en la parte
// inferior del mapa. Controla play/pause, reset, velocidad de simulacion
// y modo follow/free de la camara.
//
// Patrones y conceptos clave:
// - Componente puramente emisor de signals: no modifica estado directamente,
//   solo emite signals (playToggled, resetClicked, etc.) que el padre maneja.
//   Este patron desacopla la UI de la logica de negocio.
// - Botones con caracteres Unicode como iconos: evita dependencias de
//   fuentes externas o recursos de imagen.
// - Repeater con array de valores para generar botones de velocidad.
// - Hover feedback con MouseArea.containsMouse para cambiar color sin
//   necesidad de estados explicitos.
// - Forma pill (radius = height/2) con fondo semitransparente.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    // Properties de solo lectura que reflejan el estado del padre.
    // El componente las usa para mostrar el estado visual correcto
    // pero no las modifica: emite signals para que el padre lo haga.
    property bool playing: false
    property real simSpeed: 1.0
    property bool followAircraft: true

    signal playToggled()
    signal resetClicked()
    signal speedSelected(real speed)
    signal followClicked()

    // Posicionamiento como barra flotante centrada abajo.
    // El ancho se adapta al contenido (implicitWidth del RowLayout + padding).
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: Style.resize(15)
    width: controlsRow.implicitWidth + Style.resize(30)
    height: Style.resize(44)
    radius: Style.resize(22)
    color: Qt.rgba(0, 0, 0, 0.75)
    border.color: Qt.rgba(1, 1, 1, 0.15)
    border.width: 1

    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: Style.resize(8)

        // Boton de reset (volver al inicio)
        Label {
            text: "\u23EE"
            font.pixelSize: Style.resize(20)
            color: resetMa.containsMouse ? "white" : "#CCCCCC"

            MouseArea {
                id: resetMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.resetClicked()
            }
        }

        // Boton play/pause: el icono cambia segun el estado.
        // Usa caracteres Unicode para evitar recursos de imagen.
        Label {
            text: root.playing ? "\u23F8" : "\u25B6"
            font.pixelSize: Style.resize(22)
            color: playMa.containsMouse ? Style.mainColor : "white"

            MouseArea {
                id: playMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.playToggled()
            }
        }

        Rectangle {
            width: 1
            height: Style.resize(20)
            color: "#555555"
        }

        // ── Selector de velocidad ───────────────────────────────
        // Repeater genera un boton por cada velocidad. La velocidad activa
        // se resalta con mainColor y bold; las demas muestran hover feedback.
        Repeater {
            model: [1, 2, 4]

            Label {
                required property real modelData

                text: modelData + "x"
                font.pixelSize: Style.resize(13)
                font.bold: root.simSpeed === modelData
                color: root.simSpeed === modelData
                       ? Style.mainColor
                       : (spdMa.containsMouse ? "white" : "#AAAAAA")

                MouseArea {
                    id: spdMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.speedSelected(parent.modelData)
                }
            }
        }

        Rectangle {
            width: 1
            height: Style.resize(20)
            color: "#555555"
        }

        // ── Toggle Follow/Free ──────────────────────────────────
        // "Follow" centra el mapa en el avion automaticamente.
        // "Free" permite navegar el mapa libremente mientras la
        // simulacion continua. El arrastrar el mapa tambien activa "Free".
        Label {
            text: root.followAircraft ? "\uD83D\uDCCD Follow" : "\uD83D\uDD13 Free"
            font.pixelSize: Style.resize(12)
            color: followMa.containsMouse
                   ? "white"
                   : (root.followAircraft ? Style.mainColor : "#AAAAAA")

            MouseArea {
                id: followMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.followClicked()
            }
        }
    }
}
