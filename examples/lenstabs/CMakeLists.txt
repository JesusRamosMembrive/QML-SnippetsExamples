qt_add_library(lenstabsplugin STATIC)
qt_add_qml_module(lenstabsplugin
    URI "lenstabs"
    VERSION 1.0
    QML_FILES
        Main.qml
        LensTabStrip.qml
)
