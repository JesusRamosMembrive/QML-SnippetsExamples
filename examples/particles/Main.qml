// =============================================================================
// Main.qml — Pagina principal del modulo de Particles
// =============================================================================
// Punto de entrada para los ejemplos del sistema de particulas de Qt.
// Organiza cuatro tarjetas en un GridLayout 2x2, cada una demostrando un
// aspecto diferente: emisores basicos, affectors, trail emitters e
// interaccion con el mouse.
//
// Patron importante: cada tarjeta recibe la propiedad "active" vinculada a
// fullSize. Esto permite que los ParticleSystem internos solo corran cuando
// la pagina es visible, evitando consumo de CPU innecesario en background.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    // --- Patron de visibilidad animada ---
    // Todas las paginas del dashboard usan este patron: opacity controlada
    // por fullSize con animacion de 200ms. "visible: opacity > 0.0" evita
    // que el motor QML procese un item completamente transparente.
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

        // ScrollView permite scroll vertical cuando el contenido excede
        // el area visible. contentWidth: availableWidth fuerza que el
        // contenido respete el ancho del viewport (sin scroll horizontal).
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
                    text: "Particles Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // --- Grid de tarjetas de ejemplo ---
                // GridLayout 2x2 distribuye las tarjetas de forma uniforme.
                // Cada tarjeta tiene Layout.fillWidth/fillHeight para ocupar
                // todo el espacio disponible en su celda, con un minimumHeight
                // para garantizar espacio suficiente para el area de particulas.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BasicEmitterCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    AffectorsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    TrailEmitterCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    InteractiveParticlesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }
                }
            }
        }
    }
}
