import QtQuick
import QtCore

import utils
import buttons as Buttons
import sliders as Sliders
import switches as Switches
import textinputs as TextInputs
import indicators as Indicators
import animations as Animations

Item {
    id: root
    state: "Dashboard"
    objectName: "Dashboard"

    Buttons.Main {
        visible: fullSize
        fullSize: (root.state === "Buttons")
    }

    Sliders.Main {
        visible: fullSize
        fullSize: (root.state === "Sliders")
    }

    Switches.Main {
        visible: fullSize
        fullSize: (root.state === "Switches")
    }

    TextInputs.Main {
        visible: fullSize
        fullSize: (root.state === "TextInputs")
    }

    Indicators.Main {
        visible: fullSize
        fullSize: (root.state === "Indicators")
    }

    Animations.Main {
        visible: fullSize
        fullSize: (root.state === "Animations")
    }
}
