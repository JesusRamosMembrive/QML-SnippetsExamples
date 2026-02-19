// ============================================================================
// DrawingPadCard.qml
// Demuestra un Canvas interactivo donde el usuario dibuja con el mouse.
//
// CONCEPTO CLAVE: Combina Canvas (dibujo imperativo) con MouseArea (entrada
// del usuario) para crear una aplicacion de dibujo libre. Cada trazo se
// almacena como un objeto JavaScript con color, grosor y lista de puntos.
//
// PATRON DE DIBUJO INTERACTIVO:
//   1. onPressed: crear un nuevo "path" (trazo) con el punto inicial.
//   2. onPositionChanged: agregar puntos al trazo actual mientras se arrastra.
//   3. onReleased: finalizar el trazo.
//   4. onPaint: redibujar TODOS los trazos almacenados desde cero.
//
// Este patron de "limpiar y redibujar todo" (immediate mode) es el mas comun
// en Canvas. Aunque parece ineficiente, es simple y funciona bien para
// cantidades moderadas de trazos.
//
// NOTA SOBRE 'pragma ComponentBehavior: Bound': garantiza que los delegates
// del Repeater solo accedan a propiedades que les pertenecen explicitamente
// (via 'required property'). Es una buena practica de Qt 6 que previene
// errores silenciosos de scope.
// ============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Drawing Pad"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Barra de herramientas ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            // Selector de color usando Repeater con un modelo de strings.
            // Cada string del array se convierte en modelData dentro del delegate.
            // 'required property string modelData' es obligatorio con
            // ComponentBehavior: Bound para acceder al dato del modelo.
            Repeater {
                model: ["#FFFFFF", "#00D1A9", "#4A90D9", "#E74C3C", "#FEA601"]

                Rectangle {
                    required property string modelData

                    width: Style.resize(24)
                    height: Style.resize(24)
                    radius: width / 2
                    color: modelData
                    // Borde mas grueso y claro para indicar el color seleccionado
                    border.width: drawCanvas.strokeColor === modelData ? 3 : 1
                    border.color: drawCanvas.strokeColor === modelData ? Style.fontPrimaryColor : "#3A3D45"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: drawCanvas.strokeColor = parent.modelData
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Size:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.preferredWidth: Style.resize(80)
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: brushSlider
                    anchors.fill: parent
                    from: 1
                    to: 12
                    value: 3
                    stepSize: 1
                }
            }

            // Boton de limpiar: vacia el array de trazos y fuerza un repintado.
            Button {
                text: "Clear"
                onClicked: {
                    drawCanvas.paths = []
                    drawCanvas.requestPaint()
                }
            }
        }

        // --- Area de dibujo ---
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            border.color: Style.inactiveColor
            border.width: 1
            clip: true

            Canvas {
                id: drawCanvas
                anchors.fill: parent
                anchors.margins: 1

                // Estado del dibujo:
                // - paths: array de objetos {color, size, points[]}.
                //   Cada objeto representa un trazo completo.
                //   'property var' permite almacenar arrays y objetos JS.
                // - strokeColor: color actual del pincel.
                // - isDrawing: flag para saber si el usuario esta trazando.
                property var paths: []
                property string strokeColor: "#FFFFFF"
                property bool isDrawing: false

                // onPaint: redibuja TODOS los trazos almacenados.
                // - lineCap "round": los extremos de cada linea son redondeados.
                // - lineJoin "round": las uniones entre segmentos son suaves.
                // Estos estilos son clave para que el dibujo se vea natural.
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"

                    for (var i = 0; i < paths.length; i++) {
                        var p = paths[i]
                        if (p.points.length < 2)
                            continue

                        ctx.beginPath()
                        ctx.strokeStyle = p.color
                        ctx.lineWidth = p.size
                        ctx.moveTo(p.points[0].x, p.points[0].y)

                        for (var j = 1; j < p.points.length; j++) {
                            ctx.lineTo(p.points[j].x, p.points[j].y)
                        }
                        ctx.stroke()
                    }
                }

                // MouseArea captura la interaccion del usuario.
                // NOTA: Se usa 'function(mouse)' para recibir el evento con
                // coordenadas. Sin esto, mouse.x/mouse.y no estarian disponibles.
                MouseArea {
                    anchors.fill: parent

                    // Al presionar: crear un nuevo trazo con las propiedades
                    // actuales (color, grosor) y el punto inicial.
                    // PATRON IMPORTANTE: para que QML detecte cambios en un array,
                    // hay que reasignar la propiedad completa (drawCanvas.paths = p),
                    // no basta con hacer push() directamente sobre la propiedad.
                    onPressed: function(mouse) {
                        var newPath = {
                            color: drawCanvas.strokeColor,
                            size: brushSlider.value,
                            points: [Qt.point(mouse.x, mouse.y)]
                        }
                        var p = drawCanvas.paths
                        p.push(newPath)
                        drawCanvas.paths = p
                        drawCanvas.isDrawing = true
                    }

                    // Al mover: agregar cada posicion del mouse como punto del
                    // trazo actual, y solicitar repintado inmediato.
                    onPositionChanged: function(mouse) {
                        if (!drawCanvas.isDrawing)
                            return
                        var p = drawCanvas.paths
                        var current = p[p.length - 1]
                        current.points.push(Qt.point(mouse.x, mouse.y))
                        drawCanvas.paths = p
                        drawCanvas.requestPaint()
                    }

                    // Al soltar: finalizar el trazo actual.
                    onReleased: {
                        drawCanvas.isDrawing = false
                    }
                }
            }

            // Texto de ayuda que desaparece cuando hay al menos un trazo
            Label {
                anchors.centerIn: parent
                text: "Draw here!"
                font.pixelSize: Style.resize(16)
                color: Style.inactiveColor
                opacity: 0.4
                visible: drawCanvas.paths.length === 0
            }
        }

        Label {
            text: "Interactive canvas: pick color, adjust brush size, draw with mouse"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
