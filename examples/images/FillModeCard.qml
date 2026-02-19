import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedMode: 0
    readonly property var modes: [
        { name: "Stretch",           mode: Image.Stretch },
        { name: "PreserveAspectFit", mode: Image.PreserveAspectFit },
        { name: "PreserveAspectCrop", mode: Image.PreserveAspectCrop },
        { name: "Tile",             mode: Image.Tile },
        { name: "TileVertically",   mode: Image.TileVertically },
        { name: "TileHorizontally", mode: Image.TileHorizontally },
        { name: "Pad",              mode: Image.Pad }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Image FillMode"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Style.surfaceColor
                radius: Style.resize(8)
                border.color: "#3A3D45"
                border.width: 1

                Image {
                    anchors.fill: parent
                    anchors.margins: Style.resize(4)
                    source: "qrc:/assets/images/Qt_logo_2016.svg"
                    fillMode: root.modes[root.selectedMode].mode
                    sourceSize.width: Style.resize(100)
                    sourceSize.height: Style.resize(100)
                }
            }
        }

        // FillMode selector
        ComboBox {
            Layout.fillWidth: true
            model: root.modes.map(function(m) { return m.name })
            currentIndex: root.selectedMode
            onCurrentIndexChanged: root.selectedMode = currentIndex
            font.pixelSize: Style.resize(12)
        }

        Label {
            text: "Image.FillMode." + root.modes[root.selectedMode].name
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
