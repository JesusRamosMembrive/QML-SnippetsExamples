# =============================================================================
# Modulo QML: customitem
# =============================================================================
#
# Este modulo contiene items personalizados de QML que usan QPainter para
# dibujar graficos 2D complejos directamente en la escena de Qt Quick.
#
# Todos heredan de QQuickPaintedItem, que es el puente entre el sistema de
# pintado de Qt Widgets (QPainter) y la escena de Qt Quick (scene graph).
#
# Componentes:
#   - AnalogClock: reloj analogico con manecillas de hora, minuto y segundo
#   - WaveformItem: visualizador de ondas sinusoidales con cuadricula
#   - GaugeItem: medidor semicircular tipo velocimetro/tacometro
#   - DrawCanvas: lienzo de dibujo libre con soporte de mouse
#
# Por que QQuickPaintedItem en vez de QML Canvas?
#   QPainter es nativo C++ → mucho mas rapido que el Canvas de QML (JavaScript).
#   Tiene mas funciones: curvas anti-aliased, paths complejos, rendering de
#   texto avanzado, control preciso con QPen/QBrush/QFont.
#   Ideal para graficos que necesitan rendimiento o complejidad visual.
#
# Pipeline de renderizado:
#   QML scene graph → detecta item "sucio" → llama paint() →
#   QPainter dibuja en una textura → textura se compone en la escena
#
# target_link_libraries con Qt6::Quick: necesario para QQuickPaintedItem.
# =============================================================================

qt_add_library(customitemplugin STATIC)
qt_add_qml_module(customitemplugin
    URI "customitem"
    VERSION 1.0
    SOURCES
        analogclock.h analogclock.cpp
        waveformitem.h waveformitem.cpp
        gaugeitem.h gaugeitem.cpp
        drawcanvas.h drawcanvas.cpp
)
target_link_libraries(customitemplugin PRIVATE Qt6::Quick)
