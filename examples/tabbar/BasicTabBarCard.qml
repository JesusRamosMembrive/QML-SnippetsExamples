// =============================================================================
// BasicTabBarCard.qml — TabBar basico con StackLayout
// =============================================================================
// Demuestra el patron fundamental de navegacion por pestanas en QML:
// un TabBar vinculado a un StackLayout mediante currentIndex.
//
// El TabBar genera los TabButtons y gestiona cual esta seleccionado.
// El StackLayout muestra solo el hijo cuyo indice coincide con currentIndex,
// ocultando automaticamente los demas. Esta vinculacion bidireccional es el
// nucleo de cualquier interfaz con pestanas en Qt Quick.
//
// Aprendizaje clave: TabBar + StackLayout es el patron canonico para
// navegacion por pestanas. Solo se necesita enlazar currentIndex.
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
            text: "Basic TabBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // TabBar con tres pestanas estaticas.
        // Cada TabButton define una pestana. El TabBar gestiona internamente
        // cual esta activa via currentIndex. No necesitamos logica adicional.
        // ---------------------------------------------------------------------
        TabBar {
            id: basicTabBar
            Layout.fillWidth: true

            TabButton { text: "Home" }
            TabButton { text: "Profile" }
            TabButton { text: "Settings" }
        }

        // ---------------------------------------------------------------------
        // StackLayout: muestra solo UN hijo a la vez segun currentIndex.
        // Al vincular currentIndex con basicTabBar.currentIndex, el contenido
        // cambia automaticamente al pulsar una pestana. Cada Rectangle
        // representa el contenido de una pestana.
        // ---------------------------------------------------------------------
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: basicTabBar.currentIndex

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Home content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Profile content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Settings content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }
        }

        // Indicador de estado: muestra el indice actual para fines didacticos
        Label {
            text: "Current tab index: " + basicTabBar.currentIndex
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
        }
    }
}
