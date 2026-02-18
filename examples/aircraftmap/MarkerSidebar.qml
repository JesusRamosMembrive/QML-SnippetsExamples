import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var markerModel
    property int selectedMarker: -1

    property bool showExits:     true
    property bool showHydraulic: true
    property bool showEmergency: true
    property bool showFuel:      true
    property bool showAvionics:  true

    signal markerClicked(int index)

    function isCategoryVisible(cat) {
        if (cat === "exits")     return showExits
        if (cat === "hydraulic") return showHydraulic
        if (cat === "emergency") return showEmergency
        if (cat === "fuel")      return showFuel
        if (cat === "avionics")  return showAvionics
        return true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(12)
        spacing: Style.resize(10)

        Label {
            text: "Filters"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        CheckBox { text: "Exits";     checked: root.showExits;     onToggled: root.showExits = checked
            palette.highlight: "#4CAF50" }
        CheckBox { text: "Hydraulic"; checked: root.showHydraulic; onToggled: root.showHydraulic = checked
            palette.highlight: "#2196F3" }
        CheckBox { text: "Emergency"; checked: root.showEmergency; onToggled: root.showEmergency = checked
            palette.highlight: "#F44336" }
        CheckBox { text: "Fuel";      checked: root.showFuel;      onToggled: root.showFuel = checked
            palette.highlight: "#FF9800" }
        CheckBox { text: "Avionics";  checked: root.showAvionics;  onToggled: root.showAvionics = checked
            palette.highlight: "#9C27B0" }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Style.bgColor
        }

        Label {
            text: "Markers"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        ListView {
            id: markerListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.markerModel
            spacing: Style.resize(2)
            currentIndex: root.selectedMarker

            delegate: Rectangle {
                id: listDelegate
                width: markerListView.width
                height: Style.resize(30)
                radius: Style.resize(4)
                visible: root.isCategoryVisible(model.category)
                color: index === root.selectedMarker
                       ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                implicitHeight: visible ? Style.resize(30) : 0

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(6)
                    anchors.rightMargin: Style.resize(6)
                    spacing: Style.resize(6)
                    visible: listDelegate.visible

                    Rectangle {
                        width: Style.resize(10)
                        height: width
                        radius: width / 2
                        color: model.color
                    }

                    Label {
                        text: model.name
                        font.pixelSize: Style.resize(12)
                        color: Style.fontPrimaryColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    visible: listDelegate.visible
                    onClicked: root.markerClicked(index)
                }
            }
        }
    }
}
