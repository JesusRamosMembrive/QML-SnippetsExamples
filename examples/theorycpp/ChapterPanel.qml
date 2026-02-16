import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0

Item {
    id: root

    property var chapters: []
    property string searchText: ""
    property string selectedChapter: ""
    property string selectedTopic: ""

    signal topicSelected(string chapterName, string chapterDisplay, string topicFile, string topicDisplay)

    Rectangle {
        anchors.fill: parent
        color: "#2C3E50"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: "#1A252F"

                Label {
                    anchors.centerIn: parent
                    text: "Teoria C++"
                    font.pixelSize: Style.resize(18)
                    font.bold: true
                    color: Style.mainColor
                }
            }

            // Search field
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)
                Layout.margins: Style.resize(8)
                color: "#3D5166"
                radius: Style.resize(4)

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    color: "#FFFFFF"
                    font.pixelSize: Style.resize(13)
                    clip: true
                    onTextChanged: root.searchText = text

                    Text {
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Buscar tema..."
                        color: "#8899AA"
                        font.pixelSize: Style.resize(13)
                        visible: !searchInput.text
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Chapters list
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: chaptersListView
                    model: root.chapters
                    spacing: Style.resize(2)

                    delegate: Column {
                        id: chapterDelegate
                        width: chaptersListView.width

                        required property var modelData
                        required property int index

                        property bool expanded: false
                        property var filteredTopics: {
                            let topics = modelData.topics
                            if (root.searchText === "")
                                return topics
                            let result = []
                            let search = root.searchText.toLowerCase()
                            for (let i = 0; i < topics.length; i++) {
                                if (topics[i].displayName.toLowerCase().indexOf(search) >= 0)
                                    result.push(topics[i])
                            }
                            return result
                        }

                        // Auto-expand when search matches
                        onFilteredTopicsChanged: {
                            if (root.searchText !== "" && filteredTopics.length > 0)
                                expanded = true
                        }

                        // Chapter header
                        Rectangle {
                            width: parent.width
                            height: Style.resize(36)
                            color: chapterMouse.containsMouse ? "#3D5166" : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(12)
                                anchors.rightMargin: Style.resize(12)
                                spacing: Style.resize(8)

                                Label {
                                    text: chapterDelegate.expanded ? "\u25BC" : "\u25B6"
                                    font.pixelSize: Style.resize(10)
                                    color: Style.mainColor
                                }

                                Label {
                                    text: chapterDelegate.modelData.displayName
                                    font.pixelSize: Style.resize(13)
                                    font.bold: true
                                    color: "#FFFFFF"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: chapterDelegate.filteredTopics.length
                                    font.pixelSize: Style.resize(11)
                                    color: "#8899AA"
                                }
                            }

                            MouseArea {
                                id: chapterMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: chapterDelegate.expanded = !chapterDelegate.expanded
                            }
                        }

                        // Topics under this chapter
                        Column {
                            width: parent.width
                            visible: chapterDelegate.expanded
                            Repeater {
                                model: chapterDelegate.filteredTopics

                                Rectangle {
                                    required property var modelData
                                    required property int index

                                    width: chaptersListView.width
                                    height: Style.resize(30)
                                    color: {
                                        if (root.selectedChapter === chapterDelegate.modelData.name
                                            && root.selectedTopic === modelData.fileName)
                                            return Qt.rgba(Style.mainColor.r, Style.mainColor.g, Style.mainColor.b, 0.2)
                                        return topicMouse.containsMouse ? "#3D5166" : "transparent"
                                    }

                                    Label {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Style.resize(32)
                                        anchors.right: parent.right
                                        anchors.rightMargin: Style.resize(8)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.displayName
                                        font.pixelSize: Style.resize(12)
                                        color: {
                                            if (root.selectedChapter === chapterDelegate.modelData.name
                                                && root.selectedTopic === modelData.fileName)
                                                return Style.mainColor
                                            return "#CCDDEE"
                                        }
                                        elide: Text.ElideRight
                                    }

                                    MouseArea {
                                        id: topicMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.selectedChapter = chapterDelegate.modelData.name
                                            root.selectedTopic = modelData.fileName
                                            root.topicSelected(
                                                chapterDelegate.modelData.name,
                                                chapterDelegate.modelData.displayName,
                                                modelData.fileName,
                                                modelData.displayName
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
