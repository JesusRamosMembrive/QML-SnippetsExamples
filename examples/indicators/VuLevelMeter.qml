// =============================================================================
// VuLevelMeter.qml — Medidor de nivel VU animado (estilo ecualizador)
// =============================================================================
// Simula un ecualizador de audio de 20 bandas con 10 segmentos cada una.
// Los niveles fluctuan aleatoriamente con un Timer rapido (100ms) creando
// una animacion tipo visualizacion de musica.
//
// Patrones clave:
//   - Array como modelo reactivo: vuMeterItem.levels es un array JS que se
//     reemplaza completamente en cada tick del Timer. QML detecta el cambio
//     de referencia del array y actualiza los bindings de los delegates.
//   - Repeater doble anidado: el externo crea 20 columnas (bandas), el
//     interno crea 10 segmentos por columna. Combinados = 200 Rectangles.
//   - Inversion de indice (segIndex = 9 - index): los segmentos se apilan
//     de abajo hacia arriba en Column, pero la logica necesita que el
//     segmento 0 sea el inferior. La inversion resuelve esta discordancia.
//   - Zonas de color por altura: verde (0-5), naranja (6-7), rojo (8-9).
//     Simula los niveles de un VU-metro real (normal → pico → clipping).
//   - Behavior con duracion corta (80ms): transiciones suaves pero rapidas,
//     para que los segmentos no parpadeen bruscamente pero tampoco se
//     queden atras de la actualizacion del Timer.
//   - Patron de activacion: active=false detiene el Timer cuando la pagina
//     no esta visible, evitando 200 actualizaciones de color innecesarias
//     cada 100ms.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false

    Label {
        text: "VU Level Meter"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: vuMeterItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(100)

        // Array de 20 niveles (0.0 a 1.0), uno por banda del ecualizador.
        // Se inicializa con valores variados para un aspecto natural.
        property list<real> levels: [0.6, 0.8, 0.5, 0.9, 0.3, 0.7, 0.65, 0.85,
                              0.4, 0.75, 0.55, 0.7, 0.6, 0.45, 0.8, 0.5,
                              0.9, 0.35, 0.65, 0.7]

        // ── Timer de simulacion de audio ──
        // Cada 100ms genera nuevos niveles basados en el anterior + ruido.
        // El sesgo (-0.48 en vez de -0.5) hace que los niveles tiendan
        // ligeramente a subir, simulando un audio con energia constante.
        Timer {
            id: vuTimer
            running: root.active
            interval: 100
            repeat: true
            onTriggered: {
                var newLevels = []
                for (var i = 0; i < vuRepeater.count; i++) {
                    var prev = vuMeterItem.levels[i] || 0.5
                    var next = Math.max(0.05, Math.min(1.0,
                        prev + (Math.random() - 0.48) * 0.3))
                    newLevels.push(next)
                }
                vuMeterItem.levels = newLevels
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: Style.resize(4)

            // ── 20 bandas de frecuencia ──
            Repeater {
                id: vuRepeater
                model: 20

                delegate: Item {
                    id: vuBar
                    required property int index

                    width: Style.resize(16)
                    height: Style.resize(80)

                    property real level: vuMeterItem.levels[vuBar.index] || 0.5

                    Column {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        spacing: Style.resize(2)

                        // ── 10 segmentos por banda ──
                        // Cada segmento se enciende o apaga segun el nivel.
                        // segIndex invierte el orden: Column apila de arriba
                        // a abajo, pero queremos que el segmento 0 sea el
                        // inferior (el primero en encenderse).
                        Repeater {
                            model: 10

                            delegate: Rectangle {
                                id: vuSegment
                                required property int index

                                readonly property int segIndex: 9 - vuSegment.index
                                readonly property bool active:
                                    segIndex < Math.round(vuBar.level * 10)

                                width: vuBar.width
                                height: Style.resize(5)
                                radius: Style.resize(1)

                                // Color por zona: verde (normal), naranja (alto), rojo (pico)
                                color: !active ? Qt.rgba(1, 1, 1, 0.06)
                                     : segIndex >= 8 ? "#FF3B30"
                                     : segIndex >= 6 ? "#FF9500"
                                     : "#34C759"

                                opacity: active ? 1.0 : 0.4

                                Behavior on color {
                                    ColorAnimation { duration: 80 }
                                }
                                Behavior on opacity {
                                    NumberAnimation { duration: 80 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
