cmake_minimum_required(VERSION 3.16)

project(QMLSnippetsExamples VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick QuickControls2 Graphs WebSockets Location Positioning Pdf PdfQuick Sql Multimedia Concurrent)

# Set Qt policies
if(POLICY CMP0071)
    cmake_policy(SET CMP0071 NEW)
endif()

# Suppress QTP0004 warning - we have qmldir files where needed
qt_policy(SET QTP0004 OLD)

set(QML_IMPORT_PATH
    ${CMAKE_CURRENT_LIST_DIR}/imports
    ${CMAKE_CURRENT_LIST_DIR}/styles
    ${CMAKE_CURRENT_LIST_DIR}/mainui
    ${CMAKE_CURRENT_LIST_DIR}/examples
    CACHE STRING "" FORCE
)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(QMLSnippetsExamples src/main.cpp)

qt_add_resources(QMLSnippetsExamples "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

include(qmlmodules)

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

# Copy PDF library files next to the executable
add_custom_command(TARGET QMLSnippetsExamples POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/pdf_files
    $<TARGET_FILE_DIR:QMLSnippetsExamples>/pdf_files
)

install(TARGETS QMLSnippetsExamples
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
