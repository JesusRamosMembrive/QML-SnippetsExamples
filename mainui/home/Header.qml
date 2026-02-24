// =============================================================================
// Header.qml — Barra superior de la aplicación
// =============================================================================
//
// Muestra el nombre de la página actual y controles opcionales (selector de tema).
//
// -- property alias menuItemText --
// "alias" expone la propiedad text del Label interno (menuTextLabel) hacia afuera.
// Un alias es una REFERENCIA, no una copia: cuando el padre cambia menuItemText,
// se modifica directamente el texto del Label sin intermediarios.
//
// -- DropShadow debajo del rectángulo --
// Crea una sombra que da efecto de "elevación" (Material Design), separando
// visualmente el header del contenido que está debajo. verticalOffset controla
// qué tan abajo cae la sombra; samples define la calidad del difuminado.
//
// -- Loader para dropDownMenuLoader --
// Carga de forma diferida (lazy-load) el selector de temas. Con active: false,
// el componente NO se instancia hasta que se necesite, ahorrando recursos.
// Usa el mismo patrón opacity/visible para animar su aparición con fade.
//
// -- Selector de tema con RadioButtons --
// Respaldado por Style.setGreenTheme() y Style.setOrangeTheme(). Al hacer clic,
// el sistema reactivo de bindings propaga el cambio de color a TODA la app
// automáticamente, porque todos los componentes leen colores de Style.
//
// -- Frame con Image como background --
// En lugar de un Rectangle estándar, usa una imagen personalizada
// (Style.gfx("dropdown")) como fondo del dropdown, permitiendo formas y
// diseños que no son posibles con un simple rectángulo.
// =============================================================================

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import utils

Item {
    id: root

    property alias menuItemText: menuTextLabel.text
    property bool reorderDashBoardItems: false
    property bool reorderSwitchVisible: false

    DropShadow {
        anchors.fill: backgroundColor
        verticalOffset: Style.resize(3)
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: backgroundColor
    }

    Rectangle {
        id: backgroundColor
        width: parent.width
        height: parent.height
        anchors.right: parent.right
        color: Style.cardColor
    }

    Label {
        id: menuTextLabel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Style.resize(90)
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Style.resize(20)
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.resize(20)
    }

    Loader {
        id: dropDownMenuLoader
        width: Style.resize(228)
        height: Style.resize(127)
        anchors.top: parent.top
        anchors.topMargin: ((height / 2) + Style.resize(10))
        anchors.right: parent.right
        anchors.rightMargin: Style.resize(45)
        active: false
        opacity: active ? 1.0 : 0.0
        visible: (opacity > 0.0)
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
        sourceComponent: Frame {
            anchors.fill: parent
            background: Image {
                width: Style.resize(sourceSize.width)
                height: Style.resize(sourceSize.height)
                source: Style.gfx("dropdown")
            }

            contentItem: Column {
                anchors.top: parent.top
                anchors.topMargin: Style.resize(20)
                anchors.left: parent.left
                anchors.leftMargin: Style.resize(30)
                spacing: Style.resize(8)
                Label {
                    text: qsTr("Select theme")
                }
                Repeater {
                    model: ["Green", "Orange"]
                    delegate: RadioButton {
                        id: themeDelegate
                        required property string modelData
                        required property int index
                        width: Style.resize(100)
                        height: Style.resize(26)
                        text: qsTr("%1").arg(themeDelegate.modelData)
                        checked: (Style.theme === text.toLowerCase())
                        onClicked: {
                            if (themeDelegate.modelData === "Green") {
                                Style.setGreenTheme();
                            } else {
                                Style.setOrangeTheme();
                            }
                            dropDownMenuLoader.active = false;
                        }
                    }
                }
            }
        }
    }
}
