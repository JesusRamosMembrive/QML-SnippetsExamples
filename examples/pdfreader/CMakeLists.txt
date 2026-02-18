qt_add_library(pdfreaderplug STATIC)
qt_add_qml_module(pdfreaderplug
    URI "pdfreader"
    VERSION 1.0
    QML_FILES
        Main.qml
)
target_link_libraries(pdfreaderplug PRIVATE Qt6::PdfQuick)
