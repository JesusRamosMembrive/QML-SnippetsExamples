pragma ComponentBehavior: Bound

import QtQuick
import utils

Item {
    id: root

    property var tabs: ["Explore", "Library", "Signals", "Profile"]
    property int currentIndex: 0
    property int travelDuration: 320
    property real lensInset: Style.resize(5)
    property real magnification: 1.08
    property real glowStrength: 0.30
    property color trackColor: Style.surfaceColor
    property color tabTextColor: Style.fontSecondaryColor
    property color lensTextColor: "#0D1A16"

    // Lens geometry — updated by syncLensGeometry(), animated via Behaviors on lensWindow
    property real lensX: lensInset
    property real lensWidth: 100

    readonly property int tabCount: Math.max(1, tabs.length)

    signal tabTriggered(int index, string label)

    implicitHeight: Style.resize(52)

    function syncLensGeometry() {
        if (!tabRepeater.count)
            return
        const idx = Math.max(0, Math.min(currentIndex, tabRepeater.count - 1))
        const tabItem = tabRepeater.itemAt(idx)
        if (!tabItem)
            return
        lensX = tabItem.x + lensInset
        lensWidth = Math.max(Style.resize(60), tabItem.width - lensInset * 2)
    }

    onCurrentIndexChanged: Qt.callLater(syncLensGeometry)
    onWidthChanged:        Qt.callLater(syncLensGeometry)
    onTabsChanged:         Qt.callLater(syncLensGeometry)
    Component.onCompleted: Qt.callLater(syncLensGeometry)

    // ── Track ─────────────────────────────────────────────────────────────
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
        border.color: Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
        clip: false

        // Inner depth gradient
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: (height - 2) / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.12) }
            }
        }

        // ── Base text row (always visible, muted) ─────────────────────────
        Row {
            id: baseRow
            anchors.fill: parent

            Repeater {
                id: tabRepeater
                model: root.tabs

                delegate: Item {
                    id: tabItem
                    required property int index
                    required property var modelData

                    width: baseRow.width / root.tabCount
                    height: baseRow.height

                    Text {
                        anchors.centerIn: parent
                        text: String(tabItem.modelData)
                        font.family: Style.fontFamilyBold
                        font.pixelSize: Style.resize(15)
                        font.letterSpacing: 0.3
                        color: root.tabTextColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentIndex = tabItem.index
                            root.tabTriggered(tabItem.index, String(tabItem.modelData))
                        }
                    }
                }
            }
        }

        // ── Teal ambient glow behind the lens ─────────────────────────────
        Rectangle {
            x: root.lensX - Style.resize(5)
            y: -Style.resize(3)
            width: root.lensWidth + Style.resize(10)
            height: track.height + Style.resize(6)
            radius: height / 2
            color: Qt.rgba(0.0, 0.82, 0.66, root.glowStrength * 0.28)

            Behavior on x     { NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic } }
            Behavior on width { NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic } }
        }

        // ── Moving lens pill ───────────────────────────────────────────────
        Item {
            id: lensWindow
            x: root.lensX
            y: root.lensInset
            width: root.lensWidth
            height: track.height - root.lensInset * 2

            Behavior on x     { NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic } }
            Behavior on width { NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic } }

            // Drop shadow
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: Style.resize(5)
                anchors.bottomMargin: Style.resize(-4)
                anchors.leftMargin: Style.resize(-1)
                anchors.rightMargin: Style.resize(-1)
                radius: height / 2
                color: Qt.rgba(0.0, 0.0, 0.0, 0.28)
            }

            // Teal outer rim glow
            Rectangle {
                anchors.fill: parent
                anchors.margins: Style.resize(-1.5)
                radius: height / 2
                color: "transparent"
                border.color: Qt.rgba(0.0, 0.82, 0.66, root.glowStrength * 0.55)
                border.width: Style.resize(2.5)
            }

            // Lens body — white-to-mint gradient
            Rectangle {
                anchors.fill: parent
                radius: height / 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0.92, 1.00, 0.98, 0.98) }
                    GradientStop { position: 0.55; color: Qt.rgba(0.78, 0.97, 0.93, 0.93) }
                    GradientStop { position: 1.0;  color: Qt.rgba(0.60, 0.92, 0.86, 0.86) }
                }
                border.color: Qt.rgba(1, 1, 1, 0.78)
                border.width: 1
            }

            // Top specular highlight
            Rectangle {
                width: parent.width * 0.80
                height: parent.height * 0.34
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Style.resize(4)
                color: Qt.rgba(1, 1, 1, 0.58)
            }

            // Bottom soft shadow line
            Rectangle {
                width: parent.width * 0.50
                height: Style.resize(2)
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(5)
                color: Qt.rgba(0, 0, 0, 0.12)
            }

            // ── Clipped text layer — dark text inside the lens ─────────────
            Item {
                id: lensClip
                anchors.fill: parent
                clip: true

                Row {
                    x: -lensWindow.x
                    y: -root.lensInset
                    width: track.width
                    height: track.height

                    Repeater {
                        model: root.tabs

                        delegate: Item {
                            required property var modelData

                            width: track.width / root.tabCount
                            height: track.height

                            Text {
                                anchors.centerIn: parent
                                text: String(parent.modelData)
                                font.family: Style.fontFamilyBold
                                font.pixelSize: Style.resize(15)
                                font.bold: true
                                font.letterSpacing: 0.3
                                color: root.lensTextColor
                                scale: root.magnification
                            }
                        }
                    }
                }
            }
        }
    }
}
