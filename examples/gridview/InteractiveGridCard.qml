import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string filterText: ""

    ListModel {
        id: allItems
        ListElement { tag: "Qt";      icon: "\u25A3"; clr: "#41CD52"; category: "framework" }
        ListElement { tag: "C++";     icon: "\u2726"; clr: "#00599C"; category: "language" }
        ListElement { tag: "QML";     icon: "\u25C8"; clr: "#00D1A9"; category: "language" }
        ListElement { tag: "CMake";   icon: "\u2699"; clr: "#064F8C"; category: "tool" }
        ListElement { tag: "Git";     icon: "\u2442"; clr: "#F05032"; category: "tool" }
        ListElement { tag: "Python";  icon: "\u2728"; clr: "#3776AB"; category: "language" }
        ListElement { tag: "Rust";    icon: "\u2699"; clr: "#DEA584"; category: "language" }
        ListElement { tag: "Docker";  icon: "\u2693"; clr: "#2496ED"; category: "tool" }
        ListElement { tag: "Linux";   icon: "\u2318"; clr: "#FCC624"; category: "tool" }
        ListElement { tag: "SQL";     icon: "\u25A8"; clr: "#FF7043"; category: "language" }
        ListElement { tag: "React";   icon: "\u269B"; clr: "#61DAFB"; category: "framework" }
        ListElement { tag: "Node";    icon: "\u2B22"; clr: "#339933"; category: "framework" }
    }

    ListModel {
        id: filteredModel
    }

    Component.onCompleted: rebuildFilter()

    function rebuildFilter() {
        filteredModel.clear()
        var f = root.filterText.toLowerCase()
        for (var i = 0; i < allItems.count; i++) {
            var item = allItems.get(i)
            if (f === "" || item.tag.toLowerCase().indexOf(f) >= 0
                         || item.category.toLowerCase().indexOf(f) >= 0) {
                filteredModel.append(item)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Filterable Grid"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Search bar
        TextField {
            Layout.fillWidth: true
            placeholderText: "Filter by name or category..."
            font.pixelSize: Style.resize(13)
            onTextChanged: {
                root.filterText = text
                root.rebuildFilter()
            }
        }

        // Category buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: ["All", "language", "framework", "tool"]

                Button {
                    required property string modelData
                    text: modelData
                    font.pixelSize: Style.resize(11)
                    highlighted: root.filterText === modelData || (modelData === "All" && root.filterText === "")
                    onClicked: {
                        root.filterText = (modelData === "All") ? "" : modelData
                        root.rebuildFilter()
                    }
                }
            }
        }

        // Grid
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: filterGrid
                anchors.fill: parent
                clip: true
                cellWidth: width / 3
                cellHeight: Style.resize(80)

                model: filteredModel

                delegate: Item {
                    id: filterDelegate
                    required property string tag
                    required property string icon
                    required property string clr
                    required property string category
                    required property int index
                    width: filterGrid.cellWidth
                    height: filterGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(8)
                        color: Style.surfaceColor
                        border.color: filterDelegate.clr
                        border.width: Style.resize(2)

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(2)

                            Label {
                                text: filterDelegate.icon
                                font.pixelSize: Style.resize(22)
                                color: filterDelegate.clr
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: filterDelegate.tag
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            // Empty state
            Label {
                anchors.centerIn: parent
                text: "No results"
                font.pixelSize: Style.resize(16)
                color: Style.inactiveColor
                visible: filteredModel.count === 0
            }
        }

        Label {
            text: filteredModel.count + " of " + allItems.count + " items"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
