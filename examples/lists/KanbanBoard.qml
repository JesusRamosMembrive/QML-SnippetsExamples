import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Kanban Board"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(340)
        spacing: Style.resize(10)

        // To Do column
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: Qt.rgba(0.36, 0.55, 0.94, 0.15)

                    Label {
                        anchors.centerIn: parent
                        text: "📋 To Do"
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: "#5B8DEF"
                    }
                }

                Repeater {
                    model: [
                        { task: "Add Popups page", tag: "Feature", tagClr: "#5B8DEF" },
                        { task: "Write unit tests", tag: "Testing", tagClr: "#FF9500" },
                        { task: "Refactor Style.qml", tag: "Tech Debt", tagClr: "#AF52DE" },
                        { task: "Add C++ backend", tag: "Feature", tagClr: "#5B8DEF" }
                    ]

                    delegate: Rectangle {
                        id: kanbanTodo
                        required property var modelData
                        Layout.fillWidth: true
                        height: Style.resize(52)
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: kanbanTodo.modelData.task
                                font.pixelSize: Style.resize(11)
                                color: Style.fontPrimaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: tagLabel1.implicitWidth + Style.resize(10)
                                height: Style.resize(16)
                                radius: Style.resize(3)
                                color: Qt.rgba(
                                    Qt.color(kanbanTodo.modelData.tagClr).r,
                                    Qt.color(kanbanTodo.modelData.tagClr).g,
                                    Qt.color(kanbanTodo.modelData.tagClr).b, 0.2)

                                Label {
                                    id: tagLabel1
                                    anchors.centerIn: parent
                                    text: kanbanTodo.modelData.tag
                                    font.pixelSize: Style.resize(9)
                                    color: kanbanTodo.modelData.tagClr
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // In Progress column
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: Qt.rgba(1, 0.58, 0, 0.15)

                    Label {
                        anchors.centerIn: parent
                        text: "🔨 In Progress"
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: "#FF9500"
                    }
                }

                Repeater {
                    model: [
                        { task: "Custom Lists page", tag: "Feature", tagClr: "#5B8DEF" },
                        { task: "Dark theme polish", tag: "Design", tagClr: "#00D1A9" }
                    ]

                    delegate: Rectangle {
                        id: kanbanProgress
                        required property var modelData
                        Layout.fillWidth: true
                        height: Style.resize(52)
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: kanbanProgress.modelData.task
                                font.pixelSize: Style.resize(11)
                                color: Style.fontPrimaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: tagLabel2.implicitWidth + Style.resize(10)
                                height: Style.resize(16)
                                radius: Style.resize(3)
                                color: Qt.rgba(
                                    Qt.color(kanbanProgress.modelData.tagClr).r,
                                    Qt.color(kanbanProgress.modelData.tagClr).g,
                                    Qt.color(kanbanProgress.modelData.tagClr).b, 0.2)

                                Label {
                                    id: tagLabel2
                                    anchors.centerIn: parent
                                    text: kanbanProgress.modelData.tag
                                    font.pixelSize: Style.resize(9)
                                    color: kanbanProgress.modelData.tagClr
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // Done column
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: Qt.rgba(0.2, 0.78, 0.35, 0.15)

                    Label {
                        anchors.centerIn: parent
                        text: "✅ Done"
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: "#34C759"
                    }
                }

                Repeater {
                    model: [
                        { task: "Maps page", tag: "Feature", tagClr: "#5B8DEF" },
                        { task: "Indicators expansion", tag: "Feature", tagClr: "#5B8DEF" },
                        { task: "Animations expansion", tag: "Feature", tagClr: "#5B8DEF" }
                    ]

                    delegate: Rectangle {
                        id: kanbanDone
                        required property var modelData
                        Layout.fillWidth: true
                        height: Style.resize(52)
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: kanbanDone.modelData.task
                                font.pixelSize: Style.resize(11)
                                color: Style.fontPrimaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: tagLabel3.implicitWidth + Style.resize(10)
                                height: Style.resize(16)
                                radius: Style.resize(3)
                                color: Qt.rgba(
                                    Qt.color(kanbanDone.modelData.tagClr).r,
                                    Qt.color(kanbanDone.modelData.tagClr).g,
                                    Qt.color(kanbanDone.modelData.tagClr).b, 0.2)

                                Label {
                                    id: tagLabel3
                                    anchors.centerIn: parent
                                    text: kanbanDone.modelData.tag
                                    font.pixelSize: Style.resize(9)
                                    color: kanbanDone.modelData.tagClr
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
