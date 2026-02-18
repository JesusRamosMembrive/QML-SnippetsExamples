import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

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
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Text Input Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    TextFieldCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    TextAreaCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    ComboSpinCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    FormBuilderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }
                }

                // Card 5: Custom Input Controls
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customInputsCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customInputsCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Input Controls"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted input components built from scratch with Rectangle, TextInput, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        SearchBar {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        PinInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        TagInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        EditableLabels {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        StarRating {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        CharLimitInput {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        ColorPicker {}
                    }
                }
            }
        }
    }
}
