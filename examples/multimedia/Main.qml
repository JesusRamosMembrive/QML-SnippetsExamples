// =============================================================================
// Main.qml — Pagina principal del modulo Multimedia
// =============================================================================
// Punto de entrada de la pagina "Multimedia". Sigue el patron estandar de
// navegacion del proyecto con fullSize + animacion de opacidad.
//
// Organiza 4 tarjetas en un GridLayout 2x2: reproductor de video,
// reproductor de audio con visualizacion, control de camara y un
// reproductor interactivo con URL personalizada. Todas requieren
// el modulo QtMultimedia de Qt 6.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -------------------------------------------------------------------------
    // Patron de navegacion: fullSize controla la visibilidad de la pagina.
    // opacity + visible evita renderizado innecesario cuando esta oculta.
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

        // ScrollView con contentWidth: availableWidth fuerza layout vertical.
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
                    text: "Multimedia Showcase"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // ---------------------------------------------------------
                // GridLayout 2x2: cada tarjeta demuestra un aspecto
                // diferente del modulo QtMultimedia (video, audio, camara,
                // y controles avanzados de reproduccion).
                // ---------------------------------------------------------
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    VideoPlayerCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    AudioPlayerCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    CameraCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    InteractiveMediaCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
