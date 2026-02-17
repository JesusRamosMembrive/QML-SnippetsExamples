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

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Layout Patterns
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2400)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Layout Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        // ── Section 1: Collapsible Sidebar ────────────────
                        Label {
                            text: "Collapsible Sidebar"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: sidebarSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(260)

                            property bool sidebarOpen: true

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                // Sidebar
                                Rectangle {
                                    id: sidebarPanel
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: sidebarSection.sidebarOpen ? Style.resize(180) : Style.resize(48)
                                    color: Style.surfaceColor

                                    Behavior on width {
                                        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                                    }

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(8)
                                        spacing: Style.resize(4)

                                        // Toggle button
                                        Rectangle {
                                            Layout.fillWidth: true
                                            height: Style.resize(32)
                                            radius: Style.resize(6)
                                            color: sidebarToggleMa.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

                                            Label {
                                                anchors.centerIn: parent
                                                text: sidebarSection.sidebarOpen ? "◀" : "▶"
                                                font.pixelSize: Style.resize(14)
                                                color: Style.mainColor
                                            }

                                            MouseArea {
                                                id: sidebarToggleMa
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: sidebarSection.sidebarOpen = !sidebarSection.sidebarOpen
                                            }
                                        }

                                        // Menu items
                                        Repeater {
                                            model: [
                                                { icon: "🏠", label: "Home" },
                                                { icon: "📊", label: "Analytics" },
                                                { icon: "👤", label: "Profile" },
                                                { icon: "⚙", label: "Settings" },
                                                { icon: "📁", label: "Files" }
                                            ]

                                            delegate: Rectangle {
                                                id: sidebarItem
                                                required property var modelData
                                                required property int index

                                                Layout.fillWidth: true
                                                height: Style.resize(34)
                                                radius: Style.resize(6)
                                                color: sidebarItemMa.containsMouse
                                                       ? Qt.rgba(0, 0.82, 0.66, 0.1)
                                                       : sidebarItem.index === 0
                                                         ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                                         : "transparent"

                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: Style.resize(8)
                                                    anchors.rightMargin: Style.resize(8)
                                                    spacing: Style.resize(10)

                                                    Label {
                                                        text: sidebarItem.modelData.icon
                                                        font.pixelSize: Style.resize(16)
                                                    }

                                                    Label {
                                                        text: sidebarItem.modelData.label
                                                        font.pixelSize: Style.resize(12)
                                                        color: sidebarItem.index === 0 ? Style.mainColor : Style.fontPrimaryColor
                                                        visible: sidebarSection.sidebarOpen
                                                        Layout.fillWidth: true
                                                        elide: Text.ElideRight

                                                        opacity: sidebarSection.sidebarOpen ? 1 : 0
                                                        Behavior on opacity { NumberAnimation { duration: 150 } }
                                                    }
                                                }

                                                MouseArea {
                                                    id: sidebarItemMa
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                }
                                            }
                                        }

                                        Item { Layout.fillHeight: true }
                                    }
                                }

                                // Main content
                                Rectangle {
                                    anchors.left: sidebarPanel.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.margins: Style.resize(8)
                                    color: "transparent"

                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: Style.resize(8)

                                        Label {
                                            text: "Dashboard Content"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: Style.fontPrimaryColor
                                        }

                                        // Mini stats cards
                                        RowLayout {
                                            Layout.fillWidth: true
                                            spacing: Style.resize(6)

                                            Repeater {
                                                model: [
                                                    { label: "Users", val: "1,247", clr: "#5B8DEF" },
                                                    { label: "Revenue", val: "$8.4k", clr: "#00D1A9" },
                                                    { label: "Orders", val: "384", clr: "#FF9500" }
                                                ]

                                                delegate: Rectangle {
                                                    id: statCard
                                                    required property var modelData
                                                    Layout.fillWidth: true
                                                    height: Style.resize(55)
                                                    radius: Style.resize(6)
                                                    color: Style.surfaceColor

                                                    ColumnLayout {
                                                        anchors.centerIn: parent
                                                        spacing: Style.resize(2)

                                                        Label {
                                                            text: statCard.modelData.val
                                                            font.pixelSize: Style.resize(16)
                                                            font.bold: true
                                                            color: statCard.modelData.clr
                                                            Layout.alignment: Qt.AlignHCenter
                                                        }
                                                        Label {
                                                            text: statCard.modelData.label
                                                            font.pixelSize: Style.resize(10)
                                                            color: Style.fontSecondaryColor
                                                            Layout.alignment: Qt.AlignHCenter
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        // Content area
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            Label {
                                                anchors.centerIn: parent
                                                text: "Main content area expands\nwhen sidebar collapses"
                                                font.pixelSize: Style.resize(12)
                                                color: Style.fontSecondaryColor
                                                horizontalAlignment: Text.AlignHCenter
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 2: Split Pane ─────────────────────────
                        Label {
                            text: "Draggable Split Pane"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: splitSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(200)

                            property real splitPos: 0.5

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                // Left panel
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: parent.width * splitSection.splitPos - Style.resize(3)
                                    color: Style.surfaceColor
                                    radius: Style.resize(6)

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(4)

                                        Label {
                                            text: "Left Panel"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#5B8DEF"
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                        Label {
                                            text: Math.round(splitSection.splitPos * 100) + "%"
                                            font.pixelSize: Style.resize(20)
                                            font.bold: true
                                            color: Style.fontPrimaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }

                                // Right panel
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: parent.width * (1 - splitSection.splitPos) - Style.resize(3)
                                    color: Style.surfaceColor
                                    radius: Style.resize(6)

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(4)

                                        Label {
                                            text: "Right Panel"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: "#00D1A9"
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                        Label {
                                            text: Math.round((1 - splitSection.splitPos) * 100) + "%"
                                            font.pixelSize: Style.resize(20)
                                            font.bold: true
                                            color: Style.fontPrimaryColor
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }

                                // Divider handle
                                Rectangle {
                                    id: splitDivider
                                    x: parent.width * splitSection.splitPos - width / 2
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: Style.resize(6)
                                    color: splitDragMa.containsMouse || splitDragMa.pressed
                                           ? Style.mainColor : Qt.rgba(1, 1, 1, 0.2)
                                    radius: Style.resize(2)

                                    Behavior on color { ColorAnimation { duration: 150 } }

                                    // Handle grip dots
                                    Column {
                                        anchors.centerIn: parent
                                        spacing: Style.resize(3)

                                        Repeater {
                                            model: 3
                                            Rectangle {
                                                width: Style.resize(3)
                                                height: Style.resize(3)
                                                radius: width / 2
                                                color: Qt.rgba(1, 1, 1, 0.5)
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }
                                    }

                                    MouseArea {
                                        id: splitDragMa
                                        anchors.fill: parent
                                        anchors.margins: -Style.resize(4)
                                        hoverEnabled: true
                                        cursorShape: Qt.SplitHCursor
                                        drag.target: null

                                        property real startX: 0
                                        property real startSplit: 0

                                        onPressed: function(mouse) {
                                            startX = mouse.x
                                            startSplit = splitSection.splitPos
                                        }
                                        onPositionChanged: function(mouse) {
                                            if (pressed) {
                                                var dx = mouse.x - startX
                                                var newSplit = startSplit + dx / splitDivider.parent.width
                                                splitSection.splitPos = Math.max(0.15, Math.min(0.85, newSplit))
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 3: Masonry Grid ───────────────────────
                        Label {
                            text: "Masonry Grid (Pinterest-style)"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            id: masonrySection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(350)

                            readonly property var items: [
                                { title: "Sunset Beach", h: 120, clr: "#FF6B6B" },
                                { title: "Mountain View", h: 160, clr: "#5B8DEF" },
                                { title: "City Lights", h: 100, clr: "#FEA601" },
                                { title: "Forest Trail", h: 180, clr: "#00D1A9" },
                                { title: "Ocean Waves", h: 130, clr: "#AF52DE" },
                                { title: "Snow Peaks", h: 150, clr: "#FF9500" },
                                { title: "Desert Dunes", h: 110, clr: "#FF3B30" },
                                { title: "Flower Field", h: 140, clr: "#34C759" },
                                { title: "Rainy Day", h: 170, clr: "#636E72" },
                                { title: "Aurora", h: 125, clr: "#E84393" },
                                { title: "Starry Night", h: 155, clr: "#0984E3" },
                                { title: "Autumn Leaves", h: 100, clr: "#E17055" }
                            ]
                            readonly property int colCount: 3

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)
                                    spacing: Style.resize(8)

                                    Repeater {
                                        model: masonrySection.colCount

                                        delegate: Column {
                                            id: masonryCol
                                            required property int index

                                            width: (parent.width - Style.resize(8) * (masonrySection.colCount - 1)) / masonrySection.colCount
                                            spacing: Style.resize(8)

                                            Repeater {
                                                model: {
                                                    var colItems = []
                                                    for (var i = masonryCol.index; i < masonrySection.items.length; i += masonrySection.colCount) {
                                                        colItems.push(masonrySection.items[i])
                                                    }
                                                    return colItems
                                                }

                                                delegate: Rectangle {
                                                    id: masonryCard
                                                    required property var modelData
                                                    required property int index

                                                    width: parent.width
                                                    height: Style.resize(masonryCard.modelData.h)
                                                    radius: Style.resize(8)
                                                    color: masonryCard.modelData.clr

                                                    scale: masonryHoverMa.containsMouse ? 1.03 : 1.0
                                                    Behavior on scale { NumberAnimation { duration: 150 } }

                                                    ColumnLayout {
                                                        anchors.left: parent.left
                                                        anchors.bottom: parent.bottom
                                                        anchors.margins: Style.resize(10)
                                                        spacing: Style.resize(2)

                                                        Label {
                                                            text: masonryCard.modelData.title
                                                            font.pixelSize: Style.resize(12)
                                                            font.bold: true
                                                            color: "#FFF"
                                                        }
                                                        Label {
                                                            text: masonryCard.modelData.h + "px"
                                                            font.pixelSize: Style.resize(10)
                                                            color: Qt.rgba(1, 1, 1, 0.7)
                                                        }
                                                    }

                                                    MouseArea {
                                                        id: masonryHoverMa
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 4: Holy Grail Layout ──────────────────
                        Label {
                            text: "Holy Grail Layout"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(240)

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(6)
                                    spacing: Style.resize(4)

                                    // Header
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(36)
                                        radius: Style.resize(4)
                                        color: "#5B8DEF"

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: Style.resize(12)
                                            anchors.rightMargin: Style.resize(12)

                                            Label {
                                                text: "⚡ Header / Navbar"
                                                font.pixelSize: Style.resize(12)
                                                font.bold: true
                                                color: "#FFF"
                                            }

                                            Item { Layout.fillWidth: true }

                                            Repeater {
                                                model: ["Home", "About", "Contact"]
                                                Label {
                                                    required property string modelData
                                                    text: modelData
                                                    font.pixelSize: Style.resize(10)
                                                    color: Qt.rgba(1, 1, 1, 0.8)
                                                }
                                            }
                                        }
                                    }

                                    // Middle row: sidebar + content + aside
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(4)

                                        // Left sidebar
                                        Rectangle {
                                            Layout.preferredWidth: Style.resize(100)
                                            Layout.fillHeight: true
                                            radius: Style.resize(4)
                                            color: "#2D3436"

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(8)
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: "Nav"
                                                    font.pixelSize: Style.resize(11)
                                                    font.bold: true
                                                    color: "#00D1A9"
                                                }

                                                Repeater {
                                                    model: ["Dashboard", "Users", "Reports", "Settings"]
                                                    Label {
                                                        required property string modelData
                                                        required property int index
                                                        text: "• " + modelData
                                                        font.pixelSize: Style.resize(10)
                                                        color: index === 0 ? Style.mainColor : Style.fontSecondaryColor
                                                    }
                                                }

                                                Item { Layout.fillHeight: true }
                                            }
                                        }

                                        // Main content
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: Style.resize(4)
                                            color: Style.surfaceColor

                                            Label {
                                                anchors.centerIn: parent
                                                text: "Main Content\n(fills remaining space)"
                                                font.pixelSize: Style.resize(13)
                                                color: Style.fontPrimaryColor
                                                horizontalAlignment: Text.AlignHCenter
                                            }
                                        }

                                        // Right aside
                                        Rectangle {
                                            Layout.preferredWidth: Style.resize(90)
                                            Layout.fillHeight: true
                                            radius: Style.resize(4)
                                            color: "#2D3436"

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(8)
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: "Aside"
                                                    font.pixelSize: Style.resize(11)
                                                    font.bold: true
                                                    color: "#FF9500"
                                                }

                                                Label {
                                                    text: "Related\nlinks and\nwidgets"
                                                    font.pixelSize: Style.resize(10)
                                                    color: Style.fontSecondaryColor
                                                    wrapMode: Text.WordWrap
                                                    Layout.fillWidth: true
                                                }

                                                Item { Layout.fillHeight: true }
                                            }
                                        }
                                    }

                                    // Footer
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: Style.resize(28)
                                        radius: Style.resize(4)
                                        color: "#636E72"

                                        Label {
                                            anchors.centerIn: parent
                                            text: "Footer — © 2026 QML Snippets"
                                            font.pixelSize: Style.resize(10)
                                            color: Qt.rgba(1, 1, 1, 0.6)
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 5: Responsive Breakpoints ─────────────
                        Label {
                            text: "Responsive Breakpoints"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(10)

                            Label {
                                text: "Width: " + bpSlider.value.toFixed(0) + "px"
                                font.pixelSize: Style.resize(12)
                                color: Style.fontPrimaryColor
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(30)

                                Slider {
                                    id: bpSlider
                                    anchors.fill: parent
                                    from: 150; to: 700; value: 500; stepSize: 10
                                }
                            }

                            Label {
                                text: bpSlider.value >= 500 ? "Desktop (4 col)"
                                    : bpSlider.value >= 350 ? "Tablet (2 col)"
                                    : "Mobile (1 col)"
                                font.pixelSize: Style.resize(12)
                                font.bold: true
                                color: bpSlider.value >= 500 ? "#00D1A9"
                                     : bpSlider.value >= 350 ? "#FF9500"
                                     : "#FF3B30"
                            }
                        }

                        Item {
                            id: bpSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(280)

                            readonly property int cols: bpSlider.value >= 500 ? 4
                                                      : bpSlider.value >= 350 ? 2 : 1

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                Item {
                                    anchors.centerIn: parent
                                    width: bpSlider.value
                                    height: parent.height - Style.resize(16)

                                    // Container outline
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                        border.color: Qt.rgba(1, 1, 1, 0.1)
                                        border.width: Style.resize(1)
                                        radius: Style.resize(4)
                                    }

                                    GridLayout {
                                        anchors.fill: parent
                                        anchors.margins: Style.resize(8)
                                        columns: bpSection.cols
                                        rowSpacing: Style.resize(8)
                                        columnSpacing: Style.resize(8)

                                        Repeater {
                                            model: 8

                                            delegate: Rectangle {
                                                id: bpCard
                                                required property int index

                                                Layout.fillWidth: true
                                                Layout.preferredHeight: Style.resize(55)
                                                radius: Style.resize(8)
                                                color: Style.surfaceColor

                                                ColumnLayout {
                                                    anchors.centerIn: parent
                                                    spacing: Style.resize(2)

                                                    Rectangle {
                                                        Layout.preferredWidth: Style.resize(24)
                                                        Layout.preferredHeight: Style.resize(24)
                                                        Layout.alignment: Qt.AlignHCenter
                                                        radius: Style.resize(4)
                                                        color: [
                                                            "#5B8DEF", "#00D1A9", "#FF9500", "#FF3B30",
                                                            "#AF52DE", "#34C759", "#FEA601", "#E84393"
                                                        ][bpCard.index]

                                                        Label {
                                                            anchors.centerIn: parent
                                                            text: (bpCard.index + 1)
                                                            font.pixelSize: Style.resize(10)
                                                            font.bold: true
                                                            color: "#FFF"
                                                        }
                                                    }

                                                    Label {
                                                        text: "Card " + (bpCard.index + 1)
                                                        font.pixelSize: Style.resize(9)
                                                        color: Style.fontSecondaryColor
                                                        Layout.alignment: Qt.AlignHCenter
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator
                        Rectangle { Layout.fillWidth: true; height: Style.resize(1); color: Style.bgColor }

                        // ── Section 6: Nested Dashboard ───────────────────
                        Label {
                            text: "Nested Dashboard Layout"
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(340)

                            Rectangle {
                                anchors.fill: parent
                                color: Style.bgColor
                                radius: Style.resize(8)
                                clip: true

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(8)
                                    spacing: Style.resize(6)

                                    // Top bar
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Style.resize(6)

                                        Repeater {
                                            model: [
                                                { label: "Total Sales", val: "$24,580", change: "+12.5%", up: true, clr: "#00D1A9" },
                                                { label: "Active Users", val: "3,847", change: "+8.2%", up: true, clr: "#5B8DEF" },
                                                { label: "Bounce Rate", val: "32.1%", change: "-2.4%", up: false, clr: "#FF3B30" },
                                                { label: "Conversion", val: "5.7%", change: "+0.8%", up: true, clr: "#FF9500" }
                                            ]

                                            delegate: Rectangle {
                                                id: kpiCard
                                                required property var modelData
                                                Layout.fillWidth: true
                                                height: Style.resize(60)
                                                radius: Style.resize(6)
                                                color: Style.surfaceColor

                                                ColumnLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: Style.resize(8)
                                                    spacing: Style.resize(2)

                                                    Label {
                                                        text: kpiCard.modelData.label
                                                        font.pixelSize: Style.resize(9)
                                                        color: Style.fontSecondaryColor
                                                    }

                                                    Label {
                                                        text: kpiCard.modelData.val
                                                        font.pixelSize: Style.resize(16)
                                                        font.bold: true
                                                        color: Style.fontPrimaryColor
                                                    }

                                                    Label {
                                                        text: kpiCard.modelData.change
                                                        font.pixelSize: Style.resize(10)
                                                        font.bold: true
                                                        color: kpiCard.modelData.up ? "#34C759" : "#FF3B30"
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    // Middle: chart area + side panel
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: Style.resize(6)

                                        // Chart area
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            // Fake chart bars
                                            Row {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.margins: Style.resize(15)
                                                anchors.bottomMargin: Style.resize(25)
                                                spacing: Style.resize(6)
                                                height: Style.resize(120)

                                                Repeater {
                                                    model: [0.6, 0.8, 0.45, 0.9, 0.7, 0.55, 0.85, 0.65, 0.75, 0.5, 0.92, 0.6]

                                                    delegate: Rectangle {
                                                        id: chartBar
                                                        required property real modelData
                                                        required property int index

                                                        width: (parent.width - Style.resize(6) * 11) / 12
                                                        height: parent.height * chartBar.modelData
                                                        anchors.bottom: parent.bottom
                                                        radius: Style.resize(3)
                                                        color: Qt.hsla(0.47, 0.65, 0.35 + chartBar.modelData * 0.2, 1)
                                                    }
                                                }
                                            }

                                            Label {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.margins: Style.resize(10)
                                                text: "Monthly Revenue"
                                                font.pixelSize: Style.resize(11)
                                                font.bold: true
                                                color: Style.fontPrimaryColor
                                            }

                                            // X-axis labels
                                            Row {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.margins: Style.resize(15)
                                                anchors.bottomMargin: Style.resize(6)

                                                Repeater {
                                                    model: ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
                                                    Label {
                                                        required property string modelData
                                                        width: (parent.width) / 12
                                                        text: modelData
                                                        font.pixelSize: Style.resize(8)
                                                        color: Style.inactiveColor
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                            }
                                        }

                                        // Side panel
                                        Rectangle {
                                            Layout.preferredWidth: Style.resize(160)
                                            Layout.fillHeight: true
                                            radius: Style.resize(6)
                                            color: Style.surfaceColor

                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: Style.resize(10)
                                                spacing: Style.resize(6)

                                                Label {
                                                    text: "Recent Activity"
                                                    font.pixelSize: Style.resize(11)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                }

                                                Repeater {
                                                    model: [
                                                        { ev: "New signup", t: "2m ago", clr: "#34C759" },
                                                        { ev: "Purchase", t: "5m ago", clr: "#5B8DEF" },
                                                        { ev: "Refund", t: "12m ago", clr: "#FF3B30" },
                                                        { ev: "Login", t: "18m ago", clr: "#FF9500" },
                                                        { ev: "Upload", t: "25m ago", clr: "#AF52DE" }
                                                    ]

                                                    delegate: RowLayout {
                                                        id: activityRow
                                                        required property var modelData
                                                        Layout.fillWidth: true
                                                        spacing: Style.resize(6)

                                                        Rectangle {
                                                            width: Style.resize(6)
                                                            height: Style.resize(6)
                                                            radius: width / 2
                                                            color: activityRow.modelData.clr
                                                        }

                                                        Label {
                                                            text: activityRow.modelData.ev
                                                            font.pixelSize: Style.resize(10)
                                                            color: Style.fontPrimaryColor
                                                            Layout.fillWidth: true
                                                            elide: Text.ElideRight
                                                        }

                                                        Label {
                                                            text: activityRow.modelData.t
                                                            font.pixelSize: Style.resize(9)
                                                            color: Style.inactiveColor
                                                        }
                                                    }
                                                }

                                                Item { Layout.fillHeight: true }
                                            }
                                        }
                                    }

                                    // Bottom bar
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Style.resize(6)

                                        Repeater {
                                            model: [
                                                { label: "Pending Orders", count: "23" },
                                                { label: "Support Tickets", count: "7" },
                                                { label: "Scheduled Tasks", count: "14" }
                                            ]

                                            delegate: Rectangle {
                                                id: bottomCard
                                                required property var modelData
                                                Layout.fillWidth: true
                                                height: Style.resize(36)
                                                radius: Style.resize(6)
                                                color: Style.surfaceColor

                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: Style.resize(10)
                                                    anchors.rightMargin: Style.resize(10)

                                                    Label {
                                                        text: bottomCard.modelData.label
                                                        font.pixelSize: Style.resize(10)
                                                        color: Style.fontSecondaryColor
                                                        Layout.fillWidth: true
                                                    }

                                                    Rectangle {
                                                        width: Style.resize(24)
                                                        height: Style.resize(20)
                                                        radius: Style.resize(4)
                                                        color: Qt.rgba(0, 0.82, 0.66, 0.15)

                                                        Label {
                                                            anchors.centerIn: parent
                                                            text: bottomCard.modelData.count
                                                            font.pixelSize: Style.resize(10)
                                                            font.bold: true
                                                            color: Style.mainColor
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
