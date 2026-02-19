// =============================================================================
// DynamicCreationCard.qml — Creación dinámica con Component.createObject()
// =============================================================================
// Demuestra la creación imperativa de objetos QML en tiempo de ejecución
// usando Component.createObject(). A diferencia del Loader (declarativo),
// createObject() permite crear múltiples instancias del mismo componente
// posicionándolas libremente.
//
// Conceptos clave:
// - Component.createObject(parent, properties): crea una instancia bajo
//   el parent dado, con propiedades iniciales.
// - object.destroy(): elimina el objeto y libera su memoria. Es responsabilidad
//   del desarrollador gestionar la vida útil de objetos creados dinámicamente.
// - Las animaciones (on scale, on y) se ejecutan automáticamente al crear
//   el objeto — no necesitan iniciarse manualmente.
//
// Advertencia: crear muchos objetos sin destruirlos causa memory leaks.
// El contador objectCount y el botón "Clear All" permiten monitorear y limpiar.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int objectCount: 0

    // ---- Componente "burbuja" ----
    // Template para las burbujas que se crearán dinámicamente. Cada instancia
    // tiene color y tamaño aleatorios (Math.random), posición configurable
    // via targetX/targetY, y dos animaciones automáticas:
    // 1. Scale de 0 a 1 con easing OutBack (efecto "rebote")
    // 2. Flotación vertical infinita con SequentialAnimation
    Component {
        id: bubbleComp

        Rectangle {
            id: bubble
            property real targetX: 0
            property real targetY: 0
            x: targetX
            y: targetY
            width: Style.resize(40 + Math.random() * 30)
            height: width
            radius: width / 2
            color: Qt.hsla(Math.random(), 0.7, 0.5, 0.8)
            scale: 0

            Label {
                anchors.centerIn: parent
                text: "\u2726"
                font.pixelSize: parent.width * 0.4
                color: "#FFFFFF"
            }

            // Animación de aparición: scale de 0→1 con rebote.
            // "on scale" significa que la animación se ejecuta automáticamente
            // cuando el objeto se crea y anima la propiedad scale.
            NumberAnimation on scale {
                from: 0; to: 1; duration: 300
                easing.type: Easing.OutBack
            }

            // Animación de flotación continua: sube y baja alrededor de targetY.
            // Math.random() en la duración hace que cada burbuja flote a
            // velocidad ligeramente diferente, creando un efecto orgánico.
            SequentialAnimation on y {
                loops: Animation.Infinite
                NumberAnimation {
                    to: bubble.targetY - Style.resize(10)
                    duration: 1500 + Math.random() * 1000
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    to: bubble.targetY + Style.resize(10)
                    duration: 1500 + Math.random() * 1000
                    easing.type: Easing.InOutQuad
                }
            }

            // Click en la burbuja la destruye. destroy() es necesario
            // para objetos creados con createObject() — el garbage collector
            // de QML NO los recoge automáticamente.
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.objectCount--
                    bubble.destroy()
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Creation"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Click area to spawn, click bubble to remove"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // ---- Área de generación ----
        // spawnArea es el contenedor padre de todas las burbujas. clip: true
        // asegura que las burbujas no se dibujen fuera de los límites.
        // El MouseArea cubre toda el área — al hacer clic, crea una burbuja
        // en la posición del cursor usando createObject() con propiedades
        // iniciales {targetX, targetY}.
        Item {
            id: spawnArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Style.surfaceColor
                radius: Style.resize(8)
                border.color: "#3A3D45"
                border.width: 1
            }

            Label {
                anchors.centerIn: parent
                text: "Click to spawn objects"
                font.pixelSize: Style.resize(14)
                color: Style.inactiveColor
                visible: root.objectCount === 0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: function(mouse) {
                    var obj = bubbleComp.createObject(spawnArea, {
                        targetX: mouse.x - Style.resize(25),
                        targetY: mouse.y - Style.resize(25)
                    })
                    if (obj) root.objectCount++
                }
            }
        }

        // ---- Pie con contador y limpieza ----
        // "Clear All" itera los hijos de spawnArea en orden inverso
        // (para no invalidar índices) y destruye todos excepto el primero
        // (que es el Rectangle de fondo, no una burbuja).
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Objects: " + root.objectCount
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
            }

            Button {
                text: "Clear All"
                font.pixelSize: Style.resize(11)
                enabled: root.objectCount > 0
                onClicked: {
                    for (var i = spawnArea.children.length - 1; i >= 0; i--) {
                        var child = spawnArea.children[i]
                        if (child !== spawnArea.children[0] && child.destroy) {
                            child.destroy()
                        }
                    }
                    root.objectCount = 0
                }
            }
        }
    }
}
