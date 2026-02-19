# =============================================================================
# CMakeLists.txt — Modulo de estilo personalizado para Qt Quick Controls 2
# =============================================================================
#
# Este archivo configura el modulo de estilo "qmlsnippetsstyle", que reemplaza
# la apariencia por defecto de los controles de Qt Quick Controls 2 en toda
# la aplicacion.
#
# --- qt_add_library(qmlsnippetsstyle STATIC) ---
# Crea una biblioteca estatica. El nombre "qmlsnippetsstyle" DEBE coincidir
# con el valor Style= en qtquickcontrols2.conf. Asi Qt sabe que este modulo
# contiene las personalizaciones de estilo.
#
# --- qt_add_qml_module ---
# Registra la biblioteca como un modulo QML con URI "qmlsnippetsstyle",
# permitiendo usarlo con: import qmlsnippetsstyle
#
# --- QML_FILES (archivos de estilo) ---
# Cada entrada como Button.qml, Slider.qml, etc. es un OVERRIDE de estilo:
# cuando escribes Button {} en tu app, Qt busca PRIMERO en este modulo un
# archivo llamado "Button.qml". Si lo encuentra, usa nuestra implementacion
# personalizada en lugar del estilo Basic por defecto.
#
# IMPORTANTE: La convencion de nombres DEBE coincidir EXACTAMENTE con los
# nombres de controles de Qt (Button.qml, no MiBoton.qml). Qt resuelve los
# estilos buscando por nombre de archivo exacto. Si el nombre no coincide,
# Qt simplemente ignora el archivo y usa el estilo por defecto.
#
# --- Componentes especializados (buttons/, sliders/) ---
# Los archivos dentro de subdirectorios como buttons/GlowButton.qml y
# sliders/CircularSlider.qml NO son overrides del estilo de Qt. Son tipos
# personalizados adicionales que viven en este modulo por conveniencia.
# Se usan como cualquier tipo QML: GlowButton {} o CircularSlider {}
#
# --- Target de enlace ---
# El target para target_link_libraries es "qmlsnippetsstyleplugin" (con un
# solo "plugin"). Esto es porque qt_add_qml_module agrega automaticamente
# el sufijo "plugin" al nombre base de la biblioteca. Como el nombre base
# es "qmlsnippetsstyle" (sin "plugin"), el resultado es "qmlsnippetsstyleplugin".
# Comparar con buttonsplugin -> buttonspluginplugin (doble "plugin").
# =============================================================================

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
