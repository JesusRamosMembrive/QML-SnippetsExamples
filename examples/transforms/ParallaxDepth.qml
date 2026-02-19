// =============================================================================
// ParallaxDepth.qml — Efecto parallax con capas a diferente velocidad
// =============================================================================
// Simula profundidad mediante el efecto parallax: objetos "lejanos" se
// mueven poco con el mouse, mientras que objetos "cercanos" se mueven mucho.
// Este efecto se usa en paginas web (parallax scrolling), juegos 2D
// (fondos de plataformas), y UIs premium para dar sensacion de capas.
//
// IMPLEMENTACION:
//   - MouseArea con hoverEnabled detecta la posicion del cursor.
//   - mx/my se normalizan a rango -1..+1 (centro = 0).
//   - 3 capas con multiplicadores de movimiento diferentes:
//     * Far (8px): objetos grandes, translucidos, se mueven poco.
//     * Mid (25px): objetos medianos con borde semi-visible.
//     * Near (50px): objetos pequenos, opacos, se mueven mucho.
//   - El multiplicador mas alto = mas movimiento = apariencia mas cercana.
//
// POR QUE FUNCIONA PERCEPTUALMENTE: en la vida real, al mover la cabeza,
// los objetos cercanos se desplazan mucho en nuestro campo visual mientras
// los lejanos apenas se mueven (parallax natural). Replicar esta relacion
// de velocidades engana al cerebro para percibir profundidad en 2D.
//
// onExited: cuando el cursor sale del area, mx/my se resetean a 0 para
// que las capas vuelvan a su posicion original.
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
        text: "2. Parallax Depth"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        id: parallaxContainer
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(220)
        color: "#0C1445"
        radius: Style.resize(6)
        clip: true

        property real mx: 0
        property real my: 0

        // Capa lejana (multiplicador bajo = poco movimiento).
        // Objetos grandes y translucidos para simular nebulosas o estrellas distantes.
        Rectangle {
            x: parallaxContainer.width * 0.72 + parallaxContainer.mx * 8
            y: parallaxContainer.height * 0.18 + parallaxContainer.my * 5
            width: Style.resize(60); height: width; radius: width / 2
            color: "#FFFFFF10"; border.color: "#FFFFFF30"; border.width: 1
        }
        Rectangle {
            x: parallaxContainer.width * 0.12 + parallaxContainer.mx * 8
            y: parallaxContainer.height * 0.55 + parallaxContainer.my * 5
            width: Style.resize(45); height: width; radius: width / 2
            color: "#9B59B610"; border.color: "#9B59B630"; border.width: 1
        }

        // Capa media (multiplicador medio = movimiento moderado).
        Rectangle {
            x: parallaxContainer.width * 0.35 + parallaxContainer.mx * 25
            y: parallaxContainer.height * 0.28 + parallaxContainer.my * 18
            width: Style.resize(80); height: Style.resize(50); radius: Style.resize(8)
            color: "#4A90D918"; border.color: "#4A90D950"; border.width: 1
        }
        Rectangle {
            x: parallaxContainer.width * 0.58 + parallaxContainer.mx * 25
            y: parallaxContainer.height * 0.52 + parallaxContainer.my * 18
            width: Style.resize(55); height: Style.resize(35); radius: Style.resize(6)
            color: "#00D1A918"; border.color: "#00D1A950"; border.width: 1
        }

        // Capa cercana (multiplicador alto = mucho movimiento).
        // Objetos pequenos, opacos y con borde visible para realzar la cercan.
        Rectangle {
            x: parallaxContainer.width * 0.22 + parallaxContainer.mx * 50
            y: parallaxContainer.height * 0.42 + parallaxContainer.my * 40
            width: Style.resize(30); height: width; radius: width / 2
            color: "#FF590035"; border.color: "#FF5900"; border.width: 1.5
        }
        Rectangle {
            x: parallaxContainer.width * 0.52 + parallaxContainer.mx * 50
            y: parallaxContainer.height * 0.65 + parallaxContainer.my * 40
            width: Style.resize(25); height: width; radius: width / 2
            color: "#FEA60135"; border.color: "#FEA601"; border.width: 1.5
        }
        Rectangle {
            x: parallaxContainer.width * 0.8 + parallaxContainer.mx * 50
            y: parallaxContainer.height * 0.22 + parallaxContainer.my * 40
            width: Style.resize(20); height: width; radius: width / 2
            color: "#E74C3C35"; border.color: "#E74C3C"; border.width: 1.5
        }

        // Depth labels
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.resize(6)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.resize(20)

            Label { text: "Far (0.05x)"; font.pixelSize: Style.resize(9); color: "#FFFFFF50" }
            Label { text: "Mid (0.15x)"; font.pixelSize: Style.resize(9); color: "#4A90D980" }
            Label { text: "Near (0.3x)"; font.pixelSize: Style.resize(9); color: "#FF590090" }
        }

        Label {
            anchors.top: parent.top
            anchors.topMargin: Style.resize(8)
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Move your mouse over this area"
            font.pixelSize: Style.resize(11)
            color: "#FFFFFF40"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: function(mouse) {
                parallaxContainer.mx = (mouse.x / parallaxContainer.width - 0.5) * 2
                parallaxContainer.my = (mouse.y / parallaxContainer.height - 0.5) * 2
            }
            onExited: { parallaxContainer.mx = 0; parallaxContainer.my = 0 }
        }
    }
}
