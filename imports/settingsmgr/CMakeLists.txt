# ==============================================================================
# settingsmgr - Modulo QML para gestion de configuraciones persistentes
# ==============================================================================
#
# Este modulo proporciona un wrapper C++ sobre QSettings para exponer
# configuraciones persistentes a QML con una API limpia y tipada.
#
# QSettings: almacen clave-valor persistente de Qt.
#   - En Windows: guarda en el Registro (HKEY_CURRENT_USER\Software\...)
#   - En macOS: guarda en archivos .plist
#   - En Linux: guarda en archivos .ini (~/.config/...)
#   La ubicacion exacta depende del constructor: QSettings("org", "app")
#
# Por que un wrapper en C++ si ya existe Qt.labs.settings en QML?
#   - Qt.labs.settings es limitado: solo soporta propiedades simples.
#   - Este wrapper agrega: API generica setValue/getValue, grupos jerarquicos,
#     listado de claves, limpieza total, y propiedades con tipos fuertes.
#   - El patron Q_PROPERTY + Q_INVOKABLE da a QML acceso completo y
#     reactivo via bindings.
#
# Solo necesita Qt6::Core (QSettings) y Qt6::Qml (registro QML).
# ==============================================================================

qt_add_library(settingsmgrplugin STATIC)
qt_add_qml_module(settingsmgrplugin
    URI "settingsmgr"
    VERSION 1.0
    SOURCES
        settingsmanager.h settingsmanager.cpp
)
target_link_libraries(settingsmgrplugin PRIVATE Qt6::Core Qt6::Qml)
