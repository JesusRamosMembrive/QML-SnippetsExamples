qt_add_library(swipeviewplugin STATIC)
qt_add_qml_module(swipeviewplugin
    URI "swipeview"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicSwipeCard.qml
        IndicatorSwipeCard.qml
        CarouselCard.qml
        InteractiveSwipeCard.qml
)
