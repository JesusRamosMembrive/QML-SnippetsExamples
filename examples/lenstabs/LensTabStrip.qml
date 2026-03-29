pragma ComponentBehavior: Bound

import QtQuick
import utils

Item {
    id: root

    property var tabs: ["Explore", "Library", "Signals", "Profile"]
    property int currentIndex: 0
    property int travelDuration: 320
    property real lensInset: Style.resize(6)
    property real magnification: 1.12
    property real glowStrength: 0.30
    property real lensOverhang: Style.resize(9)
    property real distortionStrength: Style.resize(6.5)
    property color trackColor: Style.surfaceColor
    property color outlineColor: "#3A3D45"
    property color tabTextColor: Style.fontSecondaryColor
    property color lensTextColor: "#10191F"
    property color lensTopColor: Qt.rgba(1.0, 1.0, 1.0, 0.96)
    property color lensBottomColor: Qt.rgba(0.83, 0.97, 0.93, 0.90)
    property real lensX: lensInset
    property real lensWidth: width

    readonly property int tabCount: Math.max(1, tabs.length)
    readonly property real lensCenter: lensX + lensWidth / 2

    signal tabTriggered(int index, string label)

    implicitHeight: Style.resize(92)

    function syncLensGeometry() {
        if (!tabRepeater.count)
            return

        const tabItem = tabRepeater.itemAt(Math.max(0, Math.min(currentIndex, tabRepeater.count - 1)))
        if (!tabItem)
            return

        lensX = tabItem.x + lensInset
        lensWidth = Math.max(Style.resize(64), tabItem.width - lensInset * 2)
    }

    onCurrentIndexChanged: Qt.callLater(syncLensGeometry)
    onWidthChanged: Qt.callLater(syncLensGeometry)
    onTabsChanged: Qt.callLater(syncLensGeometry)
    Component.onCompleted: Qt.callLater(syncLensGeometry)

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - root.lensOverhang * 2
        radius: height / 2
        color: root.trackColor
        border.color: root.outlineColor
        border.width: 1
        clip: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: (height - 2) / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
                GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.01) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.12) }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Style.resize(10)
            anchors.rightMargin: Style.resize(10)
            height: Style.resize(1)
            color: Qt.rgba(1, 1, 1, 0.07)
        }

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
                        font.letterSpacing: 0.2
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

        Item {
            id: lensWindow
            x: root.lensX
            y: root.lensInset - root.lensOverhang
            width: root.lensWidth
            height: parent.height - root.lensInset * 2 + root.lensOverhang * 2
            clip: false

            Behavior on x {
                NumberAnimation {
                    duration: root.travelDuration
                    easing.type: Easing.InOutCubic
                }
            }

            Behavior on width {
                NumberAnimation {
                    duration: root.travelDuration
                    easing.type: Easing.InOutCubic
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: Style.resize(7)
                anchors.bottomMargin: Style.resize(-4)
                anchors.leftMargin: Style.resize(-3)
                anchors.rightMargin: Style.resize(-3)
                radius: height / 2
                color: Qt.rgba(0.02, 0.07, 0.09, 0.26)
            }

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1.0, 1.0, 1.0, 0.98) }
                    GradientStop { position: 0.32; color: Qt.rgba(0.88, 1.0, 0.97, 0.92) }
                    GradientStop { position: 0.65; color: Qt.rgba(0.70, 0.95, 0.90, 0.84) }
                    GradientStop { position: 1.0; color: Qt.rgba(0.48, 0.86, 0.80, 0.74) }
                }
                border.color: Qt.rgba(1, 1, 1, 0.72)
                border.width: 1.2
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: Style.resize(2)
                radius: height / 2
                color: "transparent"
                border.color: Qt.rgba(0.72, 1.0, 0.95, 0.32)
                border.width: 1
            }

            Rectangle {
                width: parent.width * 0.88
                height: parent.height * 0.28
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Style.resize(6)
                color: Qt.rgba(1, 1, 1, 0.40)
            }

            Rectangle {
                width: parent.width * 0.94
                height: parent.height * 0.42
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.22) }
                    GradientStop { position: 0.55; color: Qt.rgba(1, 1, 1, 0.04) }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.08) }
                }
            }

            Rectangle {
                width: Style.resize(10)
                height: parent.height * 0.82
                radius: width / 2
                anchors.left: parent.left
                anchors.leftMargin: Style.resize(6)
                anchors.verticalCenter: parent.verticalCenter
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.52) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.06) }
                }
            }

            Rectangle {
                width: Style.resize(8)
                height: parent.height * 0.76
                radius: width / 2
                anchors.right: parent.right
                anchors.rightMargin: Style.resize(6)
                anchors.verticalCenter: parent.verticalCenter
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0.18, 0.55, 0.50, 0.32) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.05) }
                }
            }

            Rectangle {
                width: parent.width * 0.52
                height: parent.height * 0.09
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(8)
                color: Qt.rgba(0, 0, 0, 0.13)
            }

            Item {
                id: lensClip
                anchors.fill: parent
                clip: true

                Row {
                    id: lensRow
                    x: -lensWindow.x
                    width: track.width
                    height: track.height
                    y: root.lensOverhang

                    Repeater {
                        model: root.tabs

                        delegate: Item {
                            id: lensCell
                            required property int index
                            required property var modelData

                            width: lensRow.width / root.tabCount
                            height: lensRow.height

                            readonly property real localCenter: (lensCell.x + lensCell.width / 2) - root.lensX
                            readonly property real lensOffset: (localCenter - lensWindow.width / 2) / Math.max(1, lensWindow.width / 2)
                            readonly property real warpAmount: lensCell.lensOffset * root.distortionStrength

                            Text {
                                anchors.centerIn: parent
                                text: String(lensCell.modelData)
                                font.family: Style.fontFamilyBold
                                font.pixelSize: Style.resize(15)
                                font.bold: true
                                font.letterSpacing: 1.2
                                color: Qt.rgba(1, 1, 1, 0.38)
                                scale: root.magnification + 0.07
                                x: -lensCell.warpAmount * 0.75
                                y: -Style.resize(3)
                                opacity: 0.42
                            }

                            Text {
                                anchors.centerIn: parent
                                text: String(lensCell.modelData)
                                font.family: Style.fontFamilyBold
                                font.pixelSize: Style.resize(15)
                                font.bold: true
                                font.letterSpacing: 0.9
                                color: Qt.rgba(0.22, 0.85, 0.80, 0.34)
                                scale: root.magnification + 0.03
                                x: lensCell.warpAmount * 0.42 + Style.resize(2)
                                y: Style.resize(1)
                                opacity: 0.36
                            }

                            Text {
                                anchors.centerIn: parent
                                text: String(lensCell.modelData)
                                font.family: Style.fontFamilyBold
                                font.pixelSize: Style.resize(15)
                                font.bold: true
                                font.letterSpacing: 0.9
                                color: root.lensTextColor
                                scale: root.magnification
                                x: lensCell.warpAmount
                                y: Math.abs(lensCell.lensOffset) * Style.resize(1.3) - Style.resize(1)
                                opacity: 0.98
                            }
                        }
                    }
                }
            }
        }
    }
}
