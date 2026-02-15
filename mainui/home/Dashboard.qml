import QtQuick
import QtCore

import utils
import buttons as Buttons

Item {
    id: root
    state: "Dashboard"
    objectName: "Dashboard"

    Buttons.Main {
        visible: fullSize
        fullSize: (root.state === "Buttons")
    }
}
