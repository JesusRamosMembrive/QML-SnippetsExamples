import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Lists & Delegates Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: ListView
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "ListView"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                id: contactInfoLabel
                                text: "Select a contact"
                                font.pixelSize: Style.resize(13)
                                color: "#333"
                            }

                            // ListView
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(6)
                                clip: true

                                ListModel {
                                    id: contactModel
                                    ListElement { name: "Alice Johnson"; role: "Designer"; avatarColor: "#4A90D9" }
                                    ListElement { name: "Bob Smith"; role: "Developer"; avatarColor: "#00D1A9" }
                                    ListElement { name: "Carol White"; role: "Manager"; avatarColor: "#FEA601" }
                                    ListElement { name: "David Brown"; role: "QA Engineer"; avatarColor: "#FF5900" }
                                    ListElement { name: "Emma Davis"; role: "DevOps"; avatarColor: "#9B59B6" }
                                    ListElement { name: "Frank Miller"; role: "Architect"; avatarColor: "#E74C3C" }
                                    ListElement { name: "Grace Lee"; role: "Analyst"; avatarColor: "#1ABC9C" }
                                }

                                ListView {
                                    id: contactListView
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    model: contactModel
                                    clip: true
                                    spacing: Style.resize(2)
                                    currentIndex: -1

                                    highlight: Rectangle {
                                        color: Qt.rgba(0, 209/255, 169/255, 0.15)
                                        radius: Style.resize(6)
                                    }
                                    highlightFollowsCurrentItem: true
                                    highlightMoveDuration: 200

                                    delegate: Item {
                                        width: contactListView.width
                                        height: Style.resize(52)

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: Style.resize(8)
                                            anchors.rightMargin: Style.resize(8)
                                            spacing: Style.resize(10)

                                            // Avatar circle
                                            Rectangle {
                                                width: Style.resize(36)
                                                height: Style.resize(36)
                                                radius: width / 2
                                                color: model.avatarColor

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: model.name[0]
                                                    font.pixelSize: Style.resize(16)
                                                    font.bold: true
                                                    color: "white"
                                                }
                                            }

                                            // Name and role
                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(2)

                                                Label {
                                                    text: model.name
                                                    font.pixelSize: Style.resize(14)
                                                    font.bold: true
                                                    color: "#333"
                                                    Layout.fillWidth: true
                                                }

                                                Label {
                                                    text: model.role
                                                    font.pixelSize: Style.resize(11)
                                                    color: "#888"
                                                    Layout.fillWidth: true
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                contactListView.currentIndex = index
                                                contactInfoLabel.text = "Selected: " + model.name + " — " + model.role
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "ListView with custom delegates showing avatar, name, and role"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: GridView
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "GridView"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                id: gridInfoLabel
                                text: "Tap a color to select"
                                font.pixelSize: Style.resize(13)
                                color: "#333"
                            }

                            // GridView
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(6)
                                clip: true

                                ListModel {
                                    id: colorModel
                                    ListElement { colorName: "Coral"; colorHex: "#FF6B6B" }
                                    ListElement { colorName: "Gold"; colorHex: "#FEA601" }
                                    ListElement { colorName: "Lime"; colorHex: "#A8E6CF" }
                                    ListElement { colorName: "Teal"; colorHex: "#00D1A9" }
                                    ListElement { colorName: "Sky"; colorHex: "#74B9FF" }
                                    ListElement { colorName: "Blue"; colorHex: "#4A90D9" }
                                    ListElement { colorName: "Purple"; colorHex: "#9B59B6" }
                                    ListElement { colorName: "Pink"; colorHex: "#FD79A8" }
                                    ListElement { colorName: "Orange"; colorHex: "#FF5900" }
                                    ListElement { colorName: "Mint"; colorHex: "#1ABC9C" }
                                    ListElement { colorName: "Slate"; colorHex: "#636E72" }
                                    ListElement { colorName: "Rose"; colorHex: "#E74C3C" }
                                }

                                GridView {
                                    id: colorGridView
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)
                                    cellWidth: Style.resize(80)
                                    cellHeight: Style.resize(90)
                                    model: colorModel
                                    clip: true
                                    currentIndex: -1

                                    delegate: Item {
                                        width: colorGridView.cellWidth
                                        height: colorGridView.cellHeight

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(4)

                                            Rectangle {
                                                width: Style.resize(50)
                                                height: Style.resize(50)
                                                radius: Style.resize(8)
                                                color: model.colorHex
                                                border.width: GridView.isCurrentItem ? 3 : 0
                                                border.color: "#333"
                                                Layout.alignment: Qt.AlignHCenter

                                                scale: GridView.isCurrentItem ? 1.1 : 1.0
                                                Behavior on scale {
                                                    NumberAnimation { duration: 150 }
                                                }
                                            }

                                            Label {
                                                text: model.colorName
                                                font.pixelSize: Style.resize(10)
                                                color: "#666"
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                colorGridView.currentIndex = index
                                                gridInfoLabel.text = model.colorName + ": " + model.colorHex
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "GridView arranges delegates in a grid with cellWidth and cellHeight"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Dynamic List
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
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

                            // Add controls
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                TextField {
                                    id: addItemField
                                    Layout.fillWidth: true
                                    placeholderText: "New item..."

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

                            Label {
                                text: "Items: " + dynamicModel.count
                                font.pixelSize: Style.resize(13)
                                color: "#333"
                            }

                            // Dynamic ListView
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

                                    add: Transition {
                                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
                                        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
                                    }

                                    remove: Transition {
                                        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
                                        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
                                    }

                                    displaced: Transition {
                                        NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutQuad }
                                    }

                                    delegate: Rectangle {
                                        id: dynamicDelegate
                                        width: dynamicListView.width
                                        height: Style.resize(40)
                                        radius: Style.resize(6)
                                        color: "white"

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
                                                color: "#333"
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }

                                            Rectangle {
                                                width: Style.resize(24)
                                                height: Style.resize(24)
                                                radius: Style.resize(4)
                                                color: removeMouseArea.containsMouse ? "#FFE0E0" : "transparent"

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "\u2715"
                                                    font.pixelSize: Style.resize(12)
                                                    color: removeMouseArea.containsMouse ? "#E74C3C" : "#AAA"
                                                }

                                                MouseArea {
                                                    id: removeMouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    onClicked: dynamicModel.remove(index)
                                                }
                                            }
                                        }
                                    }
                                }

                                // Empty state
                                Label {
                                    anchors.centerIn: parent
                                    text: "List is empty"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.inactiveColor
                                    visible: dynamicModel.count === 0
                                }
                            }

                            Label {
                                text: "Add and remove items with animated transitions"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 4: Sections
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: "white"
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
                                color: "#333"
                            }

                            // Sectioned ListView
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
                                        color: "white"

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
                                                color: "#333"
                                                Layout.fillWidth: true
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "section.property groups items and section.delegate styles the headers"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout
            }
        }
    }
}
