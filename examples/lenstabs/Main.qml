pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false
    property var tabData: [
        {
            label: "Explore",
            eyebrow: "Discovery",
            title: "Scan ideas through a moving glass layer",
            body: "The lens is not just a selected pill. It behaves like an optical layer that alters the typography as it crosses the strip."
        },
        {
            label: "Library",
            eyebrow: "Reference",
            title: "Separate visual state from semantic selection",
            body: "Clicks change the target index immediately, but the visual commitment lives in the travelling lens. That gives the movement weight."
        },
        {
            label: "Signals",
            eyebrow: "Motion",
            title: "The effect comes from overlap, not only from color",
            body: "A duplicate text layer clipped inside the lens makes every label react while the capsule passes over it, which sells the optical illusion."
        },
        {
            label: "Profile",
            eyebrow: "Polish",
            title: "Keep the first version shader-free",
            body: "This prototype stays inside plain QML so we can tune movement, contrast and hierarchy before deciding if a true refraction shader is worth it."
        }
    ]

    property int currentTabIndex: 0
    property real lensMagnification: 1.08
    property real lensGlowStrength: 0.32
    property int lensTravelDuration: 320
    property real lensInset: Style.resize(6)

    readonly property var currentTab: tabData[Math.max(0, Math.min(currentTabIndex, tabData.length - 1))]
    readonly property var tabLabels: tabData.map(function(entry) { return entry.label })

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Style.resize(300)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.0, 0.82, 0.66, 0.12) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(28)

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Text {
                        text: "Lens Tabs"
                        font.family: Style.fontFamilyBold
                        font.pixelSize: Style.resize(34)
                        font.bold: true
                        color: Style.mainColor
                    }

                    Text {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                        text: "A new tab pattern built from a classic strip plus a moving lens layer. When the user clicks another tab, the lens travels across the row and alters every label it touches."
                    }
                }

                Rectangle {
                    id: heroCard
                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight
                    implicitHeight: heroContent.implicitHeight + Style.resize(52)
                    color: Style.cardColor
                    radius: Style.resize(18)
                    border.color: "#343842"
                    border.width: 1

                    ColumnLayout {
                        id: heroContent
                        anchors.fill: parent
                        anchors.margins: Style.resize(26)
                        spacing: Style.resize(22)

                        RowLayout {
                            Layout.fillWidth: true

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)

                                Text {
                                    text: "Primary Demo"
                                    font.pixelSize: Style.resize(22)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: "The lens moves over the same text layer instead of swapping styles per tab."
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontSecondaryColor
                                    wrapMode: Text.WordWrap
                                }
                            }

                            Item { Layout.fillWidth: true }

                            Rectangle {
                                radius: height / 2
                                color: Qt.rgba(0, 209 / 255, 169 / 255, 0.14)
                                border.color: Qt.rgba(0, 209 / 255, 169 / 255, 0.26)
                                border.width: 1
                                Layout.preferredHeight: Style.resize(28)
                                Layout.preferredWidth: infoText.implicitWidth + Style.resize(20)

                                Text {
                                    id: infoText
                                    anchors.centerIn: parent
                                    text: "No shader - duplicate layer + clip"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.mainColor
                                }
                            }
                        }

                        LensTabStrip {
                            id: heroTabs
                            Layout.fillWidth: true
                            Layout.preferredHeight: implicitHeight
                            tabs: root.tabLabels
                            currentIndex: root.currentTabIndex
                            magnification: root.lensMagnification
                            glowStrength: root.lensGlowStrength
                            travelDuration: root.lensTravelDuration
                            lensInset: root.lensInset
                            onTabTriggered: function(index) {
                                root.currentTabIndex = index
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(230)
                            radius: Style.resize(16)
                            color: Style.surfaceColor
                            border.color: "#323641"
                            border.width: 1

                            Rectangle {
                                width: parent.width * 0.44
                                height: parent.height * 0.8
                                radius: width / 2
                                anchors.right: parent.right
                                anchors.rightMargin: Style.resize(-40)
                                anchors.verticalCenter: parent.verticalCenter
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(0.38, 0.86, 0.74, 0.18) }
                                    GradientStop { position: 1.0; color: "transparent" }
                                }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Style.resize(24)
                                spacing: Style.resize(12)

                                Text {
                                    text: root.currentTab.eyebrow
                                    font.pixelSize: Style.resize(13)
                                    font.bold: true
                                    font.letterSpacing: 1.1
                                    color: Style.mainColor
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: root.currentTab.title
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: Style.resize(28)
                                    font.family: Style.fontFamilyBold
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: root.currentTab.body
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: Style.resize(15)
                                    color: Style.fontSecondaryColor
                                }

                                Item { Layout.fillHeight: true }

                                RowLayout {
                                    spacing: Style.resize(10)

                                    Repeater {
                                        model: [
                                            "travel " + root.lensTravelDuration + " ms",
                                            "mag " + root.lensMagnification.toFixed(2) + "x",
                                            "glow " + root.lensGlowStrength.toFixed(2)
                                        ]

                                        Rectangle {
                                            required property string modelData
                                            radius: height / 2
                                            color: Qt.rgba(1, 1, 1, 0.06)
                                            border.color: Qt.rgba(1, 1, 1, 0.08)
                                            border.width: 1
                                            Layout.preferredHeight: Style.resize(28)
                                            Layout.preferredWidth: chipText.implicitWidth + Style.resize(18)

                                            Text {
                                                id: chipText
                                                anchors.centerIn: parent
                                                text: parent.modelData
                                                font.pixelSize: Style.resize(12)
                                                color: Style.fontSecondaryColor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: tuningCard
                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight
                    implicitHeight: tuningContent.implicitHeight + Style.resize(52)
                    color: Style.cardColor
                    radius: Style.resize(18)
                    border.color: "#343842"
                    border.width: 1

                    ColumnLayout {
                        id: tuningContent
                        anchors.fill: parent
                        anchors.margins: Style.resize(26)
                        spacing: Style.resize(18)

                        Text {
                            text: "Tuning Panel"
                            font.pixelSize: Style.resize(22)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            font.pixelSize: Style.resize(14)
                            color: Style.fontSecondaryColor
                            text: "These controls are here to tune the illusion before deciding whether we need a true shader-based refraction pass."
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: Style.resize(24)
                            rowSpacing: Style.resize(18)

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Text {
                                    text: "Magnification"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    text: root.lensMagnification.toFixed(2) + "x"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    from: 1.00
                                    to: 1.18
                                    stepSize: 0.01
                                    value: root.lensMagnification
                                    onValueChanged: root.lensMagnification = value
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Text {
                                    text: "Glow"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    text: root.lensGlowStrength.toFixed(2)
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.10
                                    to: 0.60
                                    stepSize: 0.01
                                    value: root.lensGlowStrength
                                    onValueChanged: root.lensGlowStrength = value
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Text {
                                    text: "Travel Duration"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    text: root.lensTravelDuration + " ms"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    from: 180
                                    to: 520
                                    stepSize: 10
                                    value: root.lensTravelDuration
                                    onValueChanged: root.lensTravelDuration = Math.round(value)
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(8)

                                Text {
                                    text: "Lens Inset"
                                    font.pixelSize: Style.resize(14)
                                    color: Style.fontPrimaryColor
                                }

                                Text {
                                    text: Math.round(root.lensInset) + " px"
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                }

                                Slider {
                                    Layout.fillWidth: true
                                    from: 2
                                    to: 12
                                    stepSize: 1
                                    value: root.lensInset
                                    onValueChanged: root.lensInset = Math.round(value)
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(120)
                            radius: Style.resize(14)
                            color: Style.surfaceColor
                            border.color: "#323641"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Style.resize(18)
                                spacing: Style.resize(10)

                                Text {
                                    text: "Secondary Preview"
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                LensTabStrip {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: implicitHeight
                                    tabs: ["Inbox", "Alerts", "System", "Archive"]
                                    currentIndex: 2
                                    magnification: root.lensMagnification - 0.02
                                    glowStrength: root.lensGlowStrength * 0.75
                                    travelDuration: root.lensTravelDuration
                                    lensInset: root.lensInset
                                    enabled: false
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.preferredHeight: Style.resize(20)
                }
            }
        }
    }
}
