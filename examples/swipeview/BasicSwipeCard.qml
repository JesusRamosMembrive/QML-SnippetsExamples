// =============================================================================
// BasicSwipeCard.qml — SwipeView basico con botones de navegacion
// =============================================================================
// Demuestra el uso fundamental de SwipeView: un contenedor que permite
// deslizar horizontalmente entre varias paginas. El usuario puede navegar
// mediante gestos de swipe o con los botones Prev/Next.
//
// SwipeView es ideal para interfaces donde el contenido se divide en
// paginas secuenciales (onboarding, galerias, formularios multi-paso).
// A diferencia de StackLayout (que requiere TabBar), SwipeView soporta
// gestos tactiles de forma nativa.
//
// Aprendizaje clave: SwipeView.currentIndex se puede leer Y escribir.
// Leerlo da la pagina actual; escribirlo navega programaticamente.
// clip: true es necesario para evitar que las paginas adyacentes se
// dibujen fuera de los limites del SwipeView.
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
            text: "Basic SwipeView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // SwipeView con tres paginas estaticas.
        // Cada pagina es un Rectangle con un Label centrado. Los colores
        // distintos ayudan a visualizar el cambio de pagina.
        // clip: true es esencial — sin el, las paginas adyacentes serian
        // visibles durante la animacion de deslizamiento.
        // ---------------------------------------------------------------------
        SwipeView {
            id: basicSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 1"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: Style.mainColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 2"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: "#FEA601"
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 3"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: "#4FC3F7"
                }
            }
        }

        // ---------------------------------------------------------------------
        // Barra de navegacion con botones Prev/Next y contador de paginas.
        // enabled se vincula a los limites del indice para desactivar el boton
        // cuando no hay mas paginas en esa direccion. Los Items con
        // Layout.fillWidth actuan como espaciadores flexibles.
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "\u25C0 Prev"
                enabled: basicSwipe.currentIndex > 0
                onClicked: basicSwipe.currentIndex--
            }

            Item { Layout.fillWidth: true }

            Label {
                text: (basicSwipe.currentIndex + 1) + " / " + basicSwipe.count
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Next \u25B6"
                enabled: basicSwipe.currentIndex < basicSwipe.count - 1
                onClicked: basicSwipe.currentIndex++
            }
        }
    }
}
