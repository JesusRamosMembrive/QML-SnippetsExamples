import QtQuick

import utils

Item {
    id: root

    property string currentItemName: mainMenuList.currentItemName
    signal menuItemClicked(var name)

    Rectangle {
        id: mainMenuColorFill
        width: root.width
        height: root.height
        color: Style.bgColorDashBoradMenu

        MainMenuList {
            id: mainMenuList
            anchors.fill: parent
            anchors.topMargin: Style.resize(20)
            anchors.bottomMargin: Style.resize(20)
            onMenuItemClicked: function(name) {
                root.menuItemClicked(name);
            }
        }
    }
}
