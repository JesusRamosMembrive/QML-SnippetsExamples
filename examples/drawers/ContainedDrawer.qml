import QtQuick

import utils

Item {
    id: root

    property int edge: Qt.LeftEdge
    property real sizeRatio: 0.6
    property color accentColor: Style.mainColor
    property color drawerColor: Style.bgColor
    property color borderColor: Style.surfaceColor
    property color scrimColor: "#66000000"
    property bool opened: false
    property real position: 0.0

    readonly property bool verticalDrawer: edge === Qt.LeftEdge || edge === Qt.RightEdge
    readonly property real panelWidth: verticalDrawer ? width * sizeRatio : width
    readonly property real panelHeight: verticalDrawer ? height : height * sizeRatio

    default property alias contentData: contentContainer.data

    anchors.fill: parent
    z: 20

    function open() {
        opened = true
    }

    function close() {
        opened = false
    }

    function toggle() {
        opened = !opened
    }

    function clamp(value) {
        return Math.max(0, Math.min(1, value))
    }

    function updateFromRootPoint(xPos, yPos) {
        if (edge === Qt.LeftEdge)
            position = clamp(xPos / panelWidth)
        else if (edge === Qt.RightEdge)
            position = clamp((width - xPos) / panelWidth)
        else if (edge === Qt.TopEdge)
            position = clamp(yPos / panelHeight)
        else
            position = clamp((height - yPos) / panelHeight)
    }

    onOpenedChanged: position = opened ? 1.0 : 0.0

    Rectangle {
        anchors.fill: parent
        visible: root.position > 0
        z: 0
        radius: root.parent && root.parent.radius !== undefined ? root.parent.radius : 0
        color: root.scrimColor
        opacity: root.position
    }

    MouseArea {
        anchors.fill: parent
        visible: root.position > 0
        enabled: visible
        z: 1
        onClicked: root.close()
    }

    MouseArea {
        id: edgeHandle
        z: 1
        enabled: !root.opened
        visible: enabled

        anchors.left: root.edge === Qt.LeftEdge ? parent.left : undefined
        anchors.right: root.edge === Qt.RightEdge ? parent.right : undefined
        anchors.top: root.edge === Qt.TopEdge ? parent.top : undefined
        anchors.bottom: root.edge === Qt.BottomEdge ? parent.bottom : undefined

        width: root.verticalDrawer ? Style.resize(18) : parent.width
        height: root.verticalDrawer ? parent.height : Style.resize(18)

        onPressed: root.updateFromRootPoint(mouseX + x, mouseY + y)
        onPositionChanged: if (pressed) root.updateFromRootPoint(mouseX + x, mouseY + y)
        onReleased: root.opened = root.position > 0.35
    }

    Rectangle {
        id: panel
        z: 2
        width: root.panelWidth
        height: root.panelHeight
        x: {
            if (root.edge === Qt.LeftEdge)
                return -width + (root.position * width)
            if (root.edge === Qt.RightEdge)
                return root.width - (root.position * width)
            return 0
        }
        y: {
            if (root.edge === Qt.TopEdge)
                return -height + (root.position * height)
            if (root.edge === Qt.BottomEdge)
                return root.height - (root.position * height)
            return 0
        }
        color: root.drawerColor
        border.color: root.borderColor
        border.width: 1

        Behavior on x {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on y {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.right: root.edge === Qt.LeftEdge ? parent.right : undefined
            anchors.left: root.edge === Qt.RightEdge ? parent.left : undefined
            anchors.top: root.edge === Qt.BottomEdge ? parent.top : undefined
            anchors.bottom: root.edge === Qt.TopEdge ? parent.bottom : undefined
            width: root.verticalDrawer ? 4 : parent.width
            height: root.verticalDrawer ? parent.height : 4
            color: root.accentColor
        }

        MouseArea {
            z: 1
            anchors.left: root.edge === Qt.LeftEdge ? parent.left : undefined
            anchors.right: root.edge === Qt.RightEdge ? parent.right : undefined
            anchors.top: root.edge === Qt.TopEdge ? parent.top : undefined
            anchors.bottom: root.edge === Qt.BottomEdge ? parent.bottom : undefined
            width: root.verticalDrawer ? Style.resize(18) : parent.width
            height: root.verticalDrawer ? parent.height : Style.resize(18)
            onPressed: root.updateFromRootPoint(panel.x + mouseX, panel.y + mouseY)
            onPositionChanged: if (pressed) root.updateFromRootPoint(panel.x + mouseX, panel.y + mouseY)
            onReleased: root.opened = root.position > 0.65
        }

        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: Style.resize(20)
        }
    }
}
