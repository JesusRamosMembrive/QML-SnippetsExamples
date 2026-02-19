# ============================================================================
# Modulo QML con backend C++ puro — Modelo de tabla
# ============================================================================
#
# Mismo patron que el modulo "threads": un modulo QML que solo contiene
# clases C++ (sin archivos .qml). Se usa SOURCES en vez de QML_FILES.
#
# Las clases EmployeeModel y EmployeeProxyModel tienen QML_ELEMENT,
# asi que qt_add_qml_module() las registra automaticamente en el URI
# "tablemodel". Desde QML:
#
#   import tablemodel
#   EmployeeModel { id: sourceModel }
#   EmployeeProxyModel { id: proxyModel; sourceModel: sourceModel }
#
# Nota: este modulo expone DOS clases a QML — el modelo fuente
# (QAbstractTableModel) y el proxy (QSortFilterProxyModel).
# Ambas se registran en el mismo modulo porque estan relacionadas.
# ============================================================================

qt_add_library(tablemodelplugin STATIC)
qt_add_qml_module(tablemodelplugin
    URI "tablemodel"
    VERSION 1.0
    SOURCES
        employeemodel.h
        employeemodel.cpp
        employeeproxymodel.h
        employeeproxymodel.cpp
)
