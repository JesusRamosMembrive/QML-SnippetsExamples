# =============================================================================
# CMakeLists.txt — Módulo de ejemplo "buttons"
# =============================================================================
# Patrón estándar para todas las páginas de ejemplo:
#
#   1. qt_add_library(<nombre>plugin STATIC) — crea la biblioteca estática
#      El sufijo "plugin" es convención del proyecto. Junto con qt_add_qml_module,
#      el target de enlace resultante será "<nombre>pluginplugin" (doble plugin).
#
#   2. qt_add_qml_module — registra como módulo QML con URI "<nombre>"
#      QML_FILES lista todos los archivos QML del módulo:
#        - Main.qml: punto de entrada cargado por Dashboard.qml vía Loader
#        - *Card.qml: tarjetas individuales de ejemplo (una por snippet)
#
# Cada página de ejemplo es un módulo QML independiente. Esto permite:
#   - Compilación aislada (si falla una página, las demás siguen funcionando)
#   - Carga lazy (solo se instancia cuando el usuario navega a esa página)
#   - Encapsulación (cada página tiene su propio namespace, sin colisiones)
# =============================================================================
qt_add_library(buttonsplugin STATIC)
qt_add_qml_module(buttonsplugin
    URI "buttons"
    VERSION 1.0
    QML_FILES
        Main.qml
        StandardButtonsCard.qml
        IconButtonsCard.qml
        ButtonStatesCard.qml
        CustomStyledCard.qml
        SpecializedButtonsCard.qml
        ToolButtonMenuCard.qml
)
