import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import utils
import controls

Item {
    id: root
    width: parent.width
    height: parent.height

    property string currentItemName: menuModel.get(listView.currentIndex).text
    signal menuItemClicked(var name)

    ListModel {
        id: menuModel
        ListElement { text: "Dashboard" }
        ListElement { text: "Buttons" }
        ListElement { text: "Sliders" }
        ListElement { text: "Switches" }
        ListElement { text: "TextInputs" }
        ListElement { text: "Indicators" }
        ListElement { text: "Animations" }
        ListElement { text: "Popups" }
        ListElement { text: "Lists" }
        ListElement { text: "Canvas" }
        ListElement { text: "Layouts" }
        ListElement { text: "Transforms" }
        ListElement { text: "Particles" }
        ListElement { text: "Graphs" }
        ListElement { text: "PFD" }
        ListElement { text: "HUD" }
        ListElement { text: "WebSocket" }
        ListElement { text: "ECAM" }
        ListElement { text: "NavDisplay" }
        ListElement { text: "Teoria" }
        ListElement { text: "Date" }
        ListElement { text: "AircraftMap" }
        ListElement { text: "Shapes" }
        ListElement { text: "Maps" }
        ListElement { text: "PdfReader" }
        ListElement { text: "Threads" }
        ListElement { text: "TableView" }
        ListElement { text: "TreeView" }
        ListElement { text: "Database" }
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
                color: Style.bgColorDark
                opacity: .6
            }
            Rectangle {
                width: Style.resize(4)
                height: parent.height
                color: Style.bgColor
            }
        }
        spacing: Style.resize(20)
        model: menuModel

        delegate: ItemDelegate {
            width: listView.width
            height: Style.resize(47)
            background: Rectangle { color: Style.bgColorDark }
            contentItem: Item {
                anchors.fill: parent
                Image {
                    id: iconImage
                    width: Style.resize(sourceSize.width)
                    height: Style.resize(sourceSize.height)
                    anchors.left: parent.left
                    anchors.leftMargin: Style.resize(40)
                    anchors.verticalCenter: parent.verticalCenter
                    source: Style.icon(model.text.toLowerCase())
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: "#fff"
                    }
                }
                Label {
                    anchors.left: iconImage.right
                    anchors.leftMargin: Style.resize(20)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Style.resize(3)
                    text: model.text
                    color: "#fff"
                }
            }

            onClicked: {
                listView.currentIndex = index;
                root.menuItemClicked(model.text);
            }
        }
    }
}
