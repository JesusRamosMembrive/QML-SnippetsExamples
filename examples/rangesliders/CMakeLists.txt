qt_add_library(rangeslidersplugin STATIC)
qt_add_qml_module(rangeslidersplugin
    URI "rangesliders"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicRangeSliderCard.qml
        VerticalRangeSliderCard.qml
        LabelsRangeSliderCard.qml
        InteractiveRangeCard.qml
)
