# =============================================================================
# CMakeLists.txt — Modulo C++ backend para protocolo Ethernet/STANAG 4586
# =============================================================================
#
# PATRON: Modulo C++ backend (sin archivos QML, solo SOURCES de C++)
# -----------------------------------------------------------------------
# Este modulo registra clases C++ en el sistema QML usando SOURCES.
# Las clases decoradas con QML_ELEMENT (EthernetController) quedan
# auto-registradas bajo el URI "ethernet".
#
# En QML se usa asi:
#     import ethernet
#     EthernetController { listenPort: 5000 }
#
# DEPENDENCIAS:
#   - Qt6::Network: necesario para QUdpSocket (transporte UDP)
#   - Qt6::Qml: necesario para QML_ELEMENT y el sistema de modulos QML
#
# NOMBRE DE ENLACE (link target):
#   La libreria se llama "ethernetplugin". qt_add_qml_module() genera
#   el target "ethernetpluginplugin" (doble sufijo "plugin").
#   En /qmlmodules se enlaza como: ethernetpluginplugin
# =============================================================================

qt_add_library(ethernetplugin STATIC)
qt_add_qml_module(ethernetplugin
    URI "ethernet"
    VERSION 1.0
    SOURCES
        stanagmessage.h
        stanagcodec.h stanagcodec.cpp
        udptransport.h udptransport.cpp
        ethernetcontroller.h ethernetcontroller.cpp
)
target_link_libraries(ethernetplugin PRIVATE Qt6::Network)
