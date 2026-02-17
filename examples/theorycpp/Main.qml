import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import theoryparser

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    property string currentChapter: ""
    property string currentChapterDisplay: ""
    property string currentTopic: ""
    property string currentTopicDisplay: ""

    TheoryParser {
        id: parser
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            ChapterPanel {
                id: chapterPanel
                Layout.preferredWidth: Style.resize(280)
                Layout.fillHeight: true
                chapters: parser.chapters

                onTopicSelected: function(chapterName, chapterDisplay, topicFile, topicDisplay) {
                    root.currentChapter = chapterName
                    root.currentChapterDisplay = chapterDisplay
                    root.currentTopic = topicFile
                    root.currentTopicDisplay = topicDisplay
                }
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                color: "#3A3D45"
            }

            ContentPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
                parser: parser
                chapterDir: root.currentChapter
                chapterDisplay: root.currentChapterDisplay
                topicFile: root.currentTopic
                topicDisplay: root.currentTopicDisplay
            }
        }
    }
}
