import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import tablemodel

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // Shared C++ models
    EmployeeModel { id: employeeModel }
    EmployeeProxyModel {
        id: proxyModel
        sourceModel: employeeModel
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
                    text: "TableView (C++ Models)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Demonstrates Qt 6 TableView with QAbstractTableModel, QSortFilterProxyModel, " +
                          "and editable cells via DelegateChooser. Card 1 uses pure QML; Cards 2-3 share a C++ EmployeeModel."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Card 1: Basic QML-only table (full width)
                BasicTableCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(450)
                }

                // Row: Sort/Filter + Editable side by side
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    SortFilterTableCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        proxyModel: proxyModel
                        employeeModel: employeeModel
                    }

                    EditableTableCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        employeeModel: employeeModel
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
