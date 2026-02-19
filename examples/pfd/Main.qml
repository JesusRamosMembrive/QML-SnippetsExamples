// =============================================================================
// Main.qml — Pagina principal del Primary Flight Display (PFD)
// =============================================================================
// El PFD es el instrumento mas critico de la cabina de un avion moderno.
// Muestra horizonte artificial, velocidad, altitud, rumbo y velocidad vertical.
//
// Esta pagina organiza cuatro tarjetas en un GridLayout 2x2, cada una conteniendo
// un instrumento Canvas independiente. Sigue el patron estandar del proyecto:
// fullSize controla la visibilidad con animacion de opacidad (200ms),
// y ScrollView permite scroll si el contenido excede la pantalla.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de visibilidad del proyecto: el Dashboard asigna fullSize = true
    // cuando esta pagina esta activa. La opacidad anima suavemente la transicion.
    // visible se vincula a opacity > 0 para evitar procesar un item invisible.
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
                    text: "Primary Flight Display (PFD)"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -------------------------------------------------------------
                // Grid 2x2 con los cuatro instrumentos del PFD:
                // - Horizonte artificial (ADI): actitud del avion
                // - Cintas de velocidad/altitud: datos primarios de vuelo
                // - Indicador de rumbo: brujula HSI
                // - VSI + coordinador de viraje: velocidad vertical y equilibrio
                // Cada tarjeta tiene minimumHeight para garantizar que Canvas
                // tenga suficiente espacio para dibujar los instrumentos.
                // -------------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    ArtificialHorizonCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    SpeedAltTapesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    HeadingIndicatorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }

                    VsiTurnCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(500)
                    }
                }
            }
        }
    }
}
