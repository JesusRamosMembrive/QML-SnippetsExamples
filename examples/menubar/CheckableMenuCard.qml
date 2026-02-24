// =============================================================================
// CheckableMenuCard.qml — MenuItems con checkable y submenus
// =============================================================================
// Demuestra MenuItems marcables (checkable: true) y submenus anidados.
// Simula un editor grafico donde el usuario puede activar/desactivar
// cuadricula, reglas y ajuste a grid, ademas de seleccionar nivel de zoom
// desde un submenu.
//
// Conceptos clave:
//   - MenuItem con checkable: true — muestra un checkbox junto al texto.
//     El binding bidireccional checked <-> propiedad mantiene sincronizado
//     el estado del menu con las propiedades del componente.
//   - Menu anidado (submenu): un Menu dentro de otro Menu crea una jerarquia
//     de menus desplegables, ideal para opciones con muchos valores.
//   - Canvas QML: API de dibujo similar a HTML5 Canvas, usada aqui para
//     dibujar la cuadricula dinamicamente con lineas verticales y horizontales.
//   - Menu.popup(): abre el menu como popup bajo el boton que lo invoca.
//
// La vista previa reacciona en tiempo real a los cambios de las propiedades,
// demostrando el binding declarativo de QML en accion.
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

    // -- Estado del editor visual: cada propiedad controla un aspecto
    //    de la vista previa y se sincroniza con los MenuItems checkable.
    property bool showGrid: true
    property bool showRulers: false
    property bool snapToGrid: true
    property string zoomLevel: "100%"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Checkable & Radio Menus"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- Boton que abre el menu como popup.
        //    El Menu se declara como hijo del Button pero se abre manualmente
        //    con popup() para tener control total del momento de apertura.
        Button {
            text: "View Options \u25BE"
            onClicked: viewMenu.popup()

            Menu {
                id: viewMenu

                // -- Cada MenuItem checkable tiene binding bidireccional:
                //    checked lee el valor de la propiedad root, y
                //    onTriggered lo escribe de vuelta.
                MenuItem {
                    text: "Show Grid"
                    checkable: true
                    checked: root.showGrid
                    onTriggered: root.showGrid = checked
                }

                MenuItem {
                    text: "Show Rulers"
                    checkable: true
                    checked: root.showRulers
                    onTriggered: root.showRulers = checked
                }

                MenuItem {
                    text: "Snap to Grid"
                    checkable: true
                    checked: root.snapToGrid
                    onTriggered: root.snapToGrid = checked
                }

                MenuSeparator {}

                // -- Submenu anidado: Menu dentro de Menu.
                //    Cada item del submenu usa onTriggered (no checkable)
                //    porque el zoom es una seleccion exclusiva, no un toggle.
                Menu {
                    title: "Zoom"

                    MenuItem { text: "50%"; onTriggered: root.zoomLevel = "50%" }
                    MenuItem { text: "75%"; onTriggered: root.zoomLevel = "75%" }
                    MenuItem { text: "100%"; onTriggered: root.zoomLevel = "100%" }
                    MenuItem { text: "150%"; onTriggered: root.zoomLevel = "150%" }
                    MenuItem { text: "200%"; onTriggered: root.zoomLevel = "200%" }
                }
            }
        }

        // -- Area de vista previa que reacciona a las opciones del menu.
        //    clip: true evita que la cuadricula y reglas se dibujen fuera.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // -- Canvas dibuja la cuadricula con la API 2D de JavaScript.
            //    Se muestra/oculta con la propiedad showGrid del root.
            //    onPaint se ejecuta cuando el Canvas necesita repintarse.
            Canvas {
                anchors.fill: parent
                visible: root.showGrid
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = "#333333"
                    ctx.lineWidth = 0.5
                    var step = 20
                    for (var x = 0; x < width; x += step) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }
                    for (var y = 0; y < height; y += step) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                }
            }

            // -- Regla horizontal superior con marcas numericas
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(16)
                color: "#2A2D35"
                visible: root.showRulers

                Row {
                    anchors.fill: parent
                    spacing: Style.resize(20)
                    Repeater {
                        model: 15
                        Label {
                            required property int index
                            text: (index * 20).toString()
                            font.pixelSize: Style.resize(8)
                            color: Style.inactiveColor
                            width: Style.resize(20)
                        }
                    }
                }
            }

            // -- Regla vertical izquierda (simplificada, sin marcas)
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: Style.resize(16)
                color: "#2A2D35"
                visible: root.showRulers
            }

            Label {
                anchors.centerIn: parent
                text: "Zoom: " + root.zoomLevel
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }
        }

        // -- Barra de estado que muestra el estado actual de todas las opciones
        Label {
            text: "Grid: " + root.showGrid + " | Rulers: " + root.showRulers + " | Snap: " + root.snapToGrid
            font.pixelSize: Style.resize(11)
            color: Style.inactiveColor
        }
    }
}
