import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import theoryparser

Item {
    id: root

    property TheoryParser parser
    property string chapterDir: ""
    property string chapterDisplay: ""
    property string topicFile: ""
    property string topicDisplay: ""

    property string explanationText: ""
    property var codeSections: []

    onChapterDirChanged: loadContent()
    onTopicFileChanged: loadContent()

    function loadContent() {
        if (chapterDir === "" || topicFile === "")
            return

        explanationText = parser.getExplanation(chapterDir, topicFile)
        codeSections = parser.getCodeSections(chapterDir, topicFile)
        contentFlickable.contentY = 0
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Breadcrumb header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: Style.cardColor

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(20)
                    anchors.rightMargin: Style.resize(20)
                    spacing: Style.resize(8)

                    Label {
                        text: root.chapterDir !== ""
                              ? root.chapterDisplay + "  \u203A  " + root.topicDisplay
                              : "Selecciona un tema del panel izquierdo"
                        font.pixelSize: Style.resize(14)
                        font.bold: root.chapterDir !== ""
                        color: root.chapterDir !== "" ? Style.fontPrimaryColor : Style.inactiveColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: "#3A3D45"
                }
            }

            // Content area
            Flickable {
                id: contentFlickable
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: contentColumn.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                ColumnLayout {
                    id: contentColumn
                    width: contentFlickable.width
                    spacing: Style.resize(16)

                    // Welcome screen when nothing is selected
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(300)
                        visible: root.chapterDir === ""

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(16)

                            Label {
                                text: "Teoria C++"
                                font.pixelSize: Style.resize(32)
                                font.bold: true
                                color: Style.mainColor
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Label {
                                text: "Selecciona un capitulo y tema del panel izquierdo\npara ver la teoria y ejemplos de codigo."
                                font.pixelSize: Style.resize(14)
                                color: Style.inactiveColor
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // Theory content (markdown)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(20)
                        Layout.rightMargin: Style.resize(20)
                        Layout.topMargin: Style.resize(16)
                        radius: Style.resize(8)
                        color: Style.cardColor
                        visible: root.chapterDir !== ""
                        implicitHeight: explanationEdit.implicitHeight + Style.resize(40)

                        TextEdit {
                            id: explanationEdit
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            text: root.explanationText
                            textFormat: TextEdit.MarkdownText
                            readOnly: true
                            wrapMode: TextEdit.WordWrap
                            font.pixelSize: Style.resize(14)
                            color: Style.fontPrimaryColor
                            selectByMouse: true
                            selectedTextColor: "white"
                            selectionColor: Style.mainColor
                        }
                    }

                    // Code sections header
                    Label {
                        Layout.leftMargin: Style.resize(20)
                        text: "Ejemplos de Codigo (" + root.codeSections.length + ")"
                        font.pixelSize: Style.resize(16)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        visible: root.codeSections.length > 0
                    }

                    // Code sections
                    Repeater {
                        model: root.codeSections

                        CodeBlock {
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            Layout.leftMargin: Style.resize(20)
                            Layout.rightMargin: Style.resize(20)
                            title: modelData.title
                            code: modelData.code
                            result: modelData.result
                        }
                    }

                    // Bottom spacer
                    Item {
                        Layout.preferredHeight: Style.resize(40)
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
