// =============================================================================
// DynamicTabBarCard.qml — TabBar con pestanas dinamicas (agregar/cerrar)
// =============================================================================
// Demuestra como crear un TabBar cuyas pestanas se generan dinamicamente
// desde un ListModel. El usuario puede agregar nuevas pestanas con un boton
// y cerrar las existentes con un boton "X" superpuesto en cada TabButton.
//
// Patron clave: Repeater + ListModel dentro de un TabBar. El Repeater genera
// TabButtons a partir del modelo. Al modificar el modelo (append/remove),
// las pestanas se crean o destruyen automaticamente gracias a la reactividad
// de QML.
//
// Aprendizaje clave: como gestionar pestanas dinamicas con ListModel, y
// la logica necesaria para ajustar currentIndex al cerrar una pestana
// (evitar indices fuera de rango).
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Contador global para generar nombres unicos de pestanas
    property int tabCounter: 3

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Tabs (Add / Close)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // Barra de controles: boton para agregar pestanas + contador.
        // El Item con Layout.fillWidth actua como espaciador flexible (spacer)
        // para empujar el contador a la derecha.
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Button {
                text: "+ Add Tab"
                onClicked: {
                    root.tabCounter++
                    tabModel.append({ title: "Tab " + root.tabCounter })
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: tabModel.count + " tabs"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }
        }

        // ---------------------------------------------------------------------
        // TabBar dinamico con Repeater + ListModel.
        // El Repeater genera un TabButton por cada elemento del ListModel.
        // Cuando se hace append() o remove() en el modelo, QML actualiza
        // la UI automaticamente sin necesidad de logica adicional.
        //
        // Cada TabButton incluye un boton de cierre (la "X") implementado
        // como un Rectangle con MouseArea superpuesto. Se oculta si solo
        // queda una pestana para evitar dejar el TabBar vacio.
        // ---------------------------------------------------------------------
        TabBar {
            id: dynamicTabBar
            Layout.fillWidth: true

            Repeater {
                model: ListModel {
                    id: tabModel
                    ListElement { title: "Tab 1" }
                    ListElement { title: "Tab 2" }
                    ListElement { title: "Tab 3" }
                }

                TabButton {
                    required property int index
                    required property string title
                    text: title
                    width: implicitWidth

                    // ---------------------------------------------------------
                    // Boton de cierre superpuesto en cada pestana.
                    // Al cerrar una pestana, se ajusta currentIndex hacia atras
                    // si el indice actual era >= al que se elimina. Esto evita
                    // que currentIndex apunte fuera de rango.
                    // ---------------------------------------------------------
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: Style.resize(4)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(18)
                        height: Style.resize(18)
                        radius: width / 2
                        color: closeArea.containsMouse ? "#44FFFFFF" : "transparent"
                        visible: tabModel.count > 1

                        Label {
                            anchors.centerIn: parent
                            text: "\u00D7"
                            font.pixelSize: Style.resize(14)
                            color: Style.fontSecondaryColor
                        }

                        MouseArea {
                            id: closeArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var removeIdx = index
                                if (dynamicTabBar.currentIndex >= removeIdx && dynamicTabBar.currentIndex > 0)
                                    dynamicTabBar.currentIndex--
                                tabModel.remove(removeIdx)
                            }
                        }
                    }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Area de contenido: muestra el titulo de la pestana activa.
        // Se usa una expresion ternaria con verificacion de limites para
        // evitar errores cuando currentIndex queda temporalmente invalido
        // durante la eliminacion de una pestana.
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)

            Label {
                anchors.centerIn: parent
                text: dynamicTabBar.currentIndex >= 0 && dynamicTabBar.currentIndex < tabModel.count
                      ? tabModel.get(dynamicTabBar.currentIndex).title + " content"
                      : "No tab selected"
                font.pixelSize: Style.resize(16)
                color: Style.fontPrimaryColor
            }
        }
    }
}
