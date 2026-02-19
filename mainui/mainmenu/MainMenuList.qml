pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import utils
import controls

Item {
    id: root
    width: parent.width
    height: parent.height

    property string currentItemName: menuModel.get(listView.currentIndex).name
    signal menuItemClicked(var name)

    ListModel {
        id: menuModel
        ListElement { name: "Dashboard" }
        ListElement { name: "Buttons" }
        ListElement { name: "Sliders" }
        ListElement { name: "RangeSliders" }
        ListElement { name: "ComboBox" }
        ListElement { name: "TabBar" }
        ListElement { name: "SwipeView" }
        ListElement { name: "SplitView" }
        ListElement { name: "ToolBar" }
        ListElement { name: "ScrollView" }
        ListElement { name: "MenuBar" }
        ListElement { name: "PathView" }
        ListElement { name: "GridView" }
        ListElement { name: "Flickable" }
        ListElement { name: "Shaders" }
        ListElement { name: "Loader" }
        ListElement { name: "Images" }
        ListElement { name: "States" }
        ListElement { name: "FileDialogs" }
        ListElement { name: "Switches" }
        ListElement { name: "TextInputs" }
        ListElement { name: "Indicators" }
        ListElement { name: "Animations" }
        ListElement { name: "Popups" }
        ListElement { name: "Lists" }
        ListElement { name: "Canvas" }
        ListElement { name: "Layouts" }
        ListElement { name: "Transforms" }
        ListElement { name: "Particles" }
        ListElement { name: "Graphs" }
        ListElement { name: "PFD" }
        ListElement { name: "HUD" }
        ListElement { name: "WebSocket" }
        ListElement { name: "ECAM" }
        ListElement { name: "NavDisplay" }
        ListElement { name: "Teoria" }
        ListElement { name: "Date" }
        ListElement { name: "AircraftMap" }
        ListElement { name: "Shapes" }
        ListElement { name: "Maps" }
        ListElement { name: "PdfReader" }
        ListElement { name: "Threads" }
        ListElement { name: "TableView" }
        ListElement { name: "TreeView" }
        ListElement { name: "Database" }
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        highlight: Item {
            width: listView.width
            height: Style.resize(47)
            Rectangle {
                anchors.fill: parent
                color: Style.mainColor
                opacity: 0.12
            }
            Rectangle {
                width: Style.resize(4)
                height: parent.height
                color: Style.mainColor
            }
        }
        spacing: Style.resize(20)
        model: menuModel

        delegate: ItemDelegate {
            id: menuDelegate
            required property int index
            required property string name

            width: listView.width
            height: Style.resize(47)
            background: Rectangle { color: "transparent" }
            contentItem: Item {
                anchors.fill: parent
                Image {
                    id: iconImage
                    width: Style.resize(sourceSize.width)
                    height: Style.resize(sourceSize.height)
                    anchors.left: parent.left
                    anchors.leftMargin: Style.resize(40)
                    anchors.verticalCenter: parent.verticalCenter
                    source: Style.icon(menuDelegate.name.toLowerCase())
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: "#ffffff"
                    }
                }
                Label {
                    anchors.left: iconImage.right
                    anchors.leftMargin: Style.resize(20)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Style.resize(3)
                    text: menuDelegate.name
                    color: "#ffffff"
                }
            }

            onClicked: {
                listView.currentIndex = menuDelegate.index;
                root.menuItemClicked(menuDelegate.name);
            }
        }
    }
}
