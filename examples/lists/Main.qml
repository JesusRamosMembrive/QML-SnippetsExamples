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
                        color: Style.cardColor
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
                                color: Style.fontPrimaryColor
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
                                                    color: Style.fontPrimaryColor
                                                    Layout.fillWidth: true
                                                }

                                                Label {
                                                    text: model.role
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontSecondaryColor
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
                                color: Style.fontSecondaryColor
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
                        color: Style.cardColor
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
                                color: Style.fontPrimaryColor
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
                                                border.color: Style.fontPrimaryColor
                                                Layout.alignment: Qt.AlignHCenter

                                                scale: GridView.isCurrentItem ? 1.1 : 1.0
                                                Behavior on scale {
                                                    NumberAnimation { duration: 150 }
                                                }
                                            }

                                            Label {
                                                text: model.colorName
                                                font.pixelSize: Style.resize(10)
                                                color: Style.fontSecondaryColor
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
                                color: Style.fontSecondaryColor
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
                                color: Style.fontPrimaryColor
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
                                color: Style.fontSecondaryColor
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

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Card 5: Custom List Patterns
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2600)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom List Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // ── Section 1: Swipe-to-Action List ───────────────
                        Label {
                            text: "Swipe-to-Action List"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(300)
                            color: Style.bgColor
                            radius: Style.resize(8)
                            clip: true

                            ListModel {
                                id: swipeModel
                                ListElement { msg: "Flight MH370 departed on time"; from: "ATC Tower"; time: "09:41"; clr: "#5B8DEF" }
                                ListElement { msg: "Runway 27L cleared for landing"; from: "Ground Control"; time: "09:38"; clr: "#00D1A9" }
                                ListElement { msg: "Weather advisory: crosswind 15kt"; from: "METAR"; time: "09:35"; clr: "#FF9500" }
                                ListElement { msg: "Fuel report submitted"; from: "Dispatch"; time: "09:30"; clr: "#34C759" }
                                ListElement { msg: "Gate B12 reassigned to flight IB3214"; from: "Ops Center"; time: "09:22"; clr: "#AF52DE" }
                                ListElement { msg: "Passenger count confirmed: 186 PAX"; from: "Check-in"; time: "09:15"; clr: "#FF3B30" }
                                ListElement { msg: "Catering loaded on stand"; from: "Ground Handling"; time: "09:10"; clr: "#FEA601" }
                            }

                            ListView {
                                id: swipeListView
                                anchors.fill: parent
                                anchors.margins: Style.resize(6)
                                model: swipeModel
                                clip: true
                                spacing: Style.resize(4)

                                delegate: Item {
                                    id: swipeDelegate
                                    width: swipeListView.width
                                    height: Style.resize(60)

                                    required property int index
                                    required property string msg
                                    required property string from
                                    required property string time
                                    required property string clr

                                    property real swipeX: 0
                                    property bool swiped: false

                                    // Background actions
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: Style.resize(8)
                                        color: "#2D1A1A"

                                        RowLayout {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.rightMargin: Style.resize(15)
                                            spacing: Style.resize(12)

                                            Rectangle {
                                                width: Style.resize(36)
                                                height: Style.resize(36)
                                                radius: width / 2
                                                color: "#FF9500"

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "★"
                                                    font.pixelSize: Style.resize(16)
                                                    color: "#FFF"
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        swipeDelegate.swipeX = 0
                                                        swipeDelegate.swiped = false
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                width: Style.resize(36)
                                                height: Style.resize(36)
                                                radius: width / 2
                                                color: "#FF3B30"

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "✕"
                                                    font.pixelSize: Style.resize(16)
                                                    font.bold: true
                                                    color: "#FFF"
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: swipeModel.remove(swipeDelegate.index)
                                                }
                                            }
                                        }
                                    }

                                    // Foreground card
                                    Rectangle {
                                        id: swipeFg
                                        width: parent.width
                                        height: parent.height
                                        radius: Style.resize(8)
                                        color: Style.surfaceColor
                                        x: swipeDelegate.swipeX

                                        Behavior on x {
                                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                        }

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(10)
                                            spacing: Style.resize(10)

                                            Rectangle {
                                                width: Style.resize(4)
                                                height: Style.resize(36)
                                                radius: Style.resize(2)
                                                color: swipeDelegate.clr
                                            }

                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(2)

                                                Label {
                                                    text: swipeDelegate.msg
                                                    font.pixelSize: Style.resize(13)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }
                                                Label {
                                                    text: swipeDelegate.from
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontSecondaryColor
                                                }
                                            }

                                            Label {
                                                text: swipeDelegate.time
                                                font.pixelSize: Style.resize(11)
                                                color: Style.inactiveColor
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            property real startX: 0

                                            onPressed: function(mouse) { startX = mouse.x }
                                            onPositionChanged: function(mouse) {
                                                var dx = mouse.x - startX
                                                if (dx < 0)
                                                    swipeDelegate.swipeX = Math.max(-Style.resize(110), dx)
                                            }
                                            onReleased: {
                                                if (swipeDelegate.swipeX < -Style.resize(50)) {
                                                    swipeDelegate.swipeX = -Style.resize(110)
                                                    swipeDelegate.swiped = true
                                                } else {
                                                    swipeDelegate.swipeX = 0
                                                    swipeDelegate.swiped = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Label {
                            text: "← Swipe left to reveal Star and Delete actions"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 2: Expandable Accordion ───────────────
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

                                delegate: Rectangle {
                                    id: accordionItem
                                    width: accordionList.width
                                    height: accordionHeader.height + (model.expanded ? accordionBody.height + Style.resize(10) : 0)
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
                                                    accordionModel.setProperty(index, "expanded", !model.expanded)
                                                }
                                            }

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: Style.resize(14)
                                                anchors.rightMargin: Style.resize(14)
                                                spacing: Style.resize(10)

                                                Label {
                                                    text: model.icon
                                                    font.pixelSize: Style.resize(18)
                                                }

                                                Label {
                                                    text: model.title
                                                    font.pixelSize: Style.resize(14)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                    Layout.fillWidth: true
                                                }

                                                Label {
                                                    text: model.expanded ? "▲" : "▼"
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
                                            opacity: model.expanded ? 1 : 0

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
                                                text: model.body
                                                font.pixelSize: Style.resize(12)
                                                color: Style.fontSecondaryColor
                                                wrapMode: Text.WordWrap
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 3: Chat Bubbles ───────────────────────
                        Label {
                            text: "Chat Bubbles"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(400)
                            color: Style.bgColor
                            radius: Style.resize(8)
                            clip: true

                            ListModel {
                                id: chatModel
                                ListElement { text: "Hey! How's the project going?"; isMe: false; sender: "Alice"; time: "10:30" }
                                ListElement { text: "Going well! Just finished the animations page."; isMe: true; sender: "Me"; time: "10:31" }
                                ListElement { text: "Nice! Did you add the particle system?"; isMe: false; sender: "Alice"; time: "10:32" }
                                ListElement { text: "Yes, plus orbital motion, wave bars, Lissajous curves, Newton's cradle, and a Matrix rain effect 🎉"; isMe: true; sender: "Me"; time: "10:33" }
                                ListElement { text: "That sounds amazing! Can't wait to see it."; isMe: false; sender: "Alice"; time: "10:34" }
                                ListElement { text: "I also added play/pause toggles so it doesn't kill the GPU 😅"; isMe: true; sender: "Me"; time: "10:35" }
                                ListElement { text: "Smart move. Performance matters!"; isMe: false; sender: "Alice"; time: "10:36" }
                                ListElement { text: "Now working on custom list patterns. This chat is one of them!"; isMe: true; sender: "Me"; time: "10:37" }
                            }

                            ListView {
                                id: chatListView
                                anchors.fill: parent
                                anchors.margins: Style.resize(10)
                                model: chatModel
                                clip: true
                                spacing: Style.resize(8)
                                verticalLayoutDirection: ListView.TopToBottom

                                Component.onCompleted: positionViewAtEnd()

                                delegate: Item {
                                    id: chatDelegate
                                    width: chatListView.width
                                    height: chatBubble.height + Style.resize(4)

                                    required property int index
                                    required property string text
                                    required property bool isMe
                                    required property string sender
                                    required property string time

                                    // Bubble
                                    Rectangle {
                                        id: chatBubble
                                        anchors.right: chatDelegate.isMe ? parent.right : undefined
                                        anchors.left: chatDelegate.isMe ? undefined : parent.left
                                        anchors.leftMargin: chatDelegate.isMe ? 0 : Style.resize(36)
                                        anchors.rightMargin: chatDelegate.isMe ? 0 : 0

                                        width: Math.min(chatListView.width * 0.7,
                                               chatText.implicitWidth + Style.resize(30))
                                        height: chatContent.height + Style.resize(16)
                                        radius: Style.resize(14)
                                        color: chatDelegate.isMe ? Style.mainColor : Style.surfaceColor

                                        Column {
                                            id: chatContent
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.margins: Style.resize(10)
                                            spacing: Style.resize(4)

                                            Label {
                                                id: chatText
                                                width: parent.width
                                                text: chatDelegate.text
                                                font.pixelSize: Style.resize(13)
                                                color: chatDelegate.isMe ? "#000" : Style.fontPrimaryColor
                                                wrapMode: Text.WordWrap
                                            }

                                            Label {
                                                text: chatDelegate.time
                                                font.pixelSize: Style.resize(9)
                                                color: chatDelegate.isMe
                                                       ? Qt.rgba(0, 0, 0, 0.5)
                                                       : Style.inactiveColor
                                                anchors.right: parent.right
                                            }
                                        }
                                    }

                                    // Avatar (other person only)
                                    Rectangle {
                                        visible: !chatDelegate.isMe
                                        anchors.left: parent.left
                                        anchors.bottom: chatBubble.bottom
                                        width: Style.resize(28)
                                        height: Style.resize(28)
                                        radius: width / 2
                                        color: "#5B8DEF"

                                        Label {
                                            anchors.centerIn: parent
                                            text: chatDelegate.sender[0]
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: "#FFF"
                                        }
                                    }
                                }
                            }

                            // Chat input bar
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: Style.resize(46)
                                color: Style.surfaceColor
                                radius: Style.resize(8)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(6)
                                    spacing: Style.resize(8)

                                    TextField {
                                        id: chatInput
                                        Layout.fillWidth: true
                                        placeholderText: "Type a message..."
                                        onAccepted: {
                                            if (text.trim() !== "") {
                                                var now = new Date()
                                                var h = now.getHours().toString().padStart(2, '0')
                                                var m = now.getMinutes().toString().padStart(2, '0')
                                                chatModel.append({
                                                    text: text.trim(),
                                                    isMe: true,
                                                    sender: "Me",
                                                    time: h + ":" + m
                                                })
                                                text = ""
                                                chatListView.positionViewAtEnd()
                                            }
                                        }
                                    }

                                    Button {
                                        text: "Send"
                                        onClicked: chatInput.accepted()
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 4: Timeline ───────────────────────────
                        Label {
                            text: "Timeline"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(420)
                            color: Style.bgColor
                            radius: Style.resize(8)
                            clip: true

                            ListView {
                                id: timelineList
                                anchors.fill: parent
                                anchors.margins: Style.resize(10)
                                clip: true
                                spacing: 0

                                model: ListModel {
                                    ListElement { title: "Project Kickoff"; desc: "Initial requirements gathered and team assembled"; date: "Jan 5"; clr: "#5B8DEF"; done: true }
                                    ListElement { title: "Architecture Design"; desc: "Module system, style engine, and navigation pattern defined"; date: "Jan 18"; clr: "#00D1A9"; done: true }
                                    ListElement { title: "Core Components"; desc: "Buttons, sliders, dials, indicators, and text inputs completed"; date: "Feb 3"; clr: "#34C759"; done: true }
                                    ListElement { title: "Advanced Pages"; desc: "Canvas, shapes, particles, transforms, and animations added"; date: "Feb 14"; clr: "#FF9500"; done: true }
                                    ListElement { title: "Maps & Navigation"; desc: "OpenStreetMap integration with GPS simulation and compass"; date: "Feb 17"; clr: "#AF52DE"; done: false }
                                    ListElement { title: "Testing & Polish"; desc: "Performance optimization, dark theme, and contrast fixes"; date: "Mar 1"; clr: "#FF3B30"; done: false }
                                    ListElement { title: "Release v1.0"; desc: "Final build, documentation, and deployment"; date: "Mar 15"; clr: "#FEA601"; done: false }
                                }

                                delegate: Item {
                                    id: timelineDelegate
                                    width: timelineList.width
                                    height: Style.resize(70)

                                    required property int index
                                    required property string title
                                    required property string desc
                                    required property string date
                                    required property string clr
                                    required property bool done

                                    // Vertical line
                                    Rectangle {
                                        id: timelineLine
                                        anchors.horizontalCenter: timelineDot.horizontalCenter
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: Style.resize(2)
                                        color: Qt.rgba(1, 1, 1, 0.1)
                                    }

                                    // Dot
                                    Rectangle {
                                        id: timelineDot
                                        x: Style.resize(40)
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: Style.resize(16)
                                        height: Style.resize(16)
                                        radius: width / 2
                                        color: timelineDelegate.done ? timelineDelegate.clr : "transparent"
                                        border.color: timelineDelegate.clr
                                        border.width: Style.resize(2)

                                        // Inner dot for completed
                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: Style.resize(6)
                                            height: Style.resize(6)
                                            radius: width / 2
                                            color: "#FFF"
                                            visible: timelineDelegate.done
                                        }
                                    }

                                    // Date label (left)
                                    Label {
                                        anchors.right: timelineDot.left
                                        anchors.rightMargin: Style.resize(10)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: timelineDelegate.date
                                        font.pixelSize: Style.resize(11)
                                        font.bold: true
                                        color: timelineDelegate.done ? timelineDelegate.clr : Style.inactiveColor
                                        horizontalAlignment: Text.AlignRight
                                        width: Style.resize(30)
                                    }

                                    // Content (right)
                                    ColumnLayout {
                                        anchors.left: timelineDot.right
                                        anchors.leftMargin: Style.resize(14)
                                        anchors.right: parent.right
                                        anchors.rightMargin: Style.resize(10)
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: Style.resize(3)

                                        Label {
                                            text: timelineDelegate.title
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: timelineDelegate.done ? Style.fontPrimaryColor : Style.inactiveColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Label {
                                            text: timelineDelegate.desc
                                            font.pixelSize: Style.resize(11)
                                            color: timelineDelegate.done ? Style.fontSecondaryColor : Qt.rgba(1, 1, 1, 0.25)
                                            Layout.fillWidth: true
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 5: Card Carousel ──────────────────────
                        Label {
                            text: "Card Carousel"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(220)

                            ListView {
                                id: carouselList
                                anchors.fill: parent
                                orientation: ListView.Horizontal
                                clip: true
                                spacing: Style.resize(15)
                                snapMode: ListView.SnapOneItem
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                preferredHighlightBegin: (width - Style.resize(300)) / 2
                                preferredHighlightEnd: preferredHighlightBegin + Style.resize(300)
                                cacheBuffer: 1000

                                model: ListModel {
                                    ListElement { title: "Madrid"; subtitle: "Capital of Spain"; temp: "22°C"; weather: "☀"; gradient1: "#FF6B6B"; gradient2: "#EE5A24" }
                                    ListElement { title: "London"; subtitle: "United Kingdom"; temp: "14°C"; weather: "🌧"; gradient1: "#74B9FF"; gradient2: "#0984E3" }
                                    ListElement { title: "Tokyo"; subtitle: "Japan"; temp: "19°C"; weather: "⛅"; gradient1: "#A29BFE"; gradient2: "#6C5CE7" }
                                    ListElement { title: "New York"; subtitle: "United States"; temp: "17°C"; weather: "🌤"; gradient1: "#FDCB6E"; gradient2: "#E17055" }
                                    ListElement { title: "Sydney"; subtitle: "Australia"; temp: "26°C"; weather: "☀"; gradient1: "#00D1A9"; gradient2: "#00B894" }
                                    ListElement { title: "Paris"; subtitle: "France"; temp: "16°C"; weather: "🌥"; gradient1: "#FD79A8"; gradient2: "#E84393" }
                                }

                                delegate: Item {
                                    id: carouselDelegate
                                    width: Style.resize(300)
                                    height: carouselList.height

                                    required property int index
                                    required property string title
                                    required property string subtitle
                                    required property string temp
                                    required property string weather
                                    required property string gradient1
                                    required property string gradient2

                                    readonly property bool isCurrent: carouselList.currentIndex === carouselDelegate.index

                                    scale: isCurrent ? 1.0 : 0.88
                                    opacity: isCurrent ? 1.0 : 0.6

                                    Behavior on scale {
                                        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                                    }
                                    Behavior on opacity {
                                        NumberAnimation { duration: 250 }
                                    }

                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(10)
                                        radius: Style.resize(16)

                                        gradient: Gradient {
                                            GradientStop { position: 0; color: carouselDelegate.gradient1 }
                                            GradientStop { position: 1; color: carouselDelegate.gradient2 }
                                        }

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(20)
                                            spacing: Style.resize(8)

                                            Label {
                                                text: carouselDelegate.weather
                                                font.pixelSize: Style.resize(42)
                                            }

                                            Item { Layout.fillHeight: true }

                                            Label {
                                                text: carouselDelegate.temp
                                                font.pixelSize: Style.resize(36)
                                                font.bold: true
                                                color: "#FFF"
                                            }

                                            Label {
                                                text: carouselDelegate.title
                                                font.pixelSize: Style.resize(20)
                                                font.bold: true
                                                color: "#FFF"
                                            }

                                            Label {
                                                text: carouselDelegate.subtitle
                                                font.pixelSize: Style.resize(13)
                                                color: Qt.rgba(1, 1, 1, 0.7)
                                            }
                                        }
                                    }
                                }
                            }

                            // Page dots
                            Row {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottomMargin: Style.resize(5)
                                spacing: Style.resize(6)

                                Repeater {
                                    model: carouselList.count
                                    delegate: Rectangle {
                                        id: pageDot
                                        required property int index

                                        width: carouselList.currentIndex === pageDot.index ? Style.resize(20) : Style.resize(8)
                                        height: Style.resize(8)
                                        radius: height / 2
                                        color: carouselList.currentIndex === pageDot.index ? Style.mainColor : Qt.rgba(1, 1, 1, 0.2)

                                        Behavior on width {
                                            NumberAnimation { duration: 200 }
                                        }
                                        Behavior on color {
                                            ColorAnimation { duration: 200 }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 6: Kanban Board ───────────────────────
                        Label {
                            text: "Kanban Board"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(340)
                            spacing: Style.resize(10)

                            // To Do column
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(8)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(6)

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(28)
                                        radius: Style.resize(4)
                                        color: Qt.rgba(0.36, 0.55, 0.94, 0.15)

                                        Label {
                                            anchors.centerIn: parent
                                            text: "📋 To Do"
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: "#5B8DEF"
                                        }
                                    }

                                    Repeater {
                                        model: [
                                            { task: "Add Popups page", tag: "Feature", tagClr: "#5B8DEF" },
                                            { task: "Write unit tests", tag: "Testing", tagClr: "#FF9500" },
                                            { task: "Refactor Style.qml", tag: "Tech Debt", tagClr: "#AF52DE" },
                                            { task: "Add C++ backend", tag: "Feature", tagClr: "#5B8DEF" }
                                        ]

                                        delegate: Rectangle {
                                            id: kanbanTodo
                                            required property var modelData
                                            Layout.fillWidth: true
                                            height: Style.resize(52)
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(8)
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: kanbanTodo.modelData.task
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Rectangle {
                                                    width: tagLabel1.implicitWidth + Style.resize(10)
                                                    height: Style.resize(16)
                                                    radius: Style.resize(3)
                                                    color: Qt.rgba(
                                                        Qt.color(kanbanTodo.modelData.tagClr).r,
                                                        Qt.color(kanbanTodo.modelData.tagClr).g,
                                                        Qt.color(kanbanTodo.modelData.tagClr).b, 0.2)

                                                    Label {
                                                        id: tagLabel1
                                                        anchors.centerIn: parent
                                                        text: kanbanTodo.modelData.tag
                                                        font.pixelSize: Style.resize(9)
                                                        color: kanbanTodo.modelData.tagClr
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }
                                }
                            }

                            // In Progress column
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(8)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(6)

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(28)
                                        radius: Style.resize(4)
                                        color: Qt.rgba(1, 0.58, 0, 0.15)

                                        Label {
                                            anchors.centerIn: parent
                                            text: "🔨 In Progress"
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: "#FF9500"
                                        }
                                    }

                                    Repeater {
                                        model: [
                                            { task: "Custom Lists page", tag: "Feature", tagClr: "#5B8DEF" },
                                            { task: "Dark theme polish", tag: "Design", tagClr: "#00D1A9" }
                                        ]

                                        delegate: Rectangle {
                                            id: kanbanProgress
                                            required property var modelData
                                            Layout.fillWidth: true
                                            height: Style.resize(52)
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(8)
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: kanbanProgress.modelData.task
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Rectangle {
                                                    width: tagLabel2.implicitWidth + Style.resize(10)
                                                    height: Style.resize(16)
                                                    radius: Style.resize(3)
                                                    color: Qt.rgba(
                                                        Qt.color(kanbanProgress.modelData.tagClr).r,
                                                        Qt.color(kanbanProgress.modelData.tagClr).g,
                                                        Qt.color(kanbanProgress.modelData.tagClr).b, 0.2)

                                                    Label {
                                                        id: tagLabel2
                                                        anchors.centerIn: parent
                                                        text: kanbanProgress.modelData.tag
                                                        font.pixelSize: Style.resize(9)
                                                        color: kanbanProgress.modelData.tagClr
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }
                                }
                            }

                            // Done column
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(8)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(10)
                                    spacing: Style.resize(6)

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(28)
                                        radius: Style.resize(4)
                                        color: Qt.rgba(0.2, 0.78, 0.35, 0.15)

                                        Label {
                                            anchors.centerIn: parent
                                            text: "✅ Done"
                                            font.pixelSize: Style.resize(12)
                                            font.bold: true
                                            color: "#34C759"
                                        }
                                    }

                                    Repeater {
                                        model: [
                                            { task: "Maps page", tag: "Feature", tagClr: "#5B8DEF" },
                                            { task: "Indicators expansion", tag: "Feature", tagClr: "#5B8DEF" },
                                            { task: "Animations expansion", tag: "Feature", tagClr: "#5B8DEF" }
                                        ]

                                        delegate: Rectangle {
                                            id: kanbanDone
                                            required property var modelData
                                            Layout.fillWidth: true
                                            height: Style.resize(52)
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(8)
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: kanbanDone.modelData.task
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Rectangle {
                                                    width: tagLabel3.implicitWidth + Style.resize(10)
                                                    height: Style.resize(16)
                                                    radius: Style.resize(3)
                                                    color: Qt.rgba(
                                                        Qt.color(kanbanDone.modelData.tagClr).r,
                                                        Qt.color(kanbanDone.modelData.tagClr).g,
                                                        Qt.color(kanbanDone.modelData.tagClr).b, 0.2)

                                                    Label {
                                                        id: tagLabel3
                                                        anchors.centerIn: parent
                                                        text: kanbanDone.modelData.tag
                                                        font.pixelSize: Style.resize(9)
                                                        color: kanbanDone.modelData.tagClr
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
