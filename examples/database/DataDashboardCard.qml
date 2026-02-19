// =============================================================================
// DataDashboardCard.qml — Dashboard de datos agregados con SqlQueryModel
// =============================================================================
// Muestra estadisticas agregadas de la base de datos SQLite en multiples
// widgets visuales: KPIs numericos, desglose por departamento, top salarios
// y productos con stock bajo.
//
// Conexion QML <-> C++:
//   - SqlQueryModel (C++): hereda de QAbstractListModel y envuelve
//     QSqlQueryModel. Expone execQuery(sql, connectionName) como Q_INVOKABLE
//     para ejecutar consultas SQL arbitrarias desde QML.
//   - getRow(index): metodo Q_INVOKABLE que devuelve un QVariantMap con
//     los datos de una fila, permitiendo acceso por nombre de columna.
//   - Cada widget tiene su propio SqlQueryModel porque cada uno ejecuta
//     una consulta SQL diferente (COUNT, AVG, GROUP BY, etc.).
//
// Patrones clave:
//   - refreshAll(): funcion JS que ejecuta 4 consultas SQL diferentes,
//     una por cada modelo. Se llama cuando la BD se abre y cuando se
//     modifican datos en la card CRUD.
//   - Repeater con ListModel de metadatos: los KPIs se generan desde un
//     ListModel que define label, field, prefix y suffix. El valor real
//     se obtiene de statsModel.getRow(0)[field] — patron data-driven.
//   - Barras de progreso proporcionales: width = parent.width * (count / 6)
//     crea una barra cuyo ancho es proporcional al conteo del departamento.
//   - Badge de stock con color condicional: stock < 15 muestra rojo,
//     stock < 50 muestra naranja. Patron comun para alertas visuales.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import database

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property string connectionName

    // Cada SqlQueryModel ejecuta una consulta SQL diferente.
    // Son independientes para que cada widget se actualice por separado.
    SqlQueryModel { id: statsModel }
    SqlQueryModel { id: deptModel }
    SqlQueryModel { id: topSalaryModel }
    SqlQueryModel { id: lowStockModel }

    function refreshAll() {
        statsModel.execQuery(
            "SELECT COUNT(*) as total, ROUND(AVG(salary),0) as avg_sal, " +
            "MIN(salary) as min_sal, MAX(salary) as max_sal FROM employees",
            root.connectionName)

        deptModel.execQuery(
            "SELECT department, COUNT(*) as count, ROUND(AVG(salary),0) as avg_salary " +
            "FROM employees GROUP BY department ORDER BY count DESC",
            root.connectionName)

        topSalaryModel.execQuery(
            "SELECT name, department, salary FROM employees ORDER BY salary DESC LIMIT 5",
            root.connectionName)

        lowStockModel.execQuery(
            "SELECT name, category, stock, price FROM products WHERE stock < 50 ORDER BY stock ASC",
            root.connectionName)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Data Dashboard"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Aggregate queries feeding multiple views — SqlQueryModel per widget"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }

        // Stats summary row
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Repeater {
                model: ListModel {
                    ListElement { label: "Total Employees"; field: "total"; prefix: ""; suffix: "" }
                    ListElement { label: "Avg Salary"; field: "avg_sal"; prefix: "$"; suffix: "" }
                    ListElement { label: "Min Salary"; field: "min_sal"; prefix: "$"; suffix: "" }
                    ListElement { label: "Max Salary"; field: "max_sal"; prefix: "$"; suffix: "" }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(60)
                    color: Style.bgColor
                    radius: Style.resize(6)

                    required property var model

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(2)

                        Label {
                            text: model.label
                            font.pixelSize: Style.resize(10)
                            color: Style.inactiveColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: {
                                if (statsModel.rowCount === 0) return "..."
                                var row = statsModel.getRow(0)
                                var val = row[model.field]
                                if (val === undefined) return "—"
                                return model.prefix + Number(val).toLocaleString(Qt.locale("en_US"), 'f', 0) + model.suffix
                            }
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: Style.mainColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // Two-column layout: Departments + Top Salaries
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(10)

            // Department breakdown
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.bgColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(12)
                    spacing: Style.resize(6)

                    Label {
                        text: "By Department"
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    Repeater {
                        model: deptModel

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(2)

                            required property var model
                            required property int index

                            RowLayout {
                                Layout.fillWidth: true

                                Rectangle {
                                    width: Style.resize(10)
                                    height: Style.resize(10)
                                    radius: Style.resize(2)
                                    color: {
                                        var dept = model.department || ""
                                        if (dept === "Engineering") return "#2196F3"
                                        if (dept === "Marketing") return "#FF9800"
                                        if (dept === "Design") return "#9C27B0"
                                        if (dept === "Management") return "#4CAF50"
                                        return Style.inactiveColor
                                    }
                                }

                                Label {
                                    text: (model.department || "") + " (" + (model.count || 0) + ")"
                                    font.pixelSize: Style.resize(11)
                                    color: Style.fontPrimaryColor
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: "$" + Number(model.avg_salary || 0).toLocaleString(Qt.locale("en_US"), 'f', 0)
                                    font.pixelSize: Style.resize(11)
                                    color: Style.inactiveColor
                                }
                            }

                            // Bar chart
                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(6)
                                radius: Style.resize(3)
                                color: Qt.rgba(1, 1, 1, 0.05)

                                Rectangle {
                                    width: parent.width * Math.min(1, (model.count || 0) / 6)
                                    height: parent.height
                                    radius: Style.resize(3)
                                    color: {
                                        var dept = model.department || ""
                                        if (dept === "Engineering") return "#2196F3"
                                        if (dept === "Marketing") return "#FF9800"
                                        if (dept === "Design") return "#9C27B0"
                                        if (dept === "Management") return "#4CAF50"
                                        return Style.inactiveColor
                                    }
                                    opacity: 0.7
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // Right column: Top salaries + Low stock
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(10)

                // Top 5 salaries
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Style.bgColor
                    radius: Style.resize(6)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(12)
                        spacing: Style.resize(4)

                        Label {
                            text: "Top 5 Salaries"
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Repeater {
                            model: topSalaryModel

                            RowLayout {
                                Layout.fillWidth: true

                                required property var model
                                required property int index

                                Label {
                                    text: (index + 1) + "."
                                    font.pixelSize: Style.resize(11)
                                    color: Style.inactiveColor
                                    Layout.preferredWidth: Style.resize(20)
                                }

                                Label {
                                    text: model.name || ""
                                    font.pixelSize: Style.resize(11)
                                    color: Style.fontPrimaryColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Label {
                                    text: "$" + Number(model.salary || 0).toLocaleString(Qt.locale("en_US"), 'f', 0)
                                    font.pixelSize: Style.resize(11)
                                    font.bold: true
                                    color: Style.mainColor
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }

                // Low stock products
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Style.bgColor
                    radius: Style.resize(6)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(12)
                        spacing: Style.resize(4)

                        Label {
                            text: "Low Stock (< 50)"
                            font.pixelSize: Style.resize(13)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Repeater {
                            model: lowStockModel

                            RowLayout {
                                Layout.fillWidth: true

                                required property var model
                                required property int index

                                Label {
                                    text: model.name || ""
                                    font.pixelSize: Style.resize(11)
                                    color: Style.fontPrimaryColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Rectangle {
                                    width: stockLabel.implicitWidth + Style.resize(10)
                                    height: Style.resize(18)
                                    radius: Style.resize(3)
                                    color: {
                                        var s = model.stock || 0
                                        return s < 15 ? Qt.rgba(0.96, 0.26, 0.21, 0.2)
                                             : Qt.rgba(1, 0.6, 0, 0.2)
                                    }

                                    Label {
                                        id: stockLabel
                                        anchors.centerIn: parent
                                        text: (model.stock || 0) + " units"
                                        font.pixelSize: Style.resize(10)
                                        color: {
                                            var s = model.stock || 0
                                            return s < 15 ? "#F44336" : "#FF9800"
                                        }
                                    }
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }

        // Footer
        Label {
            text: "Aggregate queries with QSqlQueryModel feeding multiple views."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
