// ============================================================================
// StandardButtonsCard.qml
// Concepto: Uso basico del componente Button de Qt Quick Controls 2.
//
// Button es el control mas fundamental de interaccion. Qt Quick Controls 2
// proporciona varias propiedades para personalizar su apariencia sin necesidad
// de crear componentes custom:
//   - text: el texto visible del boton
//   - highlighted: indica que es la accion principal (visualmente mas prominente)
//   - flat: elimina el fondo, util para acciones secundarias o barras de herramientas
//   - enabled: controla si el boton responde a interaccion del usuario
//
// La apariencia final depende del estilo activo (en este proyecto: qmlsnippetsstyle).
// Cada estilo define como se ven estas variantes en sus archivos Button.qml.
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Standard Buttons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // RowLayout distribuye los botones horizontalmente con espaciado uniforme.
        // Layout.preferredWidth/Height en cada boton establece un tamano sugerido
        // que el layout respeta siempre que haya espacio disponible.
        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            // Boton por defecto: sin propiedades extra, usa el estilo base
            Button {
                text: "Default"
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            // highlighted: true marca este boton como accion principal.
            // El estilo lo renderiza con colores mas vivos y texto en negrita.
            Button {
                text: "Highlighted"
                highlighted: true
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            // flat: true elimina el fondo del boton, dejando solo el texto.
            // Ideal para acciones secundarias donde no se quiere competir visualmente.
            Button {
                text: "Flat Button"
                flat: true
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }

            // enabled: false deshabilita toda interaccion (click, hover, focus).
            // El estilo aplica automaticamente una apariencia atenuada.
            Button {
                text: "Disabled"
                enabled: false
                Layout.preferredWidth: Style.resize(130)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            text: "flat: no background · highlighted: brighter + bold · disabled: grayed out"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.topMargin: Style.resize(10)
        }
    }
}
