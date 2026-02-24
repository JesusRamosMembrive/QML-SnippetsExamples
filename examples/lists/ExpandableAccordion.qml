// =============================================================================
// ExpandableAccordion.qml — Lista acordeon con secciones expandibles
// =============================================================================
// Implementa el patron "accordion" donde cada item tiene un encabezado
// clicable y un cuerpo que se expande/colapsa con animacion.
//
// Tecnica clave — altura dinamica del delegate:
// La altura del delegate depende de si 'expanded' es true o false:
//   height = header.height + (expanded ? body.height + padding : 0)
// Behavior on height anima este cambio, creando el efecto de expansion.
// clip: true en el delegate es CRITICO — sin el, el cuerpo se veria
// desbordando hacia abajo durante el colapso.
//
// El estado 'expanded' se guarda en el propio ListModel como un rol.
// setProperty(index, "expanded", value) modifica el modelo y QML
// reactivamente actualiza el delegate correspondiente.
//
// El indicador de flecha (triangulo) usa una animacion SequentialAnimation:
// primero se encoge (scale 0.6) y luego crece con rebote (OutBack a 1.0),
// dando un efecto elastico sutil al cambiar de direccion.
// =============================================================================

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Expandable Accordion"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(380)
        color: Style.bgColor
        radius: Style.resize(8)
        clip: true

        ListView {
            id: accordionList
            anchors.fill: parent
            anchors.margins: Style.resize(6)
            clip: true
            spacing: Style.resize(4)

            model: ListModel {
                id: accordionModel
                ListElement {
                    title: "What is QML?"
                    body: "QML (Qt Modeling Language) is a declarative language for designing user interfaces. It combines JavaScript expressions with a visual component hierarchy, making it ideal for fluid, animated UIs."
                    icon: "📘"
                    expanded: false
                }
                ListElement {
                    title: "ListView vs Repeater"
                    body: "ListView creates delegates lazily as they scroll into view, making it efficient for large datasets. Repeater creates all delegates upfront — best for small, fixed collections."
                    icon: "📋"
                    expanded: false
                }
                ListElement {
                    title: "What are Delegates?"
                    body: "Delegates define how each item in a model is visually represented. They are instantiated by views (ListView, GridView, PathView) for each data element. Each delegate has access to model roles."
                    icon: "🧩"
                    expanded: false
                }
                ListElement {
                    title: "Model-View-Delegate"
                    body: "Qt's MVD pattern separates data (Model), presentation (Delegate), and layout (View). Models can be ListModel, C++ QAbstractItemModel, or JS arrays. Views handle scrolling, positioning, and recycling."
                    icon: "🏗"
                    expanded: false
                }
                ListElement {
                    title: "Animations in Lists"
                    body: "ListView supports add, remove, move, displaced, and populate transitions. These Transition elements animate delegates as they enter, leave, or shift position within the view."
                    icon: "✨"
                    expanded: false
                }
            }

            // Cada delegate calcula su altura en funcion de 'expanded'.
            // clip: true evita que el contenido del cuerpo se vea durante
            // la animacion de colapso (mientras height se reduce).
            delegate: Rectangle {
                id: accordionItem

                required property int index
                required property bool expanded
                required property string title
                required property string body
                required property string icon

                width: accordionList.width
                height: accordionHeader.height + (accordionItem.expanded ? accordionBody.height + Style.resize(10) : 0)
                radius: Style.resize(8)
                color: Style.surfaceColor
                clip: true

                Behavior on height {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                Column {
                    width: parent.width

                    // Header
                    Item {
                        id: accordionHeader
                        width: parent.width
                        height: Style.resize(50)

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                accordionModel.setProperty(accordionItem.index, "expanded", !accordionItem.expanded)
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(14)
                            anchors.rightMargin: Style.resize(14)
                            spacing: Style.resize(10)

                            Label {
                                text: accordionItem.icon
                                font.pixelSize: Style.resize(18)
                            }

                            Label {
                                text: accordionItem.title
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }

                            Label {
                                text: accordionItem.expanded ? "▲" : "▼"
                                font.pixelSize: Style.resize(12)
                                color: Style.mainColor

                                Behavior on text {
                                    SequentialAnimation {
                                        NumberAnimation { target: parent; property: "scale"; to: 0.6; duration: 100 }
                                        NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.OutBack }
                                    }
                                }
                            }
                        }
                    }

                    // Body
                    Item {
                        id: accordionBody
                        width: parent.width
                        height: bodyLabel.implicitHeight + Style.resize(20)
                        opacity: accordionItem.expanded ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.leftMargin: Style.resize(14)
                            anchors.rightMargin: Style.resize(14)
                            height: Style.resize(1)
                            color: Qt.rgba(1, 1, 1, 0.06)
                        }

                        Label {
                            id: bodyLabel
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: Style.resize(14)
                            anchors.topMargin: Style.resize(10)
                            text: accordionItem.body
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }
}
