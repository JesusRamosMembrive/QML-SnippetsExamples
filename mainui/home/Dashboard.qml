import QtQuick
import QtCore

import utils
import buttons as Buttons
import sliders as Sliders
import switches as Switches
import textinputs as TextInputs
import indicators as Indicators
import animations as Animations
import popups as Popups
import lists as Lists
import canvas as CanvasPage
import layouts as LayoutsPage
import transforms as Transforms
import particles as Particles
import graphs as GraphsPage

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

    Popups.Main {
        visible: fullSize
        fullSize: (root.state === "Popups")
    }

    Lists.Main {
        visible: fullSize
        fullSize: (root.state === "Lists")
    }

    CanvasPage.Main {
        visible: fullSize
        fullSize: (root.state === "Canvas")
    }

    LayoutsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Layouts")
    }

    Transforms.Main {
        visible: fullSize
        fullSize: (root.state === "Transforms")
    }

    Particles.Main {
        visible: fullSize
        fullSize: (root.state === "Particles")
    }

    GraphsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Graphs")
    }
}
