import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int selectedIndex: 0

    // Inline components to load
    Component {
        id: circlesComp

        Row {
            spacing: Style.resize(10)
            anchors.centerIn: parent
            Repeater {
                model: 5
                Rectangle {
                    required property int index
                    width: Style.resize(45)
                    height: Style.resize(45)
                    radius: Style.resize(22.5)
                    color: Qt.hsla(index / 5.0, 0.7, 0.5, 1.0)
                    Label {
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }

    Component {
        id: squaresComp

        Grid {
            columns: 3
            spacing: Style.resize(8)
            anchors.centerIn: parent
            Repeater {
                model: 9
                Rectangle {
                    required property int index
                    width: Style.resize(40)
                    height: Style.resize(40)
                    radius: Style.resize(6)
                    color: Qt.hsla(index / 9.0, 0.6, 0.45, 1.0)
                }
            }
        }
    }

    Component {
        id: textComp

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(8)
            Label {
                text: "\u2605"
                font.pixelSize: Style.resize(48)
                color: Style.mainColor
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "Text Component"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.fontPrimaryColor
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "Loaded dynamically via Loader"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic Loader"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Switch sourceComponent to load different views"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: basicLoader
                anchors.fill: parent
                sourceComponent: root.selectedIndex === 0 ? circlesComp
                               : root.selectedIndex === 1 ? squaresComp
                               : textComp

                onStatusChanged: {
                    if (status === Loader.Ready && item) {
                        item.opacity = 0
                        fadeIn.start()
                    }
                }

                NumberAnimation {
                    id: fadeIn
                    target: basicLoader.item
                    property: "opacity"
                    from: 0; to: 1; duration: 200
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Repeater {
                model: ["Circles", "Grid", "Text"]

                Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    highlighted: root.selectedIndex === index
                    onClicked: root.selectedIndex = index
                }
            }
        }
    }
}
