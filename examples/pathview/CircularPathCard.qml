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
            text: "Circular PathView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Drag to rotate the circle"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: circularView
                anchors.fill: parent
                model: ListModel {
                    ListElement { label: "Qt"; clr: "#41CD52" }
                    ListElement { label: "C++"; clr: "#00599C" }
                    ListElement { label: "QML"; clr: "#00D1A9" }
                    ListElement { label: "JS"; clr: "#F7DF1E" }
                    ListElement { label: "CMake"; clr: "#064F8C" }
                    ListElement { label: "SQL"; clr: "#FF7043" }
                    ListElement { label: "Git"; clr: "#F05032" }
                    ListElement { label: "CSS"; clr: "#264DE4" }
                }

                delegate: Rectangle {
                    id: circDelegate
                    required property string label
                    required property string clr
                    required property int index
                    width: Style.resize(60)
                    height: Style.resize(60)
                    radius: Style.resize(30)
                    color: clr
                    opacity: PathView.isCurrentItem ? 1.0 : 0.6
                    scale: PathView.isCurrentItem ? 1.2 : 0.85

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200 } }

                    Label {
                        anchors.centerIn: parent
                        text: circDelegate.label
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                path: Path {
                    startX: circularView.width / 2
                    startY: Style.resize(30)
                    PathArc {
                        x: circularView.width / 2
                        y: circularView.height - Style.resize(30)
                        radiusX: circularView.width / 2 - Style.resize(40)
                        radiusY: circularView.height / 2 - Style.resize(30)
                        direction: PathArc.Clockwise
                    }
                    PathArc {
                        x: circularView.width / 2
                        y: Style.resize(30)
                        radiusX: circularView.width / 2 - Style.resize(40)
                        radiusY: circularView.height / 2 - Style.resize(30)
                        direction: PathArc.Clockwise
                    }
                }

                pathItemCount: 8
            }
        }

        Label {
            text: "Current: " + circularView.model.get(circularView.currentIndex).label
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
