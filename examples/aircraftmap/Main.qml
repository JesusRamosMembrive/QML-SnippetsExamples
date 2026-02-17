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
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // ── State ───────────────────────────────────────────────
    property int selectedMarker: -1
    property real currentZoom: 1.0
    readonly property real minZoom: 0.4
    readonly property real maxZoom: 3.5

    // Category filter flags
    property bool showExits:     true
    property bool showHydraulic: true
    property bool showEmergency: true
    property bool showFuel:      true
    property bool showAvionics:  true

    function isCategoryVisible(cat) {
        if (cat === "exits")     return showExits
        if (cat === "hydraulic") return showHydraulic
        if (cat === "emergency") return showEmergency
        if (cat === "fuel")      return showFuel
        if (cat === "avionics")  return showAvionics
        return true
    }

    function centerOnMarker(idx) {
        var m = markerModel.get(idx)
        var imgW = blueprintImage.implicitWidth * currentZoom
        var imgH = blueprintImage.implicitHeight * currentZoom
        var targetX = m.posX * imgW - flickable.width / 2
        var targetY = m.posY * imgH - flickable.height / 2
        flickable.contentX = Math.max(0, Math.min(targetX, flickable.contentWidth - flickable.width))
        flickable.contentY = Math.max(0, Math.min(targetY, flickable.contentHeight - flickable.height))
        root.selectedMarker = idx
    }

    function resetZoom() {
        currentZoom = 1.0
        flickable.contentX = 0
        flickable.contentY = 0
    }

    function fitToView() {
        var scaleW = flickable.width / blueprintImage.implicitWidth
        var scaleH = flickable.height / blueprintImage.implicitHeight
        currentZoom = Math.min(scaleW, scaleH, maxZoom)
        flickable.contentX = 0
        flickable.contentY = 0
    }

    // ── Marker data ─────────────────────────────────────────
    ListModel {
        id: markerModel

        // Exits (green) — positioned on top-down view (2nd view)
        ListElement { name: "Exit L1";         category: "exits";     color: "#4CAF50"; posX: 0.42; posY: 0.295; description: "Forward left passenger door. Type I exit." }
        ListElement { name: "Exit R1";         category: "exits";     color: "#4CAF50"; posX: 0.58; posY: 0.295; description: "Forward right passenger door. Type I exit." }
        ListElement { name: "Exit L2";         category: "exits";     color: "#4CAF50"; posX: 0.38; posY: 0.46;  description: "Over-wing left exit. Type III exit." }
        ListElement { name: "Exit R2";         category: "exits";     color: "#4CAF50"; posX: 0.62; posY: 0.46;  description: "Over-wing right exit. Type III exit." }
        ListElement { name: "Rear Exit";       category: "exits";     color: "#4CAF50"; posX: 0.50; posY: 0.62;  description: "Aft ventral airstair exit." }

        // Hydraulic (blue)
        ListElement { name: "Hydraulic Sys A"; category: "hydraulic"; color: "#2196F3"; posX: 0.45; posY: 0.52;  description: "Primary hydraulic system. Powers flight controls and landing gear." }
        ListElement { name: "Hydraulic Sys B"; category: "hydraulic"; color: "#2196F3"; posX: 0.55; posY: 0.52;  description: "Secondary hydraulic system. Backup for flight controls." }
        ListElement { name: "Standby Hyd";     category: "hydraulic"; color: "#2196F3"; posX: 0.50; posY: 0.55;  description: "Standby hydraulic system. Emergency power for rudder and thrust reversers." }

        // Emergency (red)
        ListElement { name: "First Aid Fwd";   category: "emergency"; color: "#F44336"; posX: 0.46; posY: 0.32;  description: "Forward first aid kit. Located in overhead bin near L1 door." }
        ListElement { name: "Fire Ext Fwd";    category: "emergency"; color: "#F44336"; posX: 0.54; posY: 0.32;  description: "Forward fire extinguisher. Halon 1211 type, 2.5 lb." }
        ListElement { name: "First Aid Aft";   category: "emergency"; color: "#F44336"; posX: 0.46; posY: 0.58;  description: "Aft first aid kit. Located near rear galley area." }
        ListElement { name: "Fire Ext Aft";    category: "emergency"; color: "#F44336"; posX: 0.54; posY: 0.58;  description: "Aft fire extinguisher. Halon 1211 type, 2.5 lb." }
        ListElement { name: "ELT";             category: "emergency"; color: "#F44336"; posX: 0.50; posY: 0.60;  description: "Emergency Locator Transmitter. Activates on impact or manually." }

        // Fuel (orange)
        ListElement { name: "Center Tank";     category: "fuel";      color: "#FF9800"; posX: 0.50; posY: 0.42;  description: "Center fuel tank. Capacity: 4,720 gallons. Used first in flight." }
        ListElement { name: "Left Wing Tank";  category: "fuel";      color: "#FF9800"; posX: 0.28; posY: 0.44;  description: "Left wing fuel tank. Capacity: 1,800 gallons." }
        ListElement { name: "Right Wing Tank"; category: "fuel";      color: "#FF9800"; posX: 0.72; posY: 0.44;  description: "Right wing fuel tank. Capacity: 1,800 gallons." }

        // Avionics (purple)
        ListElement { name: "FMC";             category: "avionics";  color: "#9C27B0"; posX: 0.48; posY: 0.27;  description: "Flight Management Computer. Navigation, performance, and route management." }
        ListElement { name: "Weather Radar";   category: "avionics";  color: "#9C27B0"; posX: 0.50; posY: 0.24;  description: "Weather radar antenna in nose cone. Range up to 320 NM." }
        ListElement { name: "Radio Stack";     category: "avionics";  color: "#9C27B0"; posX: 0.52; posY: 0.27;  description: "VHF comm, VHF nav, ADF, transponder, and DME equipment." }
    }

    // ── UI ──────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(15)

            // Header
            Label {
                text: "Aircraft Blueprint"
                font.pixelSize: Style.resize(32)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(15)

                // ═══════════════════════════════════════
                // Sidebar
                // ═══════════════════════════════════════
                Rectangle {
                    Layout.preferredWidth: Style.resize(230)
                    Layout.fillHeight: true
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(12)
                        spacing: Style.resize(10)

                        // Filters header
                        Label {
                            text: "Filters"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        // Category checkboxes
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

                        // Markers list header
                        Label {
                            text: "Markers"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        // Scrollable marker list
                        ListView {
                            id: markerListView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: markerModel
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

                                // Keep height 0 when hidden so ListView doesn't leave gaps
                                // (ListView doesn't collapse invisible delegates)
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
                                    onClicked: root.centerOnMarker(index)
                                }
                            }
                        }
                    }
                }

                // ═══════════════════════════════════════
                // Blueprint Viewer
                // ═══════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        // Zoom toolbar
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(40)
                            color: Style.grey

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(12)
                                anchors.rightMargin: Style.resize(12)
                                spacing: Style.resize(10)

                                Label {
                                    text: "Zoom: " + Math.round(root.currentZoom * 100) + "%"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontPrimaryColor
                                }

                                Slider {
                                    id: zoomSlider
                                    from: root.minZoom
                                    to: root.maxZoom
                                    value: root.currentZoom
                                    stepSize: 0.1
                                    Layout.preferredWidth: Style.resize(150)
                                    onMoved: root.currentZoom = value
                                }

                                Button {
                                    text: "Fit"
                                    flat: true
                                    Layout.preferredHeight: Style.resize(30)
                                    onClicked: root.fitToView()
                                }

                                Button {
                                    text: "Reset"
                                    flat: true
                                    Layout.preferredHeight: Style.resize(30)
                                    onClicked: root.resetZoom()
                                }

                                Item { Layout.fillWidth: true }

                                Label {
                                    text: root.selectedMarker >= 0
                                          ? markerModel.get(root.selectedMarker).name
                                          : "Click a marker for details"
                                    font.pixelSize: Style.resize(12)
                                    color: root.selectedMarker >= 0
                                           ? Style.mainColor : Style.inactiveColor
                                    font.italic: root.selectedMarker < 0
                                }
                            }
                        }

                        // Flickable image area
                        Flickable {
                            id: flickable
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            contentWidth:  imageItem.width * root.currentZoom
                            contentHeight: imageItem.height * root.currentZoom

                            // Click on empty area deselects
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.selectedMarker = -1
                                    infoPopup.close()
                                }
                                // Pass through to Flickable for drag
                                propagateComposedEvents: true
                                onPressed: function(mouse) { mouse.accepted = false }
                            }

                            Item {
                                id: imageItem
                                width:  blueprintImage.implicitWidth
                                height: blueprintImage.implicitHeight
                                transformOrigin: Item.TopLeft
                                scale: root.currentZoom

                                Image {
                                    id: blueprintImage
                                    anchors.fill: parent
                                    source: Style.gfx("planeBluePrint")
                                    fillMode: Image.PreserveAspectFit
                                }

                                // ── Markers overlay ──
                                Repeater {
                                    model: markerModel

                                    Item {
                                        id: markerItem
                                        required property int index
                                        required property string name
                                        required property string category
                                        required property string color
                                        required property real posX
                                        required property real posY
                                        required property string description

                                        x: posX * imageItem.width - width / 2
                                        y: posY * imageItem.height - height / 2
                                        width: Style.resize(28)
                                        height: width
                                        visible: root.isCategoryVisible(category)

                                        // Pulse animation for selected marker
                                        Rectangle {
                                            id: pulseCircle
                                            anchors.centerIn: parent
                                            width: parent.width * 1.8 / root.currentZoom
                                            height: width
                                            radius: width / 2
                                            color: "transparent"
                                            border.color: markerItem.color
                                            border.width: 2 / root.currentZoom
                                            opacity: 0
                                            visible: root.selectedMarker === markerItem.index

                                            SequentialAnimation on opacity {
                                                running: root.selectedMarker === markerItem.index
                                                loops: Animation.Infinite
                                                NumberAnimation { from: 0.8; to: 0; duration: 1200 }
                                                PauseAnimation { duration: 300 }
                                            }
                                        }

                                        // Marker circle
                                        Rectangle {
                                            id: markerCircle
                                            anchors.centerIn: parent
                                            width: Style.resize(24) / root.currentZoom
                                            height: width
                                            radius: width / 2
                                            color: markerItem.color
                                            border.color: "white"
                                            border.width: Style.resize(2) / root.currentZoom

                                            Text {
                                                anchors.centerIn: parent
                                                text: (markerItem.index + 1).toString()
                                                color: "white"
                                                font.bold: true
                                                font.pixelSize: Style.resize(11) / root.currentZoom
                                            }
                                        }

                                        MouseArea {
                                            anchors.centerIn: parent
                                            width: Style.resize(32) / root.currentZoom
                                            height: width
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.selectedMarker = markerItem.index
                                                infoPopup.markerIndex = markerItem.index
                                                infoPopup.open()
                                            }
                                        }
                                    }
                                }
                            }

                            WheelHandler {
                                onWheel: function(event) {
                                    var factor = event.angleDelta.y > 0 ? 1.15 : 0.87
                                    root.currentZoom = Math.max(root.minZoom,
                                        Math.min(root.maxZoom, root.currentZoom * factor))
                                }
                            }

                            ScrollBar.vertical:   ScrollBar { policy: ScrollBar.AsNeeded }
                            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }
                        }
                    }

                    // ── Info Popup ──
                    Popup {
                        id: infoPopup
                        property int markerIndex: -1

                        x: parent.width - width - Style.resize(20)
                        y: Style.resize(60)
                        width: Style.resize(280)
                        padding: 0
                        modal: false
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                        background: Rectangle {
                            color: Style.cardColor
                            radius: Style.resize(10)
                            border.color: infoPopup.markerIndex >= 0
                                          ? markerModel.get(infoPopup.markerIndex).color
                                          : Style.inactiveColor
                            border.width: Style.resize(2)

                            // Shadow
                            layer.enabled: true
                            layer.effect: Item {}
                        }

                        contentItem: ColumnLayout {
                            spacing: Style.resize(8)
                            visible: infoPopup.markerIndex >= 0

                            // Header bar with category color
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(36)
                                color: infoPopup.markerIndex >= 0
                                       ? markerModel.get(infoPopup.markerIndex).color
                                       : "gray"
                                radius: Style.resize(8)

                                // Square off bottom corners
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: parent.width
                                    height: Style.resize(8)
                                    color: parent.color
                                }

                                Label {
                                    anchors.centerIn: parent
                                    text: infoPopup.markerIndex >= 0
                                          ? markerModel.get(infoPopup.markerIndex).name
                                          : ""
                                    font.pixelSize: Style.resize(15)
                                    font.bold: true
                                    color: "white"
                                }
                            }

                            // Category badge
                            RowLayout {
                                Layout.leftMargin: Style.resize(12)
                                spacing: Style.resize(6)

                                Rectangle {
                                    width: Style.resize(8)
                                    height: width
                                    radius: width / 2
                                    color: infoPopup.markerIndex >= 0
                                           ? markerModel.get(infoPopup.markerIndex).color
                                           : "gray"
                                }

                                Label {
                                    text: infoPopup.markerIndex >= 0
                                          ? markerModel.get(infoPopup.markerIndex).category.toUpperCase()
                                          : ""
                                    font.pixelSize: Style.resize(11)
                                    font.bold: true
                                    color: Style.inactiveColor
                                }
                            }

                            // Description
                            Label {
                                Layout.fillWidth: true
                                Layout.leftMargin: Style.resize(12)
                                Layout.rightMargin: Style.resize(12)
                                Layout.bottomMargin: Style.resize(12)
                                text: infoPopup.markerIndex >= 0
                                      ? markerModel.get(infoPopup.markerIndex).description
                                      : ""
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                                wrapMode: Text.WordWrap
                                lineHeight: 1.3
                            }
                        }
                    }
                }
            }
        }
    }

    // Sync zoom slider
    Binding {
        target: zoomSlider
        property: "value"
        value: root.currentZoom
    }

    Component.onCompleted: fitToView()
}
