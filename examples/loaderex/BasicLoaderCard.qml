// =============================================================================
// BasicLoaderCard.qml — Loader con cambio de sourceComponent
// =============================================================================
// Demuestra el uso más básico del Loader: cambiar sourceComponent para
// intercambiar entre distintas vistas. Cuando sourceComponent cambia, el
// Loader destruye el componente anterior, libera su memoria y crea el nuevo.
//
// Conceptos clave:
// - Component {} define un "template" que no se instancia hasta que se asigna
//   al Loader. Esto es carga diferida (lazy loading).
// - onStatusChanged permite detectar cuándo el componente está listo y
//   aplicar animaciones de entrada.
// - Qt.hsla() genera colores dinámicamente usando el modelo HSL, ideal para
//   crear paletas de colores programáticas (variando el hue).
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedIndex: 0

    // ---- Componentes inline para cargar ----
    // Se definen tres Component {} como "templates" reutilizables.
    // No se instancian hasta que el Loader los necesita.
    // Cada uno muestra un patrón visual diferente para que el cambio
    // sea visualmente evidente.

    // Componente 1: Fila de círculos con colores HSL
    Component {
        id: circlesComp

        Row {
            spacing: Style.resize(10)
            anchors.centerIn: parent
            Repeater {
                model: 5
                Rectangle {
                    required property int index
                    width: Style.resize(45)
                    height: Style.resize(45)
                    radius: Style.resize(22.5)
                    color: Qt.hsla(index / 5.0, 0.7, 0.5, 1.0)
                    Label {
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }

    // Componente 2: Grid 3×3 de cuadrados coloreados
    Component {
        id: squaresComp

        Grid {
            columns: 3
            spacing: Style.resize(8)
            anchors.centerIn: parent
            Repeater {
                model: 9
                Rectangle {
                    required property int index
                    width: Style.resize(40)
                    height: Style.resize(40)
                    radius: Style.resize(6)
                    color: Qt.hsla(index / 9.0, 0.6, 0.45, 1.0)
                }
            }
        }
    }

    // Componente 3: Layout de texto centrado
    Component {
        id: textComp

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(8)
            Label {
                text: "\u2605"
                font.pixelSize: Style.resize(48)
                color: Style.mainColor
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "Text Component"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.fontPrimaryColor
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "Loaded dynamically via Loader"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic Loader"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Switch sourceComponent to load different views"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // ---- Área del Loader ----
        // El Loader ocupa todo el espacio disponible. sourceComponent se
        // selecciona con un operador ternario encadenado basado en selectedIndex.
        // Cuando el componente cambia, onStatusChanged dispara una animación
        // de fade-in: primero se pone opacity = 0 al item recién creado,
        // y luego se anima a 1. Esto da feedback visual del cambio.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: basicLoader
                anchors.fill: parent
                sourceComponent: root.selectedIndex === 0 ? circlesComp
                               : root.selectedIndex === 1 ? squaresComp
                               : textComp

                onStatusChanged: {
                    if (status === Loader.Ready && item) {
                        item.opacity = 0
                        fadeIn.start()
                    }
                }

                NumberAnimation {
                    id: fadeIn
                    target: basicLoader.item
                    property: "opacity"
                    from: 0; to: 1; duration: 200
                }
            }
        }

        // ---- Botones de selección ----
        // Repeater genera un botón por cada opción. "highlighted" marca
        // visualmente cuál está seleccionado (usa el estilo del proyecto).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Repeater {
                model: ["Circles", "Grid", "Text"]

                Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    highlighted: root.selectedIndex === index
                    onClicked: root.selectedIndex = index
                }
            }
        }
    }
}
