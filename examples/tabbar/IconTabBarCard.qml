// =============================================================================
// IconTabBarCard.qml — TabBar con iconos Unicode
// =============================================================================
// Demuestra como enriquecer visualmente un TabBar usando caracteres Unicode
// como sustitutos de iconos reales. Esta tecnica es util para prototipos
// rapidos donde no se dispone de assets graficos.
//
// Cada pestana muestra un icono Unicode junto al texto. En el contenido del
// StackLayout, el mismo icono se repite en tamano grande para reforzar la
// identidad visual de cada seccion. Los colores varian por seccion para
// mostrar como personalizar la apariencia de cada pagina.
//
// Aprendizaje clave: los caracteres Unicode (\u2302, \u2709, \u2605, \u2699)
// son una alternativa rapida a iconos de imagen cuando se necesita prototipar.
// =============================================================================
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
            text: "Tabs with Icons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // TabBar con iconos Unicode integrados en el texto.
        // Se usa la concatenacion "icono + espacio + texto" directamente en la
        // propiedad text. Es una solucion rapida, aunque para produccion se
        // recomienda usar TabButton con icon.source o contentItem personalizado.
        // ---------------------------------------------------------------------
        TabBar {
            id: iconTabBar
            Layout.fillWidth: true

            TabButton {
                text: "\u2302  Home"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2709  Messages"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2605  Favorites"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2699  Config"
                font.pixelSize: Style.resize(14)
            }
        }

        // ---------------------------------------------------------------------
        // Contenido de cada pestana: icono grande + texto descriptivo.
        // Cada seccion tiene un color de icono distinto para mostrar que se
        // puede personalizar la apariencia por pestana. El Layout.alignment
        // centra los elementos horizontal y verticalmente.
        // ---------------------------------------------------------------------
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: iconTabBar.currentIndex

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2302"; font.pixelSize: Style.resize(40); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Welcome Home"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2709"; font.pixelSize: Style.resize(40); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "3 new messages"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2605"; font.pixelSize: Style.resize(40); color: "#FEA601"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Your favorites list"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2699"; font.pixelSize: Style.resize(40); color: Style.inactiveColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Configuration panel"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }
}
