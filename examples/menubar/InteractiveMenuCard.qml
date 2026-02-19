import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property color shapeColor: Style.mainColor
    property string shapeName: "Rectangle"
    property int shapeSize: 60

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Menu-Driven Drawing"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Menu bar for drawing controls
        MenuBar {
            Layout.fillWidth: true

            Menu {
                title: "Shape"
                MenuItem { text: "Rectangle"; onTriggered: root.shapeName = "Rectangle" }
                MenuItem { text: "Circle"; onTriggered: root.shapeName = "Circle" }
                MenuItem { text: "Diamond"; onTriggered: root.shapeName = "Diamond" }
            }

            Menu {
                title: "Color"
                MenuItem { text: "Teal"; onTriggered: root.shapeColor = "#00D1A9" }
                MenuItem { text: "Orange"; onTriggered: root.shapeColor = "#FEA601" }
                MenuItem { text: "Blue"; onTriggered: root.shapeColor = "#4FC3F7" }
                MenuItem { text: "Red"; onTriggered: root.shapeColor = "#FF7043" }
                MenuItem { text: "Purple"; onTriggered: root.shapeColor = "#AB47BC" }
            }

            Menu {
                title: "Size"
                MenuItem { text: "Small (40)"; onTriggered: root.shapeSize = 40 }
                MenuItem { text: "Medium (60)"; onTriggered: root.shapeSize = 60 }
                MenuItem { text: "Large (90)"; onTriggered: root.shapeSize = 90 }
            }
        }

        // Drawing area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            Rectangle {
                anchors.centerIn: parent
                width: Style.resize(root.shapeSize)
                height: Style.resize(root.shapeSize)
                radius: root.shapeName === "Circle" ? width / 2 : 0
                rotation: root.shapeName === "Diamond" ? 45 : 0
                color: root.shapeColor

                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on rotation { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        Label {
            text: root.shapeName + " | " + root.shapeColor + " | " + root.shapeSize + "px"
            font.pixelSize: Style.resize(12)
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
