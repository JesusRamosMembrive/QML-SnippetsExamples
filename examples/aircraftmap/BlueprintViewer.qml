import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)
    clip: true

    property var markerModel
    property int selectedMarker: -1

    property bool showExits:     true
    property bool showHydraulic: true
    property bool showEmergency: true
    property bool showFuel:      true
    property bool showAvionics:  true

    property real currentZoom: 1.0
    readonly property real minZoom: 0.4
    readonly property real maxZoom: 3.5

    signal markerSelected(int index)
    signal deselected()

    function isCategoryVisible(cat) {
        if (cat === "exits")     return showExits
        if (cat === "hydraulic") return showHydraulic
        if (cat === "emergency") return showEmergency
        if (cat === "fuel")      return showFuel
        if (cat === "avionics")  return showAvionics
        return true
    }

    function centerOnMarker(idx) {
        var m = root.markerModel.get(idx)
        var imgW = blueprintImage.implicitWidth * currentZoom
        var imgH = blueprintImage.implicitHeight * currentZoom
        var targetX = m.posX * imgW - flickable.width / 2
        var targetY = m.posY * imgH - flickable.height / 2
        flickable.contentX = Math.max(0, Math.min(targetX, flickable.contentWidth - flickable.width))
        flickable.contentY = Math.max(0, Math.min(targetY, flickable.contentHeight - flickable.height))
        root.markerSelected(idx)
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
                          ? root.markerModel.get(root.selectedMarker).name
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

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.deselected()
                    infoPopup.close()
                }
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

                // Markers overlay
                Repeater {
                    model: root.markerModel

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
                                root.markerSelected(markerItem.index)
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

    // Info Popup
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
                          ? root.markerModel.get(infoPopup.markerIndex).color
                          : Style.inactiveColor
            border.width: Style.resize(2)

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
                       ? root.markerModel.get(infoPopup.markerIndex).color
                       : "gray"
                radius: Style.resize(8)

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: Style.resize(8)
                    color: parent.color
                }

                Label {
                    anchors.centerIn: parent
                    text: infoPopup.markerIndex >= 0
                          ? root.markerModel.get(infoPopup.markerIndex).name
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
                           ? root.markerModel.get(infoPopup.markerIndex).color
                           : "gray"
                }

                Label {
                    text: infoPopup.markerIndex >= 0
                          ? root.markerModel.get(infoPopup.markerIndex).category.toUpperCase()
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
                      ? root.markerModel.get(infoPopup.markerIndex).description
                      : ""
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
                wrapMode: Text.WordWrap
                lineHeight: 1.3
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
