import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Flow"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Add"
                onClicked: {
                    var colors = ["#4A90D9", "#00D1A9", "#FEA601", "#9B59B6", "#E74C3C", "#1ABC9C", "#FF5900", "#636E72"]
                    flowModel.append({ itemColor: colors[flowModel.count % colors.length], itemWidth: 40 + Math.random() * 40 })
                }
            }

            Button {
                text: "Remove"
                enabled: flowModel.count > 0
                onClicked: flowModel.remove(flowModel.count - 1)
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Items: " + flowModel.count
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }
        }

        // Width slider
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Width: " + flowWidthSlider.value.toFixed(0) + "px"
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: flowWidthSlider
                    anchors.fill: parent
                    from: 100
                    to: 400
                    value: 300
                    stepSize: 10
                }
            }
        }

        // Flow area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(6)
            clip: true

            ListModel {
                id: flowModel
                ListElement { itemColor: "#4A90D9"; itemWidth: 60 }
                ListElement { itemColor: "#00D1A9"; itemWidth: 50 }
                ListElement { itemColor: "#FEA601"; itemWidth: 70 }
                ListElement { itemColor: "#9B59B6"; itemWidth: 45 }
                ListElement { itemColor: "#E74C3C"; itemWidth: 55 }
                ListElement { itemColor: "#1ABC9C"; itemWidth: 65 }
                ListElement { itemColor: "#FF5900"; itemWidth: 50 }
                ListElement { itemColor: "#636E72"; itemWidth: 60 }
            }

            Flow {
                id: flowLayout
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Style.resize(8)
                width: flowWidthSlider.value
                spacing: Style.resize(6)

                Repeater {
                    model: flowModel

                    Rectangle {
                        width: model.itemWidth
                        height: Style.resize(30)
                        radius: Style.resize(4)
                        color: model.itemColor

                        Label {
                            anchors.centerIn: parent
                            text: (index + 1)
                            font.pixelSize: Style.resize(11)
                            color: "white"
                            font.bold: true
                        }
                    }
                }
            }

            // Width indicator line
            Rectangle {
                x: flowWidthSlider.value + Style.resize(8)
                y: 0
                width: 2
                height: parent.height
                color: "#E74C3C"
                opacity: 0.5

                Behavior on x {
                    NumberAnimation { duration: 150 }
                }
            }
        }

        Label {
            text: "Flow wraps items to the next line. Red line shows width boundary"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
