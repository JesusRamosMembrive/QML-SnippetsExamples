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

    // CRUD model created by factory (null until DB opens)
    property var employeeTableModel: null

    // Database manager — opens SQLite :memory: and creates sample data
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

                // Card 1: CRUD Table (full width)
                CrudTableCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)
                    tableModel: employeeTableModel
                    dbManager: dbManager
                }

                // Row: Query Explorer + Data Dashboard
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    QueryExplorerCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(540)
                        connectionName: dbManager.connectionName
                    }

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
