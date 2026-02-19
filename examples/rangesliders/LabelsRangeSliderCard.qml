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
        spacing: Style.resize(20)

        Label {
            text: "Formatted Ranges"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Price range
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Price Range"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: "$" + priceRange.first.value.toFixed(0) + " — $" + priceRange.second.value.toFixed(0)
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: priceRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 1000
                    stepSize: 50
                    first.value: 200
                    second.value: 800
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // Age range
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Age Range"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: ageRange.first.value.toFixed(0) + " — " + ageRange.second.value.toFixed(0) + " years"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: ageRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 18
                    to: 65
                    stepSize: 1
                    first.value: 25
                    second.value: 45
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // Temperature range
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Temperature"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: tempRange.first.value.toFixed(0) + " °C — " + tempRange.second.value.toFixed(0) + " °C"
                    font.pixelSize: Style.resize(14)
                    color: {
                        var avg = (tempRange.first.value + tempRange.second.value) / 2
                        if (avg < 10) return "#4FC3F7"
                        if (avg < 25) return Style.mainColor
                        return "#FF7043"
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: tempRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: -20
                    to: 50
                    stepSize: 1
                    first.value: 5
                    second.value: 30
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }
    }
}
