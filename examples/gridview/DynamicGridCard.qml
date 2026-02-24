// =============================================================================
// DynamicGridCard.qml — GridView dinámico con agregar/eliminar y transiciones
// =============================================================================
// Demuestra la modificación dinámica de un ListModel y cómo GridView anima
// automáticamente las inserciones y eliminaciones usando Transition.
//
// Conceptos clave:
// - ListModel.append() / remove(): añadir y quitar items del modelo.
//   GridView detecta estos cambios automáticamente y actualiza la vista.
// - add Transition / remove Transition: animaciones que GridView ejecuta
//   cuando se insertan o eliminan items. Son opcionales pero mejoran
//   mucho la experiencia de usuario.
// - cellWidth vinculado a un Slider: demuestra que GridView se re-distribuye
//   dinámicamente cuando cambian las dimensiones de celda.
// - Component.onCompleted en el modelo: inicialización imperativa del
//   ListModel, útil cuando los datos iniciales se generan con lógica.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Contador para asignar IDs únicos a cada item nuevo.
    // Empieza en 13 porque el modelo inicial tiene 12 items.
    property int nextId: 13

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Grid"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: dynGrid
                anchors.fill: parent
                clip: true
                // ---- Tamaño de celda dinámico ----
                // Vinculado al Slider, permite cambiar el tamaño en tiempo
                // real. GridView recalcula el layout automáticamente.
                cellWidth: Style.resize(cellSlider.value)
                cellHeight: cellWidth

                // Modelo inicial generado con un bucle en Component.onCompleted.
                // Se usa un array de colores predefinidos para un resultado
                // visual atractivo.
                model: ListModel {
                    id: dynModel
                    Component.onCompleted: {
                        var colors = ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043",
                                      "#AB47BC", "#EC407A", "#66BB6A", "#00599C",
                                      "#F7DF1E", "#064F8C", "#F05032", "#264DE4"]
                        for (var i = 0; i < 12; i++)
                            append({ itemId: i + 1, clr: colors[i] })
                    }
                }

                // ---- Transiciones de inserción/eliminación ----
                // add: los items nuevos aparecen con fade-in + scale-up.
                // remove: los items eliminados desaparecen con fade-out + scale-down.
                // GridView ejecuta estas transiciones automáticamente cuando
                // el ListModel cambia. Ambas animaciones corren en paralelo
                // (opacity y scale al mismo tiempo).
                add: Transition {
                    NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 200 }
                    NumberAnimation { properties: "scale"; from: 0.5; to: 1; duration: 200 }
                }
                remove: Transition {
                    NumberAnimation { properties: "opacity"; to: 0; duration: 200 }
                    NumberAnimation { properties: "scale"; to: 0.5; duration: 200 }
                }

                delegate: Item {
                    id: dynDelegate
                    required property int itemId
                    required property string clr
                    required property int index
                    width: dynGrid.cellWidth
                    height: dynGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(2)
                        radius: Style.resize(6)
                        color: dynDelegate.clr

                        Label {
                            anchors.centerIn: parent
                            text: dynDelegate.itemId.toString()
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        // ---- Botón de eliminar por item ----
                        // Pequeño círculo rojo en la esquina superior derecha.
                        // dynModel.remove(index) elimina el item del modelo,
                        // lo que dispara la remove Transition automáticamente.
                        Rectangle {
                            width: Style.resize(16)
                            height: Style.resize(16)
                            radius: Style.resize(8)
                            color: "#C62828"
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: Style.resize(3)

                            Label {
                                anchors.centerIn: parent
                                text: "\u2715"
                                font.pixelSize: Style.resize(9)
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: dynModel.remove(dynDelegate.index)
                            }
                        }
                    }
                }
            }
        }

        // ---- Controles ----
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            // Slider para ajustar el tamaño de las celdas en tiempo real.
            // Rango 50–120 px (escalado con Style.resize).
            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Size: " + cellSlider.value.toFixed(0)
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(70)
                }
                Slider {
                    id: cellSlider
                    Layout.fillWidth: true
                    from: 50; to: 120; value: 70
                }
            }

            // Botón para agregar items. El color se selecciona cíclicamente
            // con el operador módulo (%) sobre un array de colores.
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(10)

                Button {
                    text: "Add Item"
                    onClicked: {
                        var clrs = ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043", "#AB47BC", "#EC407A"]
                        dynModel.append({ itemId: root.nextId, clr: clrs[root.nextId % clrs.length] })
                        root.nextId++
                    }
                }

                Label {
                    text: dynModel.count + " items"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
