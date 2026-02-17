import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl

import utils

T.Tumbler {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    readonly property real __delegateHeight: availableHeight / visibleItemCount

    delegate: Text {
        text: modelData
        font.pixelSize: Style.resize(18) * (1.0 - 0.3 * Math.abs(Tumbler.displacement))
        font.family: Style.fontFamilyRegular
        font.bold: Math.abs(Tumbler.displacement) < 0.5
        color: Math.abs(Tumbler.displacement) < 0.5
               ? Style.fontPrimaryColor
               : Style.inactiveColor
        opacity: 1.0 - Math.abs(Tumbler.displacement) / (control.visibleItemCount / 2)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        required property var modelData
        required property int index
    }

    contentItem: TumblerView {
        implicitWidth: Style.resize(80)
        implicitHeight: Style.resize(200)
        model: control.model
        delegate: control.delegate
        path: Path {
            startX: control.contentItem.width / 2
            startY: -control.__delegateHeight / 2
            PathLine {
                x: control.contentItem.width / 2
                y: (control.visibleItemCount + 1) * control.__delegateHeight
                   - control.__delegateHeight / 2
            }
        }
    }

    background: Rectangle {
        implicitWidth: Style.resize(80)
        implicitHeight: Style.resize(200)
        color: "transparent"
        radius: Style.resize(8)
        border.width: 1
        border.color: Qt.rgba(Style.inactiveColor.r, Style.inactiveColor.g,
                              Style.inactiveColor.b, 0.4)
    }

    // Central highlight band
    Rectangle {
        parent: control.background
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - height / 2
        width: parent.width - Style.resize(4)
        height: control.__delegateHeight
        color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                       Style.mainColor.b, 0.12)
        radius: Style.resize(6)

        // Top separator
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                           Style.mainColor.b, 0.3)
        }

        // Bottom separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(Style.mainColor.r, Style.mainColor.g,
                           Style.mainColor.b, 0.3)
        }
    }
}
