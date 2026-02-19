// ============================================================================
// Database (Qt SQL) - Pagina principal
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Qt SQL y SQLite:
//    - Qt proporciona el modulo QtSql para trabajar con bases de datos SQL.
//    - SQLite es la opcion mas comun para apps de escritorio/moviles porque
//      no requiere un servidor externo; la BD es un archivo local (o en memoria).
//    - ":memory:" crea una BD temporal en RAM, ideal para demos y pruebas.
//
// 2. QSqlTableModel (CRUD):
//    - Modelo que conecta directamente a una tabla SQL y permite operaciones
//      CRUD (Create, Read, Update, Delete) sin escribir SQL manualmente.
//    - Hereda de QAbstractTableModel, asi que funciona con TableView.
//    - Se debe sobreescribir roleNames() para exponer columnas como roles QML.
//    - Los cambios se guardan con submitAll() o se revierten con revertAll().
//
// 3. QSqlQueryModel (solo lectura):
//    - Modelo de solo lectura que ejecuta una consulta SQL arbitraria.
//    - Ideal para reportes, dashboards y consultas JOIN complejas.
//    - Tambien necesita roleNames() para que QML acceda a las columnas.
//
// 4. Patron Factory para modelos:
//    - DatabaseManager expone un metodo createTableModel(tableName) que
//      crea instancias de QSqlTableModel en C++ y las devuelve a QML.
//    - Esto es necesario porque QSqlTableModel necesita la conexion DB
//      como parametro de constructor, algo que no se puede hacer desde QML.
//    - El modelo se guarda en "property var" (null hasta que la BD se abra).
//
// 5. Ciclo de vida asincrono:
//    - Component.onCompleted abre la BD y crea datos de ejemplo.
//    - onIsOpenChanged reacciona cuando la BD esta lista, creando el modelo
//      y refrescando el dashboard. Este patron evita acceder a la BD antes
//      de que este abierta.
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import database

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // Modelo CRUD creado por el factory (null hasta que la BD se abra).
    // Usamos "property var" porque el tipo exacto (QSqlTableModel*) viene
    // de C++ y QML lo maneja como un objeto generico.
    property var employeeTableModel: null

    // DatabaseManager: componente C++ que encapsula toda la logica de BD.
    // - openDatabase() crea la conexion SQLite :memory: y las tablas con datos demo.
    // - isOpen es una propiedad Q_PROPERTY que notifica cuando la BD esta lista.
    // - createTableModel() es un Q_INVOKABLE que actua como factory de modelos.
    // - connectionName identifica la conexion para que QueryExplorer ejecute
    //   consultas SQL arbitrarias sobre la misma BD.
    DatabaseManager {
        id: dbManager
        Component.onCompleted: openDatabase()
        onIsOpenChanged: {
            if (isOpen) {
                root.employeeTableModel = dbManager.createTableModel("employees")
                dashboardCard.refreshAll()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(20)

                Label {
                    text: "Database (Qt SQL)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "SQLite in-memory database with QSqlTableModel (CRUD) and QSqlQueryModel (read-only queries). " +
                          "C++ models subclassed with roleNames() for QML binding."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Card 1: Tabla CRUD (ancho completo).
                // Demuestra operaciones Create/Read/Update/Delete sobre
                // QSqlTableModel con celdas editables y botones de accion.
                CrudTableCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)
                    tableModel: employeeTableModel
                    dbManager: dbManager
                }

                // Fila: Query Explorer + Data Dashboard
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // Card con editor SQL: permite escribir consultas arbitrarias
                    // y ver los resultados en una tabla. Usa QSqlQueryModel internamente.
                    // connectionName asegura que se usa la misma conexion de BD.
                    QueryExplorerCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(540)
                        connectionName: dbManager.connectionName
                    }

                    // Card de dashboard: muestra estadisticas agregadas (conteos,
                    // promedios, etc.) calculadas con consultas SQL.
                    // refreshAll() se llama cuando la BD esta lista y cuando
                    // se modifican datos en la card CRUD.
                    DataDashboardCard {
                        id: dashboardCard
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(540)
                        connectionName: dbManager.connectionName
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
