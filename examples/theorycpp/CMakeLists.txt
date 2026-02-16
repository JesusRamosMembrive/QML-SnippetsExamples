qt_add_library(theorycppplugin STATIC)
qt_add_qml_module(theorycppplugin
    URI "theorycpp"
    VERSION 1.0
    QML_FILES
        Main.qml
        ChapterPanel.qml
        ContentPanel.qml
        CodeBlock.qml
)
