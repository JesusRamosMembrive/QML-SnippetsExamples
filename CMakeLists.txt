# =============================================================================
# CMakeLists.txt — Archivo raíz de configuración del proyecto
# =============================================================================
# Este es el punto de entrada del sistema de compilación CMake. Define el
# proyecto, localiza las dependencias de Qt, configura los módulos QML y
# enlaza todo para producir el ejecutable final.
#
# Flujo de compilación:
#   1. cmake -B build -S .    → Configura (lee este archivo)
#   2. cmake --build build    → Compila todo
# =============================================================================

# Versión mínima de CMake. Qt 6 necesita al menos 3.16 para funcionar
# correctamente con qt_add_qml_module y otras macros modernas de Qt.
cmake_minimum_required(VERSION 3.16)

# Declaración del proyecto. VERSION se puede consultar luego con
# ${PROJECT_VERSION}. LANGUAGES CXX indica que solo usamos C++
# (no C ni Fortran), lo que acelera la detección de compiladores.
project(QMLSnippetsExamples VERSION 0.1 LANGUAGES CXX)

# Obliga a que el compilador soporte el estándar C++ configurado (C++17 por
# defecto en Qt 6). Si el compilador no lo soporta, CMake falla en vez de
# degradar silenciosamente a un estándar inferior.
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- Búsqueda de dependencias de Qt ---
# find_package localiza la instalación de Qt 6.4+ en el sistema.
# REQUIRED hace que CMake falle si no encuentra algún componente.
# Cada componente corresponde a un módulo de Qt que usamos en el proyecto:
#   - Quick / QuickControls2: Motor QML y controles de interfaz
#   - Graphs: Gráficos y visualización de datos (página de charts)
#   - WebSockets: Comunicación en tiempo real (página de network)
#   - Location / Positioning: Mapas y geolocalización
#   - Pdf / PdfQuick: Visor de documentos PDF embebido
#   - Sql: Acceso a bases de datos SQLite
#   - Multimedia: Reproducción de audio/video
#   - Concurrent: Operaciones asíncronas en hilos secundarios
find_package(Qt6 6.4 REQUIRED COMPONENTS Quick QuickControls2 Graphs WebSockets Location Positioning Pdf PdfQuick Sql Multimedia Concurrent)

# --- Políticas de CMake y Qt ---
# CMP0071: Controla el procesamiento automático de archivos generados por MOC
# (Meta-Object Compiler). Con NEW, CMake ejecuta AUTOMOC sobre archivos
# generados, lo que evita errores de enlace con señales/slots en archivos
# auto-generados.
if(POLICY CMP0071)
    cmake_policy(SET CMP0071 NEW)
endif()

# QTP0004: Política de Qt que exige declarar qmldir para cada módulo QML.
# La ponemos en OLD porque nuestros módulos ya tienen qmldir manuales donde
# es necesario, y no queremos que Qt genere warnings por los que no lo tienen.
# En proyectos nuevos, Qt recomienda NEW (qmldir auto-generado), pero en este
# proyecto preferimos control manual.
qt_policy(SET QTP0004 OLD)

# --- Rutas de importación QML ---
# QML_IMPORT_PATH indica al motor QML (y a los IDEs como Qt Creator)
# dónde buscar módulos QML personalizados. Sin estas rutas, el autocompletado
# del IDE no funcionaría y el motor QML no encontraría nuestros módulos.
# CACHE STRING "" FORCE lo guarda en el caché de CMake para que los IDEs
# puedan leerlo.
# Nota: Estas rutas son para DISEÑO (IDE). En EJECUCIÓN, Qt usa los módulos
# compilados que se enlazan estáticamente.
set(QML_IMPORT_PATH
    ${CMAKE_CURRENT_LIST_DIR}/imports
    ${CMAKE_CURRENT_LIST_DIR}/styles
    ${CMAKE_CURRENT_LIST_DIR}/mainui
    ${CMAKE_CURRENT_LIST_DIR}/examples
    CACHE STRING "" FORCE
)

# Configura valores estándar del proyecto Qt (AUTOMOC, AUTORCC, etc.).
# REQUIRES 6.5 verifica que la versión de Qt sea >= 6.5 para las macros
# modernas de QML. Si usas Qt 6.4, esta línea puede necesitar ajuste.
qt_standard_project_setup(REQUIRES 6.5)

# --- Definición del ejecutable ---
# qt_add_executable es un wrapper de Qt sobre add_executable. Además de
# crear el target, configura propiedades específicas de Qt como el manejo
# de recursos y AUTOMOC/AUTORCC. Solo tiene un archivo .cpp: el punto
# de entrada (main.cpp).
qt_add_executable(QMLSnippetsExamples src/main.cpp)

# --- Recurso embebido: configuración de estilo ---
# Embebe qtquickcontrols2.conf dentro del ejecutable como recurso Qt.
# Este archivo le dice a Qt Quick Controls 2 qué estilo visual usar
# (en nuestro caso, "qmlsnippetsstyle"). Sin esto, Qt usaría el estilo
# por defecto del sistema (Basic, Material, etc.).
# PREFIX "/" significa que el recurso queda accesible en ":/qtquickcontrols2.conf".
qt_add_resources(QMLSnippetsExamples "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

# --- Registro de módulos QML ---
# include(qmlmodules) carga el archivo "qmlmodules" (sin extensión .cmake)
# desde el directorio raíz. Ese archivo contiene los add_subdirectory()
# para cada módulo QML (imports, styles, examples, mainui) y el
# target_link_libraries que enlaza todos los plugins QML con el ejecutable.
# Separarlo en un archivo aparte mantiene este CMakeLists.txt limpio.
include(qmlmodules)

# --- Enlace de bibliotecas de Qt ---
# Enlaza los módulos de Qt con el ejecutable. PRIVATE significa que estas
# dependencias solo se usan para compilar este target, no se propagan a
# otros targets que dependan de él (lo cual es correcto para un ejecutable).
# Cada Qt6::Modulo corresponde a un componente del find_package de arriba.
target_link_libraries(QMLSnippetsExamples PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Graphs
    Qt6::WebSockets
    Qt6::Location
    Qt6::Positioning
    Qt6::PdfQuick
    Qt6::Sql
    Qt6::Multimedia
    Qt6::Concurrent
)

# --- Copia de archivos PDF post-compilación ---
# Los archivos PDF de ejemplo no se embeben como recursos Qt (serían muy
# pesados). En su lugar, se copian al directorio del ejecutable después
# de compilar. $<TARGET_FILE_DIR:...> es una "generator expression" de
# CMake que se resuelve al directorio donde queda el .exe (build/Debug/,
# build/Release/, etc. según el generador).
add_custom_command(TARGET QMLSnippetsExamples POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/pdf_files
    $<TARGET_FILE_DIR:QMLSnippetsExamples>/pdf_files
)

# --- Reglas de instalación ---
# Define dónde se copian los archivos al hacer "cmake --install build".
# BUNDLE es para macOS (.app), LIBRARY para bibliotecas compartidas,
# RUNTIME para ejecutables (.exe en Windows, binario en Linux).
# En desarrollo normalmente no se usa install; es útil para distribución.
install(TARGETS QMLSnippetsExamples
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
