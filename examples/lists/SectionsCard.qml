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

                section.property: "category"
                section.criteria: ViewSection.FullString
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
                    width: sectionListView.width
                    height: Style.resize(34)
                    radius: Style.resize(4)
                    color: Style.surfaceColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(12)
                        spacing: Style.resize(8)

                        Rectangle {
                            width: Style.resize(8)
                            height: Style.resize(8)
                            radius: Style.resize(2)
                            color: {
                                switch(model.category) {
                                    case "Fruits": return "#FF6B6B";
                                    case "Vegetables": return "#00D1A9";
                                    case "Dairy": return "#74B9FF";
                                    case "Bakery": return "#FEA601";
                                    default: return "#999";
                                }
                            }
                        }

                        Label {
                            text: model.name
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
