import QtQuick
import QtQuick.Controls

import utils
import mainui

ApplicationWindow {
    id: root
    visible: true
    color: Style.bgColor
    title: qsTr("QML Snippets Examples")
    width: Style.screenWidth
    height: Style.screenHeight

    Item {
        anchors.fill: parent
        HomePage {
            id: dashboardAppContent
            anchors.fill: parent
        }
    }
}
