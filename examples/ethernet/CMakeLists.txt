# =============================================================================
# CMakeLists.txt — Modulo QML frontend para el ejemplo Ethernet/STANAG
# =============================================================================
#
# PATRON: Modulo QML puro (sin C++, solo QML_FILES)
# Este modulo contiene las paginas de ejemplo (UI) que consumen el backend
# C++ definido en imports/ethernet/.
#
# URI "ethernetex" (con sufijo "ex") para distinguirlo del backend "ethernet".
# El backend se importa como: import ethernet
# El frontend se carga como: qrc:/qt/qml/ethernetex/Main.qml
#
# NOMBRE DE ENLACE: ethernetexpluginplugin (en /qmlmodules)
# =============================================================================

qt_add_library(ethernetexplugin STATIC)
qt_add_qml_module(ethernetexplugin
    URI "ethernetex"
    VERSION 1.0
    QML_FILES
        Main.qml
        ConnectionCard.qml
        SendMessageCard.qml
        MessageLogCard.qml
        HexViewCard.qml
)
