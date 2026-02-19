qt_add_library(tabbarplugin STATIC)
qt_add_qml_module(tabbarplugin
    URI "tabbar"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicTabBarCard.qml
        IconTabBarCard.qml
        DynamicTabBarCard.qml
        InteractiveTabBarCard.qml
)
