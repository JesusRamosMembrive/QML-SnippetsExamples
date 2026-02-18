import QtQuick
import utils

Item {
    id: splash
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor
    }

    Column {
        anchors.centerIn: parent
        spacing: Style.resize(40)

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.resize(8)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "QML Snippets"
                font.family: Style.fontFamilyBold
                font.pixelSize: Style.resize(42)
                font.bold: true
                color: Style.mainColor
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Examples"
                font.family: Style.fontFamilyBold
                font.pixelSize: Style.resize(28)
                color: Style.fontPrimaryColor
            }
        }

        Item {
            id: spinner
            width: Style.resize(60)
            height: Style.resize(60)
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: 8
                delegate: Rectangle {
                    id: dot
                    required property int index

                    readonly property real angle: index * (360 / 8) * (Math.PI / 180)
                    readonly property real dotRadius: Style.resize(24)

                    x: spinner.width / 2 + dotRadius * Math.cos(angle) - width / 2
                    y: spinner.height / 2 + dotRadius * Math.sin(angle) - height / 2
                    width: Style.resize(8)
                    height: width
                    radius: width / 2
                    color: Style.mainColor
                    opacity: 0.3
                    scale: 0.6

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        PauseAnimation { duration: dot.index * 100 }
                        NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 0.3; duration: 400; easing.type: Easing.InOutQuad }
                        PauseAnimation { duration: (7 - dot.index) * 100 }
                    }

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        PauseAnimation { duration: dot.index * 100 }
                        NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 0.6; duration: 400; easing.type: Easing.InOutQuad }
                        PauseAnimation { duration: (7 - dot.index) * 100 }
                    }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Loading..."
            font.family: Style.fontFamilyRegular
            font.pixelSize: Style.resize(14)
            color: Style.inactiveColor
        }
    }
}
