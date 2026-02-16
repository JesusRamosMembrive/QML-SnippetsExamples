file(GLOB_RECURSE THEORY_FILES
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.txt"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
)

qt_add_resources(QMLSnippetsExamples "theory_content"
    PREFIX "/theory"
    FILES ${THEORY_FILES}
)
