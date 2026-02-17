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
                    text: "Layouts Examples"
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

                    // ========================================
                    // Card 1: Row & Column Layout
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "Row & Column Layout"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Spacing control
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Label {
                                    text: "Spacing: " + spacingSlider.value.toFixed(0) + "px"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: spacingSlider
                                        anchors.fill: parent
                                        from: 0
                                        to: 30
                                        value: 8
                                        stepSize: 1
                                    }
                                }
                            }

                            // RowLayout demo
                            Label {
                                text: "RowLayout"
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(50)
                                color: Style.bgColor
                                radius: Style.resize(4)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    spacing: spacingSlider.value

                                    Rectangle {
                                        Layout.preferredWidth: Style.resize(60)
                                        Layout.fillHeight: true
                                        color: "#4A90D9"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "#00D1A9"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: Style.resize(80)
                                        Layout.fillHeight: true
                                        color: "#FEA601"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "#9B59B6"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }
                                }
                            }

                            // ColumnLayout demo
                            Label {
                                text: "ColumnLayout"
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(4)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    spacing: spacingSlider.value

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(30)
                                        color: "#E74C3C"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "preferredHeight: 30"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "#1ABC9C"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "fillHeight"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(25)
                                        color: "#FF5900"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "preferredHeight: 25"; color: "white"; font.pixelSize: Style.resize(10) }
                                    }
                                }
                            }

                            Label {
                                text: "RowLayout arranges horizontally, ColumnLayout vertically. fillWidth/fillHeight expand to fill"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: GridLayout
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "GridLayout"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Column count control
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Label {
                                    text: "Columns: " + colSlider.value.toFixed(0)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontPrimaryColor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(30)

                                    Slider {
                                        id: colSlider
                                        anchors.fill: parent
                                        from: 2
                                        to: 4
                                        value: 3
                                        stepSize: 1
                                    }
                                }
                            }

                            // GridLayout demo
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(4)

                                GridLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(6)
                                    columns: colSlider.value
                                    rowSpacing: Style.resize(6)
                                    columnSpacing: Style.resize(6)

                                    // Wide cell (spans 2 columns)
                                    Rectangle {
                                        Layout.columnSpan: Math.min(2, colSlider.value)
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#4A90D9"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#00D1A9"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    // Tall cell (spans 2 rows)
                                    Rectangle {
                                        Layout.rowSpan: 2
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "#FEA601"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "rowSpan\n2"; color: "white"; font.pixelSize: Style.resize(11); horizontalAlignment: Text.AlignHCenter }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#9B59B6"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#E74C3C"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#1ABC9C"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#FF5900"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "1x1"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }

                                    Rectangle {
                                        Layout.columnSpan: Math.min(2, colSlider.value)
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: Style.resize(50)
                                        color: "#636E72"
                                        radius: Style.resize(4)
                                        Label { anchors.centerIn: parent; text: "columnSpan: 2"; color: "white"; font.pixelSize: Style.resize(11) }
                                    }
                                }
                            }

                            Label {
                                text: "GridLayout with columnSpan and rowSpan for complex arrangements"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: Flow
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
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

                    // ========================================
                    // Card 4: StackLayout
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        color: Style.cardColor
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(10)

                            Label {
                                text: "StackLayout"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Page buttons
                            RowLayout {
                                id: pageButtons
                                Layout.fillWidth: true
                                spacing: Style.resize(6)

                                property int currentPage: 0

                                Button {
                                    text: "Page 1"
                                    Layout.fillWidth: true
                                    highlighted: parent.currentPage === 0
                                    onClicked: parent.currentPage = 0
                                }

                                Button {
                                    text: "Page 2"
                                    Layout.fillWidth: true
                                    highlighted: parent.currentPage === 1
                                    onClicked: parent.currentPage = 1
                                }

                                Button {
                                    text: "Page 3"
                                    Layout.fillWidth: true
                                    highlighted: parent.currentPage === 2
                                    onClicked: parent.currentPage = 2
                                }
                            }

                            // Page indicator
                            Label {
                                text: "Current page: " + (stackLayout.currentIndex + 1) + " of 3"
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                            }

                            // StackLayout
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Style.bgColor
                                radius: Style.resize(6)
                                clip: true

                                StackLayout {
                                    id: stackLayout
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)
                                    currentIndex: pageButtons.currentPage

                                    // Page 1
                                    Rectangle {
                                        color: "#4A90D920"
                                        radius: Style.resize(8)
                                        border.color: "#4A90D9"
                                        border.width: 2

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(10)

                                            Rectangle {
                                                width: Style.resize(60)
                                                height: Style.resize(60)
                                                radius: Style.resize(8)
                                                color: "#4A90D9"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "Page 1: Welcome"
                                                font.pixelSize: Style.resize(18)
                                                font.bold: true
                                                color: "#4A90D9"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "StackLayout shows one child at a time"
                                                font.pixelSize: Style.resize(13)
                                                color: Style.fontSecondaryColor
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }

                                    // Page 2
                                    Rectangle {
                                        color: "#00D1A920"
                                        radius: Style.resize(8)
                                        border.color: "#00D1A9"
                                        border.width: 2

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(10)

                                            RowLayout {
                                                spacing: Style.resize(8)
                                                Layout.alignment: Qt.AlignHCenter

                                                Repeater {
                                                    model: 3
                                                    Rectangle {
                                                        width: Style.resize(40)
                                                        height: Style.resize(40)
                                                        radius: width / 2
                                                        color: "#00D1A9"

                                                        Label {
                                                            anchors.centerIn: parent
                                                            text: (index + 1)
                                                            color: "white"
                                                            font.bold: true
                                                        }
                                                    }
                                                }
                                            }

                                            Label {
                                                text: "Page 2: Content"
                                                font.pixelSize: Style.resize(18)
                                                font.bold: true
                                                color: "#00D1A9"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "Only the current page is visible and laid out"
                                                font.pixelSize: Style.resize(13)
                                                color: Style.fontSecondaryColor
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }

                                    // Page 3
                                    Rectangle {
                                        color: "#FEA60120"
                                        radius: Style.resize(8)
                                        border.color: "#FEA601"
                                        border.width: 2

                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: Style.resize(10)

                                            Rectangle {
                                                width: Style.resize(80)
                                                height: Style.resize(50)
                                                radius: Style.resize(25)
                                                color: "#FEA601"
                                                Layout.alignment: Qt.AlignHCenter

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "Done!"
                                                    color: "white"
                                                    font.bold: true
                                                    font.pixelSize: Style.resize(16)
                                                }
                                            }

                                            Label {
                                                text: "Page 3: Summary"
                                                font.pixelSize: Style.resize(18)
                                                font.bold: true
                                                color: "#FEA601"
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            Label {
                                                text: "Use currentIndex to switch between pages"
                                                font.pixelSize: Style.resize(13)
                                                color: Style.fontSecondaryColor
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }
                                }
                            }

                            Label {
                                text: "StackLayout stacks children, only the current page is visible"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                } // End of GridLayout
            }
        }
    }
}
