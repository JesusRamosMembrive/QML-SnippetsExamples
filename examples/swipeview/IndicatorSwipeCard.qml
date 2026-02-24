// =============================================================================
// IndicatorSwipeCard.qml — SwipeView con dos estilos de PageIndicator
// =============================================================================
// Demuestra como acompanar un SwipeView con indicadores visuales de pagina.
// Presenta dos variantes:
//   1. Indicador de puntos (dots) — el estilo clasico con delegate personalizado
//   2. Indicador de barras (bars) — mas moderno, la barra activa se expande
//
// Ambos indicadores son interactivos: se puede hacer clic en ellos para
// navegar directamente a una pagina. Las transiciones usan Behavior para
// animar el cambio de color, opacidad y ancho.
//
// Aprendizaje clave: PageIndicator acepta un delegate personalizado para
// modificar completamente la apariencia de cada punto. El estilo "bar"
// se construye manualmente con Repeater + Rectangle porque requiere
// animacion de ancho que PageIndicator no soporta nativamente.
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

    // Paleta de colores para las paginas, usada tanto en los circulos
    // de contenido como potencialmente en los indicadores
    readonly property list<color> pageColors: ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043", "#AB47BC"]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "PageIndicator Styles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // SwipeView con 5 paginas generadas via Repeater.
        // Usar Repeater dentro de SwipeView es mas limpio que declarar
        // 5 Rectangles manualmente. Cada pagina muestra un circulo de color
        // con su numero para facilitar la identificacion visual.
        // ---------------------------------------------------------------------
        SwipeView {
            id: indicatorSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Repeater {
                model: 5
                Rectangle {
                    required property int index
                    color: Style.bgColor
                    radius: Style.resize(6)

                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(80)
                        height: Style.resize(80)
                        radius: Style.resize(40)
                        color: root.pageColors[index]
                        opacity: 0.8

                        Label {
                            anchors.centerIn: parent
                            text: (index + 1).toString()
                            font.pixelSize: Style.resize(28)
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Estilo 1: PageIndicator con delegate de puntos personalizados.
        // interactive: true permite hacer clic en los puntos para navegar.
        // El delegate reemplaza los puntos por defecto con Rectangles
        // circulares que cambian color y opacidad segun si estan activos.
        // onCurrentIndexChanged sincroniza el indicador con el SwipeView.
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Default"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            PageIndicator {
                id: defaultIndicator
                count: indicatorSwipe.count
                currentIndex: indicatorSwipe.currentIndex
                interactive: true
                Layout.alignment: Qt.AlignHCenter
                onCurrentIndexChanged: indicatorSwipe.currentIndex = currentIndex

                delegate: Rectangle {
                    required property int index
                    implicitWidth: Style.resize(10)
                    implicitHeight: Style.resize(10)
                    radius: width / 2
                    color: index === defaultIndicator.currentIndex ? Style.mainColor : Style.inactiveColor
                    opacity: index === defaultIndicator.currentIndex ? 1.0 : 0.4

                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Estilo 2: Indicador tipo "barra" construido manualmente.
        // Se usa Repeater + Row en lugar de PageIndicator porque necesitamos
        // animar el ancho: la barra activa se expande (28px vs 12px).
        // Cada barra tiene un MouseArea para hacerla clicable, replicando
        // la funcionalidad de interactive: true de PageIndicator.
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Bar style (interactive)"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(4)

                Repeater {
                    model: indicatorSwipe.count
                    Rectangle {
                        required property int index
                        width: index === indicatorSwipe.currentIndex ? Style.resize(28) : Style.resize(12)
                        height: Style.resize(5)
                        radius: Style.resize(3)
                        color: index === indicatorSwipe.currentIndex ? Style.mainColor : Style.inactiveColor

                        Behavior on width { NumberAnimation { duration: 200 } }
                        Behavior on color { ColorAnimation { duration: 200 } }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: indicatorSwipe.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}
