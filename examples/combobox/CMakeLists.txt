qt_add_library(comboboxplugin STATIC)
qt_add_qml_module(comboboxplugin
    URI "combobox"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicComboBoxCard.qml
        EditableComboBoxCard.qml
        ModelComboBoxCard.qml
        InteractiveComboBoxCard.qml
)
