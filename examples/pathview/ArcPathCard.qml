import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Arc Path (Carousel)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: arcView
                anchors.fill: parent
                model: ListModel {
                    ListElement { title: "Buttons"; icon: "\u25A3"; clr: "#00D1A9" }
                    ListElement { title: "Sliders"; icon: "\u2501"; clr: "#FEA601" }
                    ListElement { title: "Popups"; icon: "\u25A1"; clr: "#4FC3F7" }
                    ListElement { title: "Canvas"; icon: "\u25CB"; clr: "#FF7043" }
                    ListElement { title: "Graphs"; icon: "\u2587"; clr: "#AB47BC" }
                    ListElement { title: "Shapes"; icon: "\u25C6"; clr: "#EC407A" }
                }

                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.StrictlyEnforceRange

                delegate: Rectangle {
                    id: arcDelegate
                    required property string title
                    required property string icon
                    required property string clr
                    required property int index
                    width: Style.resize(90)
                    height: Style.resize(100)
                    radius: Style.resize(8)
                    color: Style.surfaceColor
                    opacity: PathView.isCurrentItem ? 1.0 : 0.5
                    scale: PathView.isCurrentItem ? 1.1 : 0.75

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200 } }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(6)

                        Label {
                            text: arcDelegate.icon
                            font.pixelSize: Style.resize(28)
                            color: arcDelegate.clr
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: arcDelegate.title
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                path: Path {
                    startX: 0
                    startY: arcView.height * 0.6
                    PathQuad {
                        x: arcView.width
                        y: arcView.height * 0.6
                        controlX: arcView.width / 2
                        controlY: Style.resize(20)
                    }
                }

                pathItemCount: 5
            }
        }

        // Navigation
        RowLayout {
            Layout.fillWidth: true

            Button { text: "\u25C0"; onClicked: arcView.decrementCurrentIndex() }
            Item { Layout.fillWidth: true }
            Label {
                text: arcView.model.get(arcView.currentIndex).title
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: Style.mainColor
            }
            Item { Layout.fillWidth: true }
            Button { text: "\u25B6"; onClicked: arcView.incrementCurrentIndex() }
        }
    }
}
