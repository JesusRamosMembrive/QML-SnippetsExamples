import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

import utils
import qmlsnippetsstyle
import buttons as Buttons
import sliders as Sliders
import switches as Switches
import textinputs as TextInputs
import indicators as Indicators
import animations as Animations
import popups as Popups
import lists as Lists
import canvas as CanvasPage
import layouts as LayoutsPage
import transforms as Transforms
import particles as Particles
import graphs as GraphsPage
import pfd as PfdPage
import hud as HudPage
import websocketex as WebSocketPage
import ecam as EcamPage
import navdisplay as NavDisplayPage
import theorycpp as TheoryCppPage
import date as DatePage
import aircraftmap as AircraftMapPage
import shapes as ShapesPage
import maps as MapsPage
import pdfreader as PdfReaderPage
import threadsex as ThreadsPage

Item {
    id: root
    state: "Dashboard"
    objectName: "Dashboard"

    onStateChanged: repaintTimer.restart()

    Timer {
        id: repaintTimer
        interval: 250
        onTriggered: forceRepaintCanvases(root)
    }

    function forceRepaintCanvases(item) {
        for (var i = 0; i < item.children.length; i++) {
            var child = item.children[i]
            if (typeof child.requestPaint === "function")
                child.requestPaint()
            forceRepaintCanvases(child)
        }
    }

    // Dashboard home content
    Item {
        anchors.fill: parent
        opacity: (root.state === "Dashboard") ? 1.0 : 0.0
        visible: opacity > 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor

            ScrollView {
                id: homeScrollView
                anchors.fill: parent
                anchors.margins: Style.resize(40)
                clip: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: homeScrollView.availableWidth
                    spacing: Style.resize(20)

                    // Title
                    Label {
                        text: "QML Snippets & Examples"
                        font.pixelSize: Style.resize(36)
                        font.bold: true
                        color: Style.mainColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "A collection of QML / Qt Quick patterns and components for learning and reference."
                        font.pixelSize: Style.resize(16)
                        color: Style.fontSecondaryColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Item { Layout.preferredHeight: Style.resize(10) }

                    // Tech stack section
                    Label {
                        text: "Built with"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(10)
                        spacing: Style.resize(6)

                        Repeater {
                            model: [
                                "Qt 6.10 / Qt Quick / QML",
                                "C++ backend with CMake build system",
                                "Qt Quick Controls, Shapes, Particles, Graphs"
                            ]
                            Label {
                                required property string modelData
                                text: "\u2022  " + modelData
                                font.pixelSize: Style.resize(14)
                                color: Style.fontSecondaryColor
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(10) }

                    // Examples section header
                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "Examples"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "25 pages"
                            font.pixelSize: Style.resize(14)
                            color: Style.inactiveColor
                        }
                    }

                    // Examples list
                    Rectangle {
                        Layout.fillWidth: true
                        color: Style.cardColor
                        radius: Style.resize(8)
                        implicitHeight: examplesList.implicitHeight + Style.resize(20)

                        ListModel {
                            id: examplesModel
                            ListElement { name: "Buttons";    desc: "Standard, icon, toggle, and styled buttons" }
                            ListElement { name: "Sliders";    desc: "Range sliders, styled tracks, custom handles" }
                            ListElement { name: "Switches";   desc: "Toggle switches and check controls" }
                            ListElement { name: "TextInputs"; desc: "Text fields, validation, styled inputs" }
                            ListElement { name: "Indicators"; desc: "Progress bars, busy indicators, gauges" }
                            ListElement { name: "Animations"; desc: "Transitions, behaviors, state animations" }
                            ListElement { name: "Popups";     desc: "Dialogs, drawers, tooltips, menus" }
                            ListElement { name: "Lists";      desc: "ListView, delegates, sections" }
                            ListElement { name: "Canvas";     desc: "2D drawing, shapes, paths, pie charts" }
                            ListElement { name: "Layouts";    desc: "Row, Column, Grid, Flow layouts" }
                            ListElement { name: "Transforms"; desc: "Rotation, scale, translate, 3D effects" }
                            ListElement { name: "Particles";  desc: "Emitters, affectors, trails, interactive" }
                            ListElement { name: "Graphs";     desc: "Line series, bar charts, real-time plots" }
                            ListElement { name: "PFD";        desc: "Artificial horizon, speed/altitude tapes, heading" }
                            ListElement { name: "ECAM";       desc: "Engine gauges, warnings, fuel synoptic" }
                            ListElement { name: "HUD";        desc: "Head-up display, pitch ladder, flight path vector" }
                            ListElement { name: "WebSocket"; desc: "C++ class exposed to QML, live echo server" }
                            ListElement { name: "NavDisplay"; desc: "Moving map, compass rose, flight plan" }
                            ListElement { name: "Teoria";     desc: "C++ theory: fundamentals through advanced topics" }
                            ListElement { name: "Date";       desc: "Tumbler date picker, MonthGrid calendar" }
                            ListElement { name: "AircraftMap"; desc: "Interactive blueprint with zoomable markers" }
                            ListElement { name: "Shapes";      desc: "Bezier curves, arcs, SVG paths, gradients, morphing" }
                            ListElement { name: "Maps";        desc: "OSM map, compass overlay, animated GPS route" }
                            ListElement { name: "PdfReader";   desc: "Drag & drop PDF viewer with zoom and navigation" }
                            ListElement { name: "Threads";     desc: "C++ pipeline: QThread, moveToThread, cross-thread signals" }
                        }

                        ColumnLayout {
                            id: examplesList
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: Style.resize(10)
                            spacing: 0

                            Repeater {
                                model: examplesModel

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(36)

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        spacing: Style.resize(15)

                                        Label {
                                            text: model.name
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: Style.mainColor
                                            Layout.preferredWidth: Style.resize(110)
                                        }

                                        Label {
                                            text: model.desc
                                            font.pixelSize: Style.resize(13)
                                            color: Style.fontSecondaryColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }

                                    // Separator line
                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        height: 1
                                        color: "#3A3D45"
                                        visible: index < examplesModel.count - 1
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(5) }

                    // Footer hint
                    Label {
                        text: "Select a page from the menu to explore examples."
                        font.pixelSize: Style.resize(14)
                        font.italic: true
                        color: Style.inactiveColor
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item { Layout.preferredHeight: Style.resize(20) }
                }
            }
        }
    }

    Buttons.Main {
        visible: fullSize
        fullSize: (root.state === "Buttons")
    }

    Sliders.Main {
        visible: fullSize
        fullSize: (root.state === "Sliders")
    }

    Switches.Main {
        visible: fullSize
        fullSize: (root.state === "Switches")
    }

    TextInputs.Main {
        visible: fullSize
        fullSize: (root.state === "TextInputs")
    }

    Indicators.Main {
        visible: fullSize
        fullSize: (root.state === "Indicators")
    }

    Animations.Main {
        visible: fullSize
        fullSize: (root.state === "Animations")
    }

    Popups.Main {
        visible: fullSize
        fullSize: (root.state === "Popups")
    }

    Lists.Main {
        visible: fullSize
        fullSize: (root.state === "Lists")
    }

    CanvasPage.Main {
        visible: fullSize
        fullSize: (root.state === "Canvas")
    }

    LayoutsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Layouts")
    }

    Transforms.Main {
        visible: fullSize
        fullSize: (root.state === "Transforms")
    }

    Particles.Main {
        visible: fullSize
        fullSize: (root.state === "Particles")
    }

    GraphsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Graphs")
    }

    PfdPage.Main {
        visible: fullSize
        fullSize: (root.state === "PFD")
    }

    HudPage.Main {
        visible: fullSize
        fullSize: (root.state === "HUD")
    }

    WebSocketPage.Main {
        visible: fullSize
        fullSize: (root.state === "WebSocket")
    }

    EcamPage.Main {
        visible: fullSize
        fullSize: (root.state === "ECAM")
    }

    NavDisplayPage.Main {
        visible: fullSize
        fullSize: (root.state === "NavDisplay")
    }

    TheoryCppPage.Main {
        visible: fullSize
        fullSize: (root.state === "Teoria")
    }

    DatePage.Main {
        visible: fullSize
        fullSize: (root.state === "Date")
    }

    AircraftMapPage.Main {
        visible: fullSize
        fullSize: (root.state === "AircraftMap")
    }

    ShapesPage.Main {
        visible: fullSize
        fullSize: (root.state === "Shapes")
    }

    MapsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Maps")
    }

    PdfReaderPage.Main {
        visible: fullSize
        fullSize: (root.state === "PdfReader")
    }

    ThreadsPage.Main {
        visible: fullSize
        fullSize: (root.state === "Threads")
    }
}
