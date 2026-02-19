// ============================================================================
// DynamicListCard.qml
// Concepto: Manipulacion dinamica de ListModel + transiciones de lista.
//
// A diferencia de una lista estatica, aqui el usuario puede agregar y eliminar
// items en tiempo de ejecucion usando los metodos de ListModel:
//   - append({key: value}): agrega un elemento al final
//   - remove(index): elimina el elemento en la posicion dada
//   - count: propiedad reactiva con el numero total de elementos
//
// ListView soporta tres tipos de transiciones automaticas:
//   - add: se ejecuta cuando un nuevo item aparece en la lista
//   - remove: se ejecuta cuando un item se elimina de la lista
//   - displaced: se ejecuta en los items que se desplazan por un add/remove
//
// Estas transiciones hacen que los cambios sean visualmente fluidos sin
// necesidad de codigo imperativo — solo se declaran y ListView las aplica.
// ============================================================================

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
            text: "Dynamic List"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            TextField {
                id: addItemField
                Layout.fillWidth: true
                placeholderText: "New item..."

                // onAccepted se emite al presionar Enter en el TextField.
                // Permite agregar items sin necesidad de hacer clic en el boton.
                onAccepted: {
                    if (text.trim() !== "") {
                        dynamicModel.append({ itemText: text.trim() })
                        text = ""
                    }
                }
            }

            Button {
                text: "Add"
                onClicked: {
                    if (addItemField.text.trim() !== "") {
                        dynamicModel.append({ itemText: addItemField.text.trim() })
                        addItemField.text = ""
                    }
                }
            }
        }

        // dynamicModel.count es reactivo: este binding se actualiza automaticamente
        // cada vez que se agrega o elimina un item del modelo.
        Label {
            text: "Items: " + dynamicModel.count
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            ListModel {
                id: dynamicModel
                ListElement { itemText: "Buy groceries" }
                ListElement { itemText: "Review pull request" }
                ListElement { itemText: "Update documentation" }
                ListElement { itemText: "Fix login bug" }
            }

            ListView {
                id: dynamicListView
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                model: dynamicModel
                clip: true
                spacing: Style.resize(4)

                // Transicion 'add': cuando un item nuevo aparece, entra con fade-in
                // y escala desde 0.8 a 1.0. Easing.OutBack da un leve "rebote".
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
                    NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
                }

                // Transicion 'remove': el item se desvanece y se encoge al ser eliminado.
                remove: Transition {
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
                    NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
                }

                // Transicion 'displaced': los items restantes se reposicionan suavemente
                // cuando otro item es agregado o eliminado, animando su propiedad 'y'.
                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutQuad }
                }

                delegate: Rectangle {
                    id: dynamicDelegate
                    width: dynamicListView.width
                    height: Style.resize(40)
                    radius: Style.resize(6)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(8)

                        Rectangle {
                            width: Style.resize(6)
                            height: Style.resize(6)
                            radius: width / 2
                            color: Style.mainColor
                        }

                        Label {
                            text: model.itemText
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        // Boton de eliminar con efecto hover usando containsMouse.
                        // hoverEnabled: true es necesario para que containsMouse funcione
                        // (por defecto MouseArea solo detecta clics, no hover).
                        Rectangle {
                            width: Style.resize(24)
                            height: Style.resize(24)
                            radius: Style.resize(4)
                            color: removeMouseArea.containsMouse ? "#3D2020" : "transparent"

                            Label {
                                anchors.centerIn: parent
                                text: "\u2715"
                                font.pixelSize: Style.resize(12)
                                color: removeMouseArea.containsMouse ? "#E74C3C" : Style.inactiveColor
                            }

                            MouseArea {
                                id: removeMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                // remove(index) elimina el item en la posicion actual del delegate
                                onClicked: dynamicModel.remove(index)
                            }
                        }
                    }
                }

                // Estado vacio: se muestra cuando el modelo no tiene elementos.
                // visible esta bindeado a dynamicModel.count === 0 (reactivo).
                Label {
                    anchors.centerIn: parent
                    text: "List is empty"
                    font.pixelSize: Style.resize(14)
                    color: Style.inactiveColor
                    visible: dynamicModel.count === 0
                }
            }
        }

        Label {
            text: "Add and remove items with animated transitions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
