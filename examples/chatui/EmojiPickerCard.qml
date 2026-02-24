// =============================================================================
// EmojiPickerCard.qml — Tarjeta de ejemplo: selector de emojis con categorias
// =============================================================================
// Implementa un picker de emojis con pestanas de categoria, una cuadricula
// interactiva (GridView) y un area de previsualizacion del emoji seleccionado.
//
// Patrones clave para el aprendiz:
// - Modelo como array de objetos JS: `categories` es un array de {name, emojis}
//   que alimenta tanto los botones de pestana como el GridView.
// - GridView con cellWidth calculado (width / 4) para crear una cuadricula
//   responsive que se adapta al ancho disponible.
// - Cambio dinamico de modelo: al cambiar categoryIndex, el GridView recibe
//   un nuevo array de emojis y se actualiza automaticamente.
// - Indicacion visual de seleccion: borde + fondo condicional en el delegate
//   cuando el emoji coincide con selectedEmoji.
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

    property string selectedEmoji: ""
    property int categoryIndex: 0

    // Datos del picker: cada categoria tiene nombre y array de caracteres
    // Unicode. Se usa readonly porque los datos son constantes.
    readonly property var categories: [
        { name: "Faces",   emojis: ["\u263A", "\u2639", "\u2764", "\u2605", "\u263B", "\u2666", "\u2663", "\u2660", "\u2665", "\u266A", "\u266B", "\u2602"] },
        { name: "Symbols", emojis: ["\u2713", "\u2715", "\u2726", "\u2728", "\u2699", "\u26A1", "\u2600", "\u2601", "\u2614", "\u2708", "\u2693", "\u2692"] },
        { name: "Arrows",  emojis: ["\u2190", "\u2191", "\u2192", "\u2193", "\u2194", "\u2195", "\u21BB", "\u21BA", "\u2196", "\u2197", "\u2198", "\u2199"] },
        { name: "Shapes",  emojis: ["\u25A0", "\u25A1", "\u25B2", "\u25B3", "\u25C6", "\u25C7", "\u25CB", "\u25CF", "\u25D0", "\u25D1", "\u2B22", "\u2B23"] }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Emoji Picker"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Area de previsualizacion: muestra el emoji seleccionado a gran
        // tamano, o un placeholder invitando a elegir uno. El operador ||
        // en JS actua como fallback si selectedEmoji esta vacio.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(50)
            radius: Style.resize(8)
            color: Style.surfaceColor

            RowLayout {
                anchors.centerIn: parent
                spacing: Style.resize(10)

                Label {
                    text: root.selectedEmoji || "?"
                    font.pixelSize: Style.resize(30)
                    color: root.selectedEmoji ? Style.fontPrimaryColor : Style.inactiveColor
                }
                Label {
                    text: root.selectedEmoji ? "Selected!" : "Pick an emoji below"
                    font.pixelSize: Style.resize(14)
                    color: root.selectedEmoji ? Style.mainColor : Style.inactiveColor
                }
            }
        }

        // -----------------------------------------------------------------
        // Pestanas de categoria: se generan con Repeater sobre el array
        // categories. `highlighted` activa el estilo visual del boton
        // activo (definido en qmlsnippetsstyle).
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Repeater {
                model: root.categories

                Button {
                    required property var modelData
                    required property int index
                    text: modelData.name
                    font.pixelSize: Style.resize(10)
                    highlighted: root.categoryIndex === index
                    Layout.fillWidth: true
                    onClicked: root.categoryIndex = index
                }
            }
        }

        // -----------------------------------------------------------------
        // Cuadricula de emojis: GridView con 4 columnas (cellWidth = w/4).
        // Al cambiar categoryIndex, el modelo se re-evalua automaticamente
        // gracias al binding root.categories[root.categoryIndex].emojis.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            GridView {
                id: emojiGrid
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                cellWidth: width / 4
                cellHeight: cellWidth

                model: root.categories[root.categoryIndex].emojis

                delegate: Item {
                    required property string modelData
                    required property int index
                    width: emojiGrid.cellWidth
                    height: emojiGrid.cellHeight

                    // Cada celda resalta con borde teal cuando esta
                    // seleccionada, proporcionando feedback visual inmediato.
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(8)
                        color: root.selectedEmoji === parent.modelData ? "#1A3A35" : "transparent"
                        border.color: root.selectedEmoji === parent.modelData ? "#00D1A9" : "transparent"
                        border.width: Style.resize(1)

                        Label {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: Style.resize(24)
                            color: Style.fontPrimaryColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.selectedEmoji = modelData
                        }
                    }
                }
            }
        }
    }
}
