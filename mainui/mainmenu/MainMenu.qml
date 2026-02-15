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
        color: Style.mainColor

        MainMenuList {
            id: mainMenuList
            anchors.centerIn: parent
            onMenuItemClicked: function(name) {
                root.menuItemClicked(name);
            }
        }
    }
}
