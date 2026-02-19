qt_add_library(splitviewplugin STATIC)
qt_add_qml_module(splitviewplugin
    URI "splitview"
    VERSION 1.0
    QML_FILES
        Main.qml
        HorizontalSplitCard.qml
        VerticalSplitCard.qml
        NestedSplitCard.qml
        InteractiveSplitCard.qml
)
