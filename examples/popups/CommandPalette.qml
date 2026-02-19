// ============================================================================
// CommandPalette - Patron avanzado de popup tipo VS Code
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Popup manual vs Dialog:
//    - A diferencia de Dialog (que viene con titulo, botones y overlay
//      predeterminados), aqui se construye un popup desde cero usando
//      Rectangles, animaciones y MouseArea.
//    - Esto da control total sobre la apariencia y el comportamiento,
//      ideal para interfaces avanzadas como Command Palettes.
//
// 2. Capas de overlay (patron de apilamiento):
//    - Capa 1: Contenido de fondo (boton "Open" y comando seleccionado).
//    - Capa 2: Overlay semitransparente (Rectangle con Qt.rgba(0,0,0,0.5))
//      que oscurece el fondo y captura clics para cerrar.
//    - Capa 3: Panel de la paleta con bordes, busqueda y resultados.
//    - Las capas se apilan por orden de declaracion (ultimo = encima).
//
// 3. Animacion de entrada/salida:
//    - El panel usa anchors.topMargin animado: cuando esta cerrado,
//      topMargin = -height (fuera de la vista por arriba).
//    - Cuando se abre, topMargin = 20 (desliza hacia abajo).
//    - Easing.OutCubic da una desaceleracion natural al final.
//    - El overlay usa opacidad animada (150ms) para un fade suave.
//
// 4. Filtrado reactivo en el modelo de ListView:
//    - El modelo de ListView es un binding (expresion entre {}), NO un
//      modelo estatico. Cada vez que paletteSearchField.text cambia,
//      el binding se reevalua y genera un nuevo array filtrado.
//    - indexOf() busca coincidencias parciales en nombre y categoria.
//    - NOTA: este enfoque es adecuado para listas pequenas. Para miles
//      de items, seria mejor usar QSortFilterProxyModel en C++.
//
// 5. Placeholder personalizado con TextInput:
//    - TextInput (QtQuick) no tiene placeholderText como TextField (Controls).
//    - Se simula con un Text superpuesto que se oculta cuando hay texto
//      o cuando el campo tiene foco activo.
//
// 6. Hover + seleccion con teclado:
//    - currentIndex de ListView resalta el item "activo".
//    - MouseArea con hoverEnabled actualiza currentIndex al pasar el mouse.
//    - Esto combina navegacion por teclado (flechas) y por mouse,
//      como en editores de codigo modernos.
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Command Palette"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: paletteSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(350)
        clip: true

        property bool paletteOpen: false
        property string selectedCmd: ""

        // Lista de comandos definidos como array de objetos JS.
        // Cada comando tiene: nombre, atajo de teclado, icono y categoria.
        // readonly evita modificaciones accidentales.
        readonly property var commands: [
            { cmd: "Open File", shortcut: "Ctrl+O", icon: "📂", cat: "File" },
            { cmd: "Save", shortcut: "Ctrl+S", icon: "💾", cat: "File" },
            { cmd: "Find & Replace", shortcut: "Ctrl+H", icon: "🔍", cat: "Edit" },
            { cmd: "Toggle Terminal", shortcut: "Ctrl+`", icon: "▸", cat: "View" },
            { cmd: "Go to Definition", shortcut: "F12", icon: "→", cat: "Navigate" },
            { cmd: "Run Build", shortcut: "Ctrl+B", icon: "⚙", cat: "Build" },
            { cmd: "Git Commit", shortcut: "Ctrl+K", icon: "✓", cat: "Git" },
            { cmd: "Toggle Sidebar", shortcut: "Ctrl+B", icon: "◧", cat: "View" },
            { cmd: "Format Document", shortcut: "Alt+F", icon: "✎", cat: "Edit" },
            { cmd: "Debug Start", shortcut: "F5", icon: "▶", cat: "Debug" }
        ]

        // --- CAPA 1: Fondo con contenido principal ---
        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Contenido visible cuando la paleta esta cerrada:
        // muestra el ultimo comando seleccionado y el boton para abrirla.
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(12)

            Label {
                text: paletteSection.selectedCmd || "No command selected"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Open Command Palette"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    paletteSection.paletteOpen = true
                    paletteSearchField.text = ""
                    paletteSearchField.forceActiveFocus()
                }
            }
        }

        // --- CAPA 2: Overlay semitransparente ---
        // Oscurece el fondo y captura clics para cerrar la paleta.
        // visible se vincula a opacity > 0 para evitar capturar eventos
        // cuando el overlay es completamente transparente.
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.5)
            opacity: paletteSection.paletteOpen ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                onClicked: paletteSection.paletteOpen = false
            }
        }

        // --- CAPA 3: Panel de la paleta de comandos ---
        // Se desliza desde arriba con animacion OutCubic.
        // Cuando esta cerrado, topMargin = -height lo posiciona fuera de vista.
        Rectangle {
            id: palettePanel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: paletteSection.paletteOpen ? Style.resize(20) : -height
            width: parent.width * 0.8
            height: Style.resize(290)
            radius: Style.resize(12)
            color: Style.cardColor
            border.color: Style.mainColor
            border.width: Style.resize(1)

            // Animacion de deslizamiento vertical con desaceleracion natural
            Behavior on anchors.topMargin {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                spacing: Style.resize(8)

                // Campo de busqueda: TextInput raw (no TextField de Controls)
                // para mayor control visual. El placeholder se simula manualmente.
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(36)
                    radius: Style.resize(8)
                    color: Style.bgColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(8)
                        spacing: Style.resize(8)

                        // Prompt visual ">" al estilo VS Code
                        Label {
                            text: ">"
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: Style.mainColor
                        }

                        TextInput {
                            id: paletteSearchField
                            Layout.fillWidth: true
                            font.pixelSize: Style.resize(13)
                            font.family: Style.fontFamilyRegular
                            color: Style.fontPrimaryColor
                            clip: true
                            selectByMouse: true

                            // Placeholder manual: Text superpuesto que se oculta
                            // cuando hay texto escrito o el campo tiene foco.
                            Text {
                                anchors.fill: parent
                                text: "Type a command..."
                                font: parent.font
                                color: Style.inactiveColor
                                visible: !parent.text && !parent.activeFocus
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                // Lista de resultados filtrados.
                // El modelo es un binding reactivo: se recalcula cada vez
                // que cambia el texto de busqueda. Filtra por nombre de
                // comando y categoria usando indexOf (busqueda parcial).
                ListView {
                    id: paletteResults
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: Style.resize(2)
                    currentIndex: 0

                    model: {
                        var filter = paletteSearchField.text.toLowerCase()
                        var results = []
                        for (var i = 0; i < paletteSection.commands.length; i++) {
                            var c = paletteSection.commands[i]
                            if (!filter || c.cmd.toLowerCase().indexOf(filter) >= 0
                                || c.cat.toLowerCase().indexOf(filter) >= 0) {
                                results.push(c)
                            }
                        }
                        return results
                    }

                    delegate: Rectangle {
                        id: cmdItem
                        required property var modelData
                        required property int index

                        width: paletteResults.width
                        height: Style.resize(34)
                        radius: Style.resize(6)

                        // Color condicional: seleccionado > hover > transparente.
                        // Qt.rgba() permite colores con opacidad para efectos sutiles.
                        color: paletteResults.currentIndex === cmdItem.index
                               ? Qt.rgba(0, 0.82, 0.66, 0.1)
                               : cmdHoverMa.containsMouse
                                 ? Qt.rgba(1, 1, 1, 0.04)
                                 : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(10)
                            anchors.rightMargin: Style.resize(10)
                            spacing: Style.resize(8)

                            Label {
                                text: cmdItem.modelData.icon
                                font.pixelSize: Style.resize(14)
                            }

                            Label {
                                text: cmdItem.modelData.cmd
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }

                            // Badge de categoria con fondo sutil
                            Rectangle {
                                width: catLabel.implicitWidth + Style.resize(10)
                                height: Style.resize(18)
                                radius: Style.resize(3)
                                color: Qt.rgba(1, 1, 1, 0.06)

                                Label {
                                    id: catLabel
                                    anchors.centerIn: parent
                                    text: cmdItem.modelData.cat
                                    font.pixelSize: Style.resize(9)
                                    color: Style.inactiveColor
                                }
                            }

                            // Atajo de teclado en fuente monoespaciada
                            Label {
                                text: cmdItem.modelData.shortcut
                                font.pixelSize: Style.resize(10)
                                font.family: "monospace"
                                color: Style.inactiveColor
                            }
                        }

                        // MouseArea con hover: actualiza currentIndex al pasar
                        // el mouse, combinando navegacion por teclado y mouse.
                        // cursorShape cambia el cursor a mano para indicar clickable.
                        MouseArea {
                            id: cmdHoverMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                paletteSection.selectedCmd = "Executed: " + cmdItem.modelData.cmd
                                paletteSection.paletteOpen = false
                            }
                            onEntered: paletteResults.currentIndex = cmdItem.index
                        }
                    }
                }

                // Pie de la paleta: conteo de resultados + hints de teclado
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Label {
                        text: paletteResults.count + " commands"
                        font.pixelSize: Style.resize(10)
                        color: Style.inactiveColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "↑↓ Navigate   ↵ Select   Esc Close"
                        font.pixelSize: Style.resize(10)
                        color: Style.inactiveColor
                    }
                }
            }
        }
    }
}
