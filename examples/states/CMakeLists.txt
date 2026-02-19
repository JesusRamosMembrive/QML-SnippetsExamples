qt_add_library(statesplugin STATIC)
qt_add_qml_module(statesplugin
    URI "states"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicStatesCard.qml
        TransitionCard.qml
        StateMachineCard.qml
        InteractiveStatesCard.qml
)
