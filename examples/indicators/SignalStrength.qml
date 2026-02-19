// =============================================================================
// SignalStrength.qml — Indicador de intensidad de senal tipo WiFi/celular
// =============================================================================
// Muestra 6 niveles de senal (Excellent a None) con barras escalonadas, como
// los iconos de senal de un telefono movil. Cada nivel muestra 5 barras
// donde las activas se colorean y las inactivas quedan en gris translucido.
//
// Patrones clave:
//   - Repeater anidados: el exterior itera sobre los 6 niveles de senal,
//     el interior genera las 5 barras de cada indicador. Esto demuestra
//     como componer layouts complejos con datos declarativos.
//   - Modelo como array de objetos JS: en vez de un ListModel, el Repeater
//     usa un array literal con {bars, label, clr}. Es mas conciso para
//     datos estaticos y permite acceder via modelData.
//   - "required property" en delegates: patron de Qt 6 que reemplaza el
//     acceso implicito a model.xxx, es mas explicito y seguro con tipos.
//   - Altura proporcional al indice: height = 10 + index * 8 crea el
//     efecto escalonado clasico de las barras de senal.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Signal Strength"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(40)
        Layout.alignment: Qt.AlignHCenter

        // ── Repeater externo: un grupo de barras por cada nivel ──
        // Cada objeto del modelo define cuantas barras estan activas (bars),
        // la etiqueta descriptiva y el color correspondiente.
        Repeater {
            model: [
                { bars: 5, label: "Excellent", clr: "#34C759" },
                { bars: 4, label: "Good", clr: "#34C759" },
                { bars: 3, label: "Fair", clr: "#FF9500" },
                { bars: 2, label: "Weak", clr: "#FF9500" },
                { bars: 1, label: "Poor", clr: "#FF3B30" },
                { bars: 0, label: "None", clr: "#FF3B30" }
            ]

            delegate: ColumnLayout {
                id: signalDelegate
                spacing: Style.resize(8)

                required property var modelData
                required property int index

                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Style.resize(3)

                    // ── Repeater interno: las 5 barras de cada indicador ──
                    // La condicion index < bars determina si la barra esta
                    // activa (coloreada) o inactiva (translucida).
                    // anchors.bottom alinea todas al pie para el efecto escalonado.
                    Repeater {
                        model: 5
                        delegate: Rectangle {
                            id: signalBar

                            required property int index

                            width: Style.resize(8)
                            height: Style.resize(10 + index * 8)
                            radius: Style.resize(2)
                            anchors.bottom: parent.bottom
                            color: signalBar.index < signalDelegate.modelData.bars
                                   ? signalDelegate.modelData.clr
                                   : Qt.rgba(1, 1, 1, 0.1)

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }
                        }
                    }
                }

                Label {
                    text: signalDelegate.modelData.label
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
