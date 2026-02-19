// =============================================================================
// Main.qml — Pagina principal del Head-Up Display (HUD)
// =============================================================================
// El HUD (Head-Up Display) es un sistema de visualizacion que proyecta
// informacion de vuelo directamente en el campo visual del piloto,
// permitiendole ver datos sin bajar la mirada a los instrumentos.
//
// Esta pagina separa la logica en tres componentes:
//   - HudCanvas: el Canvas que renderiza toda la simbologia en verde fosforo
//   - HudControlsPanel: panel de sliders para ajustar los parametros de vuelo
//   - Main.qml: orquestador que conecta ambos y gestiona la visibilidad
//
// La separacion canvas/controles es un patron recomendado: mantiene el
// codigo de renderizado aislado del UI de control, facilitando la reutilizacion.
// Las propiedades fluyen: Slider -> Panel (readonly) -> Main -> HudCanvas.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: fullSize controla si esta pagina
    // esta activa. La opacidad anima la transicion y visible evita procesar
    // elementos cuando la pagina esta oculta.
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

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(10)

            Label {
                text: "Head-Up Display (HUD)"
                font.pixelSize: Style.resize(28)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
                Layout.leftMargin: Style.resize(20)
            }

            // -----------------------------------------------------------------
            // HudCanvas ocupa todo el espacio disponible. Las propiedades
            // de vuelo se conectan desde el panel de controles inferior.
            // fillHeight: true permite que el canvas crezca con la ventana.
            // -----------------------------------------------------------------
            HudCanvas {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pitch: controls.pitch
                roll: controls.roll
                heading: controls.heading
                speed: controls.speed
                altitude: controls.altitude
                fpa: controls.fpa
            }

            // -----------------------------------------------------------------
            // Panel de controles con altura fija. Expone readonly properties
            // que Main.qml pasa al HudCanvas. Este patron evita que el
            // canvas tenga que conocer los sliders directamente.
            // -----------------------------------------------------------------
            HudControlsPanel {
                id: controls
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(110)
            }

            Label {
                text: "Canvas-drawn fighter HUD: pitch ladder (solid above, dashed below horizon), flight path vector, heading tape, speed/altitude readouts. All green phosphor monochrome."
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.leftMargin: Style.resize(20)
            }
        }
    }
}
