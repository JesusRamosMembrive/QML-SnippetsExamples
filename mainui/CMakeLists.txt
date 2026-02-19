# =============================================================================
# Módulo QML: mainui — Estructura principal de la aplicación
# =============================================================================
#
# Este módulo contiene el "shell" (carcasa) de la aplicación: el layout general,
# la navegación lateral (sidebar), el header superior y el contenedor de páginas.
#
# QML_FILES puede referenciar archivos en subdirectorios (home/, mainmenu/).
# Todos se registran bajo el mismo URI "mainui", sin importar su ubicación
# en disco. Así, "import mainui" da acceso a Dashboard, Header, HomePage, etc.
#
# El nombre de librería "mainui" produce el target de enlace "mainuiplugin"
# (un solo sufijo "plugin" porque el nombre base NO contiene "plugin").
# Comparar con buttonsplugin → buttonspluginplugin (doble sufijo).
#
# Estos son componentes estructurales, NO páginas de ejemplo. Se cargan siempre
# al iniciar la app (a diferencia de los ejemplos, que se muestran según el
# estado de navegación del Dashboard).
# =============================================================================

qt_add_library(mainui STATIC)
qt_add_qml_module(mainui
    URI "mainui"
    VERSION 1.0
    QML_FILES
        home/Dashboard.qml
        home/Header.qml
        home/HomePage.qml
        mainmenu/MainMenu.qml
        mainmenu/MainMenuList.qml
)
