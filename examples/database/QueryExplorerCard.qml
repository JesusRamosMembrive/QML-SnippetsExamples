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

    SqlQueryModel { id: queryModel }

    property int elapsedMs: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "SQL Query Explorer"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Execute arbitrary SQL — read-only results via QSqlQueryModel"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }

        // Preset queries
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Presets:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: presetCombo
                Layout.fillWidth: true
                textRole: "label"
                valueRole: "sql"
                model: ListModel {
                    ListElement {
                        label: "Engineers only"
                        sql: "SELECT * FROM employees WHERE department = 'Engineering'"
                    }
                    ListElement {
                        label: "Department stats"
                        sql: "SELECT department, COUNT(*) as count, ROUND(AVG(salary),0) as avg_salary FROM employees GROUP BY department"
                    }
                    ListElement {
                        label: "Expensive products"
                        sql: "SELECT * FROM products WHERE price > 100 ORDER BY price DESC"
                    }
                    ListElement {
                        label: "Above-average salary"
                        sql: "SELECT name, department, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees) ORDER BY salary DESC"
                    }
                    ListElement {
                        label: "All products"
                        sql: "SELECT * FROM products ORDER BY category, name"
                    }
                }
                onCurrentIndexChanged: {
                    if (currentIndex >= 0 && currentValue !== undefined)
                        sqlInput.text = currentValue
                }
                Component.onCompleted: {
                    if (currentValue !== undefined)
                        sqlInput.text = currentValue
                }
            }
        }

        // SQL input
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(80)
            color: Style.bgColor
            radius: Style.resize(4)
            border.color: "#3A3D45"
            border.width: 1

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(6)

                TextArea {
                    id: sqlInput
                    color: Style.fontPrimaryColor
                    font.pixelSize: Style.resize(12)
                    font.family: "Consolas"
                    wrapMode: Text.Wrap
                    selectByMouse: true
                    placeholderText: "Enter SQL query..."
                }
            }
        }

        // Execute + status
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Button {
                text: "Execute"
                enabled: sqlInput.text.trim().length > 0
                onClicked: {
                    var start = Date.now()
                    queryModel.execQuery(sqlInput.text.trim(), root.connectionName)
                    root.elapsedMs = Date.now() - start
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: queryModel.rowCount + " rows"
                font.pixelSize: Style.resize(12)
                color: Style.inactiveColor
                visible: queryModel.lastError.length === 0
            }

            Label {
                text: root.elapsedMs + " ms"
                font.pixelSize: Style.resize(12)
                color: Style.inactiveColor
                visible: root.elapsedMs > 0
            }
        }

        // Error display
        Label {
            text: queryModel.lastError
            font.pixelSize: Style.resize(11)
            color: "#F44336"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            visible: queryModel.lastError.length > 0
        }

        // Results
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Dynamic header
            Row {
                id: queryHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(28)

                Repeater {
                    model: queryModel.columnCount()

                    Rectangle {
                        required property int index
                        width: Math.max(Style.resize(100),
                               (queryHeader.parent.width) / Math.max(queryModel.columnCount(), 1))
                        height: parent.height
                        color: Style.bgColor

                        Label {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: queryModel.headerName(index) || ""
                            color: Style.mainColor
                            font.pixelSize: Style.resize(11)
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: "#3A3D45"
                        }
                    }
                }
            }

            // Result rows
            ListView {
                id: resultList
                anchors.top: queryHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: queryModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    id: resultRow
                    width: resultList.width
                    height: Style.resize(28)
                    color: index % 2 === 0 ? Style.cardColor : Style.surfaceColor

                    required property int index
                    required property var model

                    Row {
                        anchors.fill: parent

                        Repeater {
                            model: queryModel.columnCount()

                            Label {
                                required property int index
                                width: Math.max(Style.resize(100),
                                       (resultRow.width) / Math.max(queryModel.columnCount(), 1))
                                height: resultRow.height
                                leftPadding: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: {
                                    var rowData = queryModel.getRow(resultRow.index)
                                    var key = queryModel.headerName(index)
                                    return rowData[key] !== undefined ? rowData[key] : ""
                                }
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(11)
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }

        // Footer
        Label {
            text: "QSqlQueryModel for read-only results from arbitrary SQL."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
