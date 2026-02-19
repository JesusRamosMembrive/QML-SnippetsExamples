qt_add_library(qmlsnippetsstyle STATIC)
qt_add_qml_module(qmlsnippetsstyle
    URI "qmlsnippetsstyle"
    VERSION 1.0
    QML_FILES
        BusyIndicator.qml
        Button.qml
        CheckBox.qml
        ComboBox.qml
        Dial.qml
        Dialog.qml
        Label.qml
        Menu.qml
        MenuItem.qml
        MenuSeparator.qml
        Popup.qml
        ProgressBar.qml
        RadioButton.qml
        Slider.qml
        SpinBox.qml
        Switch.qml
        TextArea.qml
        TextField.qml
        ToolButton.qml
        ToolTip.qml
        Tumbler.qml
        # Componentes especializados - Buttons
        buttons/GlowButton.qml
        buttons/GradientButton.qml
        buttons/PulseButton.qml
        buttons/NeumorphicButton.qml
        RangeSlider.qml
        # Componentes especializados - Sliders
        sliders/CircularSlider.qml
)
