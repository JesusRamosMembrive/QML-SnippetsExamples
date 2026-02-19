# =============================================================================
# Modulo QML: database
# =============================================================================
#
# Este modulo provee acceso a bases de datos SQLite desde QML. Contiene:
#
#   - DatabaseManager: gestiona el ciclo de vida de la base de datos
#     (abrir, crear tablas, cerrar). Usa QSqlDatabase con SQLite en memoria.
#
#   - SqlTableModel: wrapper sobre QSqlTableModel que agrega roleNames()
#     para QML. Proporciona un modelo lectura/escritura respaldado por una
#     tabla SQL individual, con operaciones CRUD.
#
#   - SqlQueryModel: wrapper sobre QSqlQueryModel que agrega roleNames()
#     para QML. Proporciona un modelo de solo lectura a partir de una
#     consulta SQL arbitraria.
#
# Por que wrappers personalizados?
#   Los modelos SQL integrados de Qt (QSqlTableModel, QSqlQueryModel) exponen
#   datos usando Qt::DisplayRole + indice de columna. Esto funciona bien en
#   C++/Widgets, pero en QML los delegates esperan roles con nombre:
#     Text { text: model.name }    // OK con roleNames()
#     Text { text: model[0] }      // NO funciona en QML
#   Estos wrappers agregan roleNames() que mapea cada columna SQL a un
#   nombre de rol accesible desde QML.
#
# target_link_libraries con Qt6::Sql: necesario para las clases QSqlDatabase,
# QSqlTableModel, QSqlQueryModel, QSqlQuery, etc.
# =============================================================================

qt_add_library(databaseplugin STATIC)
qt_add_qml_module(databaseplugin
    URI "database"
    VERSION 1.0
    SOURCES
        databasemanager.h databasemanager.cpp
        sqltablemodel.h sqltablemodel.cpp
        sqlquerymodel.h sqlquerymodel.cpp
)
target_link_libraries(databaseplugin PRIVATE Qt6::Sql)
