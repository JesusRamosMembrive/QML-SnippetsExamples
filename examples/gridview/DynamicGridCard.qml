import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int nextId: 13

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dynamic Grid"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: dynGrid
                anchors.fill: parent
                clip: true
                cellWidth: Style.resize(cellSlider.value)
                cellHeight: cellWidth

                model: ListModel {
                    id: dynModel
                    Component.onCompleted: {
                        var colors = ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043",
                                      "#AB47BC", "#EC407A", "#66BB6A", "#00599C",
                                      "#F7DF1E", "#064F8C", "#F05032", "#264DE4"]
                        for (var i = 0; i < 12; i++)
                            append({ itemId: i + 1, clr: colors[i] })
                    }
                }

                add: Transition {
                    NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 200 }
                    NumberAnimation { properties: "scale"; from: 0.5; to: 1; duration: 200 }
                }
                remove: Transition {
                    NumberAnimation { properties: "opacity"; to: 0; duration: 200 }
                    NumberAnimation { properties: "scale"; to: 0.5; duration: 200 }
                }

                delegate: Item {
                    id: dynDelegate
                    required property int itemId
                    required property string clr
                    required property int index
                    width: dynGrid.cellWidth
                    height: dynGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(2)
                        radius: Style.resize(6)
                        color: dynDelegate.clr

                        Label {
                            anchors.centerIn: parent
                            text: dynDelegate.itemId.toString()
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        // Remove button
                        Rectangle {
                            width: Style.resize(16)
                            height: Style.resize(16)
                            radius: Style.resize(8)
                            color: "#C62828"
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: Style.resize(3)

                            Label {
                                anchors.centerIn: parent
                                text: "\u2715"
                                font.pixelSize: Style.resize(9)
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: dynModel.remove(dynDelegate.index)
                            }
                        }
                    }
                }
            }
        }

        // Controls
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Size: " + cellSlider.value.toFixed(0)
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(70)
                }
                Slider {
                    id: cellSlider
                    Layout.fillWidth: true
                    from: 50; to: 120; value: 70
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(10)

                Button {
                    text: "Add Item"
                    onClicked: {
                        var clrs = ["#00D1A9", "#FEA601", "#4FC3F7", "#FF7043", "#AB47BC", "#EC407A"]
                        dynModel.append({ itemId: root.nextId, clr: clrs[root.nextId % clrs.length] })
                        root.nextId++
                    }
                }

                Label {
                    text: dynModel.count + " items"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
