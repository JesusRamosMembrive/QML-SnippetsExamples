// ============================================================================
// SectionsCard.qml
// Concepto: Secciones en ListView — agrupar items bajo encabezados.
//
// ListView tiene soporte nativo para secciones. Se configura con tres propiedades:
//   - section.property: nombre del rol del modelo usado para agrupar (ej: "category")
//   - section.criteria: como comparar valores (FullString = coincidencia exacta)
//   - section.delegate: componente visual para el encabezado de cada grupo
//
// IMPORTANTE: los datos en el modelo DEBEN estar ordenados por la propiedad
// de seccion. Si los items de "Fruits" estan mezclados con "Vegetables",
// ListView creara multiples encabezados repetidos. La agrupacion se basa
// en detectar cambios consecutivos, no en un GROUP BY tipo SQL.
//
// El section.delegate recibe la propiedad 'section' (string) con el valor
// actual del grupo, que se usa para mostrar el texto del encabezado.
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
            text: "Sections"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Items grouped by category with section headers"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            // Los items estan agrupados por 'category'. Notar que todos los items
            // de la misma categoria estan juntos y en orden — requisito para que
            // las secciones funcionen correctamente.
            ListModel {
                id: groceryModel
                ListElement { name: "Apple"; category: "Fruits" }
                ListElement { name: "Banana"; category: "Fruits" }
                ListElement { name: "Orange"; category: "Fruits" }
                ListElement { name: "Strawberry"; category: "Fruits" }
                ListElement { name: "Carrot"; category: "Vegetables" }
                ListElement { name: "Broccoli"; category: "Vegetables" }
                ListElement { name: "Spinach"; category: "Vegetables" }
                ListElement { name: "Milk"; category: "Dairy" }
                ListElement { name: "Cheese"; category: "Dairy" }
                ListElement { name: "Yogurt"; category: "Dairy" }
                ListElement { name: "Bread"; category: "Bakery" }
                ListElement { name: "Croissant"; category: "Bakery" }
            }

            ListView {
                id: sectionListView
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                model: groceryModel
                clip: true
                spacing: Style.resize(2)

                // section.property indica que rol del modelo se usa para agrupar.
                // section.criteria: ViewSection.FullString compara el string completo.
                // Tambien existe ViewSection.FirstCharacter para agrupar por inicial.
                section.property: "category"
                section.criteria: ViewSection.FullString

                // section.delegate: se instancia una vez por cada cambio de seccion.
                // 'required property string section' recibe el valor del grupo actual.
                section.delegate: Rectangle {
                    required property string section
                    width: sectionListView.width
                    height: Style.resize(30)
                    color: Style.mainColor
                    radius: Style.resize(4)

                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: Style.resize(10)
                        anchors.verticalCenter: parent.verticalCenter
                        text: section
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: "white"
                    }
                }

                delegate: Rectangle {
                    id: groceryDelegate

                    required property string name
                    required property string category

                    width: sectionListView.width
                    height: Style.resize(34)
                    radius: Style.resize(4)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(12)
                        spacing: Style.resize(8)

                        // Indicador de color por categoria usando un switch/expression binding
                        Rectangle {
                            width: Style.resize(8)
                            height: Style.resize(8)
                            radius: Style.resize(2)
                            color: {
                                switch(groceryDelegate.category) {
                                    case "Fruits": return "#FF6B6B";
                                    case "Vegetables": return "#00D1A9";
                                    case "Dairy": return "#74B9FF";
                                    case "Bakery": return "#FEA601";
                                    default: return "#999";
                                }
                            }
                        }

                        Label {
                            text: groceryDelegate.name
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        Label {
            text: "section.property groups items and section.delegate styles the headers"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
