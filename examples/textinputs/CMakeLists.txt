qt_add_library(textinputsplugin STATIC)
qt_add_qml_module(textinputsplugin
    URI "textinputs"
    VERSION 1.0
    QML_FILES
        Main.qml
        TextFieldCard.qml
        TextAreaCard.qml
        ComboSpinCard.qml
        FormBuilderCard.qml
        SearchBar.qml
        PinInput.qml
        TagInput.qml
        EditableLabels.qml
        StarRating.qml
        CharLimitInput.qml
        ColorPicker.qml
)
