qt_add_library(buttonsplugin STATIC)
qt_add_qml_module(buttonsplugin
    URI "buttons"
    VERSION 1.0
    QML_FILES
        Main.qml
        StandardButtonsCard.qml
        IconButtonsCard.qml
        ButtonStatesCard.qml
        CustomStyledCard.qml
        SpecializedButtonsCard.qml
        ToolButtonMenuCard.qml
)
